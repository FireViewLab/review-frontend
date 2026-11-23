// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get navHome => '홈';

  @override
  String get navSearch => '검색';

  @override
  String get navMyPage => '마이페이지';

  @override
  String get navSettings => '설정';

  @override
  String get actionSave => '저장';

  @override
  String get actionConfirm => '확인';

  @override
  String get actionRetry => '다시 시도';

  @override
  String get actionLogin => '로그인';

  @override
  String get actionViewAll => '전체 보기';

  @override
  String get settingsNotifications => '알림 설정';

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
  String get settingsAccountTitle => '계정';

  @override
  String get settingsAccountChangePassword => '비밀번호 변경';

  @override
  String get settingsDeleteAccount => '회원 탈퇴';

  @override
  String get settingsDeleteAccountConfirmTitle => '회원 탈퇴';

  @override
  String get settingsDeleteAccountConfirmBody =>
      '탈퇴하면 계정과 저장된 정보가 삭제되며 되돌릴 수 없습니다. 탈퇴할까요?';

  @override
  String get settingsDeleteAccountCancel => '취소';

  @override
  String get settingsDeleteAccountConfirm => '탈퇴';

  @override
  String get settingsDeleteAccountFailed =>
      '회원 탈퇴를 완료하지 못했습니다. 잠시 후 다시 시도해 주세요.';

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
  String get wishlistEmpty => '찜한 상품이 없어요';

  @override
  String get wishlistEmptyDesc => '상품 카드의 하트를 눌러 찜 목록에 추가해보세요.';

  @override
  String get wishlistBrowse => '상품 둘러보기';

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
  String get chatInputHint => '질문을 입력하세요';

  @override
  String get chatSend => '보내기';

  @override
  String get chatOtherProductNotice => '현재 화면과 다른 대화 문맥을 유지하고 있어요.';

  @override
  String get chatStartWithThisProduct => '이 상품으로 새 대화';

  @override
  String get chatEmptyTitle => '리뷰에서 궁금한 점을 물어보세요';

  @override
  String get chatEmptyBody => '추천 질문은 입력창에만 채워져요. 내용을 확인한 뒤 전송해주세요.';

  @override
  String get chatSuggestProduct1 => '이 상품 리뷰 믿을 만해?';

  @override
  String get chatSuggestProduct2 => '광고성 리뷰가 많아?';

  @override
  String get chatSuggestProduct4 => '비슷한 상품 추천해줘';

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
  String get planTitle => '요금제';

  @override
  String get planSubtitle => 'AI 어시스턴트를 얼마나 쓸지 고르세요.';

  @override
  String get planCurrent => '현재 요금제';

  @override
  String planUsageToday(int used, int limit) {
    return '오늘 $used/$limit회 사용';
  }

  @override
  String planUsageUnlimited(int used) {
    return '오늘 $used회 사용 · 횟수 제한 없음';
  }

  @override
  String planResetAt(String time) {
    return '$time에 초기화';
  }

  @override
  String planExpiresAt(String date) {
    return '$date까지 이용';
  }

  @override
  String planDailyQuestions(int count) {
    return '하루 질문 $count회';
  }

  @override
  String get planDailyUnlimited => '하루 질문 횟수 제한 없음';

  @override
  String get planFeatureStandard => '기본 답변';

  @override
  String get planFeatureLimited => '하루 질문 수가 가장 적어요';

  @override
  String get planFeatureMore => '무료보다 더 많은 하루 질문';

  @override
  String get planFeatureMost => '가장 많은 하루 질문';

  @override
  String get planFeaturePro => '프로 모드: 더 자세한 답변';

  @override
  String get planSelect => '이 요금제로 변경';

  @override
  String get planCurrentBadge => '이용 중';

  @override
  String planConfirmTitle(String plan) {
    return '$plan 요금제로 변경할까요?';
  }

  @override
  String get planConfirmBody => '지금은 결제 없이 바로 바뀌어요.';

  @override
  String get planConfirmAction => '변경';

  @override
  String get planCancel => '취소';

  @override
  String planChanged(String plan) {
    return '$plan 요금제로 바뀌었어요';
  }

  @override
  String get planChangeUnavailable => '요금제 변경은 아직 준비 중이에요.';

  @override
  String get planChangeFailed => '요금제를 바꾸지 못했어요. 다시 시도해 주세요.';

  @override
  String get planLoadFailed => '요금제 정보를 불러오지 못했어요.';

  @override
  String get myPageSideNavPlan => '요금제';

  @override
  String get chatViewPlans => '요금제 보기';

  @override
  String get extProductCollectingTitle => '상품 정보를 가져오고 있어요';

  @override
  String get extProductCollectingBody =>
      '쇼핑몰에서 상품과 리뷰 정보를 가져오고 있어요. 상품 정보가 준비되면 자동으로 표시돼요.';

  @override
  String get extProductCollectingSlow =>
      '쇼핑몰에서 상품 정보를 기다리고 있어요. 상품 정보가 준비되면 자동으로 표시돼요.';

  @override
  String get extProductUnavailableTitle => '상품 정보를 가져오지 못했어요';

  @override
  String get extProductUnavailableBody =>
      '상품이 없는 것이 아니라 지금 쇼핑몰에서 정보를 받지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get extProductLoadFailed => '상품을 불러오지 못했어요.';

  @override
  String get extProductRetry => '다시 시도';

  @override
  String get extProductStale => '최신 정보로 갱신하고 있어요';

  @override
  String extProductVisitShop(String shop) {
    return '$shop에서 보기';
  }

  @override
  String extProductReviewCount(int count) {
    return '리뷰 $count개';
  }

  @override
  String extProductPrice(String price) {
    return '$price원';
  }

  @override
  String get extProductAnalysisPendingTitle => '신뢰도 분석 전';

  @override
  String get extProductAnalysisPendingBody =>
      '이 상품의 리뷰는 아직 분석되지 않았어요. 신뢰도 점수는 제공되지 않아요.';

  @override
  String get extProductReviewsTitle => '리뷰';

  @override
  String get extProductReviewsEmpty => '수집된 리뷰가 없어요.';

  @override
  String get extProductReviewsMore => '리뷰 더 보기';

  @override
  String get extProductReviewsMoreFailed => '리뷰를 더 불러오지 못했어요.';

  @override
  String extProductReviewOption(String option) {
    return '옵션: $option';
  }

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

  @override
  String get adminUserPlanColumn => '요금제';

  @override
  String get adminUserPlanChange => '요금제 변경';

  @override
  String get adminUserPlanTitle => '요금제 변경';

  @override
  String get adminUserPlanExpiry => '만료일';

  @override
  String get adminUserPlanUnlimited => '무기한';

  @override
  String get adminUserPlanThirtyDays => '30일';

  @override
  String get adminUserPlanCustomDate => '날짜 직접 선택';

  @override
  String get adminUserPlanSelectDate => '날짜 선택';

  @override
  String get adminUserPlanExpired => '만료됨';

  @override
  String get adminUserPlanUnknown => '확인되지 않음';

  @override
  String get adminUserPlanSave => '저장';

  @override
  String get adminUserPlanCancel => '취소';

  @override
  String get adminUserPlanSaving => '저장 중';

  @override
  String get adminUserPlanDateRequired => '오늘 이후의 만료일을 선택해주세요.';

  @override
  String get externalWishAdd => '찜하기';

  @override
  String get externalWishRemove => '찜 취소';

  @override
  String get externalCartAdd => '장바구니 담기';

  @override
  String get externalCartAdded => '장바구니에 담김';

  @override
  String get externalReviewMenu => '리뷰 메뉴';

  @override
  String get externalReport => '신고하기';

  @override
  String get externalReal => '실제 리뷰 같아요';

  @override
  String get externalFake => '주의가 필요한 리뷰 같아요';

  @override
  String get externalNotCollected => '상품 수집이 끝난 뒤 다시 시도해주세요.';

  @override
  String get externalUnavailable => '데이터 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get externalReportDuplicate => '이미 신고한 리뷰입니다.';

  @override
  String get externalFeedbackDuplicate => '이미 피드백을 남긴 리뷰입니다.';

  @override
  String get externalFailed => '요청을 처리하지 못했습니다. 다시 시도해주세요.';

  @override
  String get externalSuccess => '처리되었습니다.';

  @override
  String get externalUnanalyzed => '분석 전';

  @override
  String get externalReason => '신고 사유';

  @override
  String get externalDetail => '상세 내용';

  @override
  String get externalDetailValidation => '상세 내용을 20자 이상 500자 이내로 작성해주세요.';

  @override
  String get externalAttachment => '첨부 URL (선택)';

  @override
  String get externalAttachmentValidation => '올바른 http 또는 https URL을 입력해주세요.';

  @override
  String get externalEvidence => '분석 근거 포함';

  @override
  String get externalCancel => '취소';

  @override
  String get externalSubmit => '제출';

  @override
  String get externalReasonFake => '가짜 리뷰 의심';

  @override
  String get externalReasonAi => '자동 생성 의심';

  @override
  String get externalReasonIrrelevant => '상품과 무관한 내용';

  @override
  String get externalReasonInappropriate => '부적절한 표현 / 개인정보';

  @override
  String get externalReasonAd => '광고성 리뷰';

  @override
  String get externalReasonRepeated => '반복 내용';

  @override
  String get externalReasonOffensive => '모욕적인 내용';

  @override
  String get externalReasonOther => '기타';

  @override
  String get productImageEnlarge => '상품 이미지 확대';

  @override
  String get productImagePrevious => '이전 상품 이미지';

  @override
  String get productImageNext => '다음 상품 이미지';

  @override
  String get imagePreviewOpen => '사진 확대';

  @override
  String get imagePreviewTitle => '사진 미리보기';

  @override
  String get imagePreviewPrevious => '이전 사진';

  @override
  String get imagePreviewNext => '다음 사진';

  @override
  String get chatFreshContext => '새 대화 · 이전 기록은 유지돼요';

  @override
  String get chatHistoryContext => '기록에서 연 대화';

  @override
  String get chatActiveContext => '진행 중인 대화';

  @override
  String get chatGeneralContext => '일반 대화 · 상품 지정 없음';

  @override
  String get chatTargetProduct => '질문 대상 상품';

  @override
  String get chatQuotaLoading => '질문 한도를 확인하고 있어요.';

  @override
  String get chatQuotaUnavailable => '한도를 다시 확인하지 못했어요. 마지막 확인 값은 유지돼요.';

  @override
  String get chatQuotaRefresh => '다시 확인';

  @override
  String get chatClosePreserve => '닫기 (대화는 유지)';

  @override
  String get chatHistoryWait => '대화 기록은 전송이 끝난 뒤 열 수 있어요.';

  @override
  String get extProductReviewPreferencesNote =>
      '정렬 설정은 불러온 리뷰에 적용돼요. 제공되지 않은 구매 인증·신뢰도 정보로 리뷰를 숨기거나 분류하지 않아요.';

  @override
  String get extProductSummaryLoading => '상품 기본 정보를 확인하고 있어요.';

  @override
  String get extProductListSummary =>
      '목록에서 받은 상품 정보예요. 최신 상세 정보와 리뷰를 확인하고 있어요.';

  @override
  String get extProductPreviousSummary =>
      '이전에 확인한 상품 정보예요. 최신 상세 정보와 리뷰를 확인하고 있어요.';

  @override
  String get recentRecordFailed => '최근 본 기록을 확인하지 못했어요. 다시 시도';

  @override
  String get recentRecordUnavailable => '최근 본 기록에 필요한 상품 식별 정보를 확인하지 못했어요.';

  @override
  String get reviewPhotoOnly => '사진 있는 리뷰';

  @override
  String get reviewListView => '리뷰 목록';

  @override
  String get reviewPhotosView => '사진 모아보기';

  @override
  String reviewPhotoScope(int loaded, int photos) {
    return '불러온 리뷰 $loaded개 · 사진 있는 리뷰 $photos개';
  }

  @override
  String get reviewPhotosEmpty => '현재 불러온 리뷰에 유효한 사진이 없어요.';

  @override
  String get externalForbidden => '이 작업을 할 권한이 없어요.';

  @override
  String get externalAuthRequestFailed =>
      '이 요청의 인증을 확인하지 못했어요. 현재 로그인 상태를 확인한 뒤 다시 시도해주세요.';

  @override
  String get externalNetworkFailure => '네트워크 연결을 확인하고 다시 시도해주세요.';

  @override
  String get externalTimeout => '요청 시간이 초과됐어요. 다시 시도해주세요.';

  @override
  String get reportTitle => '리뷰 신뢰도 리포트';

  @override
  String get reportDetails => '상세 분석 보기';

  @override
  String get reportClose => '닫기';

  @override
  String get reportBefore => '분석 전';

  @override
  String get reportCollecting => '상품·리뷰 정보를 수집하고 있어요. 분석 진행 상태와는 별개예요.';

  @override
  String get reportRunning => '분석이 진행 중이에요.';

  @override
  String get reportFailed => '분석 결과를 가져오지 못했어요.';

  @override
  String get reportDisabled => '현재 분석 기능이 비활성화되어 있어요.';

  @override
  String get reportStale => '기존 분석 결과가 최신 상태가 아니에요.';

  @override
  String get reportUnavailable => '분석 상태를 확인할 수 없어요.';

  @override
  String get reportDone => '리뷰 분석 결과가 준비됐어요. 상세 분석에서 판단 근거를 확인해보세요.';

  @override
  String get reportLoadedScope => '현재 불러온 리뷰의 분석 결과예요. 상품 전체 분석 범위와 다를 수 있어요.';

  @override
  String get reportInputCount => '분석에 입력한 리뷰';

  @override
  String get reportSourceCount => '수집된 원본 리뷰';

  @override
  String get reportSampled => '일부 리뷰 표본 분석';

  @override
  String get reportFull => '전체 수집 리뷰 분석';

  @override
  String get reportModel => '모델 버전';

  @override
  String get reportPolicy => '정책 버전';

  @override
  String get reportNoReviewResults => '현재 불러온 리뷰에 제공된 분석 결과가 없어요.';

  @override
  String get reportReasons => '제공된 판단 근거';

  @override
  String get reportCurrentCount => '현재 불러온 분석 리뷰';

  @override
  String get reportCatalogAverage => '상품 평균 RTI';

  @override
  String get reportCatalogSource =>
      '상품 목록에서 제공된 집계입니다. 상세 리뷰 결과와 업데이트 시점이 다를 수 있어요.';

  @override
  String get reviewAnalysisSafe => '신뢰도 높음';

  @override
  String get reviewAnalysisWarn => '주의';

  @override
  String get reviewAnalysisDanger => '신뢰도 낮음';

  @override
  String get reviewAnalysisMissing => '이 리뷰에 제공된 분석 결과가 없어요.';

  @override
  String get reportIntro => '구매 전, 리뷰의 신뢰도를 살펴보세요.';

  @override
  String get reportScoreLabel => '상품 리뷰 신뢰도';

  @override
  String get reportStateReady => '분석 결과';

  @override
  String get reportStateCollecting => '리뷰 수집 중';

  @override
  String get reportStateRunning => '분석 중';

  @override
  String get reportStateFailed => '결과 확인 필요';

  @override
  String get reportStateStale => '업데이트 필요';

  @override
  String get reportStateDisabled => '분석 미제공';

  @override
  String get reportStateUnavailable => '상태 확인 필요';

  @override
  String get reportPendingBody =>
      '아직 분석 결과가 없어요. 결과가 준비되면 리뷰 신뢰도와 판단 근거를 여기에서 확인할 수 있어요.';

  @override
  String get reportOverview => '분석 요약';

  @override
  String get reportCoverage => '분석 범위';

  @override
  String get reportReviewResults => '리뷰별 결과와 근거';

  @override
  String get reviewOriginal => '리뷰 원문';

  @override
  String get reviewResultTitle => '이 리뷰의 분석 결과';

  @override
  String get reviewIndividualScope =>
      '선택한 리뷰 한 건의 결과예요. 상품 전체 리포트와 분석 범위가 달라요.';

  @override
  String get reviewLoadedAggregate => '함께 불러온 리뷰의 집계';

  @override
  String get evidenceRepetitionLabel => '반복 표현';

  @override
  String get evidenceRepetitionBody => '같은 표현이 반복해서 사용됐어요.';

  @override
  String get evidenceShortLabel => '짧은 리뷰';

  @override
  String get evidenceShortBody => '리뷰 내용이 짧아 확인할 정보가 적어요.';

  @override
  String get evidenceExclamationLabel => '잦은 느낌표';

  @override
  String get evidenceExclamationBody => '느낌표가 많이 사용됐어요.';

  @override
  String get evidencePositiveLabel => '강한 긍정 표현';

  @override
  String get evidencePositiveBody => '강한 긍정 표현이 감지됐어요. 이것만으로 광고를 뜻하지는 않아요.';

  @override
  String get evidencePurchaseLabel => '구매 인증 미확인';

  @override
  String get evidencePurchaseBody => '구매 인증이 확인되지 않은 리뷰예요.';

  @override
  String get evidenceNewAccountLabel => '가입 초기 작성';

  @override
  String get evidenceNewAccountBody => '리뷰 작성 당시 가입한 지 얼마 되지 않은 계정이었어요.';

  @override
  String get evidenceDailyLabel => '하루에 여러 리뷰';

  @override
  String get evidenceDailyBody => '같은 작성자가 하루에 여러 리뷰를 작성했어요.';

  @override
  String get evidenceSimilarLabel => '비슷한 리뷰 내용';

  @override
  String get evidenceSimilarBody =>
      '내용이 비슷한 다른 리뷰가 확인됐어요. 유사성만으로 조작을 단정하지 않아요.';

  @override
  String get evidenceClusterLabel => '유사 리뷰 묶음';

  @override
  String get evidenceClusterBody =>
      '내용이 서로 비슷한 리뷰 묶음이 확인됐어요. 조작 여부가 확정된 것은 아니에요.';

  @override
  String get evidenceQualityLabel => '낮은 내용 품질 점수';

  @override
  String get evidenceQualityBody => '리뷰 내용의 품질 점수가 낮게 평가됐어요.';

  @override
  String get evidenceUnknownPurchaseLabel => '구매 여부 불명확';

  @override
  String get evidenceUnknownPurchaseBody => '제공된 정보로는 구매 여부를 확인할 수 없어요.';

  @override
  String get evidenceTrialLabel => '체험·무상 제공 가능성';

  @override
  String get evidenceTrialBody => '체험단 또는 무상 제공 리뷰일 가능성이 제시됐어요.';

  @override
  String get evidenceNoImageLabel => '첨부 사진 없음';

  @override
  String get evidenceNoImageBody => '리뷰에 첨부된 사진이 없어요.';

  @override
  String get evidenceRepurchaseLabel => '재구매 신호';

  @override
  String get evidenceRepurchaseBody => '재구매를 나타내는 정보가 확인됐어요.';

  @override
  String get evidenceUnknownLabel => '추가 분석 근거';

  @override
  String get evidenceUnknownBody => '추가 근거가 제공됐지만 아직 설명 문구를 지원하지 않아요.';

  @override
  String get homeSearchSuggestionsEmpty => '연관 검색어가 없어요. 입력한 단어로 검색할 수 있어요.';

  @override
  String get homeSearchSuggestionsError =>
      '연관 검색어를 불러오지 못했어요. 입력한 단어로 검색하거나 다시 시도해 주세요.';

  @override
  String get homeSearchSuggestionsRetry => '연관 검색어 다시 불러오기';

  @override
  String get authAccountHelp => '계정 도움말';

  @override
  String get authAccountHelpBody =>
      '이메일 계정의 비밀번호는 비밀번호 찾기에서 재설정할 수 있습니다. 구글·네이버 계정은 가입할 때 사용한 소셜 로그인 버튼을 이용해 주세요.';

  @override
  String get authForgotPassword => '비밀번호 찾기';

  @override
  String get authSignup => '회원가입';

  @override
  String get authClose => '닫기';

  @override
  String get authLogin => '로그인';

  @override
  String get authLoginDescription => 'Re:view 계정으로 로그인하고 저장한 상품과 신뢰 필터를 불러오세요.';

  @override
  String get authEmail => '이메일';

  @override
  String get authEmailHint => '이메일을 입력하세요';

  @override
  String get authPassword => '비밀번호';

  @override
  String get authPasswordHint => '비밀번호를 입력하세요';

  @override
  String get authShow => '보기';

  @override
  String get authHide => '숨김';

  @override
  String get authRememberMe => '로그인 상태 유지';

  @override
  String get authOr => '또는';

  @override
  String get authContinueNaver => '네이버 계정으로 계속하기';

  @override
  String get authContinueGoogle => 'Google 계정으로 계속하기';

  @override
  String get authNoAccount => '아직 계정이 없나요?';

  @override
  String get authSignupAction => '회원가입하기';

  @override
  String get authPrivacyNotice =>
      '개인화 정보는 계정에 안전하게 저장되며, 저장 상품과 분석 기록은 로그인한 사용자에게만 표시됩니다.';

  @override
  String get authSignupDescription =>
      'Re:view 계정을 만들고 저장 상품, 신뢰 필터, 알림 설정을 시작하세요.';

  @override
  String get authName => '이름';

  @override
  String get authNameHint => '이름을 입력하세요';

  @override
  String get authPasswordGuidance => '영문, 숫자, 특수문자를 포함해 8자 이상으로 설정해주세요.';

  @override
  String get authConfirmPassword => '비밀번호 확인';

  @override
  String get authConfirmPasswordHint => '비밀번호를 한 번 더 입력하세요';

  @override
  String get authSignupOnboarding => '회원가입하고 온보딩 시작';

  @override
  String get authSignupNaver => '네이버 계정으로 가입하기';

  @override
  String get authSignupGoogle => 'Google 계정으로 가입하기';

  @override
  String get authHasAccount => '이미 계정이 있나요?';

  @override
  String get authLoginAction => '로그인하기';

  @override
  String get authTermsConsent => '이용약관 및 개인정보처리방침에 동의합니다. (필수)';

  @override
  String get authMarketingConsent => '저장 상품 알림과 신뢰도 변화 알림을 받겠습니다. (선택)';

  @override
  String get authOnboardingNotice =>
      '다음 단계는 온보딩입니다. 가입 후 관심 카테고리와 기본 RTI 필터를 설정합니다.';

  @override
  String get authResetTitle => '비밀번호 재설정';

  @override
  String get authResetDescription => '가입한 이메일을 확인하고 새 비밀번호를 등록하세요.';

  @override
  String get authRememberAccount => '계정이 기억났나요?';

  @override
  String get authBackToLogin => '로그인으로 돌아가기';

  @override
  String get authRegisteredEmail => '가입 이메일';

  @override
  String get authSendVerification => '인증 이메일 발송';

  @override
  String get authEmailSent => '이메일을 발송했습니다';

  @override
  String get authEmailSentGuide => '이메일의 링크를 클릭하거나, 받은 토큰을 확인한 후 다음 단계로 진행하세요.';

  @override
  String get authNext => '다음';

  @override
  String get authResendEmail => '이메일 다시 받기';

  @override
  String get authNewPassword => '새 비밀번호';

  @override
  String get authNewPasswordHint => '새 비밀번호를 입력하세요';

  @override
  String get authNewPasswordGuide =>
      '이전에 사용한 비밀번호와 다르게 설정하고, 영문·숫자·특수문자를 조합해 주세요.';

  @override
  String get authConfirmNewPassword => '새 비밀번호 확인';

  @override
  String get authConfirmNewPasswordHint => '새 비밀번호를 한 번 더 입력하세요';

  @override
  String get authCompleteReset => '비밀번호 변경 완료';

  @override
  String get authResendVerification => '인증 이메일 다시 받기';

  @override
  String get authMinLength => '8자 이상';

  @override
  String get authLettersNumbers => '영문과 숫자 포함';

  @override
  String get authSymbolsRecommended => '특수문자 포함 권장';

  @override
  String get authNoEmail => '이메일을 받지 못했나요?';

  @override
  String get authNoEmailGuide => '스팸함을 확인하거나, 가입한 이메일이 맞는지 다시 확인해 주세요.';

  @override
  String get authVerifyEmail => '이메일 확인';

  @override
  String get authVerificationCode => '인증 코드';

  @override
  String get authResetSuccess => '비밀번호가 변경되었습니다';

  @override
  String get authResetSuccessGuide => '새 비밀번호로 로그인해 주세요.';

  @override
  String get authGoToLogin => '로그인하러 가기';

  @override
  String get searchFilterTitle => '필터';

  @override
  String get searchFilterReset => '초기화';

  @override
  String get searchFilterCategory => '카테고리';

  @override
  String get searchFilterPriceRange => '가격대';

  @override
  String get searchFilterWon => '원';

  @override
  String get searchFilterSeller => '판매처';

  @override
  String get searchFilterSellerHint => '판매처를 선택하세요';

  @override
  String get searchFilterRtiScore => 'RTI 신뢰 점수';

  @override
  String get searchFilterAllRti => '전체 (분석 전 포함)';

  @override
  String get searchFilterZeroPoints => '0점';

  @override
  String get searchFilterHundredPoints => '100점';

  @override
  String get searchFilterEightyMinimum => '80점 이상';

  @override
  String get searchFilterNinetyMinimum => '90점 이상';

  @override
  String get searchFilterNinetyFiveMinimum => '95점 이상';

  @override
  String get searchFilterInfoStatus => '정보 상태';

  @override
  String get searchFilterReviewConditions => '리뷰 조건';

  @override
  String get searchFilterSelectSeller => '판매처 선택';

  @override
  String get searchFilterAllSellers => '전체 판매처';

  @override
  String get searchFilterUnanalyzedOnly => '분석 전만';

  @override
  String get searchFilterMissingPriceOnly => '가격 정보 없음만';

  @override
  String get searchFilterMinimumReviews => '리뷰 50개 이상';

  @override
  String get searchFilterUnderTenThousand => '1만원 이하';

  @override
  String get searchFilterTenToThirtyThousand => '10~30만원';

  @override
  String get searchFilterAboveThreeHundredThousand => '30만원 이상';

  @override
  String searchFilterPriceAmount(String amount) {
    return '$amount원';
  }

  @override
  String searchFilterMinimumScore(int score) {
    return '$score점 이상';
  }

  @override
  String searchFilterShowResults(int count) {
    return '$count개 결과 보기';
  }

  @override
  String get analysisPolicyIndex => '정책 지수';

  @override
  String get analysisNotCalculable => '계산 불가';

  @override
  String get analysisPolicyExplanation => '정책 기준에 따른 상대 지수입니다.';

  @override
  String get analysisTextScore => '텍스트 점수';

  @override
  String get analysisBehaviorScore => '행동 점수';

  @override
  String get analysisNetworkScore => '네트워크 점수';

  @override
  String get analysisScore => '분석 점수';

  @override
  String get analysisSeparateContracts => '서로 다른 계약의 점수는 별도로 표시합니다.';

  @override
  String get analysisPolicyAverage => '상품 평균 정책 지수';

  @override
  String get owlGuideName => '리뷰엉이';

  @override
  String get extProgressProductStep => '상품 정보 수집';

  @override
  String get extProgressReviewsStep => '리뷰 수집';

  @override
  String get extProgressAnalysisStep => '리뷰 분석';

  @override
  String get extProgressStatusComplete => '완료';

  @override
  String get extProgressStatusInProgress => '진행 중';

  @override
  String get extProgressStatusWaiting => '대기';

  @override
  String get extProgressStatusFailed => '실패';

  @override
  String get extProgressStatusNotAnalyzed => '아직 분석 전';

  @override
  String get extProgressStatusUnknown => '확인 중';

  @override
  String get extProgressStatusRefreshing => '새로 수집 중';

  @override
  String get extProgressStatusDisabled => '비활성화됨';

  @override
  String get extProgressStatusUnavailable => '정보 없음';

  @override
  String get extProgressStatusPartial => '일부 완료';

  @override
  String get extProgressNoticeCollecting => '상품 정보와 리뷰의 수집 작업을 기다리고 있어요.';

  @override
  String get extProgressNoticeRefreshing =>
      '이전에 수집한 정보를 보여드리고 있어요. 새 수집 작업이 대기 중이거나 진행 중이에요.';

  @override
  String get extProgressNoticeAnalyzing => '리뷰 분석이 대기 중이거나 진행 중이에요.';

  @override
  String get extProgressNoticeNotAnalyzed => '아직 리뷰 분석 전이에요.';

  @override
  String get extProgressNoticeComplete => '리뷰 분석이 완료됐어요.';

  @override
  String get extProgressNoticeFailed =>
      '수집·분석 과정에서 문제가 확인됐어요. 단계별 상태를 확인해 주세요.';

  @override
  String get extProgressNoticeDelayed => '시간이 걸리고 있어요. 다시 확인해 주세요.';

  @override
  String get extProgressNoticeChecking => '현재 수집·분석 상태를 확인 중이에요.';

  @override
  String get extProgressNoticeDisabled => '리뷰 분석이 비활성화되어 있어요.';

  @override
  String get extProgressNoticeUnavailable => '현재 리뷰 분석 정보를 확인할 수 없어요.';

  @override
  String get extProgressRetry => '다시 확인';

  @override
  String extProgressStepSemantics(String step, String status) {
    return '$step, $status';
  }

  @override
  String get extSummaryTitle => '리뷰 분석 요약';

  @override
  String get extSummaryFallbackTitle => '분석 상태·근거 안내';

  @override
  String get extSummaryFallbackIntro => '현재 불러온 리뷰의 분석 상태와 신뢰도 근거를 정리했어요.';

  @override
  String get extSummaryNoEvidence => '분석은 끝났지만 요약할 근거가 아직 없어요.';

  @override
  String get extSummaryNotAnalyzed => '아직 분석 전이라 표시할 요약이 없어요.';

  @override
  String get extSummaryInProgress => '분석 진행 상태는 위 단계에서 확인해 주세요.';

  @override
  String get extSummaryFailed => '분석에 실패해 요약을 표시할 수 없어요.';

  @override
  String get extSummaryDisabled => '분석이 비활성화되어 요약을 표시하지 않아요.';

  @override
  String get extSummaryUnavailable => '요약을 표시할 분석 상태가 아직 확인되지 않았어요.';

  @override
  String get extSummaryMissingValue => '미제공';

  @override
  String get extSummarySampling => '표본 여부';

  @override
  String get extSummaryNotSampled => '표본 분석 아님';

  @override
  String extSummaryLoadedScope(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '현재 불러온 리뷰 $countString개 기준';
  }

  @override
  String get extSummaryV2Grades => '정책 지수 기준 등급 (v2)';

  @override
  String get extSummaryLegacyGrades => '신뢰도 등급 (v0.5)';

  @override
  String get extSummaryUnknownVersion => '분석 버전 미상';

  @override
  String extSummaryGradeCount(String grade, int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$grade: $countString개';
  }

  @override
  String get extSummaryGradeSafe => '신뢰도 높음';

  @override
  String get extSummaryGradeWarn => '주의';

  @override
  String get extSummaryGradeDanger => '신뢰도 낮음';

  @override
  String get extSummaryEvidenceTitle => '자주 확인된 신뢰도 근거';

  @override
  String get extSummaryEvidenceScope =>
      '현재 불러온 리뷰의 신뢰도 분석 근거이며, 상품 품질 평가는 아니에요.';

  @override
  String extSummaryReasonCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString개 리뷰에서 확인';
  }

  @override
  String get extSummaryNoLoadedReviews => '현재 불러온 리뷰가 없어 등급 분포를 표시할 수 없어요.';

  @override
  String extSummaryFact(String label, String value) {
    return '$label: $value';
  }

  @override
  String get extTrustDetailSource => '상세 분석 결과';

  @override
  String get extTrustCatalogSource => '목록에서 확인한 평균';

  @override
  String get extTrustNoAverage => '이 화면에서는 상품 평균을 받을 수 없어요.';

  @override
  String get extTrustBefore => '아직 분석 전이라 상품 점수가 없어요.';

  @override
  String get extTrustRunning => '분석이 진행 중이라 상품 점수를 표시하지 않아요.';

  @override
  String get extTrustGradeMissing => '등급 정보 없음';

  @override
  String get extTrustGuideSafe => '분석한 리뷰의 신뢰 신호가 대체로 안정적이에요.';

  @override
  String get extTrustGuideCaution => '판단 근거를 함께 확인해 보세요.';

  @override
  String get extTrustGuideUnknown => '점수의 출처와 제공된 근거를 함께 확인해 보세요.';

  @override
  String get extTrustNoEvidence => '제공된 상품 분석 근거가 없어요.';

  @override
  String get extTrustComponents => '세부 점수';

  @override
  String get extTrustTextExplanation => '리뷰 문장의 표현과 반복 패턴을 살펴본 점수예요.';

  @override
  String get extTrustBehaviorExplanation => '리뷰 작성자의 활동 패턴을 살펴본 점수예요.';

  @override
  String get extTrustNetworkExplanation => '리뷰·작성자 사이의 연결 패턴을 살펴본 점수예요.';

  @override
  String get extTrustCoverageInSummary => '분석 범위와 버전은 위 요약 카드에서 확인할 수 있어요.';

  @override
  String extTrustScoreValue(String label, String score) {
    return '$label $score / 100';
  }

  @override
  String get extNavProgress => '분석 진행';

  @override
  String get extNavSummary => 'AI 요약';

  @override
  String get extNavReport => '신뢰도 리포트';

  @override
  String get extNavReviews => '리뷰';

  @override
  String get extNavLabel => '섹션 바로가기';

  @override
  String get extDescriptionTitle => '상품 상세 설명';

  @override
  String get extDescriptionSource => '쇼핑몰 상세 페이지 내용';

  @override
  String get extDescriptionExpand => '상세 설명 펼치기';

  @override
  String get extDescriptionCollapse => '상세 설명 접기';

  @override
  String extDescriptionImage(int index) {
    return '상세 이미지 $index';
  }

  @override
  String get extNavDescription => '상세 설명';

  @override
  String get failureTitleOffline => '연결을 확인해 주세요';

  @override
  String get failureMessageOffline => '서버에 연결할 수 없어요. 인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get failureTitleTimeout => '응답이 지연되고 있어요';

  @override
  String get failureMessageTimeout => '연결 또는 응답 대기 시간이 초과됐어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get failureTitleUnauthorized => '로그인이 필요해요';

  @override
  String get failureMessageUnauthorized => '로그인 정보가 없거나 만료됐어요. 다시 로그인해 주세요.';

  @override
  String get failureTitleForbidden => '접근 권한이 없어요';

  @override
  String get failureMessageForbidden => '이 기능을 이용할 권한이 없어요.';

  @override
  String get failureTitleNotFound => '요청한 내용을 찾을 수 없어요';

  @override
  String get failureMessageNotFound => '요청한 정보가 없거나 더 이상 제공되지 않아요.';

  @override
  String get failureTitleRateLimited => '요청이 많아요';

  @override
  String get failureMessageRateLimited => '요청이 많아 잠시 후 다시 시도해 주세요.';

  @override
  String get failureTitleServer => '서버에서 문제가 발생했어요';

  @override
  String get failureMessageServer => '서버 오류가 발생했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get failureTitleCancelled => '요청이 취소됐어요';

  @override
  String get failureMessageCancelled => '요청이 취소되어 결과를 불러오지 않았어요.';

  @override
  String get failureTitleBadResponse => '응답을 확인할 수 없어요';

  @override
  String get failureMessageBadResponse => '응답을 처리하지 못했어요. 다시 확인해 주세요.';

  @override
  String get failureTitleUnknown => '문제가 발생했어요';

  @override
  String get failureMessageUnknown => '요청을 완료하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get failureRetry => '다시 시도';

  @override
  String get failureSearchRetry => '다시 검색';

  @override
  String get analysisPending => '분석 중';

  @override
  String get analysisTextCaution => '본문의 반복·홍보·설명문 표현을 확인해 주세요.';

  @override
  String analysisAttentionReviews(int count) {
    return '주의 리뷰 $count건';
  }

  @override
  String get scrollToTop => '맨 위로';

  @override
  String get actionUndo => '되돌리기';

  @override
  String get wishlistRemoved => '찜에서 뺐어요';

  @override
  String get cartRemoved => '장바구니에서 뺐어요';

  @override
  String get listLoading => '불러오는 중';

  @override
  String get cartEmptyTitle => '장바구니가 비어 있어요';

  @override
  String get cartEmptyDescription => '마음에 드는 상품을 담아보세요.';

  @override
  String get emptyViewWishlist => '찜 목록 보기';

  @override
  String get recentProductsEmptyTitle => '최근 본 상품이 없어요';

  @override
  String get recentProductsEmptyDescription =>
      '궁금한 상품을 둘러보세요. 최근 조회 기록은 여기에 모여요.';

  @override
  String get warningProductsEmptyTitle => '주의 상품이 없어요';

  @override
  String get warningProductsFilteredEmptyTitle => '선택한 등급의 주의 상품이 없어요';

  @override
  String get warningProductsEmptyDescription => '다른 상품도 둘러보고 관심 있는 상품을 찜해보세요.';

  @override
  String get searchEmptyTitle => '검색 결과가 없어요';

  @override
  String get searchEmptyQueryDescription => '상품명이나 카테고리를 입력해 검색해보세요.';

  @override
  String get searchEmptyDescription => '다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.';

  @override
  String get searchFilteredEmptyTitle => '필터에 맞는 상품이 없어요';

  @override
  String get searchFilteredEmptyDescription => '필터를 초기화하거나 조건을 조금 넓혀보세요.';

  @override
  String get searchResetFilters => '필터 초기화';

  @override
  String get extProductVisitShopGeneric => '쇼핑몰에서 보기';

  @override
  String get headerSupport => '고객센터';

  @override
  String get headerSellerRegistration => '판매자 입점';

  @override
  String get headerAppDownload => '앱 다운로드';

  @override
  String get headerCart => '장바구니';

  @override
  String get headerMyAccount => '내 계정';

  @override
  String get headerMember => '회원';

  @override
  String headerMemberName(String name) {
    return '$name님';
  }

  @override
  String get headerMemberBadge => 'Re:view 멤버';

  @override
  String get headerOrderActivity => '주문/활동';

  @override
  String get homeNavBest => '베스트';

  @override
  String get homeNavNew => '신상품';

  @override
  String get homeNavReviewRanking => '리뷰랭킹';

  @override
  String get homePopularCategoriesNow => '지금 인기 카테고리';

  @override
  String get homeCategoryPickTitle => '카테고리 추천 PICK';

  @override
  String get homeAllCategoriesTitle => '모든 카테고리를 한눈에';

  @override
  String get homeAllCategoriesDescription => '리뷰 데이터 기반 인기 상품과 카테고리를 확인해보세요.';

  @override
  String homeCategoryViewAll(String category) {
    return '$category 전체보기  >';
  }

  @override
  String get homeBannerFallbackNotice => '배너를 불러오지 못해 기본 배너를 표시합니다.';

  @override
  String get homeProductsLoadFailed => '상품을 불러오지 못했습니다.';

  @override
  String get homeViewAllProducts => '전체 상품 보기';

  @override
  String get homeBannerLinkFailed => '배너 링크를 열지 못했습니다.';

  @override
  String get homePriceUnavailable => '가격 정보 없음';

  @override
  String get homeRecommendationsPending => '추천 상품 API 연결 대기 중';

  @override
  String get homeRecommendationsPendingDescription =>
      '임의 상품을 만들지 않고 실제 상품 데이터가 연결되면 카드 목록으로 표시됩니다.';

  @override
  String get homeTrustTitle => 'Re:view가 더 믿을 수 있는 이유';

  @override
  String get homeTrustIndexTitle => 'RTI 리뷰 신뢰도 지수';

  @override
  String get homeFooterAbout => '서비스 소개';

  @override
  String get homeFooterTerms => '이용약관';

  @override
  String get homeFooterPrivacy => '개인정보처리방침';

  @override
  String get homeSuggestedProductsPending => '추천상품 API 연결 대기 중';

  @override
  String get homeRtiChecking => 'RTI 확인 중';

  @override
  String get homeTrustAnalyzedProduct => '신뢰도 분석 상품';

  @override
  String get homeBannerPlay => '재생';

  @override
  String get homeBannerPause => '일시정지';

  @override
  String get homeBannerPrevious => '이전 배너';

  @override
  String get homeBannerNext => '다음 배너';

  @override
  String homeBannerPosition(int index, int count) {
    return '배너 $index/$count';
  }

  @override
  String homeBannerTrustLabel(String badge) {
    return '$badge\n신뢰도 확인';
  }

  @override
  String get landingHomeTooltip => '홈으로';

  @override
  String get landingFeatureRti => 'RTI 기반';

  @override
  String get landingFeatureAdPatterns => '광고성 패턴 분석';

  @override
  String get landingFeatureEvidence => '판별 근거 제공';

  @override
  String get landingHeroDescription =>
      '상품별 리뷰를 분석하고, RTI로 판단한 신뢰 지수를 제공해\n더 믿을 수 있는 구매 결정을 도와드려요.';

  @override
  String get landingHeroHeadline => '가짜 리뷰에 흔들리지 않는\n더 똑똑한 쇼핑, ';

  @override
  String get landingStart => '시작하기';

  @override
  String get landingLearnRti => 'RTI 알아보기';

  @override
  String get landingCloseHint => '언제든 닫고 홈으로 이동할 수 있어요';

  @override
  String get landingGradeHigh => '신뢰 높음';

  @override
  String landingRtiReliabilityScore(String score) {
    return 'RTI 신뢰도 $score%';
  }

  @override
  String get landingRtiAnalyzing => 'RTI 신뢰도 분석 중';

  @override
  String get landingSummaryLowAd => '광고 패턴 낮음';

  @override
  String get landingSummaryFewRepeats => '반복 문구 적음';

  @override
  String get landingSummaryNoAnomalies => '이상 징후 없음';

  @override
  String get landingAnalysisSummary => 'Re:view 분석 요약';

  @override
  String get landingAnalysisDisclaimer =>
      '실제 사용자 리뷰를 기반으로 분석하여\n광고성/조작 신호는 필터링되어 분석에 반영됩니다.';

  @override
  String get settingsEditInterests => '관심 카테고리·알림 설정 다시 편집';

  @override
  String get homeCategoryBenefitReviewBased => '리뷰 데이터 기반 추천';

  @override
  String get homeCategoryBenefitRtiRanking => 'RTI 랭킹 확인';

  @override
  String get homeCategoryBenefitFastShippingProducts => '빠른 배송 상품';

  @override
  String get homeCategoryBenefitAllOffers => '혜택 모아보기';

  @override
  String get homeCategoryBenefitSize => '사이즈 추천';

  @override
  String get homeCategoryBenefitStyle => '스타일 추천';

  @override
  String get homeCategoryBenefitGenderDeals => '성별 핫딜';

  @override
  String get homeCategoryBenefitGifts => '베스트 선물';

  @override
  String get homeCategoryBenefitAuthenticityCheck => '정품 인증';

  @override
  String get homeCategoryBenefitBrandEvents => '브랜드 기획전';

  @override
  String get homeCategoryBenefitGiftWrapping => '선물 포장 서비스';

  @override
  String get homeCategoryBenefitFreeReturns => '무료 반품';

  @override
  String get homeCategoryBenefitIngredients => '성분으로 찾기';

  @override
  String get homeCategoryBenefitSkinType => '피부 타입 추천';

  @override
  String get homeCategoryBenefitReviewRanking => '리뷰 랭킹';

  @override
  String get homeCategoryBenefitSamples => '샘플 체험';

  @override
  String get homeCategoryBenefitDawnDelivery => '새벽배송';

  @override
  String get homeCategoryBenefitBulkDiscount => '대용량 할인';

  @override
  String get homeCategoryBenefitReviewFavorites => '리뷰 인기상품';

  @override
  String get homeCategoryBenefitSubscriptions => '정기배송';

  @override
  String get homeCategoryBenefitTodayDeals => '오늘의 특가';

  @override
  String get homeCategoryBenefitHousewarming => '집들이 추천';

  @override
  String get homeCategoryBenefitFastShipping => '빠른배송';

  @override
  String get homeCategoryBenefitByRoom => '공간별 추천';

  @override
  String get homeCategoryBenefitPopularInteriors => '인기 인테리어';

  @override
  String get homeCategoryBenefitInstallation => '설치 서비스';

  @override
  String get homeCategoryBenefitSeasonalDecor => '시즌 데코';

  @override
  String get homeCategoryBenefitBeginners => '입문자 추천';

  @override
  String get homeCategoryBenefitTopGear => '베스트 장비';

  @override
  String get homeCategoryBenefitSeasonalOutdoors => '시즌 아웃도어';

  @override
  String get homeCategoryBenefitQuickCompare => '빠른 비교';

  @override
  String get homeCategoryBenefitCarCare => '차량관리 필수템';

  @override
  String get homeCategoryBenefitMaintenance => '정비용품 추천';

  @override
  String get homeCategoryBenefitBrandDeals => '브랜드 특가';

  @override
  String get homeCategoryBenefitSafetyGear => '안전장비 모음';

  @override
  String get homeCategoryBenefitParenting => '육아 필수템';

  @override
  String get homeCategoryBenefitByAge => '연령별 추천';

  @override
  String get homeCategoryBenefitSafetyCertification => '안전인증';

  @override
  String get homeCategoryBenefitSpecialOffers => '기획전';

  @override
  String get homeCategoryBenefitPopularTreats => '인기 간식';

  @override
  String get homeCategoryBenefitVetPicks => '수의사 추천';

  @override
  String get homeCategoryBenefitPetPersonalized => '우리 아이 맞춤';

  @override
  String get homeCategoryBenefitMerchandiserPicks => 'MD 추천';

  @override
  String get homeCategoryBenefitPreorders => '예약판매';

  @override
  String get homeCategoryBenefitLimitedMerch => '한정판 굿즈';

  @override
  String get homeCategoryBenefitBestsellers => '베스트셀러';

  @override
  String get homeCategoryBenefitTravelChecklist => '여행 준비 체크리스트';

  @override
  String get homeCategoryBenefitPopularStays => '인기 숙소';

  @override
  String get homeCategoryBenefitDiscountTickets => '할인 티켓';

  @override
  String get homeCategoryBenefitSubscriptionOffers => '구독 혜택';

  @override
  String get homeCategoryBenefitAuthenticityGuarantee => '정품 보증';

  @override
  String get homeCategoryBenefitBrandWeek => '브랜드 위크';

  @override
  String get homeCategoryBenefitPremiumOffers => '프리미엄 혜택';

  @override
  String get homeCategoryBenefitExclusiveOffers => '단독 오퍼';

  @override
  String get homeCategoryRecommendedLabel => '추천';

  @override
  String get authLoginContinue => '내 관심 상품을 이어서 관리하세요.';

  @override
  String get authLoginTrackHeadline => '내 관심 상품의 리뷰 신뢰도를\n계속 추적하세요.';

  @override
  String get authLoginManageDescription =>
      '로그인하면 저장한 상품, 신뢰 필터 설정, 분석 피드백 내역을 한 계정에서 이어서 관리할 수 있습니다.';

  @override
  String get authLoginSafeShopping => '안전한 쇼핑을 위한 로그인';

  @override
  String get authLoginRecentProducts => '최근 확인한 상품';

  @override
  String get authLoginRestoreRecords => '로그인 후 저장 상품과 분석 기록을 불러옵니다.';

  @override
  String get authLoginKeepTrackingRti => 'RTI 계속 추적';

  @override
  String get authMetricText => '텍스트';

  @override
  String get authMetricBehavior => '행동';

  @override
  String get authMetricPurchaseContext => '구매맥락';

  @override
  String get authProductUncategorized => '카테고리 미분류';

  @override
  String get authLoginSavedProducts => '저장 상품 관리';

  @override
  String get authLoginSavedProductsDescription =>
      '관심 상품을 모아두고 RTI 변화 위협 신호를 확인합니다.';

  @override
  String get authLoginPersonalFilters => '개인 신뢰 필터';

  @override
  String get authLoginPersonalFiltersDescription =>
      '위험 리뷰 숨김, 최소 RTI 기준 등 나에게 맞는 필터를 유지합니다.';

  @override
  String get authLoginFeedbackTracking => '분석 피드백 추적';

  @override
  String get authLoginFeedbackTrackingDescription =>
      '신고와 피드백 처리 상태를 한곳에서 확인합니다.';

  @override
  String get authFooterContact => '문의';

  @override
  String get authSignupFilterHeadline => '내 쇼핑 기준에 맞는\n리뷰 신뢰 필터를\n만들어보세요.';

  @override
  String get authSignupFilterDescription =>
      '회원가입 후 관심 카테고리와 기본 신뢰 필터를 설정하면, 상품을 볼 때마다 내 기준에 맞는 RTI 신호와 알림을 받을 수 있습니다.';

  @override
  String get authSignupCreateAccount => '새 계정 만들기';

  @override
  String get authSignupAccountStep => '계정 생성';

  @override
  String get authSignupAccountStepDescription => '이름과 이메일로 Re:view 계정을 만듭니다.';

  @override
  String get authSignupCurrentStep => '현재 단계';

  @override
  String get authSignupInterestStep => '관심 카테고리 선택';

  @override
  String get authSignupInterestStepDescription => '관심사가 쌓이면 더 나은 신뢰 신호를 제공합니다.';

  @override
  String get authSignupFilterStep => '신뢰 필터 설정';

  @override
  String get authSignupFilterStepDescription => '위험 리뷰 숨김, 최소 RTI 기준을 설정합니다.';

  @override
  String get authSignupFollowupFlow => '가입 후 바로 이어지는 흐름';

  @override
  String get authSignupFollowupDescription =>
      '회원가입이 끝나면 온보딩에서 관심 카테고리와 기본 필터를 설정합니다.';

  @override
  String get authSignupPersonalizedBrowse => '개인화된 상품 탐색';

  @override
  String get authSignupPersonalizedBrowseDescription =>
      '관심 카테고리에 맞는 신뢰 피드를 먼저 확인합니다.';

  @override
  String get authSignupSavedAlerts => '저장 상품 알림';

  @override
  String get authSignupSavedAlertsDescription =>
      '관심 상품의 위험 신호가 증가하면 알림을 받을 수 있습니다.';

  @override
  String get authSignupFeedbackHistory => '피드백 기록 관리';

  @override
  String get authSignupFeedbackHistoryDescription => '신고와 분석 피드백 처리 상태를 추적합니다.';

  @override
  String authSetupMinutes(int minutes) {
    return '$minutes분 설정';
  }

  @override
  String get authValidationNameRequired => '이름을 입력해주세요.';

  @override
  String get authValidationEmailRequired => '이메일을 입력해주세요.';

  @override
  String get authValidationEmailInvalid => '올바른 이메일 형식으로 입력해주세요.';

  @override
  String get authValidationPasswordRequired => '비밀번호를 입력해주세요.';

  @override
  String get authValidationPasswordComposition => '영문, 숫자, 특수문자를 모두 포함해주세요.';

  @override
  String get authValidationPasswordConfirmRequired => '비밀번호를 한 번 더 입력해주세요.';

  @override
  String get authValidationPasswordMismatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get authValidationTermsRequired => '필수 약관에 동의해주세요.';

  @override
  String authValidationPasswordMinLength(int minLength) {
    return '비밀번호는 $minLength자 이상이어야 합니다.';
  }

  @override
  String get authResetVerifyHeadline => '안전하게 인증하고\n';

  @override
  String get authResetHeadlineEmphasis => '비밀번호를 다시 설정';

  @override
  String get authResetHeadlineEnd => ' 하세요.';

  @override
  String get authResetValueDescription =>
      'Re:view 계정의 저장 상품, 신뢰 필터, 피드백 내역을 보호하기 위해 이메일 후 새 비밀번호를 설정합니다.';

  @override
  String get authResetRecoveryBadge => '계정 복구';

  @override
  String get authResetEmailStepDescription => '가입한 이메일 주소로 인증 코드를 발송합니다.';

  @override
  String get authResetCodeStep => '인증 코드 입력';

  @override
  String get authResetNewPasswordStep => '새 비밀번호 설정';

  @override
  String get authResetNewPasswordStepDescription =>
      '보안 기준을 만족하는 새 비밀번호를 등록합니다.';

  @override
  String get authResetProcessTitle => '비밀번호 재설정 과정';

  @override
  String get authResetProcessDescription => '계정 소유 확인 후 안전하게 비밀번호를 변경합니다.';

  @override
  String get authResetSecurityBadge => '보안 인증';

  @override
  String get authResetKeepData => '계정 데이터 유지';

  @override
  String get authResetKeepDataDescription => '비밀번호를 바꿔도 저장 필터 설정은 그대로';

  @override
  String get authResetProtectCode => '인증 코드 보호';

  @override
  String get authResetProtectCodeDescription =>
      '인증 코드는 일정 시간 후 만료되며 타인에게 공유하지 않아야 합니다.';

  @override
  String get authResetSignInAgain => '로그인 재확인';

  @override
  String get authResetSignInAgainDescription => '비밀번호 변경 후 새 다시 로그인합니다.';

  @override
  String authResetCodeStepDescription(int digits) {
    return '메일로 받은 $digits자리 코드를 입력해 계정을 확인합니다.';
  }

  @override
  String get authOAuthLoginFailed => 'OAuth 로그인에 실패했습니다.';

  @override
  String get onboardingCategoryTitle => '관심 있는 카테고리를 선택해 주세요';

  @override
  String get onboardingCategoryDescription =>
      '선택하지 않아도 진행할 수 있습니다. 관심 설정은 나중에 설정에서 다시 변경할 수 있어요.';

  @override
  String get onboardingUnanalyzedNotice => '분석 전 상품을 안전한 상품으로 판정하지 않습니다.';

  @override
  String get onboardingSkipExisting => '기존 설정으로 건너뛰기';

  @override
  String onboardingTrustThreshold(int score) {
    return '신뢰도 기준: $score점';
  }

  @override
  String get onboardingNotificationDescription =>
      '알림함에서 받을 알림을 선택하세요. 실제 분석 결과가 생성된 경우에만 관련 알림을 받을 수 있어요.';

  @override
  String get onboardingFeedbackResults => '피드백 처리 결과';

  @override
  String get onboardingMarketingConsent => '마케팅·이벤트 알림 동의';

  @override
  String get onboardingNotificationAvailability =>
      '브라우저 푸시·이메일·문자 및 주간 리포트는 현재 제공되지 않습니다. 이 화면은 알림함 설정을 저장합니다.';

  @override
  String get onboardingPrevious => '이전';

  @override
  String get onboardingSaveComplete => '저장하고 완료';

  @override
  String get onboardingPreferredCategories => '선호 카테고리';

  @override
  String get onboardingReload => '다시 불러오기';

  @override
  String get reportSubmit => '신고 접수하기';

  @override
  String get reportReceived => '신고 접수';

  @override
  String get reportReceivedDescription => '대상 리뷰와 신고 사유가 저장됩니다.';

  @override
  String get reportAssistedReview => 'AI 보조 검토';

  @override
  String get reportAssistedReviewDescription => 'RTI 신호와 유사 리뷰 이력을 함께 확인합니다.';

  @override
  String get reportTeamDecision => '운영팀 판단';

  @override
  String get reportTeamDecisionDescription => '허위/악의성이면 무선 검토 상태가 갱신됩니다.';

  @override
  String get reportResultNotification => '결과 알림';

  @override
  String get reportResultNotificationDescription =>
      '검토 완료되면 피드백 내역에 결과가 반영됩니다.';

  @override
  String get reportProcessTitle => '처리 절차';

  @override
  String get reportProcessDescription => '신고 접수 후 운영팀이 검토하는 흐름이에요.';

  @override
  String get reportGuideRepeated => '반복 문구를 구체적으로 적기';

  @override
  String get reportGuideRepeatedDescription =>
      '정확한 위치/문장/패턴 등 눈에 띄는 표현을 적어주세요.';

  @override
  String get reportGuideContext => '상품 사용 맥락 확인';

  @override
  String get reportGuideContextDescription =>
      '실제 사용 경험이 없거나 상품과 무관한 부분을 알려주세요.';

  @override
  String get reportGuideAttachments => '첨부 자료 첨부';

  @override
  String get reportGuideAttachmentsDescription =>
      '해당 근거가 여러 상황에 반복된다면 첨부가 좋습니다.';

  @override
  String get reportGuideTitle => '신고 가이드';

  @override
  String get reportGuideDescription => '이런 경우 신고가 더 잘 처리돼요.';

  @override
  String get reportSummaryTitle => '접수 요약';

  @override
  String get reportSummaryDescription => '제출 전 입력한 내용을 확인하세요.';

  @override
  String get reportLiveBadge => '실시간';

  @override
  String get reportSelectedReasons => '선택 사유';

  @override
  String get reportAnalysisEvidence => 'AI 근거';

  @override
  String get reportTargetReviews => '대상 리뷰';

  @override
  String get reportReasonTitle => '신고 사유 선택';

  @override
  String get reportReasonDescription => '카드를 탭해서 선택하세요 · 여러 개 선택 가능합니다.';

  @override
  String get reportViewCriteria => '신고 기준 보기';

  @override
  String get reportStepTarget => '대상 확인';

  @override
  String get reportStepTargetDescription => '상품과 리뷰 정보 확인';

  @override
  String get reportStepReasonDescription => '문제 유형 선택';

  @override
  String get reportStepDetails => '상세 근거';

  @override
  String get reportStepDetailsDescription => '추가 설명 입력';

  @override
  String get reportStepComplete => '접수 완료';

  @override
  String get reportStepCompleteDescription => '검토 상태 추적';

  @override
  String get reportTargetDescription => '신고하려는 상품과 리뷰가 맞는지 확인해주세요.';

  @override
  String get reportFromAnalysis => '분석 팝업에서 이동';

  @override
  String get reportPrivacyConsent => '개인정보 수집 및 신고 처리 안내에 동의합니다.';

  @override
  String get reportPrivacyDescription =>
      '신고 내용은 리뷰 접수, 처리 결과 안내, 모델 품질 개선을 위해 사용되며 필요한 기간 동안 보관됩니다.';

  @override
  String get reportTruthConsent => '허위 신고가 아님을 확인합니다.';

  @override
  String get reportTruthDescription => '신고 내용이 사실과 다를 경우 처리 우선순위가 낮아질 수 있습니다.';

  @override
  String get reportTitleText => '리뷰 신고 접수';

  @override
  String get reportDescription =>
      '의심 리뷰의 문제 유형과 근거를 남겨주세요. 제출된 신고는 운영 검수와 모델 개선 피드백에 함께 활용됩니다.';

  @override
  String get reportViewMyFeedback => '내 피드백 내역 보기';

  @override
  String get reportReportBreadcrumb => '리포트';

  @override
  String get reportEvidenceTitle => '분석 근거 함께 제출 (선택)';

  @override
  String get reportEvidenceDescription => '현재 리뷰의 RTI 분석 신호를 신고 근거로 첨부할 수 있어요.';

  @override
  String get reportAttachEvidence => 'AI 분석 근거 첨부';

  @override
  String get reportAttachEvidenceDescription => 'RTI 신호 데이터가 신고 근거와 함께 제출돼요.';

  @override
  String get reportViewEvidence => '근거 보기';

  @override
  String get reportDetailsTitle => '상세 근거 입력';

  @override
  String get reportDetailsDescription => '신고 판단에 도움이 되는 내용을 남겨주세요.';

  @override
  String get reportType => '신고 유형';

  @override
  String get reportVisibility => '처리 결과 공개 범위';

  @override
  String get reportDetailHint => '구체적인 문제 내용과 맥락을 입력해주세요.';

  @override
  String get reportAttachments => '첨부 자료 ';

  @override
  String get reportOptional => '(선택)';

  @override
  String get reportAttachmentsFull => '첨부 가능한 개수를 모두 채웠어요';

  @override
  String get reportAttachmentsHint => '스크린샷이나 추가 근거를 첨부해주세요';

  @override
  String get reportChooseFiles => '파일 선택';

  @override
  String get reportConsentsRequired => '동의 항목을 모두 확인해주세요.';

  @override
  String get reportSubmittedTitle => '신고 접수 완료';

  @override
  String get reportSubmittedDescription =>
      '신고가 접수되었습니다.\n처리 결과는 피드백 내역에서 확인할 수 있어요.';

  @override
  String get reportViewFeedback => '피드백 내역 보기';

  @override
  String get reportAlreadyReportedTitle => '이미 신고한 리뷰';

  @override
  String get reportAlreadyReportedDescription =>
      '이 리뷰는 이미 신고하셨습니다.\n중복 신고는 접수되지 않아요.';

  @override
  String reportReviewCount(int count) {
    return '$count건';
  }

  @override
  String reportAverageReviewRound(int round) {
    return '평균 $round차 검토';
  }

  @override
  String reportRiskyReviewScore(String score) {
    return '위험 리뷰 · RTI $score';
  }

  @override
  String reportMaxAttachments(int count) {
    return '최대 $count개까지만 첨부할 수 있어요.';
  }

  @override
  String reportFileTooLarge(String name, int size) {
    return '$name은 ${size}MB를 초과합니다.';
  }

  @override
  String reportMinimumCharacters(int count) {
    return '최소 $count자 이상 입력해주세요.';
  }

  @override
  String reportMinimumCharactersHelp(int count) {
    return '최소 $count자 이상 입력하면 운영팀 검토에 더 도움이 돼요.';
  }

  @override
  String reportCharacterCount(int count) {
    return '$count자';
  }

  @override
  String reportAttachmentLimits(int size, int count) {
    return 'PNG, JPG, PDF · 최대 ${size}MB · 최대 $count개';
  }

  @override
  String reportReasonRequired(int count) {
    return '신고 사유를 $count개 이상 선택해주세요.';
  }

  @override
  String reportDetailsRequired(int count) {
    return '상세 설명을 $count자 이상 입력해주세요.';
  }

  @override
  String get reportReasonFake => '가짜 리뷰 / 리뷰 날바 의심';

  @override
  String get reportReasonGenerated => 'AI 생성 흔적 의심';

  @override
  String get reportReasonFakeDescription =>
      '반복되고, 과도한 칭찬, 구매 이력 복수가 동조하는 가능성이 있는 리뷰예요.';

  @override
  String get reportReasonGeneratedDescription =>
      '반복이 지나치게 정밀하거나, 동일한 문장 구조가 반복되는 리뷰예요.';

  @override
  String get reportReasonIrrelevantDescription =>
      '실제 상품 사용 경험과 관련이 없는 내용이거나 다른 상품/페이지의 내용을 포함해요.';

  @override
  String get reportReasonInappropriateDescription =>
      '비방, 혐오 표현, 이름 등 개인정보가 포함된 리뷰예요.';

  @override
  String get reportReasonAdDescription => '광고 리뷰입니다.';

  @override
  String get reportReasonRepeatDescription => '반복되는 내용입니다.';

  @override
  String get reportReasonOtherDescription => '기타 신고 사유입니다.';

  @override
  String get reportTypeRepetition => '반복 문구';

  @override
  String get reportTypeNewAccount => '계정 생성 직후';

  @override
  String get reportTypeSimilarCluster => '유사 리뷰 군집';

  @override
  String get reportPrivate => '비공개';

  @override
  String get reportOnlyMe => '나에게만 공개';

  @override
  String get reportTeamOnly => '운영팀 공유';

  @override
  String get reportSelectPrompt => '선택해주세요';

  @override
  String get reportGuideBadge => '안내';

  @override
  String get paymentTestCartTitle => '장바구니 토스 TEST 결제';

  @override
  String get paymentTestServiceTitle => '토스 TEST 서비스 결제';

  @override
  String get paymentTestCartDescription =>
      'TEST 주문·결제 전용입니다. 실제 상품 배송과 실결제는 진행하지 않습니다. 판매·배송 가능 상품과 최종 금액은 서버 견적으로 확인합니다.';

  @override
  String get paymentTestServiceDescription =>
      '테스트 전용입니다. 외부 쇼핑몰 상품 주문·실결제·자동 플랜 변경을 진행하지 않습니다.';

  @override
  String get paymentTestLoginRequired =>
      '주문 조회와 결제는 로그인이 필요합니다. 결제 콜백 주소는 로그인 후 다시 열어 주세요.';

  @override
  String get paymentTestNotConfigured =>
      'TEST 결제 키와 서버 주문·승인 계약이 아직 준비되지 않았습니다. 현재 결제를 시작하거나 완료할 수 없습니다.';

  @override
  String get paymentTestWebOnly => '현재 TEST 결제는 웹 브라우저에서만 지원합니다.';

  @override
  String get paymentTestOrder => 'TEST 주문';

  @override
  String get paymentTestReloadTargets => '결제 대상 다시 조회';

  @override
  String get paymentTestOpening => 'TEST 결제창 여는 중';

  @override
  String get paymentTestOpen => 'TEST 결제창 열기';

  @override
  String get paymentTestReloadWindow => '결제창 다시 불러오기';

  @override
  String get paymentTestReloadApproval => '서버 승인 상태 다시 조회';

  @override
  String get paymentTestBackToOrders => 'TEST 주문 선택으로 돌아가기';

  @override
  String get paymentTestCheckPlan => '현재 플랜 확인';

  @override
  String get paymentCheckoutTitle => '장바구니 TEST 주문';

  @override
  String get paymentCheckoutDescription =>
      '실결제·실제 배송은 진행하지 않습니다. 쇼핑몰 상품을 이 서비스가 판매·배송할 수 있는지 서버 확인이 필요합니다. 표시 가격은 참고용이며 배송비·최종 금액은 서버 견적으로 확인합니다.';

  @override
  String get paymentCheckoutNotConfigured =>
      'TEST 공개 키와 장바구니 견적·주문·승인 API가 아직 없습니다. 주문 저장과 결제는 사용할 수 없습니다. 주소는 서버에 보내거나 저장하지 않습니다.';

  @override
  String get paymentCheckoutLoginSelect => '로그인 후 주문 선택';

  @override
  String get paymentCheckoutNoSelection =>
      '현재 계정의 선택 상품이 없습니다. 장바구니에서 상품을 선택해 주세요.';

  @override
  String get paymentCheckoutRecipient => '수령인';

  @override
  String get paymentCheckoutPhone => '연락처';

  @override
  String get paymentCheckoutPostalCode => '우편번호';

  @override
  String get paymentCheckoutAddress => '주소';

  @override
  String get paymentCheckoutAddressDetail => '상세 주소 (선택)';

  @override
  String get paymentCheckoutRequired => '입력해 주세요.';

  @override
  String get paymentCheckoutPhoneInvalid => '연락처 형식을 확인해 주세요.';

  @override
  String get paymentCheckoutQuote => '서버 TEST 견적 확인';

  @override
  String get paymentCheckoutBack => '장바구니로 돌아가기';

  @override
  String paymentCheckoutUnitPrice(String price) {
    return '참고 개당 $price원';
  }

  @override
  String paymentCheckoutQuantity(int count, String price) {
    return '$count개 · $price';
  }

  @override
  String paymentCheckoutPostalLength(int count) {
    return '우편번호 $count자리를 입력해 주세요.';
  }

  @override
  String get paymentTestRequestFailed =>
      '결제창 요청이 취소되었거나 실패했습니다. 결제 완료로 처리하지 않았습니다.';

  @override
  String get paymentTestLoadFailed =>
      'TEST 결제창을 불러오지 못했습니다. 네트워크와 설정을 확인한 뒤 다시 시도해 주세요.';

  @override
  String get paymentTestWebBrowserOnly => 'TEST 결제는 웹 브라우저에서만 사용할 수 있습니다.';

  @override
  String get planRefreshFailed =>
      '요금제 변경 요청은 처리됐지만 현재 플랜과 한도를 확인하지 못했습니다. 다시 불러와 확인해 주세요.';

  @override
  String get detailSettingsRetry => '표시 설정을 불러오지 못했습니다. 재시도';

  @override
  String get detailHelpfulUnavailable => '도움 횟수가 제공되지 않아 기존 리뷰 순서로 표시합니다.';

  @override
  String get detailNoReviews => '아직 등록된 리뷰가 없습니다.';

  @override
  String get detailNoMatchingReviews => '해당 조건에 맞는 리뷰가 없습니다.';

  @override
  String get detailVerified => '구매인증';

  @override
  String get detailSortRti => 'RTI 높은순';

  @override
  String get detailViewReviewAnalysis => '리뷰 분석 보기';

  @override
  String get detailHelpful => '도움이 됐어요';

  @override
  String get detailNotHelpful => '도움이 안 됐어요';

  @override
  String get detailFeedbackSubmitted => '피드백이 제출됐습니다.';

  @override
  String get detailFeedbackFailed => '피드백 제출에 실패했습니다. 다시 시도해주세요.';

  @override
  String detailShowHiddenReviews(int count) {
    return '설정 기준 이하 리뷰 $count개 표시';
  }

  @override
  String detailMoreReviewsRemaining(int count) {
    return '리뷰 더보기 ($count개 남음)';
  }

  @override
  String get detailLowestPrice => '최저가';

  @override
  String get detailShipping => '배송';

  @override
  String detailCompareAllSellers(int count) {
    return '전체 $count개 판매처 가격 비교';
  }

  @override
  String get detailInsights => '리뷰 인사이트';

  @override
  String get detailMentionedKeywords => '많이 언급된 키워드';

  @override
  String get detailPositivePoints => '만족 포인트';

  @override
  String get detailNegativePoints => '아쉬운 포인트';

  @override
  String get detailMoreInsights => '리뷰 인사이트 더보기';

  @override
  String get detailRiskSummary => '종합 위험 요약';

  @override
  String get detailRiskSummaryTooltip => '이 상품의 전체 리뷰에 대한\nAI 신뢰도 분석 결과입니다.';

  @override
  String get detailScoreTooltip =>
      'RTI 신뢰도 점수는 구매 인증, 텍스트 신뢰도,\n반복 표현, 시점 패턴 등을 종합해 산출됩니다.';

  @override
  String get detailDisclaimer => '분석 결과는 참고용이며 최종 판단은 여러 리뷰를 함께 확인해주세요.';

  @override
  String get detailCriteria => '분석 기준';

  @override
  String get detailReported => '신고 완료';

  @override
  String get detailReportReview => '리뷰 신고';

  @override
  String get detailSignalsTitle => 'RTI 구성 신호';

  @override
  String get detailSignalsTooltip =>
      'RTI 점수를 구성하는 신호와 각각의 점수입니다.\n텍스트·행동·네트워크 분석을 종합해 산출합니다.';

  @override
  String get detailEvidenceTooltip =>
      '리뷰 신뢰도를 판단한 구체적인 근거와\n각 근거가 점수에 기여한 비중입니다.';

  @override
  String get detailAlsoViewed => '이 제품을 본 고객이 함께 본 제품';

  @override
  String get detailKeySignals => '주요 판단 신호';

  @override
  String get detailTrend => '위험도 추이';

  @override
  String get detailTrendDescription => '상품 리뷰의 평균 RTI와 위험 리뷰 비율 변화를 보여줘요.';

  @override
  String get detailTrendPending => 'AI 분석 완료 후 위험도 추이를 확인할 수 있습니다';

  @override
  String get detailAverageRti => '평균 RTI';

  @override
  String get detailRiskyReviewRatio => '위험 리뷰 비율';

  @override
  String get detailToday => '오늘';

  @override
  String get detailRecentReviewOrder => '최신 리뷰 순서';

  @override
  String get detailAnalyzing => 'AI 분석 중';

  @override
  String get detailNoAnalyzedReviews => '분석된 리뷰가 없습니다.';

  @override
  String get detailOfficialSeller => '공식 판매처';

  @override
  String get detailTrustHigh => '리뷰 신뢰도 높음';

  @override
  String get detailTrustMedium => '리뷰 신뢰도 보통';

  @override
  String get detailTrustLow => '리뷰 신뢰도 낮음';

  @override
  String detailFormattedReviewCount(String count) {
    return '리뷰 $count개';
  }

  @override
  String get detailBrand => '브랜드';

  @override
  String get detailAverageRating => '평균 별점';

  @override
  String detailSellerCount(int count) {
    return '$count곳';
  }

  @override
  String detailRatingReviewCount(String rating, String count) {
    return '$rating (리뷰 $count개)';
  }

  @override
  String get detailAnalysisInProgress => 'AI 리뷰 분석 진행 중';

  @override
  String get detailAnalysisInProgressDescription =>
      'Re:view AI가 리뷰를 실시간 분석하고 있습니다. 완료 후 신뢰도 점수가 자동으로 업데이트됩니다.';

  @override
  String get detailInformation => '상품 정보';

  @override
  String detailReviewTabCount(String count) {
    return '리뷰 $count';
  }

  @override
  String detailComparisonTabCount(int count) {
    return '가격비교 $count';
  }

  @override
  String get searchGridView => '카드형 보기';

  @override
  String get searchListView => '리스트형 보기';

  @override
  String get searchSort => '정렬';

  @override
  String get searchPageSize => '페이지당 상품 수';

  @override
  String searchResultCountLabel(int count) {
    return '$count개 결과';
  }

  @override
  String searchPageSizeCount(int count) {
    return '$count개씩 보기';
  }

  @override
  String get searchCartAdded => '장바구니에 담겼습니다.';

  @override
  String get searchCartAddFailed => '장바구니 담기에 실패했습니다.';

  @override
  String searchFormattedReviewCount(String count) {
    return '(리뷰 $count)';
  }

  @override
  String get searchAllProducts => '전체 상품';

  @override
  String get searchCategoryProducts => '카테고리 상품';

  @override
  String get searchResultsTitle => '검색 결과';

  @override
  String get searchAboutRti => 'Re:view Trust Index(RTI)란?';

  @override
  String get searchAboutRtiDescription => '실제 구매자 리뷰의 신뢰도를 종합해 산출한 지표입니다.';

  @override
  String searchFormattedProductCount(String count) {
    return '$count개 상품';
  }

  @override
  String searchQuickFilterAllCount(int count) {
    return '전체 $count';
  }

  @override
  String get searchMultiStoreTitle => '멀티 스토어 통합 검색';

  @override
  String get searchComparedProducts => '비교 상품';

  @override
  String get searchCollectedReviews => '수집 리뷰';

  @override
  String get searchNotCounted => '미집계';

  @override
  String get searchReviewBasedComparison => '실사용 리뷰 기반 비교';

  @override
  String get searchComparisonDescription =>
      '가격과 리뷰, RTI 신뢰도를 한 번에 비교해 신뢰도 높은 상품을 빠르게 골라보세요.';

  @override
  String get searchLowestPriceComparison => '최저가 비교';

  @override
  String get searchReviewTrust => '리뷰 신뢰도';

  @override
  String get searchFastDelivery => '빠른 배송';

  @override
  String get searchOfficialStores => '공식몰 포함';

  @override
  String get searchVeryHighTrust => '매우 신뢰 높음';

  @override
  String get searchModerateTrust => '보통';

  @override
  String get searchLowTrust => '낮음';

  @override
  String searchComparedProductCount(String count) {
    return '$count개';
  }

  @override
  String searchCollectedReviewCount(String count) {
    return '$count건';
  }

  @override
  String get searchUnconfirmedCategoriesNotice =>
      '쇼핑몰 상품은 카테고리 이름으로 검색하며, 분류가 확정되지 않은 결과도 함께 표시합니다. 상세 분류는 쇼핑몰 원문을 확인해 주세요.';

  @override
  String searchLoadedProductsScope(int count, int limit) {
    return '현재 불러온 $count개 상품에서 필터·정렬합니다. 키워드 검색은 최대 $limit개 결과이며 전체 쇼핑몰 상품 검색 필터가 아닙니다. 배송·판매량·출시일·사진 리뷰 정보는 제공되지 않아 해당 조건은 지원하지 않습니다.';
  }

  @override
  String get searchSortAccuracy => '추천순';

  @override
  String get searchSortRti => 'RTI순';

  @override
  String get searchSortReviewCount => '리뷰 많은순';

  @override
  String get searchSortSales => '판매 많은순';

  @override
  String get searchSortPriceLow => '최저가순';

  @override
  String get searchSortPriceHigh => '높은 가격순';

  @override
  String get searchSortNewest => '신상품순';

  @override
  String get searchMissingClassification => '분류 정보 없음';

  @override
  String get cartSelectionSummary => '선택 상품 요약';

  @override
  String get cartUnknownPriceExcluded => '가격 정보가 없는 상품은 합계에서 제외했어요.';

  @override
  String get cartReferencePriceNotice =>
      '표시 가격은 참고용입니다. 구매와 배송비·쿠폰 확인은 각 쇼핑몰에서 진행해 주세요.';

  @override
  String get cartViewSelectedSellers => '선택 상품 구매처 확인';

  @override
  String get cartContinueShopping => '쇼핑 계속하기';

  @override
  String get cartShippingConditions => '배송 조건은 구매처에서 확인';

  @override
  String get cartSaveLater => '나중에 담기';

  @override
  String get cartDelete => '삭제';

  @override
  String cartTrustLevel(String level) {
    return '신뢰도 $level';
  }

  @override
  String cartPriceReduction(String price) {
    return '$price 인하';
  }

  @override
  String cartEstimatedArrival(String date) {
    return '$date 도착 예정';
  }

  @override
  String cartStockRemaining(int count) {
    return '재고 $count개 남음';
  }

  @override
  String get cartDeleteSelected => '선택 삭제';

  @override
  String get cartMoveToWishlist => '찜한 상품으로 이동';

  @override
  String cartSelectAllCount(int selected, int total) {
    return '전체 선택 ($selected/$total)';
  }

  @override
  String get cartSellersTitle => '구매처 확인';

  @override
  String get cartSellersDescription =>
      '상품 상세에서 제공되는 쇼핑몰 구매 링크를 이용해 주세요. TEST 주문 기능은 별도 화면에서 준비하며 현재 서버 판매·배송 계약은 없습니다.';

  @override
  String get cartViewProductAndSeller => '상품 상세 및 구매처 보기';

  @override
  String get cartDescription => '담아둔 상품을 확인하고 주문 전 리뷰 신뢰도도 함께 비교하세요.';

  @override
  String get cartTrustCheckTitle => '리뷰 신뢰도 체크';

  @override
  String get cartTrustCheckDescription =>
      '제품별 RTI 지수를 확인하고, 신뢰할 수 있는 리뷰가 많은 상품을 선택해보세요.';

  @override
  String cartTotalProducts(int count) {
    return '총 $count개 상품';
  }

  @override
  String wishlistCountItems(int count) {
    return '$count개';
  }

  @override
  String get wishlistShoppingMall => '쇼핑몰';

  @override
  String get wishlistPriceComparisonUnavailable =>
      '서버에서 가격하락 비교 정보를 제공하지 않고 있어요. 가격이 변하지 않았다는 뜻은 아니에요.';

  @override
  String get wishlistUncategorized => '미분류';

  @override
  String get wishlistShopUnknown => '쇼핑몰 정보 없음';

  @override
  String get myPageTrustUnavailable => '찜 상품의 분석 정보를 확인할 수 없어요.';

  @override
  String get myPageTrustScope => '찜한 상품 중 분석된 RTI의 평균과 서버 주의 등급 기준입니다.';

  @override
  String myPageTrustScorePoints(int score) {
    return '$score점';
  }

  @override
  String get myPageBack => '마이페이지로 돌아가기';

  @override
  String get myPageActivityLoadFailed => '최근 활동을 불러오지 못했어요.';

  @override
  String get myPageActivityRecent => '최근';

  @override
  String get myPageActivityJustNow => '방금 전';

  @override
  String myPageActivityDaysAgo(int count) {
    return '$count일 전';
  }

  @override
  String myPageActivityHoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String myPageNamedDescription(String name) {
    return '$name님의 정보와 저장한 상품 활동을 관리해요.';
  }

  @override
  String get myPageWarningScope =>
      '찜한 상품 중 서버가 의심·위험 등급으로 분석한 상품이에요. 분석 전 상품은 포함하지 않아요.';

  @override
  String get myPageCheckList => '목록 확인';

  @override
  String get myPageAllWarnings => '전체 주의';

  @override
  String get myPageLoadFailed => '주의 상품을 확인할 수 없어요.';

  @override
  String myPageViewListCount(int count) {
    return '목록 보기 ($count)';
  }

  @override
  String recentProductsScope(int count) {
    return '서버의 최근 $count개 조회 기록에서 중복 상품을 제외했어요. 전체 기간의 상품 수와는 다를 수 있어요.';
  }

  @override
  String get recentProductsLoadFailed => '최근 본 상품을 불러오지 못했어요.';

  @override
  String get notificationsAll => '전체 알림';

  @override
  String get notificationsPriceAlerts => '가격 알림';

  @override
  String get notificationsSavedSettings => '저장된 알림 수신 설정';

  @override
  String get notificationsMore => '더 보기';

  @override
  String get notificationsTargetUnsupported => '이 알림의 이동 대상은 아직 지원되지 않습니다.';

  @override
  String get notificationsCheckingUnreadShort => '읽지 않은 알림 확인 중';

  @override
  String get notificationsUnreadFailedShort => '알림 수를 확인하지 못했어요.';

  @override
  String get notificationsManageInboxAndPrices => '알림함 · 가격 알림 관리';

  @override
  String get notificationsServiceTitle => '서비스 알림';

  @override
  String get notificationsCheckingUnread => '읽지 않은 알림을 확인하고 있어요.';

  @override
  String get notificationsUnreadFailed => '읽지 않은 알림 수를 확인하지 못했어요.';

  @override
  String get notificationsSettingsFailed => '저장된 알림 설정을 불러오지 못했어요.';

  @override
  String get notificationsSettingsChecking => '저장된 알림 설정 확인 중';

  @override
  String get notificationsReviewSettings => '알림·리뷰 설정';

  @override
  String get notificationsMonitoringNotice =>
      '위험 변화 자동 감시는 서버 연동이 필요해요. 수신 설정을 켜는 것만으로 감시가 시작되지는 않아요.';

  @override
  String get notificationsInboxNotice =>
      '알림함에 저장된 알림을 확인해요. 브라우저 푸시·이메일·문자는 지원하지 않아요.';

  @override
  String notificationsUnreadCount(int count) {
    return '읽지 않은 알림 $count개';
  }

  @override
  String get notificationsReceiving => '받음';

  @override
  String get notificationsNotReceiving => '받지 않음';

  @override
  String notificationsRiskStatus(String status) {
    return '위험 감지 $status';
  }

  @override
  String notificationsAnalysisStatus(String status) {
    return '분석 결과 $status';
  }

  @override
  String notificationsFeedbackStatus(String status) {
    return '처리 결과 $status';
  }

  @override
  String get priceWatchTitle => '가격하락 · 가격 알림 관리';

  @override
  String get priceWatchHistoryNotice =>
      '가격 알림 이력·구독 저장은 아직 지원되지 않아요. 아래는 알림 기록이 아닌 찜 상품의 서버 가격하락 표시입니다.';

  @override
  String get priceWatchComparisonUnavailable =>
      '서버가 찜 상품의 비교 가격 정보를 제공하지 않아 하락 여부를 확인할 수 없어요.';

  @override
  String get priceWatchRefreshWishlistPrices => '찜 가격 정보 새로고침';

  @override
  String get priceWatchViewWishlist => '찜 상품 확인';

  @override
  String get priceWatchSubscriptionNotice => '서버 가격이력·구독 저장 연동 후 신청할 수 있어요.';

  @override
  String get priceWatchSubscriptionUnavailable => '가격 알림 신청 · 미지원';

  @override
  String get priceWatchDropIndicator => '서버 가격하락 표시 · 하락액/비율 정보 없음';

  @override
  String priceWatchLoadFailed(String message) {
    return '가격하락 표시를 확인하지 못했어요. $message';
  }

  @override
  String priceWatchDropCounts(int total, int known, int drops) {
    return '찜 $total개 중 가격하락 정보가 있는 $known개에서 $drops개가 하락으로 표시됐어요. 기준 가격·시점은 제공되지 않았어요.';
  }

  @override
  String get extProgressPreviousComplete => '수집·분석 완료 · 이전 수집 정보';

  @override
  String get extProgressPreviousInfo => '이전에 수집한 정보';

  @override
  String get extReviewSummaryTitle => '리뷰 요약';

  @override
  String extReviewRatingSummary(int count, String rating, String distribution) {
    return '불러온 리뷰 $count개 · 평균 $rating점 · $distribution';
  }

  @override
  String extReviewStarCount(int stars, int count) {
    return '$stars점 $count개';
  }

  @override
  String extReviewKeywords(String keywords) {
    return '자주 언급된 표현: $keywords';
  }

  @override
  String extReviewPositive(String excerpt) {
    return '긍정 리뷰: “$excerpt”';
  }

  @override
  String extReviewNegative(String excerpt) {
    return '아쉬운 리뷰: “$excerpt”';
  }

  @override
  String get extReviewSummaryRequest => 'AI로 리뷰 요약 받기';

  @override
  String get extReviewSummaryQuestion => '이 상품 리뷰들을 장점과 아쉬운 점으로 짧게 요약해 줘';

  @override
  String get extSummaryEvidenceToggle => '분석 상태·근거 보기';

  @override
  String get chatHistoryProductLoading => '상품 정보 불러오는 중';
}
