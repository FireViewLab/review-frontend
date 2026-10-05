// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => '홈';

  @override
  String get navSearch => '검색';

  @override
  String get navCart => '장바구니';

  @override
  String get navWishlist => '저장한 상품';

  @override
  String get navMyPage => '마이페이지';

  @override
  String get navSettings => '설정';

  @override
  String get actionSave => '저장';

  @override
  String get actionCancel => '취소';

  @override
  String get actionConfirm => '확인';

  @override
  String get actionRetry => '다시 시도';

  @override
  String get actionBack => '뒤로';

  @override
  String get actionLogin => '로그인';

  @override
  String get actionLogout => '로그아웃';

  @override
  String get actionSignup => '회원가입';

  @override
  String get actionViewAll => '전체 보기';

  @override
  String get stateLoading => '불러오는 중입니다.';

  @override
  String get stateError => '오류가 발생했습니다.';

  @override
  String get stateEmpty => '표시할 항목이 없습니다.';

  @override
  String get settingsSaved => '설정이 저장되었습니다.';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsNotifications => '알림 설정';

  @override
  String get settingsFilters => '분석 필터 설정';

  @override
  String get langKorean => '한국어';

  @override
  String get langEnglish => 'English';

  @override
  String get langJapanese => '日本語';

  @override
  String get langChinese => '中文(简体)';

  @override
  String get sideNavOrders => '주문/배송';

  @override
  String get sideNavRecentlyViewed => '최근 본 상품';

  @override
  String get sideNavReviewActivity => '리뷰 활동';

  @override
  String get sideNavAccountSettings => '계정 설정';

  @override
  String get sideNavFeedbackHistory => '피드백 내역';

  @override
  String get settingsSubtitle => '알림, 필터, 계정 설정을 관리해요.';

  @override
  String settingsSubtitleNamed(String nickname) {
    return '$nickname님의 알림, 필터, 계정 설정을 관리해요.';
  }

  @override
  String get settingsNotificationEmail => '이메일 알림 받기';

  @override
  String get settingsNotificationEmailDesc => '상품 가격 변동, 리뷰 업데이트를 이메일로 받아요.';

  @override
  String get settingsNotificationPush => '앱 푸시 알림 받기';

  @override
  String get settingsNotificationPushDesc => '저장한 상품의 실시간 알림을 브라우저에서 받아요.';

  @override
  String get settingsNotificationAdEmail => '이메일 광고 수신';

  @override
  String get settingsNotificationAdEmailDesc => '프로모션 및 맞춤 혜택 정보를 이메일로 받아요.';

  @override
  String get settingsFilterHighlightLowRti => '주의 상품 먼저 보기';

  @override
  String get settingsFilterHighlightLowRtiDesc => '리뷰 신뢰도가 낮은 상품을 목록 상단에 표시해요.';

  @override
  String get settingsFilterWishlistAlert => '저장 상품 알림 받기';

  @override
  String get settingsFilterWishlistAlertDesc => '관심 상품의 RTI 변화가 있을 때 알림을 드려요.';

  @override
  String get settingsFilterCategory => '카테고리 필터';

  @override
  String get settingsFilterCategoryDesc => '선택한 카테고리 상품을 기준으로 분석 결과를 우선 표시해요.';

  @override
  String get settingsFilterCategoryAll => '전체 카테고리';

  @override
  String get settingsFilterMinReview => '리뷰 최소 개수';

  @override
  String get settingsFilterMinReviewDesc => '이 개수 이상 리뷰가 있는 상품만 분석 결과에 반영해요.';

  @override
  String get settingsFilterMinReviewSuffix => '개';

  @override
  String get settingsFilterLowRti => '낮은 RTI 경고 기준';

  @override
  String get settingsFilterLowRtiDesc => 'RTI 점수가 이 값 이하면 주의 상품으로 분류해요.';

  @override
  String get settingsFilterLowRtiSuffix => '점';

  @override
  String get settingsAccountTitle => '계정';

  @override
  String get settingsAccountChangePassword => '비밀번호 변경';

  @override
  String get settingsAccountLabelName => '이름';

  @override
  String get settingsAccountLabelEmail => '이메일';

  @override
  String get settingsAccountLabelJoinDate => '가입일';

  @override
  String get settingsAccountLabelMemberType => '회원 유형';

  @override
  String get settingsAccountDefaultName => '사용자';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role 회원';
  }

  @override
  String get settingsLanguageSection => '언어 설정';

  @override
  String get settingsLanguageApplyNow => '변경 즉시 적용됩니다.';

  @override
  String get settingsSavedFeedback => '저장됐어요';

  @override
  String get wishlistTitle => '찜한 상품';

  @override
  String get wishlistSubtitle => '저장된 상품을 한눈에 보고 가격과 리뷰 신뢰도를 확인해보세요.';

  @override
  String wishlistCount(int count) {
    return '찜한 상품 $count개';
  }

  @override
  String get wishlistEmpty => '찜한 상품이 없습니다';

  @override
  String get wishlistEmptyDesc => '상품 카드의 하트를 눌러 찜 목록에 추가해보세요.';

  @override
  String get wishlistBrowse => '상품 탐색하러 가기';

  @override
  String get wishlistFilteredEmpty => '선택한 필터에 해당하는 찜 상품이 없습니다.';

  @override
  String get wishlistSummaryTitle => '찜 리스트 요약';

  @override
  String wishlistSummaryTotal(int count) {
    return '총 $count개';
  }

  @override
  String get wishlistSummaryPriceDrop => '가격 하락';

  @override
  String get wishlistSummaryNewAlert => '신규 알림';

  @override
  String get wishlistSummaryTotalReview => '총 리뷰';

  @override
  String get wishlistProductView => '상품 보기';

  @override
  String get wishlistProductPriceDrop => '가격 하락';

  @override
  String get wishlistSortRecent => '최근 저장 순';

  @override
  String get wishlistSortPriceLow => '낮은 가격 순';

  @override
  String get wishlistSortPriceHigh => '높은 가격 순';

  @override
  String get wishlistSortRti => 'RTI 높은 순';

  @override
  String get wishlistSortReviewCount => '리뷰 많은 순';

  @override
  String get wishlistFilterAll => '전체';

  @override
  String get wishlistFilterPriceDrop => '가격 하락';

  @override
  String get wishlistFilterRti => 'RTI 점수';

  @override
  String get wishlistFilterLowestPrice => '최저 가격';

  @override
  String get wishlistFilterBrand => '브랜드';

  @override
  String get wishlistFilterCategory => '카테고리';

  @override
  String get myPageTitle => '마이페이지';

  @override
  String get myPageLoading => '마이페이지 정보를 불러오는 중입니다.';

  @override
  String get myPageWishlistLoading => '저장한 상품을 불러오는 중입니다.';

  @override
  String get myPageWishlistEmpty => '저장한 상품이 없습니다.';

  @override
  String get myPageInterestProducts => '관심 상품';

  @override
  String get myPageDefaultName => '사용자';

  @override
  String get myPageMemberBasic => '일반 회원 (무료)';

  @override
  String get myPageSideNavMyPage => '마이페이지';

  @override
  String get myPageSideNavOrders => '주문/배송';

  @override
  String get myPageSideNavWishlist => '저장한 상품';

  @override
  String get myPageSideNavRecentlyViewed => '최근 본 상품';

  @override
  String get myPageSideNavRiskyProducts => '주의 상품';

  @override
  String get myPageSideNavAlerts => '알림';

  @override
  String get myPageRecentActivity => '최근 활동';

  @override
  String get myPageRecentActivityEmpty => '최근 활동이 없습니다.';

  @override
  String get myPageRecentLabel => '최근';

  @override
  String get myPageReviewTrustSummary => '리뷰 신뢰 요약';

  @override
  String get myPageAvgRti => '관심 상품 평균 RTI';

  @override
  String get myPageRtiSaveHint => '관심 상품을 저장하면 리뷰 신뢰도 요약이 표시됩니다.';

  @override
  String get myPageRiskyNone => '현재 대시보드에 주의가 필요한 상품이 없습니다.';

  @override
  String myPageRiskyCount(int count) {
    return '주의 상품 $count개를 확인해보세요.';
  }

  @override
  String get myPageHighlightLowRti => '주의 상품 먼저 보기';

  @override
  String get myPageWishlistAlertLabel => '저장 상품 알림 받기';

  @override
  String get myPageAccountInfo => '계정 정보';

  @override
  String get myPageAccountInfoSubtitle => '개인 정보 및 기본 정보를 관리해요.';

  @override
  String myPageAccountNickname(String nickname) {
    return '닉네임: $nickname';
  }

  @override
  String myPageAccountEmail(String email) {
    return '이메일: $email';
  }

  @override
  String myPageAccountMemberType(String role) {
    return '회원 유형: $role';
  }

  @override
  String get myPageDefaultMemberRole => '일반 회원';

  @override
  String get myPageLoginInfo => '로그인 정보';

  @override
  String get myPageLoginInfoSubtitle => '이메일, 로그인 수단을 관리해요.';

  @override
  String myPageLoginEmail(String email) {
    return '로그인 이메일: $email';
  }

  @override
  String get myPageLoginStatus => '인증 상태: 로그인됨';

  @override
  String get myPageOnboardingComplete => '완료';

  @override
  String get myPageOnboardingIncomplete => '미완료';

  @override
  String myPageOnboarding(String status) {
    return '온보딩: $status';
  }

  @override
  String get myPageChangePassword => '비밀번호 변경';

  @override
  String get myPageChangePasswordSubtitle => '안전한 비밀번호로 관리하세요.';

  @override
  String get myPageNotificationSettings => '알림 설정';

  @override
  String get myPageNotificationSettingsSubtitle => '이메일 및 푸시 알림을 설정해요.';

  @override
  String get myPageAccountSecurity => '계정 / 보안';

  @override
  String get navCategory => '카테고리';

  @override
  String get navWishShort => '찜';

  @override
  String get navMyShort => '마이';

  @override
  String get homeSearchHint => '찾고 있는 상품을 리뷰 기반으로 검색해보세요';

  @override
  String get homeSearchSuggestionsTitle => '연관 검색어';

  @override
  String get homeSearchSuggestionsLoading => '연관 검색어를 불러오는 중입니다.';

  @override
  String get homeSearchSuggestionsHint => '두 글자 이상 입력하면 연관 검색어가 표시됩니다.';

  @override
  String get homeRecentSearchTitle => '최근 검색';

  @override
  String get homeRecentSearchDeleteAll => '전체 삭제';

  @override
  String get homeRecentSearchEmpty => '최근 검색어가 없습니다.';

  @override
  String get homePopularSearchTitle => '인기 검색';

  @override
  String get homeSearchProductsTitle => '추천 상품';

  @override
  String get homeTrendingTitle => '지금 많이 찾는 키워드';

  @override
  String get homeKeywordsEmpty => '표시할 키워드가 없습니다.';

  @override
  String get homeRecommendedTitle => '에디터가 고른 리뷰 기반 추천 상품';

  @override
  String get homeViewAll => '전체보기';

  @override
  String get homeLoginRequired => '로그인이 필요합니다.';

  @override
  String get homeBenefitTitle => '첫 구매 고객을 위한 혜택';

  @override
  String get homeBenefitSubtitle => '리뷰 기반 쇼핑을 시작하면 받을 수 있는 회원 혜택입니다.';

  @override
  String get homeBenefitButton => '혜택 받기';

  @override
  String get homeTrustDescription => '광고·조작 리뷰를 필터링하고 실사용 리뷰를 분석해 신뢰도를 제공합니다.';

  @override
  String get homeTrustViewMore => '자세히 보기';

  @override
  String get homeTrustLabel1 => '실사용 리뷰 분석';

  @override
  String get homeTrustLabel2 => '광고/조작 필터링';

  @override
  String get homeTrustLabel3 => '신뢰도 점수 제공';

  @override
  String get homePopularCategoryTitle => '인기 카테고리';

  @override
  String get homeCategoryEmpty => '표시할 카테고리가 없습니다.';

  @override
  String get feedbackHistoryTitle => '내 피드백 내역';

  @override
  String get feedbackHistorySubtitle => '제출한 상품/리뷰 피드백 내역을 확인할 수 있습니다.';

  @override
  String get feedbackHistoryLoading => '피드백 내역을 불러오는 중입니다.';

  @override
  String get feedbackHistoryEmpty => '제출한 피드백이 없습니다.';

  @override
  String get feedbackHistoryEmptyDesc => '상품 상세 페이지에서 리뷰 피드백을 제출할 수 있습니다.';

  @override
  String feedbackHistoryCount(int count) {
    return '$count건의 피드백';
  }

  @override
  String get feedbackHistoryViewProduct => '상품 보기';

  @override
  String get feedbackStatusSubmitted => '접수';

  @override
  String get feedbackStatusPending => '검토 중';

  @override
  String get feedbackStatusAccepted => '처리됨';

  @override
  String get feedbackStatusRejected => '반려됨';

  @override
  String get adminSidebarTitle => '관리자';

  @override
  String get adminMenuDashboard => '대시보드';

  @override
  String get adminMenuSuspiciousReviews => '의심 리뷰 관리';

  @override
  String get adminMenuReports => '신고 관리';

  @override
  String get adminMenuAnalysisFeedbacks => '분석 피드백 관리';

  @override
  String get adminMenuUsers => '사용자 관리';

  @override
  String get adminMenuLogout => '로그아웃';

  @override
  String get adminDashboardTitle => '운영 대시보드';

  @override
  String get adminPlaceholderMessage => '준비 중인 화면입니다.';

  @override
  String get adminTopBarSearchHint => '사용자, 리뷰, 신고 ID로 검색';

  @override
  String get adminTopBarNotifications => '알림';

  @override
  String get chatLauncherTooltip => 'AI 어시스턴트 열기';

  @override
  String get chatTitle => 'Re:view AI';

  @override
  String get chatSubtitle => '리뷰와 구매 판단을 도와드려요';

  @override
  String get chatNewConversation => '새 대화';

  @override
  String get chatClose => '닫기';

  @override
  String get chatInputHint => '질문을 입력하세요';

  @override
  String get chatSend => '보내기';

  @override
  String get chatProductContext => '이 상품의 리뷰를 바탕으로 답해요';

  @override
  String get chatOtherProductNotice => '다른 상품에 대한 대화가 이어지고 있어요';

  @override
  String get chatStartWithThisProduct => '이 상품으로 새 대화';

  @override
  String get chatEmptyTitle => '리뷰에서 궁금한 점을 물어보세요';

  @override
  String get chatEmptyBody => '리뷰 신뢰도와 광고성 리뷰 판단을 도와드려요.';

  @override
  String get chatSuggestProduct1 => '이 상품 리뷰 믿을 만해?';

  @override
  String get chatSuggestProduct2 => '광고성 리뷰가 많아?';

  @override
  String get chatSuggestProduct3 => '실사용자들이 말하는 단점은?';

  @override
  String get chatSuggestGeneral1 => 'RTI 점수는 어떻게 매겨져?';

  @override
  String get chatSuggestGeneral2 => '광고성 리뷰는 어떻게 구별해?';

  @override
  String get chatThinking => '답변을 준비하고 있어요';

  @override
  String get chatLoginTitle => '로그인하고 AI에게 물어보세요';

  @override
  String get chatLoginBody => '대화 내용은 내 계정에 저장돼요.';

  @override
  String get chatLoginButton => '로그인';

  @override
  String get chatErrorUnavailable => '챗봇이 잠시 응답할 수 없어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get chatErrorTimeout => '답변이 너무 오래 걸리고 있어요. 다시 시도해 주세요.';

  @override
  String get chatErrorNetwork => '네트워크 연결을 확인해 주세요.';

  @override
  String get chatErrorUnknown => '답변을 받지 못했어요.';

  @override
  String get chatRetry => '다시 시도';

  @override
  String get chatDisclaimer => 'AI 답변은 참고용이며 틀릴 수 있어요.';

  @override
  String get settingsReviewDisplay => '리뷰 표시';

  @override
  String get settingsPrivacy => '개인정보';

  @override
  String get settingsRtiThreshold => '최소 RTI 기준';

  @override
  String get settingsRtiThresholdDesc => '이 기준 미만의 리뷰를 걸러내는 기준입니다.';

  @override
  String get settingsReviewSort => '리뷰 기본 정렬';

  @override
  String get settingsSortVerifiedRecent => '구매확인 최신순';

  @override
  String get settingsSortRecent => '최신순';

  @override
  String get settingsSortHelpful => '도움순';

  @override
  String get settingsRtiLabel => 'RTI 라벨 표시';

  @override
  String get settingsLabelSmall => '작은 배지';

  @override
  String get settingsLabelLarge => '큰 배지';

  @override
  String get settingsLabelNone => '표시 안 함';

  @override
  String get settingsCardDensity => '상품 카드 밀도';

  @override
  String get settingsDensityComfortable => '여유롭게';

  @override
  String get settingsDensityCompact => '촘촘하게';

  @override
  String get settingsLoading => '설정을 불러오는 중입니다.';

  @override
  String get settingsLoadFailed => '설정을 불러오지 못했습니다.';

  @override
  String get settingsSaveFailed => '설정을 저장하지 못했습니다.';

  @override
  String get settingsRiskyProduct => '위험 상품 알림';

  @override
  String get settingsRiskyProductDesc => '찜한 상품의 위험 비율이 높아지면 알림을 받습니다.';

  @override
  String get settingsAnalysisComplete => '분석 완료 알림';

  @override
  String get settingsAnalysisCompleteDesc => '새 상품의 분석이 완료되면 알림을 받습니다.';

  @override
  String get settingsFeedbackResult => '피드백 결과 알림';

  @override
  String get settingsFeedbackResultDesc => '제출한 신고와 피드백의 처리 결과를 받습니다.';

  @override
  String get settingsMarketing => '마케팅 알림';

  @override
  String get settingsMarketingDesc => '추천 상품과 마케팅 알림을 받습니다.';

  @override
  String get settingsHideRisky => '위험 리뷰 숨김';

  @override
  String get settingsHideRiskyDesc => '위험 리뷰를 기본적으로 접어서 표시합니다.';

  @override
  String get settingsSuspiciousLabel => '의심 리뷰 라벨 표시';

  @override
  String get settingsSuspiciousLabelDesc => '의심스러운 리뷰에 구분 라벨을 표시합니다.';

  @override
  String get settingsVerifiedFirst => '구매확인 리뷰 우선';

  @override
  String get settingsVerifiedFirstDesc => '구매가 확인된 리뷰를 먼저 표시합니다.';

  @override
  String get settingsAutoAnalysis => '분석 팝업 자동 열기';

  @override
  String get settingsAutoAnalysisDesc => '위험 리뷰를 클릭하면 분석 상세를 자동으로 엽니다.';

  @override
  String get settingsDataAnalysis => '리뷰 분석 데이터 활용 동의';

  @override
  String get settingsDataAnalysisDesc => '리뷰 분석을 위한 데이터 활용에 동의합니다.';

  @override
  String get notificationsTitle => '알림';

  @override
  String get notificationsMarkAllRead => '모두 읽음';

  @override
  String get notificationsLoading => '알림을 불러오는 중이에요';

  @override
  String get notificationsEmpty => '새 알림이 없어요';

  @override
  String get notificationsEmptyBody => '신고·피드백 처리 결과와 분석 완료 소식을 여기서 알려드려요.';

  @override
  String get headerNotifications => '알림';

  @override
  String get chatPreviousConversations => '이전 대화';

  @override
  String get chatBackToConversation => '대화로 돌아가기';

  @override
  String get chatHistoryLoading => '이전 대화를 불러오는 중입니다.';

  @override
  String get chatHistoryEmpty => '이전 대화가 없습니다.';

  @override
  String get chatHistoryLoadError => '이전 대화를 불러오지 못했습니다. 다시 시도해 주세요.';

  @override
  String get chatHistoryLoadMore => '더 불러오기';

  @override
  String get chatHistoryUntitled => '제목 없는 대화';

  @override
  String get adminUsersSubtitle => '가입한 사용자를 최신 가입순으로 확인하세요.';

  @override
  String get adminRefresh => '새로고침';

  @override
  String get adminTotalUsers => '전체 사용자';

  @override
  String get adminRetry => '다시 시도';

  @override
  String get adminEmail => '이메일';

  @override
  String get adminNickname => '닉네임';

  @override
  String get adminRole => '권한';

  @override
  String get adminSignupProvider => '가입 경로';

  @override
  String get adminAtiScore => 'ATI 점수';

  @override
  String get adminJoinedAt => '가입일';

  @override
  String get adminUserRole => '사용자';

  @override
  String get adminUsersEmpty => '가입한 사용자가 없습니다.';

  @override
  String get adminNaver => '네이버';

  @override
  String get adminReportPending => '검토 대기';

  @override
  String get adminUnderReview => '검토 중';

  @override
  String get adminReportAccepted => '접수 (인정)';

  @override
  String get adminReportRejected => '기각 (미인정)';

  @override
  String get adminDanger => '위험';

  @override
  String get adminWarning => '경고';

  @override
  String get adminSafe => '안전';

  @override
  String get adminFeedbackSubmitted => '접수';

  @override
  String get adminFeedbackResolved => '처리 완료';

  @override
  String get adminFeedbackRejected => '반려';

  @override
  String get adminJudgmentTrustworthy => '신뢰도가 더 높아요';

  @override
  String get adminJudgmentRisky => '위험도가 더 높아요';

  @override
  String get adminJudgmentUndecided => '판단 보류';

  @override
  String get adminReviewDetails => '리뷰 상세 정보';

  @override
  String get adminViewProduct => '상품 페이지 보기';

  @override
  String get adminRtiAnalysis => 'RTI 분석 결과';

  @override
  String get adminScoreUnit => '점';

  @override
  String get adminReviewContent => '리뷰 내용';

  @override
  String adminDetectedSignals(int count) {
    return '탐지 신호 ($count)';
  }

  @override
  String get adminVerifiedPurchase => '구매 인증';

  @override
  String get adminVerified => '인증됨';

  @override
  String get adminNotVerified => '인증 안됨';

  @override
  String get adminReviewerInfo => '작성자 정보';

  @override
  String get adminReviewer => '작성자';

  @override
  String get adminRating => '별점';

  @override
  String get adminWrittenAt => '작성일';

  @override
  String adminSelectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get adminSaved => '변경 사항이 저장되었습니다.';

  @override
  String get adminSaveFailed => '저장에 실패했습니다.';

  @override
  String get adminFeedbackDetails => '피드백 상세 정보';

  @override
  String get adminSaveChanges => '변경 사항 저장';

  @override
  String get adminFeedbackId => '피드백 ID';

  @override
  String get adminReviewId => '리뷰 ID';

  @override
  String get adminProductName => '상품명';

  @override
  String get adminCreatedAt => '등록일';

  @override
  String get adminUpdatedAt => '수정일';

  @override
  String get adminFeedbackType => '피드백 유형';

  @override
  String get adminUserJudgment => '사용자 판단';

  @override
  String adminRelatedSignals(int count) {
    return '관련 신호 ($count)';
  }

  @override
  String get adminFeedbackContent => '피드백 내용';

  @override
  String get adminAttachmentLink => '첨부 파일 / 링크';

  @override
  String get adminReplyEmail => '회신 이메일';

  @override
  String get adminComment => '관리자 메모';

  @override
  String get adminCommentHint => '검토 내용이나 조치 사항을 입력하세요...';

  @override
  String get adminChangeStatus => '상태 변경';

  @override
  String get adminReportDetails => '신고 상세 정보';

  @override
  String get adminSave => '저장하기';

  @override
  String get adminReportInfo => '신고 정보';

  @override
  String get adminReportId => '신고 ID';

  @override
  String get adminReportReason => '신고 사유';

  @override
  String get adminReportedAt => '신고 시간';

  @override
  String get adminUpdatedTime => '수정 시간';

  @override
  String get adminReportedReview => '신고 대상 리뷰';

  @override
  String get adminReportContent => '신고 내용';

  @override
  String get adminAttachment => '첨부 파일';

  @override
  String get adminEvidenceIncluded => 'AI 증거 포함';

  @override
  String get adminIncluded => '포함';

  @override
  String get adminNotIncluded => '미포함';

  @override
  String get adminOptionalCommentHint => '메모를 입력하세요. (선택사항)';

  @override
  String get adminSuspiciousReviewsSubtitle =>
      'RTI 분석을 통해 탐지된 의심 리뷰를 검토하고 적절한 조치를 취하세요.';

  @override
  String get adminRtiUpperBound => 'RTI 점수 상한';

  @override
  String adminScoreBelow(int score) {
    return '$score점 미만';
  }

  @override
  String get adminAll => '전체';

  @override
  String get adminTotalSuspiciousReviews => '전체 의심 리뷰';

  @override
  String get adminCurrentFilter => '현재 조회 기준';

  @override
  String get adminRtiScore => 'RTI 점수';

  @override
  String get adminTrustGrade => '신뢰 등급';

  @override
  String get adminSuspiciousReviewsEmpty => '표시할 의심 리뷰가 없습니다.';

  @override
  String get adminFeedbacksSubtitle =>
      '사용자가 RTI 분석 결과에 대해 제공한 피드백을 검토하고 처리하세요.';

  @override
  String get adminTotalFeedbacks => '전체 피드백';

  @override
  String get adminAllTime => '전체 기간 기준';

  @override
  String get adminStatus => '상태';

  @override
  String get adminFeedbacksEmpty => '표시할 분석 피드백이 없습니다.';

  @override
  String get adminReportsSubtitle => '사용자 신고를 검토하고 처리 상태를 변경하세요.';

  @override
  String get adminTotalReports => '전체 신고';

  @override
  String get adminReportsCountHelper => '전체 신고 건수';

  @override
  String get adminPendingReportsHelper => '검토가 필요한 신고';

  @override
  String get adminUnderReviewReportsHelper => '현재 검토 중인 신고';

  @override
  String get adminAcceptedReportsHelper => '신고가 접수된 건';

  @override
  String get adminRejectedReportsHelper => '신고가 기각된 건';

  @override
  String adminBulkSuccess(int total) {
    return '$total건을 처리했습니다.';
  }

  @override
  String adminBulkFailure(int total, int failed) {
    return '$total건 중 $failed건 처리에 실패했습니다. 실패한 항목은 선택된 상태로 남겨 두었습니다.';
  }

  @override
  String get adminAcceptReports => '접수 처리';

  @override
  String get adminRejectReports => '기각 처리';

  @override
  String get adminEvidence => 'AI 증거';

  @override
  String get adminReportsEmpty => '표시할 신고가 없습니다.';

  @override
  String get adminDashboardSubtitle => '리뷰 분석 현황과 처리 대기 업무를 한눈에 확인하세요.';

  @override
  String get adminModelPerformance => 'AI 모델 성능';

  @override
  String adminPeriodDays(int days) {
    return '$days일';
  }

  @override
  String get adminTotalReviews => '전체 리뷰';

  @override
  String get adminTotalReviewsHelper => '분석 대상 리뷰 전체';

  @override
  String get adminSuspiciousReviews => '의심 리뷰';

  @override
  String get adminRiskyReviews => '위험 리뷰';

  @override
  String get adminPendingReports => '처리 대기 신고';

  @override
  String get adminPendingFeedbacks => '처리 대기 분석 피드백';

  @override
  String get adminOpenSection => '눌러서 바로가기';

  @override
  String adminCountPercent(String count, String percent) {
    return '$count건 · $percent%';
  }

  @override
  String get adminRtiDistribution => 'RTI 등급 분포';

  @override
  String adminAnalyzedCount(String count) {
    return '분석 리뷰 $count건';
  }

  @override
  String get adminSuspicious => '의심';

  @override
  String get adminAverageRti => '전체 평균 RTI';

  @override
  String adminDailyTrendTitle(int days) {
    return '일별 평균 RTI · 분석 건수 (최근 $days일)';
  }

  @override
  String get adminTrendEmpty => '기간 내 분석된 리뷰가 없습니다.';

  @override
  String adminTrendTooltip(String date, String score, String count) {
    return '$date\n평균 RTI $score · $count건';
  }

  @override
  String get adminUserAgreement => '사용자 판정 동의율';

  @override
  String adminFeedbackCount(String count) {
    return '피드백 $count건';
  }

  @override
  String get adminAgree => '동의';

  @override
  String get adminDisagree => '이의';

  @override
  String get adminFeedbackStats => '분석 피드백 처리 현황';

  @override
  String adminResolutionRate(String percent) {
    return '처리율 $percent%';
  }

  @override
  String get adminApplied => '반영';

  @override
  String get adminDismissed => '기각';

  @override
  String get sessionExpiredMessage => '로그인이 만료됐어요. 다시 로그인해 주세요.';

  @override
  String get sessionExpiredLogin => '로그인';

  @override
  String get settingsAccountLabelLoginMethod => '로그인 방식';

  @override
  String get settingsLoginMethodEmail => '이메일';

  @override
  String get settingsLoginMethodNaver => '네이버';

  @override
  String get chatLauncherLabel => 'AI에게 물어보기';

  @override
  String get chatLauncherProductLabel => '이 상품 리뷰 물어보기';

  @override
  String get chatProductCta => 'AI에게 이 상품 물어보기';

  @override
  String get chatEmptyProductTitle => '이 상품, 무엇이 궁금하세요?';

  @override
  String get chatCopy => '복사';

  @override
  String get chatCopied => '복사했어요';

  @override
  String get chatThinkingLong => '답변을 만드는 데 시간이 조금 걸리고 있어요';

  @override
  String get chatThinkingVeryLong => '아직 답변을 기다리고 있어요. 창을 닫아도 대화는 유지돼요';

  @override
  String get chatBlockedTitle => '답변할 수 없는 질문이에요';

  @override
  String get chatModeStandard => '기본';

  @override
  String get chatModePro => '프로';

  @override
  String get chatModeProActive => '프로 모드로 더 자세히 답해요';

  @override
  String get chatModeProLocked => '프로 모드는 프로 요금제에서 쓸 수 있어요';

  @override
  String get chatPlanFree => '무료';

  @override
  String get chatPlanPlus => '플러스';

  @override
  String get chatPlanPro => '프로';

  @override
  String chatQuotaRemaining(int remaining, int limit) {
    return '오늘 남은 질문 $remaining/$limit';
  }

  @override
  String get chatQuotaUnlimited => '질문 횟수 제한 없음';

  @override
  String get chatQuotaExceededTitle => '오늘 질문을 모두 사용했어요';

  @override
  String chatQuotaExceededBody(String time) {
    return '$time에 다시 물어볼 수 있어요';
  }

  @override
  String get chatQuotaExceededBodyNoTime => '한도가 초기화되면 다시 물어볼 수 있어요';

  @override
  String get chatPlanRequiredTitle => '프로 요금제에서 이용할 수 있어요';

  @override
  String get chatPlanRequiredAction => '기본 모드로 다시 묻기';

  @override
  String get chatSuggestGeneral3 => '믿을 만한 리뷰는 어떻게 골라?';
}
