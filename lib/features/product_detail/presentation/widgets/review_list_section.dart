import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_review.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/review_rti_analysis_dialog.dart';
import 'package:re_view_front/features/search/presentation/utils/search_formatters.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';

enum ReviewSortOption { newest, verified, withPhoto, rtiHigh, helpful }

class ReviewListSection extends ConsumerStatefulWidget {
  const ReviewListSection({
    super.key,
    required this.reviews,
    this.safeCount = 0,
    this.warnCount = 0,
    this.dangerCount = 0,
    this.onFeedback,
    this.productId,
    this.productName = '',
  });

  final List<ProductReview> reviews;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(int reviewId, String feedbackType)? onFeedback;
  final int? productId;
  final String productName;

  @override
  ConsumerState<ReviewListSection> createState() => _ReviewListSectionState();
}

class _ReviewListSectionState extends ConsumerState<ReviewListSection> {
  /// 처음에 그리는 리뷰 수. 리뷰가 많아도 첫 화면을 빨리 그리기 위해 나눠서 보여 준다.
  static const _pageSize = 10;

  ReviewSortOption? _selectedSort;
  bool _showHidden = false;
  SettingsData? get _preferences =>
      ref.watch(confirmedDisplayPreferencesProvider);
  ReviewSortOption get _sortOption =>
      _selectedSort ??
      (_preferences?.reviewSortOrder == 'HELPFUL'
          ? ReviewSortOption.helpful
          : ReviewSortOption.newest);
  bool _isHidden(ProductReview review) {
    final settings = _preferences;
    return !_showHidden &&
        settings?.hideRiskyReviews == true &&
        review.rtiScore != null &&
        review.rtiScore! < settings!.rtiThreshold;
  }

  bool _photoOnly = false;
  int _visibleCount = _pageSize;

  List<ProductReview> get _filteredSortedReviews {
    var list = widget.reviews.where((r) => !_isHidden(r)).toList();
    list.sort((a, b) {
      final first = DateTime.tryParse(a.createdAt.replaceAll('.', '-'));
      final second = DateTime.tryParse(b.createdAt.replaceAll('.', '-'));
      if (first == null) return second == null ? 0 : 1;
      if (second == null) return -1;
      return second.compareTo(first);
    });
    if (_selectedSort == null &&
        (_preferences?.prioritizeVerifiedReviews == true ||
            _preferences?.reviewSortOrder == 'VERIFIED_RECENT')) {
      list = [
        for (final r in list)
          if (r.isVerifiedPurchase) r,
        for (final r in list)
          if (!r.isVerifiedPurchase) r,
      ];
    }

    if (_photoOnly) {
      list = list.where((r) => r.imageUrls.isNotEmpty).toList();
    }

    return switch (_sortOption) {
      ReviewSortOption.newest => list,
      ReviewSortOption.verified =>
        list.where((r) => r.isVerifiedPurchase).toList(),
      ReviewSortOption.withPhoto =>
        list.where((r) => r.imageUrls.isNotEmpty).toList(),
      ReviewSortOption.helpful =>
        (list..sort((a, b) {
          if (a.helpfulCount == null) return b.helpfulCount == null ? 0 : 1;
          if (b.helpfulCount == null) return -1;
          return b.helpfulCount!.compareTo(a.helpfulCount!);
        })),
      ReviewSortOption.rtiHigh =>
        (list..sort((a, b) {
          if (a.rtiScore == null) return b.rtiScore == null ? 0 : 1;
          if (b.rtiScore == null) return -1;
          return b.rtiScore!.compareTo(a.rtiScore!);
        })),
    };
  }

