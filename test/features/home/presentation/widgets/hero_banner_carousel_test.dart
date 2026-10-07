import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/theme/app_theme.dart';
import 'package:re_view_front/features/home/presentation/data/home_content.dart';
import 'package:re_view_front/features/home/presentation/widgets/home/banners/hero_banner_carousel.dart';

void main() {
  Future<void> pumpCarousel(
    WidgetTester tester, {
    bool reduced = false,
    Size size = const Size(1440, 900),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reduced,
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        ),
        home: Scaffold(body: HeroBannerCarousel(items: banners)),
      ),
    );
    await tester.pumpAndSettle();
  }

  PageController controller(WidgetTester tester) =>
      tester.widget<PageView>(find.byType(PageView)).controller!;
  Finder indicator(int index) => find.byWidgetPredicate(
    (w) =>
        w is Semantics && w.properties.label == '배너 $index/${banners.length}',
  );

  testWidgets(
    'centers a dominant asset without cropping and retains the slide on resize',
    (tester) async {
      await pumpCarousel(tester);
      var ctl = controller(tester);
      final page = ctl.page!.round();
      final image = find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName == banners.first.assetPath,
      );
      expect(tester.getCenter(image).dx, closeTo(720, 1));
      expect(tester.getSize(image).width, greaterThan(900));
      expect(tester.widget<Image>(image).fit, BoxFit.contain);
      await tester.tap(find.byTooltip('다음 배너'));
      await tester.pumpAndSettle();
      expect(ctl.page, closeTo(page + 1, .01));
      expect(indicator(2), findsOneWidget);
      await pumpCarousel(tester, size: const Size(390, 900));
      ctl = controller(tester);
      expect(ctl.page, closeTo(page + 1, .01));
      expect(indicator(2), findsOneWidget);
      expect(
        tester.getSize(find.byType(HeroBannerCarousel)).height,
        lessThan(300),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rapid arrows and wrap-around reflect the settled page', (
    tester,
  ) async {
    await pumpCarousel(tester);
    final ctl = controller(tester);
    final page = ctl.page!.round();
    await tester.tap(find.byTooltip('다음 배너'));
    await tester.pump(const Duration(milliseconds: 30));
    await tester.tap(find.byTooltip('다음 배너'));
    await tester.pumpAndSettle();
    expect(ctl.page, closeTo(page + 2, .01));
    expect(indicator(3), findsOneWidget);
    await tester.tap(find.byTooltip('이전 배너'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('이전 배너'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('이전 배너'));
    await tester.pumpAndSettle();
    expect(indicator(banners.length), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(indicator(1), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'pause and reduced motion stop auto advancing while manual controls work',
    (tester) async {
      await pumpCarousel(tester, size: const Size(320, 900), textScale: 1.5);
      final initial = controller(tester).page!;
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(controller(tester).page, closeTo(initial + 1, .01));
      await tester.tap(find.byTooltip('일시정지'));
      await tester.pump(const Duration(seconds: 10));
      expect(controller(tester).page, closeTo(initial + 1, .01));
      await tester.tap(find.byTooltip('재생'));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(controller(tester).page, closeTo(initial + 2, .01));
      await pumpCarousel(tester, reduced: true, size: const Size(320, 900));
      final reducedPage = controller(tester).page!;
      await tester.pump(const Duration(seconds: 10));
      expect(controller(tester).page, reducedPage);
      await tester.tap(find.byTooltip('다음 배너'));
      await tester.pumpAndSettle();
      expect(controller(tester).page, closeTo(reducedPage + 1, .01));
      expect(tester.takeException(), isNull);
    },
  );
}
