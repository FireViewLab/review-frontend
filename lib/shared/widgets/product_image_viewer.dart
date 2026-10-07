import 'dart:async';
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

  List<String> get _images => widget.imageUrls
      .where((url) => url.trim().isNotEmpty)
      .toList(growable: false);

  @override
  void didUpdateWidget(ProductImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedIndex >= _images.length) _selectedIndex = 0;
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
    if (_reduceMotion || _images.length <= 1) return;
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
              child: InkWell(
                borderRadius: AppRadius.large,
                onTap: images.isNotEmpty ? _openImageDialog : null,
                child: MouseRegion(
                  cursor: images.isNotEmpty
                      ? SystemMouseCursors.zoomIn
                      : MouseCursor.defer,
                  onHover: images.isNotEmpty && !_reduceMotion
                      ? (event) =>
                            setState(() => _hoverPosition = event.localPosition)
                      : null,
                  onExit: (_) => setState(() => _hoverPosition = null),
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

class _ZoomableProductImage extends StatelessWidget {
  const _ZoomableProductImage({required this.url, required this.hoverPosition});

  final String url;
  final Offset? hoverPosition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final position = hoverPosition;
        final showZoom =
            position != null && constraints.biggest.shortestSide > 220;
        final lensSize = (constraints.biggest.shortestSide * 0.26)
            .clamp(112.0, 148.0)
            .toDouble();
        final previewSize = (constraints.biggest.shortestSide * 0.55)
            .clamp(112.0, 300.0)
            .toDouble();
        final alignment = position == null
            ? Alignment.center
            : Alignment(
                (position.dx / constraints.maxWidth).clamp(0, 1) * 2 - 1,
                (position.dy / constraints.maxHeight).clamp(0, 1) * 2 - 1,
              );

        return Stack(
          clipBehavior: Clip.hardEdge,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: AppRadius.large,
              child: AppNetworkImage(url: url),
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
              _ZoomPreview(
                url: url,
                alignment: alignment,
                size: previewSize,
                left: AppSpacing.sm,
                right: null,
                top: null,
                bottom: AppSpacing.sm,
              ),
            ],
          ],
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
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  final String url;
  final Alignment alignment;
  final double size;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: IgnorePointer(
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
