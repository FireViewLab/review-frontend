import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class ProductImageGallery extends ConsumerStatefulWidget {
  const ProductImageGallery({
    super.key,
    required this.productId,
    required this.imageUrls,
  });

  final int productId;
  final List<String> imageUrls;

  @override
  ConsumerState<ProductImageGallery> createState() =>
      _ProductImageGalleryState();
}

class _ProductImageGalleryState extends ConsumerState<ProductImageGallery> {
  int _selectedIndex = 0;
  Timer? _autoSlideTimer;
  Offset? _hoverPosition;
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) _hoverPosition = null;
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    if (_reduceMotion || widget.imageUrls.length <= 1) return;
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % widget.imageUrls.length;
      });
    });
  }

  void _goTo(int index) {
    _autoSlideTimer?.cancel();
    setState(() => _selectedIndex = index);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: images.isNotEmpty
                  ? () =>
                        _showProductImageDialog(context, images, _selectedIndex)
                  : null,
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
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _WishlistButton(productId: widget.productId),
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
        final previewSize = (constraints.biggest.shortestSide * 0.62)
            .clamp(260.0, 360.0)
            .toDouble();
        final canShowLeftPreview = constraints.maxWidth > previewSize + 72;
        final alignment = position == null
            ? Alignment.center
            : Alignment(
                (position.dx / constraints.maxWidth).clamp(0, 1) * 2 - 1,
                (position.dy / constraints.maxHeight).clamp(0, 1) * 2 - 1,
              );

        return Stack(
          clipBehavior: Clip.none,
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
                left: canShowLeftPreview ? -previewSize - AppSpacing.md : null,
                right: canShowLeftPreview ? null : AppSpacing.sm,
                top: canShowLeftPreview ? 0 : null,
                bottom: canShowLeftPreview ? null : AppSpacing.sm,
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

class _WishlistButton extends ConsumerWidget {
  const _WishlistButton({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(wishlistButtonProvider(productId));
    final liked = asyncStatus.value ?? false;
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8)],
      ),
      child: SizedBox.square(
        dimension: 40,
        child: IconButton(
          tooltip: liked ? '찜 취소' : '찜하기',
          onPressed: asyncStatus.isLoading
              ? null
              : () {
                  if (!isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그인이 필요합니다.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  ref.read(wishlistButtonProvider(productId).notifier).toggle();
                },
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: liked ? Colors.red : AppColors.textSecondary,
          ),
          padding: EdgeInsets.zero,
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
          tooltip: icon == Icons.chevron_left ? '이전 상품 이미지' : '다음 상품 이미지',
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

void _showProductImageDialog(
  BuildContext context,
  List<String> imageUrls,
  int initialIndex,
) {
  showDialog<void>(
    context: context,
    builder: (_) =>
        _ProductImageDialog(imageUrls: imageUrls, initialIndex: initialIndex),
  );
}

class _ProductImageDialog extends StatefulWidget {
  const _ProductImageDialog({
    required this.imageUrls,
    required this.initialIndex,
  });

  final List<String> imageUrls;
  final int initialIndex;

  @override
  State<_ProductImageDialog> createState() => _ProductImageDialogState();
}

class _ProductImageDialogState extends State<_ProductImageDialog> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.md),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black54),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 680,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: AppRadius.medium,
                    child: AppNetworkImage(
                      url: widget.imageUrls[_current],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (widget.imageUrls.length > 1) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _DialogNavButton(
                        icon: Icons.chevron_left,
                        enabled: _current > 0,
                        onTap: () => setState(() => _current--),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        '${_current + 1} / ${widget.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _DialogNavButton(
                        icon: Icons.chevron_right,
                        enabled: _current < widget.imageUrls.length - 1,
                        onTap: () => setState(() => _current++),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black45,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogNavButton extends StatelessWidget {
  const _DialogNavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: enabled
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.08),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.white38,
          size: 22,
        ),
      ),
    );
  }
}
