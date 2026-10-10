import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';
import 'package:re_view_front/shared/widgets/shimmer_box.dart';
import 'package:re_view_front/features/product_detail/presentation/widgets/analysis_report/analysis_report_loading.dart';

Widget _app(Widget child, {required bool reduced}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Scaffold(body: child),
  ),
);

void main() {
  testWidgets('analysis skeleton becomes static under reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const SingleChildScrollView(child: AnalysisReportSkeletonView()),
        reduced: true,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AnalysisReportSkeletonView), findsOneWidget);
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'reduced motion keeps the loading indicator and message without ticking',
    (tester) async {
      await tester.pumpWidget(
        _app(const AppLoadingView(message: '불러오는 중'), reduced: true),
      );
      await tester.pumpAndSettle();
      expect(find.text('불러오는 중'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.binding.hasScheduledFrame, isFalse);
    },
  );

  testWidgets(
    'changing motion preference stops and resumes shimmer without losing its shape',
    (tester) async {
      const skeleton = ShimmerWrapper(
        child: ShimmerBox(width: 100, height: 30),
      );
      await tester.pumpWidget(_app(skeleton, reduced: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);
      final size = tester.getSize(find.byType(ShimmerBox));
      await tester.pumpWidget(_app(skeleton, reduced: true));
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.getSize(find.byType(ShimmerBox)), size);
      await tester.pumpWidget(_app(skeleton, reduced: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);
    },
  );
}
