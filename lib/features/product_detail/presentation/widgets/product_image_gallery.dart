import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:re_view_front/shared/widgets/product_image_viewer.dart';

class ProductImageGallery extends StatelessWidget {
  const ProductImageGallery({
    super.key,
    required this.productId,
    required this.imageUrls,
  });
  final int productId;
  final List<String> imageUrls;
  @override
  Widget build(BuildContext context) => ProductImageViewer(
    imageUrls: imageUrls,
    trailingAction: _WishlistButton(productId: productId),
  );
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
              : () async {
                  if (!isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그인이 필요합니다.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  final error = await ref
                      .read(wishlistButtonProvider(productId).notifier)
                      .toggle();
                  if (context.mounted && error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error)));
                  }
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
