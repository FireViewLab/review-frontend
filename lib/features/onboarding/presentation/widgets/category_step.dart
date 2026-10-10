import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/features/onboarding/domain/entities/onboarding_preferences.dart';

class CategoryStep extends StatelessWidget {
  const CategoryStep({
    super.key,
    required this.selectedCategories,
    required this.availableCategories,
    required this.minTrustScore,
    required this.onThresholdChanged,
    required this.onToggle,
    required this.onNext,
    required this.onSkip,
  });
  final Set<String> selectedCategories;
  final List<PreferenceCategory> availableCategories;
  final int minTrustScore;
  final ValueChanged<int> onThresholdChanged;
  final ValueChanged<String> onToggle;
  final VoidCallback? onNext;
  final VoidCallback onSkip;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        '관심 있는 카테고리를 선택해 주세요',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: AppSpacing.sm),
      const Text('선택하지 않아도 진행할 수 있습니다. 관심 설정은 나중에 설정에서 다시 변경할 수 있어요.'),
      const SizedBox(height: AppSpacing.lg),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final category in availableCategories)
            FilterChip(
              label: Text(category.displayName),
              selected: selectedCategories.contains(category.value),
              onSelected: (_) => onToggle(category.value),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('신뢰도 기준: $minTrustScore점'),
      const Text('분석 전 상품을 안전한 상품으로 판정하지 않습니다.'),
      Slider(
        value: minTrustScore.toDouble(),
        min: 0,
        max: 100,
        divisions: 100,
        label: '$minTrustScore',
        onChanged: (value) => onThresholdChanged(value.round()),
      ),
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        spacing: 12,
        children: [
          TextButton(onPressed: onSkip, child: const Text('기존 설정으로 건너뛰기')),
          FilledButton(onPressed: onNext, child: const Text('다음')),
        ],
      ),
    ],
  );
}
