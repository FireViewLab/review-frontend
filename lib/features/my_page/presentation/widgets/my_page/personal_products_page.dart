import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/app/theme/app_colors.dart';

/// A full-page viewport, never a scrollable list inside a profile card/dialog.
class PersonalProductsPage extends StatelessWidget {
  const PersonalProductsPage({
    super.key,
    required this.title,
    required this.scope,
    required this.onRefresh,
    required this.sliver,
    this.controls,
  });
  final String title;
  final String scope;
  final VoidCallback onRefresh;
  final Widget sliver;
  final Widget? controls;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: LayoutBuilder(
      builder: (context, constraints) {
        final inset = constraints.maxWidth > 872
            ? (constraints.maxWidth - 840) / 2
            : 16.0;
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(inset, 16, inset, 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: '마이페이지로 돌아가기',
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(RoutePaths.myPage);
                            }
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          tooltip: '새로고침',
                          onPressed: onRefresh,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(scope),
                    if (controls != null) ...[
                      const SizedBox(height: 16),
                      controls!,
                    ],
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(inset, 0, inset, 32),
              sliver: sliver,
            ),
          ],
        );
      },
    ),
  );
}
