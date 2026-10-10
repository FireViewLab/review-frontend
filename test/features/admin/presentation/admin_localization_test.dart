import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_view_front/core/network/auth_token_store.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_analysis_feedback.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_dashboard.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_suspicious_review.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_analysis_feedbacks_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_reports_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_suspicious_reviews_page.dart';
import 'package:re_view_front/features/admin/presentation/pages/admin_users_page.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_analysis_feedback_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_analysis_feedback_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_analysis_feedback_view_model.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_dashboard_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_dashboard_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_dashboard_view_model.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_report_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_report_view_model.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_suspicious_review_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_suspicious_review_view_model.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_user_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_user_state.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_user_view_model.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_labels.dart';
import 'package:re_view_front/features/admin/presentation/widgets/admin_top_bar.dart';
import 'package:re_view_front/features/admin/presentation/widgets/report_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/analysis_feedback_detail_panel.dart';
import 'package:re_view_front/features/admin/presentation/widgets/suspicious_review_detail_panel.dart';
import 'package:re_view_front/features/notifications/domain/repositories/notification_repository.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

import '../../../helpers/pump_app.dart';

void main() {
  for (final language in ['ko', 'en', 'ja', 'zh']) {
    final locale = Locale(language);
    test('localizes enum labels and placeholders in $language', () async {
      final l10n = await AppLocalizations.delegate.load(locale);
      expect(
        ReportStatus.pending.localizedLabel(l10n),
        l10n.adminReportPending,
      );
      expect(
        ReportStatus.underReview.localizedLabel(l10n),
        l10n.adminUnderReview,
      );
      expect(
        ReportStatus.accepted.localizedLabel(l10n),
        l10n.adminReportAccepted,
      );
      expect(
        ReportStatus.rejected.localizedLabel(l10n),
        l10n.adminReportRejected,
      );
      expect(
        AnalysisFeedbackStatus.submitted.localizedLabel(l10n),
        l10n.adminFeedbackSubmitted,
      );
      expect(
        AnalysisFeedbackStatus.underReview.localizedLabel(l10n),
        l10n.adminUnderReview,
      );
      expect(
        AnalysisFeedbackStatus.resolved.localizedLabel(l10n),
        l10n.adminFeedbackResolved,
      );
      expect(
        AnalysisFeedbackStatus.rejected.localizedLabel(l10n),
        l10n.adminFeedbackRejected,
      );
      expect(TrustGrade.danger.localizedLabel(l10n), l10n.adminDanger);
      expect(TrustGrade.warning.localizedLabel(l10n), l10n.adminWarning);
      expect(TrustGrade.safe.localizedLabel(l10n), l10n.adminSafe);
      expect(
        analysisUserJudgmentLabel('MORE_TRUSTWORTHY', l10n),
        l10n.adminJudgmentTrustworthy,
      );
      expect(
        analysisUserJudgmentLabel('MORE_RISKY', l10n),
        l10n.adminJudgmentRisky,
      );
      expect(
        analysisUserJudgmentLabel('UNDECIDED', l10n),
        l10n.adminJudgmentUndecided,
      );
      expect(analysisUserJudgmentLabel(null, l10n), '-');
      expect(analysisUserJudgmentLabel('UNKNOWN', l10n), '-');
      expect(l10n.adminSelectedCount(3), contains('3'));
      expect(l10n.adminBulkFailure(5, 2), allOf(contains('5'), contains('2')));
      expect(
        l10n.adminTrendTooltip('2026.10.02', '82.5', '1,200'),
        allOf(contains('2026.10.02'), contains('82.5'), contains('1,200')),
      );
    });

    final pages = <String, Widget>{
      'dashboard': const AdminDashboardPage(),
      'users': const AdminUsersPage(),
      'reports': const AdminReportsPage(),
      'feedbacks': const AdminAnalysisFeedbacksPage(),
      'reviews': const AdminSuspiciousReviewsPage(),
    };
    for (final entry in pages.entries) {
      testWidgets('renders ${entry.key} in $language', (tester) async {
        await _pumpPage(tester, entry.value, locale);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(entry.value.runtimeType)),
        );
        final title = switch (entry.key) {
          'dashboard' => l10n.adminDashboardTitle,
          'users' => l10n.adminMenuUsers,
          'reports' => l10n.adminMenuReports,
          'feedbacks' => l10n.adminMenuAnalysisFeedbacks,
          _ => l10n.adminMenuSuspiciousReviews,
        };
        expect(find.text(title), findsOneWidget);
        expect(find.byTooltip(l10n.adminRefresh), findsOneWidget);
        if (entry.key == 'users') {
          expect(find.text(l10n.adminEmail), findsWidgets);
          expect(find.text(l10n.adminUserRole), findsOneWidget);
        }
        if (entry.key == 'feedbacks') {
          expect(find.text(l10n.adminJudgmentTrustworthy), findsOneWidget);
          expect(find.text('SUBMITTED'), findsNothing);
        }
        if (language != 'ko') {
          final texts = tester
              .widgetList<Text>(find.byType(Text))
              .map((text) => text.data ?? text.textSpan?.toPlainText() ?? '');
          expect(
            texts.where((text) => RegExp(r'[가-힣]').hasMatch(text)),
            isEmpty,
          );
        }
        expect(tester.takeException(), isNull);
      });
    }

    final details = <Widget>[
      ReportDetailPanel(report: _report, onClose: () {}),
      AnalysisFeedbackDetailPanel(feedback: _feedback, onClose: () {}),
      SuspiciousReviewDetailPanel(review: _review, onClose: () {}),
    ];
    for (final detail in details) {
      testWidgets('renders ${detail.runtimeType} in $language', (tester) async {
        await _pumpPage(
          tester,
          Center(child: SizedBox(width: 360, height: 950, child: detail)),
          locale,
        );
        if (language != 'ko') {
          expect(
            tester
                .widgetList<Text>(find.byType(Text))
                .where((text) => RegExp(r'[가-힣]').hasMatch(text.data ?? '')),
            isEmpty,
          );
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final width in [300.0, 800.0, 1400.0]) {
    testWidgets(
      'top bar removes search and opens notifications at width $width',
      (tester) async {
        final repository = _MockNotifications();
        when(
          repository.getUnreadCount,
        ).thenAnswer((_) async => const Success(7));
        final container = ProviderContainer(
          overrides: [
            authTokenStoreProvider.overrideWith(_TokenStore.new),
            notificationRepositoryProvider.overrideWithValue(repository),
            apiClientProvider.overrideWith(
              (ref) => throw StateError('Unexpected API access'),
            ),
          ],
        );
        addTearDown(container.dispose);
        var menuTaps = 0;
        final router = GoRouter(
          initialLocation: '/admin',
          routes: [
            GoRoute(
              path: '/admin',
              builder: (_, _) => Scaffold(
                body: Column(
                  children: [AdminTopBar(onMenuTap: () => menuTaps++)],
                ),
              ),
            ),
            GoRoute(
              path: '/notifications',
              builder: (_, _) =>
                  const Scaffold(body: Text('notifications page')),
            ),
          ],
        );
        addTearDown(router.dispose);
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await _pumpRouter(tester, router, container, const Locale('en'));
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
          tester.element(find.byType(AdminTopBar)),
        );
        expect(find.byType(TextField), findsNothing);
        expect(find.text('7'), findsOneWidget);
        await tester.tap(find.byTooltip(l10n.adminSidebarTitle));
        expect(menuTaps, 1);
        container.read(unreadNotificationCountProvider.notifier).adjust(-7);
        await tester.pump();
        expect(
          tester.widget<Badge>(find.byType(Badge)).isLabelVisible,
          isFalse,
        );
        container.read(unreadNotificationCountProvider.notifier).adjust(105);
        await tester.pump();
        expect(find.text('99+'), findsOneWidget);
        await tester.tap(find.byTooltip(l10n.adminTopBarNotifications));
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          '/notifications',
        );
        expect(find.text('notifications page'), findsOneWidget);
        expect(tester.takeException(), isNull);
        verify(repository.getUnreadCount).called(1);
      },
    );
  }
}

