import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/account/presentation/widgets/account_navigation.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';

/// 계정 메뉴를 유지하며 유한한 높이 안에서 본문 Navigator를 전환한다.
class AccountShell extends ConsumerWidget {
  const AccountShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;
  static const _sideNavBreakpoint = 980.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = switch (ref.watch(myPageViewModelProvider)) {
      MyPageSuccess(:final profile) => profile,
      _ => null,
    };
    if (context.viewportSize.width < _sideNavBreakpoint) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.isMobile ? AppSpacing.md : AppSpacing.xxl,
              AppSpacing.lg,
              context.isMobile ? AppSpacing.md : AppSpacing.xxl,
              0,
            ),
            child: AccountTabBar(location: location),
          ),
          Expanded(child: Semantics(container: true, child: child)),
        ],
      );
    }
    return AppContentView(
      maxWidth: 1320,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 260,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: AccountSideNav(location: location, profile: profile),
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(child: Semantics(container: true, child: child)),
        ],
      ),
    );
  }
}

/// 스크롤은 Navigator 바깥이 아니라 각 계정 본문 안에 둔다.
class AccountContent extends StatelessWidget {
  const AccountContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = context.viewportSize.width >= AccountShell._sideNavBreakpoint;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        wide
            ? 0
            : context.isMobile
            ? AppSpacing.md
            : AppSpacing.xxl,
        context.isMobile ? AppSpacing.lg : AppSpacing.xl,
        wide
            ? 0
            : context.isMobile
            ? AppSpacing.md
            : AppSpacing.xxl,
        AppSpacing.xxxl,
      ),
      child: child,
    );
  }
}