  @override
  Widget build(BuildContext context) {
    final preferences = _preferences;
    final reviews = _filteredSortedReviews;
    final hiddenCount = widget.reviews.where(_isHidden).length;
    final preferencesState = ref.watch(savedDisplayPreferencesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (preferencesState.hasError)
          TextButton.icon(
            onPressed: () => ref.invalidate(savedDisplayPreferencesProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('표시 설정을 불러오지 못했습니다. 재시도'),
          ),
        if (hiddenCount > 0)
          TextButton(
            onPressed: () => setState(() {
              _showHidden = true;
            }),
            child: Text('설정 기준 이하 리뷰 $hiddenCount개 표시'),
          ),
        if (_sortOption == ReviewSortOption.helpful &&
            !widget.reviews.any((r) => r.helpfulCount != null))
          const Text('도움 횟수가 제공되지 않아 기존 리뷰 순서로 표시합니다.'),
        _FilterRow(
          sortOption: _sortOption,
          photoOnly: _photoOnly,
          onSortChanged: (v) => setState(() {
            _selectedSort = v;
            _visibleCount = _pageSize;
          }),
          onPhotoOnlyChanged: (v) => setState(() {
            _photoOnly = v;
            _visibleCount = _pageSize;
          }),
        ),
        const SizedBox(height: AppSpacing.md),
        if (widget.reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '아직 등록된 리뷰가 없습니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                '해당 조건에 맞는 리뷰가 없습니다.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          )
        else ...[
          ...reviews
              .take(_visibleCount)
              .map(
                (review) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ReviewCard(
                    review: review,
                    preferences: preferences,
                    safeCount: widget.safeCount,
                    warnCount: widget.warnCount,
                    dangerCount: widget.dangerCount,
                    onFeedback: widget.onFeedback != null
                        ? (feedbackType) =>
                              widget.onFeedback!(review.id, feedbackType)
                        : null,
                    productId: widget.productId,
                    productName: widget.productName,
                  ),
                ),
              ),
          if (reviews.length > _visibleCount)
            Center(
              child: OutlinedButton(
                onPressed: () => setState(() => _visibleCount += _pageSize),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderStrong),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: Text('리뷰 더보기 (${reviews.length - _visibleCount}개 남음)'),
              ),
            ),
        ],
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.sortOption,
    required this.photoOnly,
    required this.onSortChanged,
    required this.onPhotoOnlyChanged,
  });

  final ReviewSortOption sortOption;
  final bool photoOnly;
  final ValueChanged<ReviewSortOption> onSortChanged;
  final ValueChanged<bool> onPhotoOnlyChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _FilterChip(
          label: '최신순',
          selected: sortOption == ReviewSortOption.newest,
          onTap: () => onSortChanged(ReviewSortOption.newest),
        ),
        _FilterChip(
          label: '구매인증',
          selected: sortOption == ReviewSortOption.verified,
          onTap: () => onSortChanged(ReviewSortOption.verified),
        ),
        _FilterChip(
          label: '사진 포함',
          selected: sortOption == ReviewSortOption.withPhoto,
          onTap: () => onSortChanged(ReviewSortOption.withPhoto),
        ),
        _FilterChip(
          label: '도움순',
          selected: sortOption == ReviewSortOption.helpful,
          onTap: () => onSortChanged(ReviewSortOption.helpful),
        ),
        _FilterChip(
          label: 'RTI 높은순',
          selected: sortOption == ReviewSortOption.rtiHigh,
          onTap: () => onSortChanged(ReviewSortOption.rtiHigh),
        ),
        const _Divider(),
        GestureDetector(
          onTap: () => onPhotoOnlyChanged(!photoOnly),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Checkbox(
                  value: photoOnly,
                  onChanged: (v) => onPhotoOnlyChanged(v ?? false),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '사진 리뷰만 보기',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs + 2,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.small,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderStrong,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: selected ? AppColors.onPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      color: AppColors.borderStrong,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    this.safeCount = 0,
    this.warnCount = 0,
    this.dangerCount = 0,
    this.onFeedback,
    this.productId,
    this.productName = '',
    this.preferences,
  });

  final SettingsData? preferences;
  final ProductReview review;
  final int safeCount;
  final int warnCount;
  final int dangerCount;
  final Future<bool> Function(String feedbackType)? onFeedback;
  final int? productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    final images = review.imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList(growable: false);
    final rtiColor = colorFromHex(review.rtiColor);

    final risky =
        review.rtiScore != null &&
        review.rtiScore! < (preferences?.rtiThreshold ?? 0);
    return GestureDetector(
      onTap:
          preferences?.autoOpenAnalysisPopup == true &&
              risky &&
              review.rtiDetail != null
          ? () => showReviewRtiAnalysisDialog(
              context,
              review,
              safeCount: safeCount,
              warnCount: warnCount,
              dangerCount: dangerCount,
              productId: productId,
              productName: productName,
            )
          : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.medium,
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(name: review.authorName),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              review.authorName,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            if (review.isVerifiedPurchase) ...[
                              const SizedBox(width: AppSpacing.xxs),
                              _VerifiedBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            for (var i = 0; i < 5; i++)
                              Icon(
                                i < review.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color(0xFFF59E0B),
                                size: 13,
                              ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              review.platform.isNotEmpty
                                  ? '${review.createdAt} · ${review.platform}'
                                  : review.createdAt,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  if (preferences?.rtiLabelStyle != 'NONE')
                    GestureDetector(
                      onTap: () => showReviewRtiAnalysisDialog(
                        context,
                        review,
                        safeCount: safeCount,
                        warnCount: warnCount,
                        dangerCount: dangerCount,
                        productId: productId,
                        productName: productName,
                      ),
                      child: _RtiBadgeSmall(
                        score: review.rtiScore,
                        label: review.rtiLabel,
                        color: rtiColor,
                        hasDetail: review.rtiDetail != null,
                        large: preferences?.rtiLabelStyle == 'BADGE_LARGE',
                      ),
                    ),
                  const SizedBox(width: AppSpacing.xxs),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'ANALYSIS', child: Text('리뷰 분석 보기')),
                      PopupMenuItem(value: 'HELPFUL', child: Text('도움이 됐어요')),
                      PopupMenuItem(
                        value: 'NOT_HELPFUL',
                        child: Text('도움이 안 됐어요'),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'ANALYSIS') {
                        showReviewRtiAnalysisDialog(
                          context,
                          review,
                          safeCount: safeCount,
                          warnCount: warnCount,
                          dangerCount: dangerCount,
                          productId: productId,
                          productName: productName,
                        );
                        return;
                      }
                      if (onFeedback == null) return;
                      final success = await onFeedback!(value);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? '피드백이 제출됐습니다.'
                                  : '피드백 제출에 실패했습니다. 다시 시도해주세요.',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                review.content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
              if (review.reasons.isNotEmpty &&
                  preferences?.showSuspiciousLabel != false) ...[
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: review.reasons
                      .map((r) => _ReasonChip(label: r, color: rtiColor))
                      .toList(),
                ),
              ],
              if (images.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.xs),
                    itemBuilder: (context, index) => ImagePreviewThumbnail(
                      imageUrls: images,
                      index: index,
                      size: 80,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: Text(
          '구매인증',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _RtiBadgeSmall extends StatelessWidget {
  const _RtiBadgeSmall({
    required this.score,
    required this.label,
    required this.color,
    this.hasDetail = false,
    this.large = false,
  });

  final int? score;
  final String? label;
  final Color color;
  final bool hasDetail;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            score != null ? 'RTI $score' : '분석 전',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: large ? 14 : 11,
            ),
          ),
          if (score != null && label?.isNotEmpty == true) ...[
            const SizedBox(width: 4),
            Container(width: 1, height: 9, color: color.withValues(alpha: 0.3)),
            const SizedBox(width: 4),
            Text(
              label!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (hasDetail) ...[
            const SizedBox(width: 2),
            Icon(Icons.chevron_right, size: 10, color: color),
          ],
        ],
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
