import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/features/product_detail/domain/entities/product_detail.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/rti_summary_card.dart';

void main() {
  testWidgets('uses Korean wording for high repetition instead of hanja', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RtiSummaryCard(
            rtiSummary: const RtiSummary(
              rtiScore: 50,
              rtiLabel: '주의',
              rtiSubLabel: '확인 필요',
              realReviewRatio: 0.5,
              realReviewLabel: '보통',
              adSuspicionRatio: 0.2,
              adSuspicionLabel: '높음',
              repetitionRatio: 0.4,
              repetitionLabel: '높음',
              summaryMessage: '반복 표현이 확인됩니다.',
              analyzedReviewCount: 10,
            ),
            onDetailPressed: () {},
          ),
        ),
      ),
    );

    // 리포트 카드는 점수와 요약만 보여 주고 한자 표기를 쓰지 않는다.
    expect(find.textContaining('多'), findsNothing);
    expect(find.text('50'), findsOneWidget);
  });
}
