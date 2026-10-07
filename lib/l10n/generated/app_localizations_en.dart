// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navCart => 'Cart';

  @override
  String get navWishlist => 'Saved';

  @override
  String get navMyPage => 'My Page';

  @override
  String get navSettings => 'Settings';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'OK';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionBack => 'Back';

  @override
  String get actionLogin => 'Log in';

  @override
  String get actionLogout => 'Log out';

  @override
  String get actionSignup => 'Sign up';

  @override
  String get actionViewAll => 'View all';

  @override
  String get stateLoading => 'Loading…';

  @override
  String get stateError => 'Something went wrong.';

  @override
  String get stateEmpty => 'Nothing to show.';

  @override
  String get settingsSaved => 'Settings saved.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsFilters => 'Analysis Filters';

  @override
  String get langKorean => '한국어';

  @override
  String get langEnglish => 'English';

  @override
  String get langJapanese => '日本語';

  @override
  String get langChinese => '中文(简体)';

  @override
  String get sideNavOrders => 'Orders';

  @override
  String get sideNavRecentlyViewed => 'Recently Viewed';

  @override
  String get sideNavReviewActivity => 'Review Activity';

  @override
  String get sideNavAccountSettings => 'Account Settings';

  @override
  String get sideNavFeedbackHistory => 'Feedback History';

  @override
  String get settingsSubtitle =>
      'Manage your notifications, filters, and account.';

  @override
  String settingsSubtitleNamed(String nickname) {
    return 'Manage $nickname\'s notifications, filters, and account.';
  }

  @override
  String get settingsNotificationEmail => 'Email Notifications';

  @override
  String get settingsNotificationEmailDesc =>
      'Receive price drops and review updates via email.';

  @override
  String get settingsNotificationPush => 'Push Notifications';

  @override
  String get settingsNotificationPushDesc =>
      'Get real-time alerts for saved products in your browser.';

  @override
  String get settingsNotificationAdEmail => 'Promotional Emails';

  @override
  String get settingsNotificationAdEmailDesc =>
      'Receive promotions and personalized deals via email.';

  @override
  String get settingsFilterHighlightLowRti => 'Show Risky Products First';

  @override
  String get settingsFilterHighlightLowRtiDesc =>
      'Show products with low review trust scores at the top of the list.';

  @override
  String get settingsFilterWishlistAlert => 'Wishlist RTI Alerts';

  @override
  String get settingsFilterWishlistAlertDesc =>
      'Get notified when your saved products\' RTI changes.';

  @override
  String get settingsFilterCategory => 'Category Filter';

  @override
  String get settingsFilterCategoryDesc =>
      'Prioritize analysis results based on the selected category.';

  @override
  String get settingsFilterCategoryAll => 'All Categories';

  @override
  String get settingsFilterMinReview => 'Minimum Review Count';

  @override
  String get settingsFilterMinReviewDesc =>
      'Only include products with at least this many reviews in analysis.';

  @override
  String get settingsFilterMinReviewSuffix => '';

  @override
  String get settingsFilterLowRti => 'Low RTI Warning Threshold';

  @override
  String get settingsFilterLowRtiDesc =>
      'Products with RTI scores at or below this value are flagged.';

  @override
  String get settingsFilterLowRtiSuffix => '';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsAccountChangePassword => 'Change Password';

  @override
  String get settingsAccountLabelName => 'Name';

  @override
  String get settingsAccountLabelEmail => 'Email';

  @override
  String get settingsAccountLabelJoinDate => 'Joined';

  @override
  String get settingsAccountLabelMemberType => 'Member Type';

  @override
  String get settingsAccountDefaultName => 'User';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role Member';
  }

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageApplyNow => 'Changes apply immediately.';

  @override
  String get settingsSavedFeedback => 'Saved!';

  @override
  String get wishlistTitle => 'Saved Products';

  @override
  String get wishlistSubtitle =>
      'View saved products and check prices and review trust scores at a glance.';

  @override
  String wishlistCount(int count) {
    return '$count saved';
  }

  @override
  String get wishlistEmpty => 'No saved products';

  @override
  String get wishlistEmptyDesc =>
      'Tap the heart on a product card to add it to your list.';

  @override
  String get wishlistBrowse => 'Browse Products';

  @override
  String get wishlistFilteredEmpty =>
      'No saved products match the selected filter.';

  @override
  String get wishlistSummaryTitle => 'Wishlist Summary';

  @override
  String wishlistSummaryTotal(int count) {
    return 'Total $count';
  }

  @override
  String get wishlistSummaryPriceDrop => 'Price Drop';

  @override
  String get wishlistSummaryNewAlert => 'New Alert';

  @override
  String get wishlistSummaryTotalReview => 'Total Reviews';

  @override
  String get wishlistProductView => 'View Product';

  @override
  String get wishlistProductPriceDrop => 'Price Drop';

  @override
  String get wishlistSortRecent => 'Recently Saved';

  @override
  String get wishlistSortPriceLow => 'Price: Low to High';

  @override
  String get wishlistSortPriceHigh => 'Price: High to Low';

  @override
  String get wishlistSortRti => 'RTI: High to Low';

  @override
  String get wishlistSortReviewCount => 'Most Reviews';

  @override
  String get wishlistFilterAll => 'All';

  @override
  String get wishlistFilterPriceDrop => 'Price Drop';

  @override
  String get wishlistFilterRti => 'RTI Score';

  @override
  String get wishlistFilterLowestPrice => 'Lowest Price';

  @override
  String get wishlistFilterBrand => 'Brand';

  @override
  String get wishlistFilterCategory => 'Category';

  @override
  String get myPageTitle => 'My Page';

  @override
  String get myPageLoading => 'Loading your page…';

  @override
  String get myPageWishlistLoading => 'Loading saved products…';

  @override
  String get myPageWishlistEmpty => 'No saved products.';

  @override
  String get myPageInterestProducts => 'Saved Products';

  @override
  String get myPageDefaultName => 'User';

  @override
  String get myPageMemberBasic => 'Basic (Free)';

  @override
  String get myPageSideNavMyPage => 'My Page';

  @override
  String get myPageSideNavOrders => 'Orders';

  @override
  String get myPageSideNavWishlist => 'Saved';

  @override
  String get myPageSideNavRecentlyViewed => 'Recently Viewed';

  @override
  String get myPageSideNavRiskyProducts => 'Risky Products';

  @override
  String get myPageSideNavAlerts => 'Alerts';

  @override
  String get myPageRecentActivity => 'Recent Activity';

  @override
  String get myPageRecentActivityEmpty => 'No recent activity.';

  @override
  String get myPageRecentLabel => 'Recent';

  @override
  String get myPageReviewTrustSummary => 'Review Trust Summary';

  @override
  String get myPageAvgRti => 'Avg. RTI of Saved Products';

  @override
  String get myPageRtiSaveHint =>
      'Save products to see the review trust summary.';

  @override
  String get myPageRiskyNone => 'No products need attention in your dashboard.';

  @override
  String myPageRiskyCount(int count) {
    return 'Check $count risky products.';
  }

  @override
  String get myPageHighlightLowRti => 'Show Risky Products First';

  @override
  String get myPageWishlistAlertLabel => 'Wishlist RTI Alerts';

  @override
  String get myPageAccountInfo => 'Account Info';

  @override
  String get myPageAccountInfoSubtitle =>
      'Manage your personal and basic information.';

  @override
  String myPageAccountNickname(String nickname) {
    return 'Nickname: $nickname';
  }

  @override
  String myPageAccountEmail(String email) {
    return 'Email: $email';
  }

  @override
  String myPageAccountMemberType(String role) {
    return 'Member Type: $role';
  }

  @override
  String get myPageDefaultMemberRole => 'Basic';

  @override
  String get myPageLoginInfo => 'Login Info';

  @override
  String get myPageLoginInfoSubtitle => 'Manage your email and login method.';

  @override
  String myPageLoginEmail(String email) {
    return 'Login email: $email';
  }

  @override
  String get myPageLoginStatus => 'Auth status: Logged in';

  @override
  String get myPageOnboardingComplete => 'Complete';

  @override
  String get myPageOnboardingIncomplete => 'Incomplete';

  @override
  String myPageOnboarding(String status) {
    return 'Onboarding: $status';
  }

  @override
  String get myPageChangePassword => 'Change Password';

  @override
  String get myPageChangePasswordSubtitle => 'Keep your account secure.';

  @override
  String get myPageNotificationSettings => 'Notifications';

  @override
  String get myPageNotificationSettingsSubtitle =>
      'Set up email and push notifications.';

  @override
  String get myPageAccountSecurity => 'Account / Security';

  @override
  String get navCategory => 'Category';

  @override
  String get navWishShort => 'Saved';

  @override
  String get navMyShort => 'My';

  @override
  String get homeSearchHint => 'Search products based on reviews';

  @override
  String get homeSearchSuggestionsTitle => 'Related Searches';

  @override
  String get homeSearchSuggestionsLoading => 'Loading related searches...';

  @override
  String get homeSearchSuggestionsHint =>
      'Type at least 2 characters to see related searches.';

  @override
  String get homeRecentSearchTitle => 'Recent Searches';

  @override
  String get homeRecentSearchDeleteAll => 'Clear All';

  @override
  String get homeRecentSearchEmpty => 'No recent searches.';

  @override
  String get homePopularSearchTitle => 'Popular';

  @override
  String get homeSearchProductsTitle => 'Suggested Products';

  @override
  String get homeTrendingTitle => 'Trending Keywords';

  @override
  String get homeKeywordsEmpty => 'No keywords to display.';

  @override
  String get homeRecommendedTitle => 'Editor\'s Review-Based Picks';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeLoginRequired => 'Login required.';

  @override
  String get homeBenefitTitle => 'Benefits for New Customers';

  @override
  String get homeBenefitSubtitle =>
      'Enjoy member benefits when you start review-based shopping.';

  @override
  String get homeBenefitButton => 'Get Benefits';

  @override
  String get homeTrustDescription =>
      'We filter promotional and manipulated reviews, analyze genuine reviews, and provide a trust score.';

  @override
  String get homeTrustViewMore => 'Learn More';

  @override
  String get homeTrustLabel1 => 'Real Review Analysis';

  @override
  String get homeTrustLabel2 => 'Ad/Manipulation Filtering';

  @override
  String get homeTrustLabel3 => 'Trust Score';

  @override
  String get homePopularCategoryTitle => 'Popular Categories';

  @override
  String get homeCategoryEmpty => 'No categories to display.';

  @override
  String get feedbackHistoryTitle => 'My Feedback History';

  @override
  String get feedbackHistorySubtitle =>
      'View the history of product/review feedback you\'ve submitted.';

  @override
  String get feedbackHistoryLoading => 'Loading feedback history...';

  @override
  String get feedbackHistoryEmpty => 'No feedback submitted yet.';

  @override
  String get feedbackHistoryEmptyDesc =>
      'You can submit review feedback on the product detail page.';

  @override
  String feedbackHistoryCount(int count) {
    return '$count feedback item(s)';
  }

  @override
  String get feedbackHistoryViewProduct => 'View Product';

  @override
  String get feedbackStatusSubmitted => 'Submitted';

  @override
  String get feedbackStatusPending => 'Under Review';

  @override
  String get feedbackStatusAccepted => 'Accepted';

  @override
  String get feedbackStatusRejected => 'Rejected';

  @override
  String get adminSidebarTitle => 'Admin';

  @override
  String get adminMenuDashboard => 'Dashboard';

  @override
  String get adminMenuSuspiciousReviews => 'Suspicious Reviews';

  @override
  String get adminMenuReports => 'Reports';

  @override
  String get adminMenuAnalysisFeedbacks => 'Analysis Feedback';

  @override
  String get adminMenuUsers => 'Users';

  @override
  String get adminMenuLogout => 'Log out';

  @override
  String get adminDashboardTitle => 'Operations Dashboard';

  @override
  String get adminPlaceholderMessage => 'This screen is coming soon.';

  @override
  String get adminTopBarSearchHint => 'Search users, reviews, report IDs';

  @override
  String get adminTopBarNotifications => 'Notifications';

  @override
  String get chatLauncherTooltip => 'Open AI assistant';

  @override
  String get chatTitle => 'Re:view AI';

  @override
  String get chatSubtitle => 'Help with reviews and buying decisions';

  @override
  String get chatNewConversation => 'New chat';

  @override
  String get chatClose => 'Close';

  @override
  String get chatInputHint => 'Type your question';

  @override
  String get chatSend => 'Send';

  @override
  String get chatProductContext =>
      'Answers are based on this product\'s reviews';

  @override
  String get chatOtherProductNotice =>
      'This conversation keeps a different context from the current page.';

  @override
  String get chatStartWithThisProduct => 'New chat for this product';

  @override
  String get chatEmptyTitle => 'Ask what you want to know about reviews';

  @override
  String get chatEmptyBody =>
      'Suggestions only fill the input. Review the question before sending.';

  @override
  String get chatSuggestProduct1 => 'Are this product\'s reviews trustworthy?';

  @override
  String get chatSuggestProduct2 => 'Are there many sponsored reviews?';

  @override
  String get chatSuggestProduct3 => 'What downsides do real buyers mention?';

  @override
  String get chatSuggestGeneral1 => 'How is the RTI score calculated?';

  @override
  String get chatSuggestGeneral2 => 'How do I spot sponsored reviews?';

  @override
  String get chatThinking => 'Preparing an answer';

  @override
  String get chatLoginTitle => 'Log in to ask the AI';

  @override
  String get chatLoginBody => 'Your chats are saved to your account.';

  @override
  String get chatLoginButton => 'Log in';

  @override
  String get chatErrorUnavailable =>
      'The assistant is temporarily unavailable. Please try again shortly.';

  @override
  String get chatErrorTimeout =>
      'The answer is taking too long. Please try again.';

  @override
  String get chatErrorNetwork => 'Please check your network connection.';

  @override
  String get chatErrorUnknown => 'Couldn\'t get an answer.';

  @override
  String get chatRetry => 'Retry';

  @override
  String get chatDisclaimer => 'AI answers are for reference and may be wrong.';

  @override
  String get settingsReviewDisplay => 'Review display';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsRtiThreshold => 'Minimum RTI threshold';

  @override
  String get settingsRtiThresholdDesc => 'Filter reviews below this RTI score.';

  @override
  String get settingsReviewSort => 'Default review order';

  @override
  String get settingsSortVerifiedRecent => 'Verified, newest first';

  @override
  String get settingsSortRecent => 'Newest first';

  @override
  String get settingsSortHelpful => 'Most helpful';

  @override
  String get settingsRtiLabel => 'RTI label style';

  @override
  String get settingsLabelSmall => 'Small badge';

  @override
  String get settingsLabelLarge => 'Large badge';

  @override
  String get settingsLabelNone => 'Hidden';

  @override
  String get settingsCardDensity => 'Product card density';

  @override
  String get settingsDensityComfortable => 'Comfortable';

  @override
  String get settingsDensityCompact => 'Compact';

  @override
  String get settingsLoading => 'Loading settings.';

  @override
  String get settingsLoadFailed => 'Could not load settings.';

  @override
  String get settingsSaveFailed => 'Could not save settings.';

  @override
  String get settingsRiskyProduct => 'Risky product alerts';

  @override
  String get settingsRiskyProductDesc =>
      'Get notified when a saved product becomes risky.';

  @override
  String get settingsAnalysisComplete => 'Analysis complete alerts';

  @override
  String get settingsAnalysisCompleteDesc =>
      'Get notified when product analysis is complete.';

  @override
  String get settingsFeedbackResult => 'Feedback result alerts';

  @override
  String get settingsFeedbackResultDesc =>
      'Get updates on submitted reports and feedback.';

  @override
  String get settingsMarketing => 'Marketing notifications';

  @override
  String get settingsMarketingDesc =>
      'Receive recommendations and marketing notifications.';

  @override
  String get settingsHideRisky => 'Hide risky reviews';

  @override
  String get settingsHideRiskyDesc => 'Collapse risky reviews by default.';

  @override
  String get settingsSuspiciousLabel => 'Show suspicious review labels';

  @override
  String get settingsSuspiciousLabelDesc =>
      'Label reviews with suspicious behavior.';

  @override
  String get settingsVerifiedFirst => 'Prioritize verified reviews';

  @override
  String get settingsVerifiedFirstDesc =>
      'Show verified purchase reviews first.';

  @override
  String get settingsAutoAnalysis => 'Open analysis automatically';

  @override
  String get settingsAutoAnalysisDesc =>
      'Open analysis details when a risky review is clicked.';

  @override
  String get settingsDataAnalysis => 'Allow review data analysis';

  @override
  String get settingsDataAnalysisDesc =>
      'Allow your data to be used for review analysis.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsLoading => 'Loading notifications';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsEmptyBody =>
      'We\'ll let you know here when reports, feedback, or analyses are processed.';

  @override
  String get headerNotifications => 'Alerts';

  @override
  String get chatPreviousConversations => 'Previous conversations';

  @override
  String get chatBackToConversation => 'Back to conversation';

  @override
  String get chatHistoryLoading => 'Loading previous conversations.';

  @override
  String get chatHistoryEmpty => 'No previous conversations.';

  @override
  String get chatHistoryLoadError =>
      'Could not load previous conversations. Please try again.';

  @override
  String get chatHistoryLoadMore => 'Load more';

  @override
  String get chatHistoryUntitled => 'Untitled conversation';

  @override
  String get adminUsersSubtitle => 'View registered users, newest first.';

  @override
  String get adminRefresh => 'Refresh';

  @override
  String get adminTotalUsers => 'Total users';

  @override
  String get adminRetry => 'Retry';

  @override
  String get adminEmail => 'Email';

  @override
  String get adminNickname => 'Nickname';

  @override
  String get adminRole => 'Role';

  @override
  String get adminSignupProvider => 'Sign-up method';

  @override
  String get adminAtiScore => 'ATI score';

  @override
  String get adminJoinedAt => 'Joined';

  @override
  String get adminUserRole => 'User';

  @override
  String get adminUsersEmpty => 'No registered users.';

  @override
  String get adminNaver => 'Naver';

  @override
  String get adminReportPending => 'Awaiting review';

  @override
  String get adminUnderReview => 'Under review';

  @override
  String get adminReportAccepted => 'Accepted';

  @override
  String get adminReportRejected => 'Rejected';

  @override
  String get adminDanger => 'Risky';

  @override
  String get adminWarning => 'Warning';

  @override
  String get adminSafe => 'Safe';

  @override
  String get adminFeedbackSubmitted => 'Submitted';

  @override
  String get adminFeedbackResolved => 'Resolved';

  @override
  String get adminFeedbackRejected => 'Rejected';

  @override
  String get adminJudgmentTrustworthy => 'More trustworthy';

  @override
  String get adminJudgmentRisky => 'More risky';

  @override
  String get adminJudgmentUndecided => 'Undecided';

  @override
  String get adminReviewDetails => 'Review details';

  @override
  String get adminViewProduct => 'View product';

  @override
  String get adminRtiAnalysis => 'RTI analysis';

  @override
  String get adminScoreUnit => 'points';

  @override
  String get adminReviewContent => 'Review content';

  @override
  String adminDetectedSignals(int count) {
    return 'Detected signals ($count)';
  }

  @override
  String get adminVerifiedPurchase => 'Verified purchase';

  @override
  String get adminVerified => 'Verified';

  @override
  String get adminNotVerified => 'Not verified';

  @override
  String get adminReviewerInfo => 'Reviewer information';

  @override
  String get adminReviewer => 'Reviewer';

  @override
  String get adminRating => 'Rating';

  @override
  String get adminWrittenAt => 'Written';

  @override
  String adminSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get adminSaved => 'Changes saved.';

  @override
  String get adminSaveFailed => 'Could not save changes.';

  @override
  String get adminFeedbackDetails => 'Feedback details';

  @override
  String get adminSaveChanges => 'Save changes';

  @override
  String get adminFeedbackId => 'Feedback ID';

  @override
  String get adminReviewId => 'Review ID';

  @override
  String get adminProductName => 'Product';

  @override
  String get adminCreatedAt => 'Created';

  @override
  String get adminUpdatedAt => 'Updated';

  @override
  String get adminFeedbackType => 'Feedback type';

  @override
  String get adminUserJudgment => 'User judgment';

  @override
  String adminRelatedSignals(int count) {
    return 'Related signals ($count)';
  }

  @override
  String get adminFeedbackContent => 'Feedback content';

  @override
  String get adminAttachmentLink => 'Attachment / link';

  @override
  String get adminReplyEmail => 'Reply email';

  @override
  String get adminComment => 'Admin note';

  @override
  String get adminCommentHint => 'Enter review notes or actions taken...';

  @override
  String get adminChangeStatus => 'Change status';

  @override
  String get adminReportDetails => 'Report details';

  @override
  String get adminSave => 'Save';

  @override
  String get adminReportInfo => 'Report information';

  @override
  String get adminReportId => 'Report ID';

  @override
  String get adminReportReason => 'Report reason';

  @override
  String get adminReportedAt => 'Reported';

  @override
  String get adminUpdatedTime => 'Updated';

  @override
  String get adminReportedReview => 'Reported review';

  @override
  String get adminReportContent => 'Report content';

  @override
  String get adminAttachment => 'Attachment';

  @override
  String get adminEvidenceIncluded => 'AI evidence included';

  @override
  String get adminIncluded => 'Included';

  @override
  String get adminNotIncluded => 'Not included';

  @override
  String get adminOptionalCommentHint => 'Enter a note (optional).';

  @override
  String get adminSuspiciousReviewsSubtitle =>
      'Review suspicious reviews detected by RTI analysis and take appropriate action.';

  @override
  String get adminRtiUpperBound => 'RTI score limit';

  @override
  String adminScoreBelow(int score) {
    return 'Below $score';
  }

  @override
  String get adminAll => 'All';

  @override
  String get adminTotalSuspiciousReviews => 'Total suspicious reviews';

  @override
  String get adminCurrentFilter => 'Current filter';

  @override
  String get adminRtiScore => 'RTI score';

  @override
  String get adminTrustGrade => 'Trust grade';

  @override
  String get adminSuspiciousReviewsEmpty => 'No suspicious reviews to show.';

  @override
  String get adminFeedbacksSubtitle =>
      'Review and handle user feedback on RTI analysis results.';

  @override
  String get adminTotalFeedbacks => 'Total feedback';

  @override
  String get adminAllTime => 'All time';

  @override
  String get adminStatus => 'Status';

  @override
  String get adminFeedbacksEmpty => 'No analysis feedback to show.';

  @override
  String get adminReportsSubtitle =>
      'Review user reports and update their status.';

  @override
  String get adminTotalReports => 'Total reports';

  @override
  String get adminReportsCountHelper => 'All reports';

  @override
  String get adminPendingReportsHelper => 'Reports awaiting review';

  @override
  String get adminUnderReviewReportsHelper => 'Reports under review';

  @override
  String get adminAcceptedReportsHelper => 'Accepted reports';

  @override
  String get adminRejectedReportsHelper => 'Rejected reports';

  @override
  String adminBulkSuccess(int total) {
    return 'Processed $total items.';
  }

  @override
  String adminBulkFailure(int total, int failed) {
    return 'Failed to process $failed of $total items. Failed items remain selected.';
  }

  @override
  String get adminAcceptReports => 'Accept';

  @override
  String get adminRejectReports => 'Reject';

  @override
  String get adminEvidence => 'AI evidence';

  @override
  String get adminReportsEmpty => 'No reports to show.';

  @override
  String get adminDashboardSubtitle =>
      'See review analysis and pending tasks at a glance.';

  @override
  String get adminModelPerformance => 'AI model performance';

  @override
  String adminPeriodDays(int days) {
    return '$days days';
  }

  @override
  String get adminTotalReviews => 'Total reviews';

  @override
  String get adminTotalReviewsHelper => 'All reviews for analysis';

  @override
  String get adminSuspiciousReviews => 'Suspicious reviews';

  @override
  String get adminRiskyReviews => 'Risky reviews';

  @override
  String get adminPendingReports => 'Pending reports';

  @override
  String get adminPendingFeedbacks => 'Pending analysis feedback';

  @override
  String get adminOpenSection => 'Click to open';

  @override
  String adminCountPercent(String count, String percent) {
    return '$count · $percent%';
  }

  @override
  String get adminRtiDistribution => 'RTI grade distribution';

  @override
  String adminAnalyzedCount(String count) {
    return '$count analyzed reviews';
  }

  @override
  String get adminSuspicious => 'Suspicious';

  @override
  String get adminAverageRti => 'Overall average RTI';

  @override
  String adminDailyTrendTitle(int days) {
    return 'Daily average RTI · analysis count (last $days days)';
  }

  @override
  String get adminTrendEmpty => 'No reviews analyzed in this period.';

  @override
  String adminTrendTooltip(String date, String score, String count) {
    return '$date\nAverage RTI $score · $count reviews';
  }

  @override
  String get adminUserAgreement => 'User agreement rate';

  @override
  String adminFeedbackCount(String count) {
    return '$count feedback items';
  }

  @override
  String get adminAgree => 'Agree';

  @override
  String get adminDisagree => 'Disagree';

  @override
  String get adminFeedbackStats => 'Analysis feedback status';

  @override
  String adminResolutionRate(String percent) {
    return 'Resolution rate $percent%';
  }

  @override
  String get adminApplied => 'Applied';

  @override
  String get adminDismissed => 'Dismissed';

  @override
  String get sessionExpiredMessage =>
      'Your session has expired. Please log in again.';

  @override
  String get sessionExpiredLogin => 'Log in';

  @override
  String get settingsAccountLabelLoginMethod => 'Sign-in method';

  @override
  String get settingsLoginMethodEmail => 'Email';

  @override
  String get settingsLoginMethodNaver => 'Naver';

  @override
  String get chatLauncherLabel => 'Ask AI';

  @override
  String get chatLauncherProductLabel => 'Ask about this product';

  @override
  String get chatProductCta => 'Ask AI about this product';

  @override
  String get chatEmptyProductTitle =>
      'What would you like to know about this product?';

  @override
  String get chatCopy => 'Copy';

  @override
  String get chatCopied => 'Copied';

  @override
  String get chatThinkingLong => 'This is taking a little longer';

  @override
  String get chatThinkingVeryLong =>
      'Still waiting for the answer. You can close this panel and the conversation stays.';

  @override
  String get chatBlockedTitle => 'I can\'t answer this question';

  @override
  String get chatModeStandard => 'Standard';

  @override
  String get chatModePro => 'Pro';

  @override
  String get chatModeProActive => 'Pro mode gives more detailed answers';

  @override
  String get chatModeProLocked => 'Pro mode is available on the Pro plan';

  @override
  String get chatPlanFree => 'Free';

  @override
  String get chatPlanPlus => 'Plus';

  @override
  String get chatPlanPro => 'Pro';

  @override
  String get planTitle => 'Plans';

  @override
  String get planSubtitle => 'Choose how much you use the AI assistant.';

  @override
  String get planCurrent => 'Current plan';

  @override
  String planUsageToday(int used, int limit) {
    return '$used of $limit questions used today';
  }

  @override
  String planUsageUnlimited(int used) {
    return '$used questions used today · unlimited';
  }

  @override
  String planResetAt(String time) {
    return 'Resets at $time';
  }

  @override
  String planExpiresAt(String date) {
    return 'Active until $date';
  }

  @override
  String planDailyQuestions(int count) {
    return '$count questions a day';
  }

  @override
  String get planDailyUnlimited => 'Unlimited questions a day';

  @override
  String get planFeatureStandard => 'Standard answers';

  @override
  String get planFeatureLimited => 'Fewest questions a day';

  @override
  String get planFeatureMore => 'More questions a day than Free';

  @override
  String get planFeatureMost => 'The most questions a day';

  @override
  String get planFeaturePro => 'Pro mode: more detailed answers';

  @override
  String get planSelect => 'Switch to this plan';

  @override
  String get planCurrentBadge => 'Current';

  @override
  String planConfirmTitle(String plan) {
    return 'Switch to the $plan plan?';
  }

  @override
  String get planConfirmBody =>
      'For now it changes right away, with no payment.';

  @override
  String get planConfirmAction => 'Switch';

  @override
  String get planCancel => 'Cancel';

  @override
  String planChanged(String plan) {
    return 'You are now on the $plan plan';
  }

  @override
  String get planChangeUnavailable => 'Changing plans is not available yet.';

  @override
  String get planChangeFailed => 'Could not change the plan. Please try again.';

  @override
  String get planLoadFailed => 'Could not load your plan.';

  @override
  String get planRetry => 'Retry';

  @override
  String get myPageSideNavPlan => 'Plans';

  @override
  String get chatViewPlans => 'View plans';

  @override
  String get extProductCollectingTitle => 'Fetching product details';

  @override
  String get extProductCollectingBody =>
      'We are fetching product and review information from the shop. Product details will appear automatically when available.';

  @override
  String get extProductCollectingSlow =>
      'We are still waiting for product information from the shop. Product details will appear automatically when available.';

  @override
  String get extProductUnavailableTitle => 'Could not get this product';

  @override
  String get extProductUnavailableBody =>
      'The product may still exist. We could not reach the shop right now. Please try again shortly.';

  @override
  String get extProductLoadFailed => 'Could not load the product.';

  @override
  String get extProductRetry => 'Retry';

  @override
  String get extProductStale => 'Refreshing with the latest information';

  @override
  String extProductVisitShop(String shop) {
    return 'View on $shop';
  }

  @override
  String extProductReviewCount(int count) {
    return '$count reviews';
  }

  @override
  String extProductPrice(String price) {
    return '₩$price';
  }

  @override
  String get extProductAnalysisPendingTitle => 'Not analyzed yet';

  @override
  String get extProductAnalysisPendingBody =>
      'Reviews for this product have not been analyzed. No trust score is available.';

  @override
  String get extProductReviewsTitle => 'Reviews';

  @override
  String get extProductReviewsEmpty => 'No reviews have been collected.';

  @override
  String get extProductReviewsMore => 'Show more reviews';

  @override
  String get extProductReviewsMoreFailed => 'Could not load more reviews.';

  @override
  String extProductReviewOption(String option) {
    return 'Option: $option';
  }

  @override
  String chatQuotaRemaining(int remaining, int limit) {
    return '$remaining of $limit questions left today';
  }

  @override
  String get chatQuotaUnlimited => 'Unlimited questions';

  @override
  String get chatQuotaExceededTitle => 'You\'ve used all of today\'s questions';

  @override
  String chatQuotaExceededBody(String time) {
    return 'You can ask again at $time';
  }

  @override
  String get chatQuotaExceededBodyNoTime =>
      'You can ask again once the limit resets';

  @override
  String get chatPlanRequiredTitle => 'Available on the Pro plan';

  @override
  String get chatPlanRequiredAction => 'Ask again in Standard mode';

  @override
  String get chatSuggestGeneral3 => 'How do I pick trustworthy reviews?';

  @override
  String get adminUserPlanColumn => 'Plan';

  @override
  String get adminUserPlanChange => 'Change plan';

  @override
  String get adminUserPlanTitle => 'Change plan';

  @override
  String get adminUserPlanExpiry => 'Expiration';

  @override
  String get adminUserPlanUnlimited => 'No expiration';

  @override
  String get adminUserPlanThirtyDays => '30 days';

  @override
  String get adminUserPlanCustomDate => 'Choose a date';

  @override
  String get adminUserPlanSelectDate => 'Select date';

  @override
  String get adminUserPlanExpired => 'Expired';

  @override
  String get adminUserPlanUnknown => 'Unknown';

  @override
  String get adminUserPlanSave => 'Save';

  @override
  String get adminUserPlanCancel => 'Cancel';

  @override
  String get adminUserPlanSaving => 'Saving';

  @override
  String get adminUserPlanDateRequired =>
      'Choose an expiration date from today onward.';

  @override
  String get externalWishAdd => 'Save';

  @override
  String get externalWishRemove => 'Unsave';

  @override
  String get externalCartAdd => 'Add to cart';

  @override
  String get externalCartAdded => 'Added to cart';

  @override
  String get externalReviewMenu => 'Review menu';

  @override
  String get externalReport => 'Report review';

  @override
  String get externalReal => 'Looks real';

  @override
  String get externalFake => 'Looks fake';

  @override
  String get externalNotCollected =>
      'Try again after product collection is complete.';

  @override
  String get externalUnavailable =>
      'The data server is unavailable. Try again later.';

  @override
  String get externalReportDuplicate => 'You already reported this review.';

  @override
  String get externalFeedbackDuplicate =>
      'You already gave feedback on this review.';

  @override
  String get externalFailed => 'Could not complete the request. Try again.';

  @override
  String get externalSuccess => 'Done.';

  @override
  String get externalUnanalyzed => 'Not analyzed';

  @override
  String get externalReason => 'Report reason';

  @override
  String get externalDetail => 'Details';

  @override
  String get externalDetailValidation => 'Enter 20 to 500 characters.';

  @override
  String get externalAttachment => 'Attachment URL (optional)';

  @override
  String get externalAttachmentValidation => 'Enter a valid http or https URL.';

  @override
  String get externalEvidence => 'Include analysis evidence';

  @override
  String get externalCancel => 'Cancel';

  @override
  String get externalSubmit => 'Submit';

  @override
  String get externalReasonFake => 'Suspected fake review';

  @override
  String get externalReasonAi => 'Suspected generated content';

  @override
  String get externalReasonIrrelevant => 'Unrelated content';

  @override
  String get externalReasonInappropriate =>
      'Inappropriate content / personal information';

  @override
  String get externalReasonAd => 'Advertisement';

  @override
  String get externalReasonRepeated => 'Repetitive content';

  @override
  String get externalReasonOffensive => 'Offensive content';

  @override
  String get externalReasonOther => 'Other';

  @override
  String get productImageEnlarge => 'Enlarge product image';

  @override
  String get productImagePrevious => 'Previous product image';

  @override
  String get productImageNext => 'Next product image';

  @override
  String get imagePreviewOpen => 'Enlarge image';

  @override
  String get imagePreviewTitle => 'Image preview';

  @override
  String get imagePreviewPrevious => 'Previous image';

  @override
  String get imagePreviewNext => 'Next image';

  @override
  String get chatFreshContext => 'New conversation · history is preserved';

  @override
  String get chatHistoryContext => 'Conversation opened from history';

  @override
  String get chatActiveContext => 'Ongoing conversation';

  @override
  String get chatGeneralContext => 'General conversation · no product selected';

  @override
  String get chatTargetProduct => 'Question target product';

  @override
  String get chatQuotaLoading => 'Checking your question quota.';

  @override
  String get chatQuotaUnavailable =>
      'Could not refresh quota. Last confirmed values are retained.';

  @override
  String get chatQuotaRefresh => 'Refresh';

  @override
  String get chatClosePreserve => 'Close (keep conversation)';

  @override
  String get chatHistoryWait => 'History is available after sending completes.';

  @override
  String get extProductSummaryLoading => 'Checking basic product information.';

  @override
  String get extProductListSummary =>
      'Product information from the list. Checking current details and reviews.';

  @override
  String get extProductPreviousSummary =>
      'Previously viewed product information. Checking current details and reviews.';

  @override
  String get recentRecordFailed =>
      'Could not confirm recently viewed history. Retry';

  @override
  String get recentRecordUnavailable =>
      'The product ID needed for server view history is unavailable.';
}
