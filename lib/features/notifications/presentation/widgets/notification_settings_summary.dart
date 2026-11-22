import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';

/// Shows only persisted server preferences, never an unsaved/default toggle.
class NotificationSettingsSummary extends ConsumerWidget {
  const NotificationSettingsSummary({super.key, this.entryOnly = false});
  final bool entryOnly;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);
    if (entryOnly) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context).myPageSideNavAlerts,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            unread.isLoading
                ? AppLocalizations.of(context).notificationsCheckingUnreadShort
                : unread.hasError
                ? AppLocalizations.of(context).notificationsUnreadFailedShort
                : AppLocalizations.of(
                    context,
                  ).notificationsUnreadCount(unread.value ?? 0),
          ),
          TextButton.icon(
            onPressed: () => context.push(RoutePaths.notifications),
            icon: const Icon(Icons.notifications_outlined),
            label: Text(
              AppLocalizations.of(context).notificationsManageInboxAndPrices,
            ),
          ),
          if (unread.hasError)
            TextButton(
              onPressed: () => ref.invalidate(unreadNotificationCountProvider),
              child: Text(AppLocalizations.of(context).actionRetry),
            ),
        ],
      );
    }
    final settings = ref.watch(savedDisplayPreferencesProvider);
    final data = settings.isLoading || settings.hasError
        ? null
        : settings.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).notificationsServiceTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          unread.isLoading
              ? AppLocalizations.of(context).notificationsCheckingUnread
              : unread.hasError
              ? AppLocalizations.of(context).notificationsUnreadFailed
              : AppLocalizations.of(
                  context,
                ).notificationsUnreadCount(unread.value ?? 0),
        ),
        if (data != null)
          Text(
            [
              AppLocalizations.of(context).notificationsRiskStatus(
                data.notifyRiskyProduct
                    ? AppLocalizations.of(context).notificationsReceiving
                    : AppLocalizations.of(context).notificationsNotReceiving,
              ),
              AppLocalizations.of(context).notificationsAnalysisStatus(
                data.notifyAnalysisComplete
                    ? AppLocalizations.of(context).notificationsReceiving
                    : AppLocalizations.of(context).notificationsNotReceiving,
              ),
              AppLocalizations.of(context).notificationsFeedbackStatus(
                data.notifyFeedbackResult
                    ? AppLocalizations.of(context).notificationsReceiving
                    : AppLocalizations.of(context).notificationsNotReceiving,
              ),
            ].join(' · '),
          )
        else
          Text(
            settings.hasError
                ? AppLocalizations.of(context).notificationsSettingsFailed
                : AppLocalizations.of(context).notificationsSettingsChecking,
          ),
        Wrap(
          spacing: 8,
          children: [
            TextButton.icon(
              onPressed: () => context.push(RoutePaths.settings),
              icon: const Icon(Icons.settings_outlined),
              label: Text(
                AppLocalizations.of(context).notificationsReviewSettings,
              ),
            ),
            if (settings.hasError || unread.hasError)
              TextButton(
                onPressed: () {
                  if (settings.hasError) {
                    ref.invalidate(savedDisplayPreferencesProvider);
                  }
                  if (unread.hasError) {
                    ref.invalidate(unreadNotificationCountProvider);
                  }
                },
                child: Text(AppLocalizations.of(context).actionRetry),
              ),
          ],
        ),
        Text(AppLocalizations.of(context).notificationsMonitoringNotice),
        Text(AppLocalizations.of(context).notificationsInboxNotice),
      ],
    );
  }
}
