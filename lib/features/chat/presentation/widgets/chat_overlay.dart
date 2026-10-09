import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/responsive/breakpoints.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_panel.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_style.dart';
import 'package:re_view_front/features/chat/presentation/widgets/popup_route_tracker.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 앱 전체 위에 떠 있는 챗봇 런처와 패널.
///
/// `MaterialApp.router`의 builder에서 감싸므로 라우트가 바뀌어도 대화가 유지된다.
/// Navigator 바깥이라 TextField 선택 메뉴 등을 위해 자체 [Overlay]를 둔다.
class ChatOverlay extends StatefulWidget {
  const ChatOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<ChatOverlay> createState() => _ChatOverlayState();
}

class _ChatOverlayState extends State<ChatOverlay> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) => const _ChatLayer(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(child: Overlay(initialEntries: [_entry])),
      ],
    );
  }
}

/// 챗봇을 숨기는 화면. 인증·온보딩 흐름과 관리자 화면에서는 띄우지 않는다.
const _hiddenPathPrefixes = [
  RoutePaths.landing,
  RoutePaths.login,
  RoutePaths.signup,
  RoutePaths.onboarding,
  RoutePaths.oauthCallback,
  RoutePaths.passwordReset,
  RoutePaths.resetPassword,
  RoutePaths.admin,
];

/// Data 서버 상품 화면 경로 `/product/{platform}/{productId}`.
///
/// 숫자 ID만 있는 기존 상품 화면(`/product/{id}`)은 맞지 않는다. 챗봇은 Data 서버
/// 상품만 찾을 수 있어서, 그 화면에서는 상품 없이 일반 질문으로 대화한다.

class _ChatLayer extends ConsumerWidget {
  const _ChatLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // redirect가 적용된 최종 위치를 써야 한다. routeInformationProvider는
    // 브라우저가 요청한 위치(예: 로그인 상태의 /landing)를 그대로 들고 있다.
    return ListenableBuilder(
      listenable: Listenable.merge([router.routerDelegate, popupRouteTracker]),
      builder: (context, _) {
        final path = router.routerDelegate.currentConfiguration.uri.path;
        final hidden = _hiddenPathPrefixes.any(
          (prefix) => path == prefix || path.startsWith('$prefix/'),
        );
        // 다이얼로그·바텀시트가 열려 있으면 모달 위로 올라오지 않게 숨긴다.
        if (hidden || popupRouteTracker.hasPopup) {
          return const SizedBox.shrink();
        }

        final productRef = ExternalProductRef.fromRoute(
          router.routerDelegate.currentConfiguration.uri,
        );
        // 서버가 받는 형식은 "{platform}-{productId}"다.
        final extra = router.routerDelegate.currentConfiguration.extra;
        final productId = productRef == null
            ? null
            : extra is ProductRouteContext
            ? extra.chatProductId
            : productRef.externalId;
        return _ChatLauncherLayout(
          router: router,
          productId: productId,
          // 홈 모바일은 하단 탭(72px) 위로 띄운다.
          hasBottomTabs: path == RoutePaths.home,
        );
      },
    );
  }
}

class _ChatLauncherLayout extends ConsumerWidget {
  const _ChatLauncherLayout({
    required this.router,
    required this.productId,
    required this.hasBottomTabs,
  });

  final GoRouter router;
  final String? productId;
  final bool hasBottomTabs;

  static const double _bottomTabsHeight = 72;
  static const double _panelWidth = 420;
  static const double _panelMaxHeight = 720;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(chatViewModelProvider.select((s) => s.isOpen));
    final l10n = AppLocalizations.of(context);
    final media = MediaQuery.of(context);
    final isMobile = AppBreakpoints.isMobile(media.size.width);
    final edge = isMobile ? AppSpacing.md : AppSpacing.lg;
    final bottom =
        media.padding.bottom +
        edge +
        (isMobile && hasBottomTabs ? _bottomTabsHeight : 0);

    void onPlanPressed() {
      // 모바일에서는 패널이 화면을 덮으므로 닫고 이동한다.
      if (isMobile) ref.read(chatViewModelProvider.notifier).close();
      router.go(RoutePaths.plan);
    }

    void onLoginPressed() {
      ref.read(chatViewModelProvider.notifier).close();
      router.go(RoutePaths.login);
    }

    if (!isOpen) {
      return Stack(
        children: [
          Positioned(
            right: edge,
            bottom: bottom,
            child: _Launcher(
              // 모바일은 화면이 좁아 아이콘만 둔다.
              label: isMobile ? null : l10n.chatLauncherLabel,
              tooltip: l10n.chatLauncherTooltip,
              onPressed: ref.read(chatViewModelProvider.notifier).open,
            ),
          ),
        ],
      );
    }

    // 패널에 닫기 버튼이 있으므로 열려 있는 동안 런처는 그리지 않는다.
    return Stack(
      children: [
        if (isMobile)
          Positioned.fill(
            // 화면 키보드가 올라오면 입력창이 가려지지 않게 그만큼 올린다.
            bottom: media.viewInsets.bottom,
            child: SafeArea(
              child: ChatPanel(
                productId: productId,
                onLoginPressed: onLoginPressed,
                onPlanPressed: onPlanPressed,
                fullScreen: true,
              ),
            ),
          )
        else
          Positioned(
            right: edge,
            bottom: edge + media.padding.bottom,
            width: math.min(
              _panelWidth,
              math.max(
                0,
                media.size.width - media.padding.horizontal - 2 * edge,
              ),
            ),
            // 창이 낮으면 화면 밖으로 나가지 않게 창 높이에 맞춘다.
            height: math.min(
              math.max(
                media.size.height - media.padding.vertical - 2 * edge,
                0,
              ),
              _panelMaxHeight,
            ),
            child: _Appear(
              child: ChatPanel(
                productId: productId,
                onLoginPressed: onLoginPressed,
                onPlanPressed: onPlanPressed,
              ),
            ),
          ),
      ],
    );
  }
}

/// 패널이 아래에서 살짝 올라오며 나타난다.
class _Appear extends StatelessWidget {
  const _Appear({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: child,
      // Keep the panel's Material opaque over underlying DOM image views.
      // Animate position only; fading the whole panel exposes home imagery.
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 16 * (1 - value)),
        child: child,
      ),
    );
  }
}

/// 어시스턴트를 여는 버튼. 무엇을 하는 버튼인지 보이도록 문구를 함께 둔다.
class _Launcher extends StatefulWidget {
  const _Launcher({
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  /// null이면 아이콘만 그린다.
  final String? label;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<_Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<_Launcher> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    const radius = BorderRadius.all(Radius.circular(28));
    final scale = _hovered && !MediaQuery.disableAnimationsOf(context)
        ? 1.03
        : 1.0;
    return Tooltip(
      message: widget.tooltip,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 140),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Color(0x1F0F172A),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          // 사이트의 카드·버튼과 같은 흰 바탕에 얇은 테두리를 쓴다.
          child: Material(
            color: AppColors.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: ChatStyle.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onPressed,
              onHover: (value) => setState(() => _hovered = value),
              child: Padding(
                padding: EdgeInsets.fromLTRB(6, 6, label == null ? 6 : 18, 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ChatMark(size: 40),
                    if (label != null) ...[
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: ChatStyle.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
