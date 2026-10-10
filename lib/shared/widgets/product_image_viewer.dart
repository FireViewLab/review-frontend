import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:re_view_front/core/utils/product_image_urls.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';
import 'package:re_view_front/shared/widgets/image_preview_dialog.dart';

class ProductImageViewer extends StatefulWidget {
  const ProductImageViewer({
    super.key,
    this.trailingAction,
    required this.imageUrls,
  });

  final Widget? trailingAction;
  final List<String> imageUrls;

  @override
  State<ProductImageViewer> createState() => _ProductImageViewerState();
}

class _ProductImageViewerState extends State<ProductImageViewer> {
  int _selectedIndex = 0;
  Timer? _autoSlideTimer;
  Offset? _hoverPosition;
  bool _reduceMotion = false;

  List<String> get _images => productImageUrls(additional: widget.imageUrls);

  @override
  void didUpdateWidget(ProductImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldImages = productImageUrls(additional: oldWidget.imageUrls);
    if (listEquals(oldImages, _images)) return;
    final selected = _selectedIndex < oldImages.length
        ? oldImages[_selectedIndex]
        : null;
    final next = selected == null ? -1 : _images.indexOf(selected);
    _selectedIndex = next < 0 ? 0 : next;
    _hoverPosition = null;
    _startAutoSlide();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) _hoverPosition = null;
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (_reduceMotion || _hoverPosition != null || _images.length <= 1) return;
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % _images.length;
      });
    });
  }

  void _goTo(int index) {
    _autoSlideTimer?.cancel();
    setState(() => _selectedIndex = index);
    _startAutoSlide();
  }

  void _openImageDialog() {
    _autoSlideTimer?.cancel();
    final l10n = AppLocalizations.of(context);
    showImagePreviewDialog(
      context,
      imageUrls: _images,
      initialIndex: _selectedIndex,
      title: l10n.productImageEnlarge,
      previousLabel: l10n.productImagePrevious,
      nextLabel: l10n.productImageNext,
    ).whenComplete(() {
      if (mounted) _startAutoSlide();
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Semantics(
              button: images.isNotEmpty,
              label: AppLocalizations.of(context).productImageEnlarge,
              child: GestureDetector(
                onHorizontalDragStart: images.length <= 1
                    ? null
                    : (_) => _autoSlideTimer?.cancel(),
                onHorizontalDragEnd: images.length <= 1
                    ? null
                    : (details) {
                        final speed = details.primaryVelocity ?? 0;
                        if (speed.abs() > 80) {
                          _goTo(
                            (_selectedIndex + (speed < 0 ? 1 : -1)).clamp(
                              0,
                              images.length - 1,
                            ),
                          );
                        } else {
                          _startAutoSlide();
                        }
                      },
                child: InkWell(
                  borderRadius: AppRadius.large,
                  onTap: images.isNotEmpty ? _openImageDialog : null,
                  child: MouseRegion(
                    cursor: images.isNotEmpty
                        ? SystemMouseCursors.zoomIn
                        : MouseCursor.defer,
                    onHover: images.isNotEmpty && !_reduceMotion
                        ? (event) {
                            _autoSlideTimer?.cancel();
                            setState(
                              () => _hoverPosition = event.localPosition,
                            );
                          }
                        : null,
                    onExit: (_) {
                      setState(() => _hoverPosition = null);
                      _startAutoSlide();
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FB),
                          borderRadius: AppRadius.large,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: _selectedIndex < images.length
                            ? _ZoomableProductImage(
                                url: images[_selectedIndex],
                                hoverPosition: _hoverPosition,
                              )
                            : const ColoredBox(color: AppColors.surfaceMuted),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.trailingAction != null)
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: widget.trailingAction!,
              ),
            if (images.length > 1) ...[
              Positioned(
                left: AppSpacing.xs,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _GalleryArrowButton(
                    icon: Icons.chevron_left,
                    onPressed: _selectedIndex > 0
                        ? () => _goTo(_selectedIndex - 1)
                        : null,
                  ),
                ),
              ),
              Positioned(
                right: AppSpacing.xs,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _GalleryArrowButton(
                    icon: Icons.chevron_right,
                    onPressed: _selectedIndex < images.length - 1
                        ? () => _goTo(_selectedIndex + 1)
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.sm,
                right: AppSpacing.sm,
                child: _IndexIndicator(
                  current: _selectedIndex + 1,
                  total: images.length,
                ),
              ),
            ],
          ],
        ),
        if (images.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 68,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => _goTo(index),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: AppRadius.small,
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.small,
                      child: SizedBox.square(
                        dimension: 66,
                        child: AppNetworkImage(url: images[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _IndexIndicator extends StatelessWidget {
  const _IndexIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          '$current / $total',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ZoomableProductImage extends StatefulWidget {
  const _ZoomableProductImage({required this.url, required this.hoverPosition});

  final String url;
  final Offset? hoverPosition;

  @override
  State<_ZoomableProductImage> createState() => _ZoomableProductImageState();
}

class _ZoomableProductImageState extends State<_ZoomableProductImage> {
  // The decorative overlay belongs to this photo's route and disappears with
  // it. Its child is empty until the photo is hovered and side space exists.
  final _previewController = OverlayPortalController()..show();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final position = widget.hoverPosition;
        final showZoom =
            position != null &&
            MediaQuery.sizeOf(context).width >= 768 &&
            constraints.biggest.shortestSide > 220;
        final lensSize = (constraints.biggest.shortestSide * 0.26)
            .clamp(112.0, 148.0)
            .toDouble();
        final preferredPreviewSize = (constraints.biggest.shortestSide * 0.55)
            .clamp(112.0, 300.0)
            .toDouble();
        final alignment = position == null
            ? Alignment.center
            : Alignment(
                (position.dx / constraints.maxWidth).clamp(0, 1) * 2 - 1,
                (position.dy / constraints.maxHeight).clamp(0, 1) * 2 - 1,
              );

        return OverlayPortal.overlayChildLayoutBuilder(
          controller: _previewController,
          overlayChildBuilder: (context, info) {
            if (!showZoom) return const SizedBox.shrink();
            final imageRect = MatrixUtils.transformRect(
              info.childPaintTransform,
              Offset.zero & info.childSize,
            );
            final padding = MediaQuery.paddingOf(context);
            final inset = AppSpacing.sm;
            final safeRect = Rect.fromLTRB(
              padding.left + inset,
              padding.top + inset,
              info.overlaySize.width - padding.right - inset,
              info.overlaySize.height - padding.bottom - inset,
            );
            // Never put the preview back over the photo or outside the screen.
            // Small layouts retain the explicit click/touch image dialog.
            if (!safeRect.overlaps(imageRect)) {
              return const SizedBox.shrink();
            }
            final rightSpace = safeRect.right - imageRect.right - inset;
            final leftSpace = imageRect.left - inset - safeRect.left;
            final availableSize = math.min(
              leftSpace >= 112 ? leftSpace : rightSpace,
              safeRect.height,
            );
            if (availableSize < 112) return const SizedBox.shrink();
            final previewSize = math.min(preferredPreviewSize, availableSize);
            final double left;
            if (leftSpace >= previewSize) {
              left = imageRect.left - inset - previewSize;
            } else if (rightSpace >= previewSize) {
              left = imageRect.right + inset;
            } else {
              return const SizedBox.shrink();
            }
            final top = (imageRect.bottom - previewSize)
                .clamp(safeRect.top, safeRect.bottom - previewSize)
                .toDouble();
            return Positioned(
              left: left,
              top: top,
              child: ExcludeSemantics(
                child: _ZoomPreview(
                  url: widget.url,
                  alignment: alignment,
                  size: previewSize,
                ),
              ),
            );
          },
          child: Stack(
            clipBehavior: Clip.hardEdge,
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: AppRadius.large,
                child: AppNetworkImage(url: widget.url),
              ),
              if (showZoom) ...[
                Positioned(
                  left: (position.dx - lensSize / 2).clamp(
                    8,
                    constraints.maxWidth - lensSize - 8,
                  ),
                  top: (position.dy - lensSize / 2).clamp(
                    8,
                    constraints.maxHeight - lensSize - 8,
                  ),
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.36),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: const [
                          BoxShadow(color: Color(0x22000000), blurRadius: 10),
                        ],
                      ),
                      child: SizedBox.square(dimension: lensSize),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ZoomPreview extends StatelessWidget {
  const _ZoomPreview({
    required this.url,
    required this.alignment,
    required this.size,
  });

  final String url;
  final Alignment alignment;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.medium,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.medium,
          child: SizedBox.square(
            dimension: size,
            child: Transform.scale(
              scale: 2.8,
              alignment: alignment,
              child: AppNetworkImage(url: url),
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryArrowButton extends StatelessWidget {
  const _GalleryArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: SizedBox.square(
        dimension: 32,
        child: IconButton(
          tooltip: icon == Icons.chevron_left
              ? AppLocalizations.of(context).productImagePrevious
              : AppLocalizations.of(context).productImageNext,
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          padding: EdgeInsets.zero,
          color: onPressed != null
              ? AppColors.textPrimary
              : AppColors.textTertiary,
        ),
      ),
    );
  }
}
