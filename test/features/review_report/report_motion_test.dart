import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/features/review_report/domain/entities/review_report.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_report_main_form.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_report_step_indicator.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/review_target_card.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/reason_selector_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/detail_input_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/agreement_section.dart';
import 'package:re_view_front/features/review_report/presentation/widgets/trendy_dropdown.dart';

void main() {
  for (final reduced in [false, true]) {
    testWidgets('form steps preserve the draft (reduced=$reduced)', (
      tester,
    ) async {
      final controller = TextEditingController(
        text: '신고의 상세 근거를 충분히 설명하는 테스트 내용입니다.',
      );
      addTearDown(controller.dispose);
      var step = ReportStep.target;
      var submitting = false;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduced),
            child: Scaffold(
              body: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setState) => ReviewReportMainForm(
                    productName: '테스트 상품',
                    reviewContent: '테스트 리뷰',
                    rtiScore: 70,
                    rtiGrade: 'B',
                    selectedReasons: const {ReportReason.fakeReview},
                    detailController: controller,
                    reportType: null,
                    disclosure: null,
                    includeAiEvidence: false,
                    agreePrivacy: true,
                    agreeNotFalse: true,
                    currentStep: step,
                    maxReachedStep: ReportStep.submit,
                    onStepChanged: (value) => setState(() => step = value),
                    onReasonToggled: (_) {},
                    onReportTypeChanged: (_) {},
                    onDisclosureChanged: (_) {},
                    onIncludeAiChanged: (_) {},
                    onAgreePrivacyChanged: (_) {},
                    onAgreeNotFalseChanged: (_) {},
                    attachments: const [],
                    onAttachmentsChanged: (_) {},
                    onSubmit: () => setState(() => submitting = true),
                    isSubmitting: submitting,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final (label, type, oldType) in [
        ('신고 사유', ReasonSelectorSection, ReviewTargetCard),
        ('상세 근거', DetailInputSection, ReasonSelectorSection),
        ('접수 완료', AgreementSection, DetailInputSection),
      ]) {
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        if (reduced) {
          await tester.pump();
        } else {
          await tester.pumpAndSettle();
        }
        expect(find.byType(type), findsOneWidget);
        expect(find.byType(oldType), findsNothing);
        expect(controller.text, '신고의 상세 근거를 충분히 설명하는 테스트 내용입니다.');
        expect(tester.takeException(), isNull);
      }
      if (reduced) {
        await tester.ensureVisible(find.text('신고 접수하기'));
        await tester.tap(find.text('신고 접수하기'));
        await tester.pumpAndSettle();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(tester.binding.hasScheduledFrame, isFalse);
      }
    });
  }

  testWidgets('reduced motion dropdown opens and selection still works', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: TrendyDropdown(
              label: '분류',
              value: null,
              items: const ['유형 A', '유형 B'],
              onChanged: (value) => selected = value,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('선택해주세요'));
    await tester.pump();
    expect(find.text('유형 B'), findsOneWidget);
    await tester.tap(find.text('유형 B'));
    await tester.pumpAndSettle();
    expect(selected, '유형 B');
    expect(find.text('유형 B'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
