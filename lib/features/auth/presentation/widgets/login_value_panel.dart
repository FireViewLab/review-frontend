import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_product.dart';
import 'package:re_view_front/features/landing/presentation/providers/landing_providers.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class LoginValuePanel extends ConsumerWidget {
  const LoginValuePanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (compact) {
      return Text(
        '내 관심 상품을 이어서 관리하세요.',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      );
    }
    final productAsync = ref.watch(featuredProductProvider);
    final product = productAsync.value;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _LoginBadge(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '내 관심 상품의 리뷰 신뢰도를\n계속 추적하세요.',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              height: 1.16,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '로그인하면 저장한 상품, 신뢰 필터 설정, 분석 피드백 내역을 한 계정에서 이어서 관리할 수 있습니다.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 36),
          _TrustSummaryCard(product: product),
          const SizedBox(height: AppSpacing.lg),
          const _LoginBenefitGrid(),
        ],
      ),
    );
  }
}

class _LoginBadge extends StatelessWidget {
  const _LoginBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          '안전한 쇼핑을 위한 로그인',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _TrustSummaryCard extends StatelessWidget {
  const _TrustSummaryCard({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '최근 확인한 상품',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '로그인 후 저장 상품과 분석 기록을 불러옵니다.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const _TrackingBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _FeaturedProductSection(product: product),
          ],
        ),
      ),
    );
  }
}

class _TrackingBadge extends StatelessWidget {
  const _TrackingBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          'RTI 계속 추적',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _FeaturedProductSection extends StatelessWidget {
  const _FeaturedProductSection({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useHorizontal = constraints.maxWidth >= 560;
        final thumbnail = Stack(
          clipBehavior: Clip.none,
          children: [
            _ProductThumbnail(product: product),
            Positioned(
              right: -10,
              top: 16,
              child: _RtiScoreBadge(score: product?.rtiScore),
            ),
          ],
        );
        final details = _ProductDetails(product: product);

        if (!useHorizontal) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbnail,
              const SizedBox(height: AppSpacing.lg),
              details,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            thumbnail,
            const SizedBox(width: AppSpacing.xl),
            Expanded(child: details),
          ],
        );
      },
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product?.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return const _SkeletonBox(width: 150, height: 150, radius: 22);
    }

    return SizedBox(
      width: 150,
      height: 150,
      child: AppNetworkImage(
        url: imageUrl,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(22),
        placeholderIcon: Icons.inventory_2_outlined,
        iconSize: 42,
      ),
    );
  }
}

class _RtiScoreBadge extends StatelessWidget {
  const _RtiScoreBadge({required this.score});

  final int? score;

  Color get _color {
    if (score == null) return AppColors.primary;
    if (score! >= 80) return AppColors.success;
    if (score! >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: _color, width: 2),
      ),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: score != null
              ? Text(
                  '$score',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _color,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                )
              : const _SkeletonBox(width: 20, height: 12, radius: 6),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({required this.product});

  final DashboardProduct? product;

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 300, height: 20, radius: 8),
          SizedBox(height: AppSpacing.sm),
          _SkeletonBox(width: 230, height: 14, radius: 7),
          SizedBox(height: AppSpacing.lg),
          _SkeletonMetricRow(label: '텍스트', widthFactor: 0.64),
          SizedBox(height: AppSpacing.sm),
          _SkeletonMetricRow(label: '행동', widthFactor: 0.78),
          SizedBox(height: AppSpacing.sm),
          _SkeletonMetricRow(label: '구매맥락', widthFactor: 0.86),
        ],
      );
    }

    final rti = (product!.rtiScore ?? 0).clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product!.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          product!.storeName.isNotEmpty ? product!.storeName : '카테고리 미분류',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SkeletonMetricRow(
          label: '텍스트',
          widthFactor: (rti * 0.90).clamp(0, 100) / 100,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SkeletonMetricRow(
          label: '행동',
          widthFactor: (rti * 1.05).clamp(0, 100) / 100,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SkeletonMetricRow(label: '구매맥락', widthFactor: rti / 100),
      ],
    );
  }
}

class _SkeletonMetricRow extends StatelessWidget {
  const _SkeletonMetricRow({required this.label, required this.widthFactor});

  final String label;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              const _SkeletonBox(
                width: double.infinity,
                height: 7,
                radius: 999,
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const _SkeletonBox(width: 28, height: 12, radius: 6),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FA),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFE3E8F2)),
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F7FC), Color(0xFFE9EEF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: width == 150
          ? Center(
              child: Icon(
                Icons.inventory_2_outlined,
                color: AppColors.textTertiary.withValues(alpha: 0.7),
                size: 42,
              ),
            )
          : null,
    );
  }
}

class _LoginBenefitGrid extends StatelessWidget {
  const _LoginBenefitGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        number: '1',
        title: '저장 상품 관리',
        body: '관심 상품을 모아두고 RTI 변화 위협 신호를 확인합니다.',
      ),
      (
        number: '2',
        title: '개인 신뢰 필터',
        body: '위험 리뷰 숨김, 최소 RTI 기준 등 나에게 맞는 필터를 유지합니다.',
      ),
      (number: '3', title: '분석 피드백 추적', body: '신고와 피드백 처리 상태를 한곳에서 확인합니다.'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 560;
        final cards = [
          for (final item in items)
            _BenefitCard(
              number: item.number,
              title: item.title,
              body: item.body,
            ),
        ];

        if (!useRow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards) ...[
                card,
                if (card != cards.last) const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final card in cards) ...[
              Expanded(child: card),
              if (card != cards.last) const SizedBox(width: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                number,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
