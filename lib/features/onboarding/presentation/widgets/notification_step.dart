import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

class NotificationStep extends StatelessWidget {
  const NotificationStep({
    super.key,
    required this.state,
    required this.onChanged,
    required this.onPrevious,
    required this.onComplete,
  });
  final OnboardingState state;
  final ValueChanged<SettingsData> onChanged;
  final VoidCallback onPrevious;
  final VoidCallback onComplete;
  @override
  Widget build(BuildContext context) {
    final settings = state.settings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('알림 설정', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        const Text('알림함에서 받을 알림을 선택하세요. 실제 분석 결과가 생성된 경우에만 관련 알림을 받을 수 있어요.'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('위험 상품 알림'),
          value: settings.notifyRiskyProduct,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyRiskyProduct: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('분석 완료 알림'),
          value: settings.notifyAnalysisComplete,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyAnalysisComplete: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('피드백 처리 결과'),
          value: settings.notifyFeedbackResult,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyFeedbackResult: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('마케팅·이벤트 알림 동의'),
          value: settings.notifyMarketing,
          onChanged: (value) =>
              onChanged(settings.copyWith(notifyMarketing: value)),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          '브라우저 푸시·이메일·문자 및 주간 리포트는 현재 제공되지 않습니다. 이 화면은 알림함 설정을 저장합니다.',
        ),
        const SizedBox(height: AppSpacing.lg),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          spacing: 12,
          children: [
            OutlinedButton(onPressed: onPrevious, child: const Text('이전')),
            FilledButton(onPressed: onComplete, child: const Text('저장하고 완료')),
          ],
        ),
      ],
    );
  }
}