Future<void> _pumpRouter(
  WidgetTester tester,
  GoRouter router,
  ProviderContainer container,
  Locale locale,
) async {
  final template = localizedApp(router: router) as MaterialApp;
  await pumpApp(
    tester,
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: template.theme,
        locale: locale,
        routerConfig: router,
        supportedLocales: template.supportedLocales,
        localizationsDelegates: template.localizationsDelegates,
      ),
    ),
  );
}

Future<void> _pumpPage(WidgetTester tester, Widget page, Locale locale) async {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = ProviderContainer(
    overrides: [
      adminDashboardViewModelProvider.overrideWith(_Dashboard.new),
      adminUserViewModelProvider.overrideWith(_Users.new),
      adminReportViewModelProvider.overrideWith(_Reports.new),
      adminAnalysisFeedbackViewModelProvider.overrideWith(_Feedbacks.new),
      adminSuspiciousReviewViewModelProvider.overrideWith(_Reviews.new),
      apiClientProvider.overrideWith(
        (ref) => throw StateError('Unexpected API access'),
      ),
    ],
  );
  addTearDown(container.dispose);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: page),
      ),
    ],
  );
  addTearDown(router.dispose);
  await _pumpRouter(tester, router, container, locale);
  await tester.pumpAndSettle();
}

