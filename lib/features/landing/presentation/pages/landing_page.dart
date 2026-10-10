import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/responsive/responsive_layout.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/landing/presentation/widgets/landing_hero_section.dart';
import 'package:re_view_front/features/landing/presentation/widgets/landing_rti_demo_card.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _HomePreviewBackground()),
        _Backdrop(onDismiss: () => context.go(RoutePaths.home)),
        _LandingCard(
          onClose: () => context.go(RoutePaths.home),
          onStartPressed: () => context.go(RoutePaths.signup),
          onRtiInfoPressed: () => context.go(RoutePaths.home),
        ),
      ],
    );
  }
}

/// 랜딩 뒤에 보이는 홈 화면 미리보기.
///
/// 실제 HomePage를 그리면 홈 API 호출과 전체 위젯 빌드, BackdropFilter 합성
/// 비용이 첫 화면에 붙는다. 미리 블러 처리한 스크린샷으로 대신한다.
class _HomePreviewBackground extends StatelessWidget {
  const _HomePreviewBackground();

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return ColoredBox(
      color: AppColors.background,
      child: Image.asset(
        isMobile
            ? 'assets/images/landing/home_mobile.webp'
            : 'assets/images/landing/home_desktop.webp',
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.medium,
        excludeFromSemantics: true,
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Container(color: const Color(0x660F172A)),
    );
  }
}

class _LandingCard extends StatelessWidget {
  const _LandingCard({
    required this.onClose,
    required this.onStartPressed,
    required this.onRtiInfoPressed,
  });

  final VoidCallback onClose;
  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, screenSize) {
        final isMobile = screenSize == AppScreenSize.mobile;
        final viewportHeight = MediaQuery.sizeOf(context).height;

        return Center(
          child: Padding(
            padding: isMobile
                ? const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  )
                : const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.lg,
                  ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppBreakpoints.wideContentMaxWidth,
                maxHeight: viewportHeight - AppSpacing.lg * 2,
              ),
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: isMobile
                          ? const EdgeInsets.all(AppSpacing.lg)
                          : const EdgeInsets.all(AppSpacing.xxl),
                      child: isMobile
                          ? _MobileContent(
                              onStartPressed: onStartPressed,
                              onRtiInfoPressed: onRtiInfoPressed,
                            )
                          : _DesktopContent(
                              onStartPressed: onStartPressed,
                              onRtiInfoPressed: onRtiInfoPressed,
                            ),
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: _CloseButton(onPressed: onClose),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent({
    required this.onStartPressed,
    required this.onRtiInfoPressed,
  });

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xxl),
            child: LandingHeroSection(
              onStartPressed: onStartPressed,
              onRtiInfoPressed: onRtiInfoPressed,
            ),
          ),
        ),
        const Expanded(flex: 6, child: LandingRtiDemoCard()),
      ],
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent({
    required this.onStartPressed,
    required this.onRtiInfoPressed,
  });

  final VoidCallback onStartPressed;
  final VoidCallback onRtiInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LandingHeroSection(
          onStartPressed: onStartPressed,
          onRtiInfoPressed: onRtiInfoPressed,
        ),
        const SizedBox(height: AppSpacing.xl),
        const LandingRtiDemoCard(),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.close),
      color: AppColors.textSecondary,
      tooltip: '홈으로',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surface,
        shape: const CircleBorder(),
      ),
    );
  }
}
