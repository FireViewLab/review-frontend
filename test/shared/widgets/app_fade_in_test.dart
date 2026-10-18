import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_motion.dart';
import 'package:re_view_front/shared/widgets/app_fade_in.dart';

void main() {
  double opacityOf(WidgetTester tester) => tester
      .widget<FadeTransition>(
        find.descendant(
          of: find.byType(AppFadeIn),
          matching: find.byType(FadeTransition),
        ),
      )
      .opacity
      .value;

  testWidgets('finishes within the base duration even with a long delay', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppFadeIn(delay: 360, child: Text('내용'))),
    );
    expect(opacityOf(tester), 0);

    // 지연 상한 60ms + 180ms 안에 끝난다.
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pump(AppMotion.base);
    await tester.pump();
    expect(opacityOf(tester), 1);
  });

  testWidgets('shows the content at once when motion is reduced', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: AppFadeIn(delay: 360, child: Text('내용')),
        ),
      ),
    );
    expect(opacityOf(tester), 1);
  });
}
