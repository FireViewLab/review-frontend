import 'package:re_view_front/features/price_watch/presentation/widgets/price_watch_section.dart';
import 'package:re_view_front/features/notifications/presentation/widgets/notification_settings_summary.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';
import 'package:re_view_front/features/notifications/presentation/notification_target.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';
import 'package:re_view_front/features/notifications/presentation/view_models/notification_list_state.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';
import 'package:re_view_front/shared/widgets/app_content_view.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool _priceMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(notificationListViewModelProvider);
    final vm = ref.read(notificationListViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NotificationListener<ScrollNotification>(
        // 바닥 근처까지 스크롤하면 다음 페이지를 불러온다.
        onNotification: (notification) {
          if (!_priceMode &&
              notification.depth == 0 &&
              notification.metrics.axis == Axis.vertical &&
              notification.metrics.extentAfter < 400) {
            vm.loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          key: PageStorageKey(
            _priceMode ? 'price-alerts' : 'all-notifications',
          ),
          slivers: [
            SliverToBoxAdapter(
              child: AppContentView(
                maxWidth: 840,
                padding: EdgeInsets.fromLTRB(
                  context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                  context.isMobile ? AppSpacing.lg : AppSpacing.xl,
                  context.isMobile ? AppSpacing.md : AppSpacing.xxl,
                  AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.notificationsTitle,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed:
                              !_priceMode &&
                                  !state.isLoading &&
                                  !state.isLoadingMore &&
                                  !state.isMutating
                              ? vm.markAllRead
                              : null,
                          icon: const Icon(Icons.done_all_rounded, size: 18),
                          label: Text(l10n.notificationsMarkAllRead),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('전체 알림'),
                          selected: !_priceMode,
                          onSelected: (_) => setState(() => _priceMode = false),
                        ),
                        ChoiceChip(
                          label: const Text('가격 알림'),
                          selected: _priceMode,
                          onSelected: (_) => setState(() => _priceMode = true),
                        ),
                      ],
                    ),
                    if (!_priceMode) ...[
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton.icon(
                            onPressed: state.isLoading || state.isMutating
                                ? null
                                : vm.refresh,
                            icon: const Icon(Icons.refresh),
                            label: const Text('새로고침'),
                          ),
                          TextButton.icon(
                            onPressed: () => context.push(RoutePaths.settings),
                            icon: const Icon(Icons.settings_outlined),
                            label: const Text('알림 설정'),
                          ),
                        ],
                      ),
                      const ExpansionTile(
                        title: Text('저장된 알림 수신 설정'),
                        childrenPadding: EdgeInsets.all(12),
                        children: [NotificationSettingsSummary()],
                      ),
                      if (state.errorMessage != null &&
                          state.items.isNotEmpty) ...[
                        Text(
                          state.errorMessage!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                        TextButton(
                          onPressed: state.failedPage
                              ? vm.retryMore
                              : vm.refresh,
                          child: const Text('다시 시도'),
                        ),
                      ],
                      if (!state.isLast &&
                          !state.isLoading &&
                          state.errorMessage == null)
                        TextButton(
                          onPressed: state.isLoadingMore || state.isMutating
                              ? null
                              : vm.loadMore,
                          child: const Text('더 보기'),
                        ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.sizeOf(context).width > 872
                    ? (MediaQuery.sizeOf(context).width - 840) / 2
                    : 16,
                0,
                MediaQuery.sizeOf(context).width > 872
                    ? (MediaQuery.sizeOf(context).width - 840) / 2
                    : 16,
                32,
              ),
              sliver: _priceMode
                  ? const PriceWatchSliver()
                  : _Body(
                      state: state,
                      onRetry: vm.refresh,
                      onTap: (notification) {
                        vm.markRead(notification.id);
                        final route = notificationRoute(notification.targetUrl);
                        if (route != null) {
                          context.push(route);
                        } else if (notification.targetUrl != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('이 알림의 이동 대상은 아직 지원되지 않습니다.'),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.onRetry,
    required this.onTap,
  });

  final NotificationListState state;
  final VoidCallback onRetry;
  final ValueChanged<AppNotification> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.isLoading && state.items.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 320,
          child: AppLoadingView(message: l10n.notificationsLoading),
        ),
      );
    }
    if (state.errorMessage != null && state.items.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 320,
          child: AppErrorView(message: state.errorMessage!, onRetry: onRetry),
        ),
      );
    }
    if (state.items.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
          child: Column(
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.notificationsEmpty,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.notificationsEmptyBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppColors.border),
      itemBuilder: (context, index) => index == state.items.length
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          : _NotificationTile(
              key: ValueKey(state.items[index].id),
              notification: state.items[index],
              onTap: () => onTap(state.items[index]),
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconFor(notification.type);
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: notification.isRead ? AppColors.surface : AppColors.primaryLight,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: textTheme.titleSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (notification.message.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        notification.message,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      [
                        if (notification.typeDescription.isNotEmpty)
                          notification.typeDescription,
                        _formatDate(notification.createdAt),
                      ].join(' · '),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (IconData, Color) _iconFor(String type) {
    if (type.startsWith('REPORT_')) {
      return (Icons.flag_outlined, AppColors.warning);
    }
    if (type.startsWith('ANALYSIS_FEEDBACK_')) {
      return (Icons.feedback_outlined, AppColors.info);
    }
    return switch (type) {
      'ANALYSIS_COMPLETE' => (Icons.task_alt_rounded, AppColors.success),
      'ANALYSIS_FAILED' => (Icons.error_outline_rounded, AppColors.error),
      'RISKY_PRODUCT_DETECTED' => (
        Icons.warning_amber_rounded,
        AppColors.error,
      ),
      _ => (Icons.campaign_outlined, AppColors.primary),
    };
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}.${two(local.month)}.${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}