class _MockNotifications extends Mock implements NotificationRepository {}

class _TokenStore extends AuthTokenStore {
  @override
  bool build() => true;
  @override
  String? get nickname =>
      'A very long administrator nickname that should be truncated';
}

class _Users extends AdminUserViewModel {
  @override
  AdminUserState build() => const AdminUserState(
    items: [
      AdminUser(
        userId: 1,
        email: 'user@example.com',
        nickname: 'Reviewer',
        role: 'USER',
        provider: 'LOCAL',
        atiScore: 80,
        createdAt: null,
      ),
    ],
  );
}

class _Reports extends AdminReportViewModel {
  @override
  AdminReportState build() => const AdminReportState(items: [_report]);
}

class _Feedbacks extends AdminAnalysisFeedbackViewModel {
  @override
  AdminAnalysisFeedbackState build() =>
      const AdminAnalysisFeedbackState(items: [_feedback]);
}

class _Reviews extends AdminSuspiciousReviewViewModel {
  @override
  AdminSuspiciousReviewState build() =>
      const AdminSuspiciousReviewState(items: [_review]);
}

class _Dashboard extends AdminDashboardViewModel {
  @override
  AdminDashboardState build() => const AdminDashboardState(
    summary: AsyncData(
      AdminDashboardSummary(
        totalReviews: 1200,
        suspiciousReviewCount: 20,
        dangerReviewCount: 10,
        pendingReports: 5,
        pendingAnalysisFeedbacks: 3,
        totalUsers: 100,
      ),
    ),
    performance: AsyncData(
      AdminModelPerformance(
        totalAnalyzedReviews: 1200,
        averageRtiScore: 80,
        rtiDistribution: RtiDistribution(
          safeCount: 1000,
          suspiciousCount: 100,
          dangerCount: 100,
          safePercent: 83.3,
          suspiciousPercent: 8.3,
          dangerPercent: 8.4,
        ),
        userAgreement: UserAgreementStats(
          totalFeedbacks: 10,
          agreementCount: 8,
          disagreementCount: 2,
          agreementRate: 80,
        ),
        feedbackStats: AnalysisFeedbackStats(
          submitted: 1,
          underReview: 2,
          resolved: 5,
          rejected: 2,
          resolutionRate: 70,
        ),
        dailyTrend: [],
      ),
    ),
  );
}

const _review = AdminSuspiciousReview(
  reviewId: 1,
  productId: 2,
  productName: 'Product',
  reviewerNickname: 'Reviewer',
  content: 'Review',
  rating: 4,
  rtiScore: 30,
  trustGrade: TrustGrade.danger,
  reasons: ['Signal'],
  isVerifiedPurchase: true,
  writtenAt: null,
);

const _report = AdminReport(
  reportId: 1,
  reviewId: 2,
  productName: 'Product',
  reviewContent: 'Review',
  reason: 'SPAM',
  reasonDescription: 'Spam',
  detail: 'Report',
  attachmentUrl: null,
  includeAiEvidence: true,
  status: ReportStatus.pending,
  statusDescription: 'Server description',
  adminComment: null,
  createdAt: null,
  updatedAt: null,
);

const _feedback = AdminAnalysisFeedback(
  feedbackId: 1,
  reviewId: 2,
  productName: 'Product',
  reviewContent: 'Review',
  feedbackType: 'OTHER',
  feedbackTypeDescription: 'Other',
  userJudgment: 'MORE_TRUSTWORTHY',
  relatedSignals: ['Signal'],
  detail: 'Feedback',
  attachmentUrl: null,
  replyEmail: null,
  status: AnalysisFeedbackStatus.submitted,
  statusDescription: 'Server description',
  createdAt: null,
  updatedAt: null,
);
