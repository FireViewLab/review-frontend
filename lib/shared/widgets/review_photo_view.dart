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
  });
  final bool photoOnly, photoView;
  final ValueChanged<bool> onPhotoOnlyChanged, onPhotoViewChanged;
  final int loadedCount, photoReviewCount;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Text(l.reviewPhotoOnly),
              selected: photoOnly,
              onSelected: onPhotoOnlyChanged,
            ),
            ChoiceChip(
              label: Text(l.reviewListView),
              selected: !photoView,
              onSelected: (_) => onPhotoViewChanged(false),
            ),
            ChoiceChip(
              label: Text(l.reviewPhotosView),
              selected: photoView,
              onSelected: (_) => onPhotoViewChanged(true),
            ),
          ],
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
