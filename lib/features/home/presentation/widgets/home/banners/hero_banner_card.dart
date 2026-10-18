import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_network_image.dart';

class HeroBannerCard extends StatelessWidget {
  const HeroBannerCard({
    super.key,
    required this.item,
    required this.focus,
    required this.child,
    required this.onPressed,
  });

  final HomeBannerData item;
  final double focus;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${item.title} ${item.emphasis}',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0x160F172A,
                ).withValues(alpha: 0x16 / 255 * focus),
                blurRadius: 24,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: child,
          ),
        ),
      ),
    );
  }
}

class HeroBannerImage extends StatelessWidget {
  const HeroBannerImage({
    super.key,
    required this.item,
    required this.onPressed,
  });
  final HomeBannerData item;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final useCompactText = context.viewportSize.width < 1280;
    return item.imageUrl != null
        ? AppNetworkImage(
            url: context.isMobile
                ? item.mobileImageUrl ?? item.imageUrl!
                : item.imageUrl!,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            placeholderIcon: Icons.image_not_supported_outlined,
          )
        : Image.asset(
            item.assetPath!,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => context.isMobile
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        '${item.title}\n${item.emphasis}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(38),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 11,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                item.emphasis,
                                style:
                                    (context.isMobile || useCompactText
                                            ? Theme.of(
                                                context,
                                              ).textTheme.headlineSmall
                                            : Theme.of(
                                                context,
                                              ).textTheme.displayMedium)
                                        ?.copyWith(
                                          color: item.accentColor,
                                          fontWeight: FontWeight.w900,
                                        ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                item.description,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              OutlinedButton(
                                onPressed: onPressed,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(item.ctaLabel),
                                    const SizedBox(width: AppSpacing.xxs),
                                    const Icon(Icons.chevron_right, size: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!context.isMobile) ...[
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 8,
                            child: HeroBannerVisual(item: item),
                          ),
                        ],
                      ],
                    ),
                  ),
          );
  }
}

class HeroBannerVisual extends StatelessWidget {
  const HeroBannerVisual({super.key, required this.item});

  final HomeBannerData item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 172,
          height: 172,
          decoration: const BoxDecoration(
            color: Color(0xB3FFFFFF),
            shape: BoxShape.circle,
          ),
        ),
        Icon(item.icon, size: 118, color: item.accentColor.withAlpha(210)),
        Positioned(
          top: AppSpacing.sm,
          right: 0,
          child: Container(
            width: 104,
            height: 104,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x120F172A),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              '${item.badgeLabel}\n신뢰도 확인',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
