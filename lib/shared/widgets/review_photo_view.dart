import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';

/// Only server-provided, absolute web image URLs; preserve review-local order.
List<String> validReviewImages(Iterable<String> urls) => [
  ...urls.map((s) => s.trim()).where((s) {
    final uri = Uri.tryParse(s);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty;
  }).toSet(),
];

class ReviewPhotoEntry {
  const ReviewPhotoEntry({
    required this.reviewKey,
    required this.images,
    this.label = '',
  });
  final String reviewKey;
  final List<String> images;
  final String label;
}

class ReviewPhotoToolbar extends StatelessWidget {
  const ReviewPhotoToolbar({
    super.key,
    required this.photoOnly,
    required this.photoView,
    required this.onPhotoOnlyChanged,
    required this.onPhotoViewChanged,
    required this.loadedCount,
    required this.photoReviewCount,
    this.sortControls,
  });
  final bool photoOnly, photoView;
  final ValueChanged<bool> onPhotoOnlyChanged, onPhotoViewChanged;
  final int loadedCount, photoReviewCount;
  final Widget? sortControls;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth.clamp(0.0, 360.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: AppRadius.medium,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ReviewViewButton(
                            label: l.reviewListView,
                            icon: Icons.view_list_outlined,
                            selected: !photoView,
                            onPressed: () => onPhotoViewChanged(false),
                          ),
                        ),
                        Expanded(
                          child: _ReviewViewButton(
                            label: l.reviewPhotosView,
                            icon: Icons.photo_library_outlined,
                            selected: photoView,
                            onPressed: () => onPhotoViewChanged(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!photoView)
                FilterChip(
                  avatar: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: Text(l.reviewPhotoOnly),
                  selected: photoOnly,
                  onSelected: onPhotoOnlyChanged,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ?sortControls,
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.reviewPhotoScope(loadedCount, photoReviewCount),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// A single view-mode group, with wrapping text and keyboard activation.
class _ReviewViewButton extends StatelessWidget {
  const _ReviewViewButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    inMutuallyExclusiveGroup: true,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: selected ? AppColors.surface : Colors.transparent,
        foregroundColor: selected ? AppColors.primary : AppColors.textSecondary,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class ReviewPhotoGrid extends StatelessWidget {
  const ReviewPhotoGrid({super.key, required this.entries});
  final List<ReviewPhotoEntry> entries;
  @override
  Widget build(BuildContext context) {
    final photos = [
      for (final entry in entries)
        for (final index in validReviewImages(entry.images).asMap().keys)
          (entry: entry, images: validReviewImages(entry.images), index: index),
    ];
    if (photos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(AppLocalizations.of(context).reviewPhotosEmpty),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisExtent: 180,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, i) {
        final photo = photos[i];
        return Column(
          key: ValueKey((photo.entry.reviewKey, photo.index)),
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => ImagePreviewThumbnail(
                  imageUrls: photo.images,
                  index: photo.index,
                  size: constraints.maxWidth,
                ),
              ),
            ),
            Text(
              photo.entry.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${photo.index + 1}/${photo.images.length}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      },
    );
  }
}
