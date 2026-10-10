import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/features/settings/presentation/providers/settings_providers.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';

/// Shows only persisted server preferences, never an unsaved/default toggle.
class NotificationSettingsSummary extends ConsumerWidget {
  const NotificationSettingsSummary({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(savedDisplayPreferencesProvider);
    final unread = ref.watch(unreadNotificationCountProvider);
    final data = settings.isLoading || settings.hasError
        ? null
        : settings.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('서비스 알림', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Text(
          unread.isLoading
              ? '읽지 않은 알림을 확인하고 있어요.'
              : unread.hasError
              ? '읽지 않은 알림 수를 확인하지 못했어요.'
              : '읽지 않은 알림 ${unread.value ?? 0}개',
        ),
        if (data != null)
          Text(
            [
              '위험 감지 ${data.notifyRiskyProduct ? '받음' : '받지 않음'}',
              '분석 결과 ${data.notifyAnalysisComplete ? '받음' : '받지 않음'}',
              '처리 결과 ${data.notifyFeedbackResult ? '받음' : '받지 않음'}',
            ].join(' · '),
          )
        else
          Text(settings.hasError ? '저장된 알림 설정을 불러오지 못했어요.' : '저장된 알림 설정 확인 중'),
        Wrap(
          spacing: 8,
          children: [
            TextButton.icon(
              onPressed: () => context.push(RoutePaths.notifications),
              icon: const Icon(Icons.notifications_outlined),
              label: const Text('알림함 열기'),
            ),
            TextButton.icon(
              onPressed: () => context.push(RoutePaths.settings),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('알림·리뷰 설정'),
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
                child: const Text('다시 시도'),
              ),
          ],
        ),
        const Text('위험 변화 자동 감시는 서버 연동이 필요해요. 수신 설정을 켜는 것만으로 감시가 시작되지는 않아요.'),
        const Text('알림함에 저장된 알림을 확인해요. 브라우저 푸시·이메일·문자는 지원하지 않아요.'),
      ],
    );
  }
}
