import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:re_view_front/features/product_detail/domain/entities/product_analysis_result.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_trend.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group(AnalysisReportTrendSection, () {
    testWidgets('switches between a single observation and the empty period', (
      tester,
    ) async {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day - 10);
      final point = AnalysisTrendPoint(
        date: date.toIso8601String(),
        averageRti: 82.5,
        reviewCount: 10,
        safeCount: 8,
        warnCount: 1,
        dangerCount: 1,
      );
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(
              body: AnalysisReportTrendSection(
                trend: [point],
                isAnalyzing: false,
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await pumpApp(tester, localizedApp(router: router));

      final context = tester.element(find.byType(AnalysisReportTrendSection));
      final l10n = AppLocalizations.of(context);
      final dateLabel = DateFormat.yMMMd(l10n.localeName).format(date);
      final scoreLabel = l10n.detailTrendSingleScore(point.averageRti);

      expect(find.text(dateLabel), findsOneWidget);
      expect(find.text(scoreLabel), findsOneWidget);
      expect(find.byIcon(Icons.circle), findsOneWidget);

      await tester.tap(find.text(l10n.adminPeriodDays(7)));
      await tester.pump();
      expect(find.text(l10n.detailTrendEmptyPeriod), findsOneWidget);
      expect(find.text(dateLabel), findsNothing);
      expect(find.text(scoreLabel), findsNothing);

      await tester.tap(find.text(l10n.adminPeriodDays(30)));
      await tester.pump();
      expect(find.text(l10n.detailTrendEmptyPeriod), findsNothing);
      expect(find.text(scoreLabel), findsOneWidget);
    });
  });
}
