import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// 홈 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// 검색 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get navSearch;

  /// 마이페이지 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get navMyPage;

  /// 설정 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get navSettings;

  /// 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get actionSave;

  /// 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get actionConfirm;

  /// 재시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get actionRetry;

  /// 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get actionLogin;

  /// 전체 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 보기'**
  String get actionViewAll;

  /// 알림 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get settingsNotifications;

  /// 사이드 네비게이션 계정 설정
  ///
  /// In ko, this message translates to:
  /// **'계정 설정'**
  String get sideNavAccountSettings;

  /// 사이드 네비게이션 피드백 내역
  ///
  /// In ko, this message translates to:
  /// **'피드백 내역'**
  String get sideNavFeedbackHistory;

  /// 설정 페이지 부제목 (비로그인)
  ///
  /// In ko, this message translates to:
  /// **'알림, 필터, 계정 설정을 관리해요.'**
  String get settingsSubtitle;

  /// 설정 페이지 부제목 (로그인)
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님의 알림, 필터, 계정 설정을 관리해요.'**
  String settingsSubtitleNamed(String nickname);

  /// 계정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get settingsAccountTitle;

  /// 비밀번호 변경 링크
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get settingsAccountChangePassword;

  /// 회원 탈퇴 버튼
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get settingsDeleteAccount;

  /// 회원 탈퇴 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get settingsDeleteAccountConfirmTitle;

  /// 회원 탈퇴 확인 안내
  ///
  /// In ko, this message translates to:
  /// **'탈퇴하면 계정과 저장된 정보가 삭제되며 되돌릴 수 없습니다. 탈퇴할까요?'**
  String get settingsDeleteAccountConfirmBody;

  /// 회원 탈퇴 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get settingsDeleteAccountCancel;

  /// 회원 탈퇴 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'탈퇴'**
  String get settingsDeleteAccountConfirm;

  /// 회원 탈퇴 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴를 완료하지 못했습니다. 잠시 후 다시 시도해 주세요.'**
  String get settingsDeleteAccountFailed;

  /// 계정 이름 레이블
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get settingsAccountLabelName;

  /// 계정 이메일 레이블
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get settingsAccountLabelEmail;

  /// 계정 가입일 레이블
  ///
  /// In ko, this message translates to:
  /// **'가입일'**
  String get settingsAccountLabelJoinDate;

  /// 회원 유형 레이블
  ///
  /// In ko, this message translates to:
  /// **'회원 유형'**
  String get settingsAccountLabelMemberType;

  /// 닉네임 미설정 시 기본 이름
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get settingsAccountDefaultName;

  /// 회원 유형 표시 (역할 포함)
  ///
  /// In ko, this message translates to:
  /// **'{role} 회원'**
  String settingsAccountMemberLabel(String role);

  /// 언어 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get settingsLanguageSection;

  /// 언어 변경 즉시 적용 안내
  ///
  /// In ko, this message translates to:
  /// **'변경 즉시 적용됩니다.'**
  String get settingsLanguageApplyNow;

  /// 설정 저장 완료 피드백 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장됐어요'**
  String get settingsSavedFeedback;

  /// 위시리스트 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품'**
  String get wishlistTitle;

  /// 위시리스트 페이지 부제목
  ///
  /// In ko, this message translates to:
  /// **'저장된 상품을 한눈에 보고 가격과 리뷰 신뢰도를 확인해보세요.'**
  String get wishlistSubtitle;

  /// 찜한 상품 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품 {count}개'**
  String wishlistCount(int count);

  /// 위시리스트 빈 상태 제목
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품이 없어요'**
  String get wishlistEmpty;

  /// 위시리스트 빈 상태 설명
  ///
  /// In ko, this message translates to:
  /// **'상품 카드의 하트를 눌러 찜 목록에 추가해보세요.'**
  String get wishlistEmptyDesc;

  /// 위시리스트 빈 상태 탐색 버튼
  ///
  /// In ko, this message translates to:
  /// **'상품 둘러보기'**
  String get wishlistBrowse;

  /// 필터 결과 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'선택한 필터에 해당하는 찜 상품이 없습니다.'**
  String get wishlistFilteredEmpty;

  /// 위시리스트 요약 카드 제목
  ///
  /// In ko, this message translates to:
  /// **'찜 리스트 요약'**
  String get wishlistSummaryTitle;

  /// 위시리스트 총 개수
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개'**
  String wishlistSummaryTotal(int count);

  /// 가격 하락 통계 레이블
  ///
  /// In ko, this message translates to:
  /// **'가격 하락'**
  String get wishlistSummaryPriceDrop;

  /// 신규 알림 통계 레이블
  ///
  /// In ko, this message translates to:
  /// **'신규 알림'**
  String get wishlistSummaryNewAlert;

  /// 총 리뷰 통계 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 리뷰'**
  String get wishlistSummaryTotalReview;

  /// 위시리스트 상품 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'상품 보기'**
  String get wishlistProductView;

  /// 상품 카드 가격 하락 뱃지
  ///
  /// In ko, this message translates to:
  /// **'가격 하락'**
  String get wishlistProductPriceDrop;

  /// 최근 저장 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'최근 저장 순'**
  String get wishlistSortRecent;

  /// 낮은 가격 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'낮은 가격 순'**
  String get wishlistSortPriceLow;

  /// 높은 가격 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'높은 가격 순'**
  String get wishlistSortPriceHigh;

  /// RTI 높은 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'RTI 높은 순'**
  String get wishlistSortRti;

  /// 리뷰 많은 순 정렬 옵션
  ///
  /// In ko, this message translates to:
  /// **'리뷰 많은 순'**
  String get wishlistSortReviewCount;

  /// 전체 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get wishlistFilterAll;

  /// 가격 하락 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'가격 하락'**
  String get wishlistFilterPriceDrop;

  /// RTI 점수 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수'**
  String get wishlistFilterRti;

  /// 최저 가격 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'최저 가격'**
  String get wishlistFilterLowestPrice;

  /// 카테고리 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get wishlistFilterCategory;

  /// 마이페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get myPageTitle;

  /// 마이페이지 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'마이페이지 정보를 불러오는 중입니다.'**
  String get myPageLoading;

  /// 위시리스트 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품을 불러오는 중입니다.'**
  String get myPageWishlistLoading;

  /// 위시리스트 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품이 없습니다.'**
  String get myPageWishlistEmpty;

  /// 관심 상품 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'관심 상품'**
  String get myPageInterestProducts;

  /// 닉네임 미설정 시 기본 이름
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get myPageDefaultName;

  /// 사이드 네비게이션 마이페이지
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get myPageSideNavMyPage;

  /// 사이드 네비게이션 주문/배송
  ///
  /// In ko, this message translates to:
  /// **'주문/배송'**
  String get myPageSideNavOrders;

  /// 사이드 네비게이션 저장한 상품
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품'**
  String get myPageSideNavWishlist;

  /// 사이드 네비게이션 최근 본 상품
  ///
  /// In ko, this message translates to:
  /// **'최근 본 상품'**
  String get myPageSideNavRecentlyViewed;

  /// 사이드 네비게이션 주의 상품
  ///
  /// In ko, this message translates to:
  /// **'주의 상품'**
  String get myPageSideNavRiskyProducts;

  /// 사이드 네비게이션 알림
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get myPageSideNavAlerts;

  /// 최근 활동 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 활동'**
  String get myPageRecentActivity;

  /// 최근 활동 빈 상태
  ///
  /// In ko, this message translates to:
  /// **'최근 활동이 없습니다.'**
  String get myPageRecentActivityEmpty;

  /// 리뷰 신뢰 요약 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰 요약'**
  String get myPageReviewTrustSummary;

  /// 관심 상품 평균 RTI 레이블
  ///
  /// In ko, this message translates to:
  /// **'관심 상품 평균 RTI'**
  String get myPageAvgRti;

  /// RTI 요약 저장 안내
  ///
  /// In ko, this message translates to:
  /// **'관심 상품을 저장하면 리뷰 신뢰도 요약이 표시됩니다.'**
  String get myPageRtiSaveHint;

  /// 주의 상품 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'현재 대시보드에 주의가 필요한 상품이 없습니다.'**
  String get myPageRiskyNone;

  /// 주의 상품 개수 안내
  ///
  /// In ko, this message translates to:
  /// **'주의 상품 {count}개를 확인해보세요.'**
  String myPageRiskyCount(int count);

  /// 계정 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'계정 정보'**
  String get myPageAccountInfo;

  /// 계정 정보 섹션 부제목
  ///
  /// In ko, this message translates to:
  /// **'개인 정보 및 기본 정보를 관리해요.'**
  String get myPageAccountInfoSubtitle;

  /// 닉네임 표시
  ///
  /// In ko, this message translates to:
  /// **'닉네임: {nickname}'**
  String myPageAccountNickname(String nickname);

  /// 이메일 표시
  ///
  /// In ko, this message translates to:
  /// **'이메일: {email}'**
  String myPageAccountEmail(String email);

  /// 회원 유형 표시
  ///
  /// In ko, this message translates to:
  /// **'회원 유형: {role}'**
  String myPageAccountMemberType(String role);

  /// 기본 회원 유형
  ///
  /// In ko, this message translates to:
  /// **'일반 회원'**
  String get myPageDefaultMemberRole;

  /// 로그인 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'로그인 정보'**
  String get myPageLoginInfo;

  /// 로그인 정보 섹션 부제목
  ///
  /// In ko, this message translates to:
  /// **'이메일, 로그인 수단을 관리해요.'**
  String get myPageLoginInfoSubtitle;

  /// 로그인 이메일 표시
  ///
  /// In ko, this message translates to:
  /// **'로그인 이메일: {email}'**
  String myPageLoginEmail(String email);

  /// 로그인 상태 표시
  ///
  /// In ko, this message translates to:
  /// **'인증 상태: 로그인됨'**
  String get myPageLoginStatus;

  /// 온보딩 완료 상태
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get myPageOnboardingComplete;

  /// 온보딩 미완료 상태
  ///
  /// In ko, this message translates to:
  /// **'미완료'**
  String get myPageOnboardingIncomplete;

  /// 온보딩 상태 표시
  ///
  /// In ko, this message translates to:
  /// **'온보딩: {status}'**
  String myPageOnboarding(String status);

  /// 비밀번호 변경 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get myPageChangePassword;

  /// 비밀번호 변경 부제목
  ///
  /// In ko, this message translates to:
  /// **'안전한 비밀번호로 관리하세요.'**
  String get myPageChangePasswordSubtitle;

  /// 알림 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get myPageNotificationSettings;

  /// 알림 설정 부제목
  ///
  /// In ko, this message translates to:
  /// **'이메일 및 푸시 알림을 설정해요.'**
  String get myPageNotificationSettingsSubtitle;

  /// 계정/보안 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'계정 / 보안'**
  String get myPageAccountSecurity;

  /// 모바일 하단 네비게이션 카테고리
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get navCategory;

  /// 모바일 하단 네비게이션 찜 (짧은 표현)
  ///
  /// In ko, this message translates to:
  /// **'찜'**
  String get navWishShort;

  /// 모바일 하단 네비게이션 마이페이지 (짧은 표현)
  ///
  /// In ko, this message translates to:
  /// **'마이'**
  String get navMyShort;

  /// 홈 검색바 힌트 텍스트
  ///
  /// In ko, this message translates to:
  /// **'찾고 있는 상품을 리뷰 기반으로 검색해보세요'**
  String get homeSearchHint;

  /// 검색 패널 연관 검색어 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'연관 검색어'**
  String get homeSearchSuggestionsTitle;

  /// 연관 검색어 로딩 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'연관 검색어를 불러오는 중입니다.'**
  String get homeSearchSuggestionsLoading;

  /// 연관 검색어 입력 유도 메시지
  ///
  /// In ko, this message translates to:
  /// **'두 글자 이상 입력하면 연관 검색어가 표시됩니다.'**
  String get homeSearchSuggestionsHint;

  /// 최근 검색 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 검색'**
  String get homeRecentSearchTitle;

  /// 최근 검색어 전체 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 삭제'**
  String get homeRecentSearchDeleteAll;

  /// 최근 검색어 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어가 없습니다.'**
  String get homeRecentSearchEmpty;

  /// 인기 검색 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'인기 검색'**
  String get homePopularSearchTitle;

  /// 검색 패널 추천 상품 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'추천 상품'**
  String get homeSearchProductsTitle;

  /// 트렌딩 키워드 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'지금 많이 찾는 키워드'**
  String get homeTrendingTitle;

  /// 트렌딩 키워드 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'표시할 키워드가 없습니다.'**
  String get homeKeywordsEmpty;

  /// 추천 상품 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'에디터가 고른 리뷰 기반 추천 상품'**
  String get homeRecommendedTitle;

  /// 전체보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get homeViewAll;

  /// 로그인 필요 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다.'**
  String get homeLoginRequired;

  /// 혜택 카드 제목
  ///
  /// In ko, this message translates to:
  /// **'첫 구매 고객을 위한 혜택'**
  String get homeBenefitTitle;

  /// 혜택 카드 부제목
  ///
  /// In ko, this message translates to:
  /// **'리뷰 기반 쇼핑을 시작하면 받을 수 있는 회원 혜택입니다.'**
  String get homeBenefitSubtitle;

  /// 혜택 받기 버튼
  ///
  /// In ko, this message translates to:
  /// **'혜택 받기'**
  String get homeBenefitButton;

  /// 리뷰 신뢰도 설명
  ///
  /// In ko, this message translates to:
  /// **'광고·조작 리뷰를 필터링하고 실사용 리뷰를 분석해 신뢰도를 제공합니다.'**
  String get homeTrustDescription;

  /// 자세히 보기 링크
  ///
  /// In ko, this message translates to:
  /// **'자세히 보기'**
  String get homeTrustViewMore;

  /// 신뢰도 기능 레이블 1
  ///
  /// In ko, this message translates to:
  /// **'실사용 리뷰 분석'**
  String get homeTrustLabel1;

  /// 신뢰도 기능 레이블 2
  ///
  /// In ko, this message translates to:
  /// **'광고/조작 필터링'**
  String get homeTrustLabel2;

  /// 신뢰도 기능 레이블 3
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 점수 제공'**
  String get homeTrustLabel3;

  /// 인기 카테고리 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'인기 카테고리'**
  String get homePopularCategoryTitle;

  /// 카테고리 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'표시할 카테고리가 없습니다.'**
  String get homeCategoryEmpty;

  /// 피드백 내역 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'내 피드백 내역'**
  String get feedbackHistoryTitle;

  /// 피드백 내역 페이지 부제목
  ///
  /// In ko, this message translates to:
  /// **'제출한 상품/리뷰 피드백 내역을 확인할 수 있습니다.'**
  String get feedbackHistorySubtitle;

  /// 피드백 내역 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'피드백 내역을 불러오는 중입니다.'**
  String get feedbackHistoryLoading;

  /// 피드백 내역 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'제출한 피드백이 없습니다.'**
  String get feedbackHistoryEmpty;

  /// 피드백 내역 없을 때 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'상품 상세 페이지에서 리뷰 피드백을 제출할 수 있습니다.'**
  String get feedbackHistoryEmptyDesc;

  /// 피드백 건수
  ///
  /// In ko, this message translates to:
  /// **'{count}건의 피드백'**
  String feedbackHistoryCount(int count);

  /// 피드백 카드 상품 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'상품 보기'**
  String get feedbackHistoryViewProduct;

  /// No description provided for @feedbackStatusSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'접수'**
  String get feedbackStatusSubmitted;

  /// 피드백 상태: 검토 중
  ///
  /// In ko, this message translates to:
  /// **'검토 중'**
  String get feedbackStatusPending;

  /// 피드백 상태: 처리됨
  ///
  /// In ko, this message translates to:
  /// **'처리됨'**
  String get feedbackStatusAccepted;

  /// 피드백 상태: 반려됨
  ///
  /// In ko, this message translates to:
  /// **'반려됨'**
  String get feedbackStatusRejected;

  /// 관리자 사이드바 타이틀
  ///
  /// In ko, this message translates to:
  /// **'관리자'**
  String get adminSidebarTitle;

  /// 관리자 메뉴 — 대시보드
  ///
  /// In ko, this message translates to:
  /// **'대시보드'**
  String get adminMenuDashboard;

  /// 관리자 메뉴 — 의심 리뷰 관리
  ///
  /// In ko, this message translates to:
  /// **'의심 리뷰 관리'**
  String get adminMenuSuspiciousReviews;

  /// 관리자 메뉴 — 신고 관리
  ///
  /// In ko, this message translates to:
  /// **'신고 관리'**
  String get adminMenuReports;

  /// 관리자 메뉴 — 분석 피드백 관리
  ///
  /// In ko, this message translates to:
  /// **'분석 피드백 관리'**
  String get adminMenuAnalysisFeedbacks;

  /// 관리자 메뉴 — 사용자 관리
  ///
  /// In ko, this message translates to:
  /// **'사용자 관리'**
  String get adminMenuUsers;

  /// 관리자 사이드바 로그아웃 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get adminMenuLogout;

  /// 관리자 대시보드 페이지 타이틀
  ///
  /// In ko, this message translates to:
  /// **'운영 대시보드'**
  String get adminDashboardTitle;

  /// 관리자 상단 알림 벨 툴팁
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get adminTopBarNotifications;

  /// 우측 하단 챗봇 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'AI 어시스턴트 열기'**
  String get chatLauncherTooltip;

  /// 챗봇 패널 제목
  ///
  /// In ko, this message translates to:
  /// **'Re:view AI'**
  String get chatTitle;

  /// 챗봇 패널 부제
  ///
  /// In ko, this message translates to:
  /// **'리뷰와 구매 판단을 도와드려요'**
  String get chatSubtitle;

  /// 새 대화 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'새 대화'**
  String get chatNewConversation;

  /// 질문 입력창 힌트
  ///
  /// In ko, this message translates to:
  /// **'질문을 입력하세요'**
  String get chatInputHint;

  /// 전송 버튼
  ///
  /// In ko, this message translates to:
  /// **'보내기'**
  String get chatSend;

  /// 현재 화면 상품과 대화 상품이 다를 때 안내
  ///
  /// In ko, this message translates to:
  /// **'현재 화면과 다른 대화 문맥을 유지하고 있어요.'**
  String get chatOtherProductNotice;

  /// 현재 상품으로 새 대화 시작
  ///
  /// In ko, this message translates to:
  /// **'이 상품으로 새 대화'**
  String get chatStartWithThisProduct;

  /// 대화가 없을 때 제목
  ///
  /// In ko, this message translates to:
  /// **'리뷰에서 궁금한 점을 물어보세요'**
  String get chatEmptyTitle;

  /// 대화가 없을 때 설명
  ///
  /// In ko, this message translates to:
  /// **'추천 질문은 입력창에만 채워져요. 내용을 확인한 뒤 전송해주세요.'**
  String get chatEmptyBody;

  /// 상품 대화 추천 질문 1
  ///
  /// In ko, this message translates to:
  /// **'이 상품 리뷰 믿을 만해?'**
  String get chatSuggestProduct1;

  /// 상품 대화 추천 질문 2
  ///
  /// In ko, this message translates to:
  /// **'광고성 리뷰가 많아?'**
  String get chatSuggestProduct2;

  /// No description provided for @chatSuggestProduct4.
  ///
  /// In ko, this message translates to:
  /// **'비슷한 상품 추천해줘'**
  String get chatSuggestProduct4;

  /// 상품 대화 추천 질문 3
  ///
  /// In ko, this message translates to:
  /// **'실사용자들이 말하는 단점은?'**
  String get chatSuggestProduct3;

  /// 일반 대화 추천 질문 1
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수는 어떻게 매겨져?'**
  String get chatSuggestGeneral1;

  /// 일반 대화 추천 질문 2
  ///
  /// In ko, this message translates to:
  /// **'광고성 리뷰는 어떻게 구별해?'**
  String get chatSuggestGeneral2;

  /// 응답 대기 중 표시
  ///
  /// In ko, this message translates to:
  /// **'답변을 준비하고 있어요'**
  String get chatThinking;

  /// 비로그인 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'로그인하고 AI에게 물어보세요'**
  String get chatLoginTitle;

  /// 비로그인 안내 설명
  ///
  /// In ko, this message translates to:
  /// **'대화 내용은 내 계정에 저장돼요.'**
  String get chatLoginBody;

  /// 비로그인 안내 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get chatLoginButton;

  /// 503 오류
  ///
  /// In ko, this message translates to:
  /// **'챗봇이 잠시 응답할 수 없어요. 잠시 후 다시 시도해 주세요.'**
  String get chatErrorUnavailable;

  /// 응답 시간 초과
  ///
  /// In ko, this message translates to:
  /// **'답변이 너무 오래 걸리고 있어요. 다시 시도해 주세요.'**
  String get chatErrorTimeout;

  /// 네트워크 오류
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인해 주세요.'**
  String get chatErrorNetwork;

  /// 기타 오류
  ///
  /// In ko, this message translates to:
  /// **'답변을 받지 못했어요.'**
  String get chatErrorUnknown;

  /// 다시 시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get chatRetry;

  /// 입력창 아래 안내
  ///
  /// In ko, this message translates to:
  /// **'AI 답변은 참고용이며 틀릴 수 있어요.'**
  String get chatDisclaimer;

  /// No description provided for @settingsReviewDisplay.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 표시'**
  String get settingsReviewDisplay;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보'**
  String get settingsPrivacy;

  /// No description provided for @settingsRtiThreshold.
  ///
  /// In ko, this message translates to:
  /// **'최소 RTI 기준'**
  String get settingsRtiThreshold;

  /// No description provided for @settingsRtiThresholdDesc.
  ///
  /// In ko, this message translates to:
  /// **'이 기준 미만의 리뷰를 걸러내는 기준입니다.'**
  String get settingsRtiThresholdDesc;

  /// No description provided for @settingsReviewSort.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 기본 정렬'**
  String get settingsReviewSort;

  /// No description provided for @settingsSortVerifiedRecent.
  ///
  /// In ko, this message translates to:
  /// **'구매확인 최신순'**
  String get settingsSortVerifiedRecent;

  /// No description provided for @settingsSortRecent.
  ///
  /// In ko, this message translates to:
  /// **'최신순'**
  String get settingsSortRecent;

  /// No description provided for @settingsSortHelpful.
  ///
  /// In ko, this message translates to:
  /// **'도움순'**
  String get settingsSortHelpful;

  /// No description provided for @settingsRtiLabel.
  ///
  /// In ko, this message translates to:
  /// **'RTI 라벨 표시'**
  String get settingsRtiLabel;

  /// No description provided for @settingsLabelSmall.
  ///
  /// In ko, this message translates to:
  /// **'작은 배지'**
  String get settingsLabelSmall;

  /// No description provided for @settingsLabelLarge.
  ///
  /// In ko, this message translates to:
  /// **'큰 배지'**
  String get settingsLabelLarge;

  /// No description provided for @settingsLabelNone.
  ///
  /// In ko, this message translates to:
  /// **'표시 안 함'**
  String get settingsLabelNone;

  /// No description provided for @settingsCardDensity.
  ///
  /// In ko, this message translates to:
  /// **'상품 카드 밀도'**
  String get settingsCardDensity;

  /// No description provided for @settingsDensityComfortable.
  ///
  /// In ko, this message translates to:
  /// **'여유롭게'**
  String get settingsDensityComfortable;

  /// No description provided for @settingsDensityCompact.
  ///
  /// In ko, this message translates to:
  /// **'촘촘하게'**
  String get settingsDensityCompact;

  /// No description provided for @settingsLoading.
  ///
  /// In ko, this message translates to:
  /// **'설정을 불러오는 중입니다.'**
  String get settingsLoading;

  /// No description provided for @settingsLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'설정을 불러오지 못했습니다.'**
  String get settingsLoadFailed;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In ko, this message translates to:
  /// **'설정을 저장하지 못했습니다.'**
  String get settingsSaveFailed;

  /// No description provided for @settingsRiskyProduct.
  ///
  /// In ko, this message translates to:
  /// **'위험 상품 알림'**
  String get settingsRiskyProduct;

  /// No description provided for @settingsRiskyProductDesc.
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품의 위험 비율이 높아지면 알림을 받습니다.'**
  String get settingsRiskyProductDesc;

  /// No description provided for @settingsAnalysisComplete.
  ///
  /// In ko, this message translates to:
  /// **'분석 완료 알림'**
  String get settingsAnalysisComplete;

  /// No description provided for @settingsAnalysisCompleteDesc.
  ///
  /// In ko, this message translates to:
  /// **'새 상품의 분석이 완료되면 알림을 받습니다.'**
  String get settingsAnalysisCompleteDesc;

  /// No description provided for @settingsFeedbackResult.
  ///
  /// In ko, this message translates to:
  /// **'피드백 결과 알림'**
  String get settingsFeedbackResult;

  /// No description provided for @settingsFeedbackResultDesc.
  ///
  /// In ko, this message translates to:
  /// **'제출한 신고와 피드백의 처리 결과를 받습니다.'**
  String get settingsFeedbackResultDesc;

  /// No description provided for @settingsMarketing.
  ///
  /// In ko, this message translates to:
  /// **'마케팅 알림'**
  String get settingsMarketing;

  /// No description provided for @settingsMarketingDesc.
  ///
  /// In ko, this message translates to:
  /// **'추천 상품과 마케팅 알림을 받습니다.'**
  String get settingsMarketingDesc;

  /// No description provided for @settingsHideRisky.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰 숨김'**
  String get settingsHideRisky;

  /// No description provided for @settingsHideRiskyDesc.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰를 기본적으로 접어서 표시합니다.'**
  String get settingsHideRiskyDesc;

  /// No description provided for @settingsSuspiciousLabel.
  ///
  /// In ko, this message translates to:
  /// **'의심 리뷰 라벨 표시'**
  String get settingsSuspiciousLabel;

  /// No description provided for @settingsSuspiciousLabelDesc.
  ///
  /// In ko, this message translates to:
  /// **'의심스러운 리뷰에 구분 라벨을 표시합니다.'**
  String get settingsSuspiciousLabelDesc;

  /// No description provided for @settingsVerifiedFirst.
  ///
  /// In ko, this message translates to:
  /// **'구매확인 리뷰 우선'**
  String get settingsVerifiedFirst;

  /// No description provided for @settingsVerifiedFirstDesc.
  ///
  /// In ko, this message translates to:
  /// **'구매가 확인된 리뷰를 먼저 표시합니다.'**
  String get settingsVerifiedFirstDesc;

  /// No description provided for @settingsAutoAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'분석 팝업 자동 열기'**
  String get settingsAutoAnalysis;

  /// No description provided for @settingsAutoAnalysisDesc.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰를 클릭하면 분석 상세를 자동으로 엽니다.'**
  String get settingsAutoAnalysisDesc;

  /// No description provided for @settingsDataAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석 데이터 활용 동의'**
  String get settingsDataAnalysis;

  /// No description provided for @settingsDataAnalysisDesc.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석을 위한 데이터 활용에 동의합니다.'**
  String get settingsDataAnalysisDesc;

  /// 알림 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationsTitle;

  /// 모두 읽음 처리 버튼
  ///
  /// In ko, this message translates to:
  /// **'모두 읽음'**
  String get notificationsMarkAllRead;

  /// 알림 로딩 문구
  ///
  /// In ko, this message translates to:
  /// **'알림을 불러오는 중이에요'**
  String get notificationsLoading;

  /// 알림이 없을 때 제목
  ///
  /// In ko, this message translates to:
  /// **'새 알림이 없어요'**
  String get notificationsEmpty;

  /// 알림이 없을 때 설명
  ///
  /// In ko, this message translates to:
  /// **'신고·피드백 처리 결과와 분석 완료 소식을 여기서 알려드려요.'**
  String get notificationsEmptyBody;

  /// 헤더 알림 버튼 라벨
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get headerNotifications;

  /// No description provided for @chatPreviousConversations.
  ///
  /// In ko, this message translates to:
  /// **'이전 대화'**
  String get chatPreviousConversations;

  /// No description provided for @chatBackToConversation.
  ///
  /// In ko, this message translates to:
  /// **'대화로 돌아가기'**
  String get chatBackToConversation;

  /// No description provided for @chatHistoryLoading.
  ///
  /// In ko, this message translates to:
  /// **'이전 대화를 불러오는 중입니다.'**
  String get chatHistoryLoading;

  /// No description provided for @chatHistoryEmpty.
  ///
  /// In ko, this message translates to:
  /// **'이전 대화가 없습니다.'**
  String get chatHistoryEmpty;

  /// No description provided for @chatHistoryLoadError.
  ///
  /// In ko, this message translates to:
  /// **'이전 대화를 불러오지 못했습니다. 다시 시도해 주세요.'**
  String get chatHistoryLoadError;

  /// No description provided for @chatHistoryLoadMore.
  ///
  /// In ko, this message translates to:
  /// **'더 불러오기'**
  String get chatHistoryLoadMore;

  /// No description provided for @chatHistoryUntitled.
  ///
  /// In ko, this message translates to:
  /// **'제목 없는 대화'**
  String get chatHistoryUntitled;

  /// No description provided for @adminUsersSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'가입한 사용자를 최신 가입순으로 확인하세요.'**
  String get adminUsersSubtitle;

  /// No description provided for @adminRefresh.
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get adminRefresh;

  /// No description provided for @adminTotalUsers.
  ///
  /// In ko, this message translates to:
  /// **'전체 사용자'**
  String get adminTotalUsers;

  /// No description provided for @adminRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get adminRetry;

  /// No description provided for @adminEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get adminEmail;

  /// No description provided for @adminNickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get adminNickname;

  /// No description provided for @adminRole.
  ///
  /// In ko, this message translates to:
  /// **'권한'**
  String get adminRole;

  /// No description provided for @adminSignupProvider.
  ///
  /// In ko, this message translates to:
  /// **'가입 경로'**
  String get adminSignupProvider;

  /// No description provided for @adminAtiScore.
  ///
  /// In ko, this message translates to:
  /// **'ATI 점수'**
  String get adminAtiScore;

  /// No description provided for @adminJoinedAt.
  ///
  /// In ko, this message translates to:
  /// **'가입일'**
  String get adminJoinedAt;

  /// No description provided for @adminUserRole.
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get adminUserRole;

  /// No description provided for @adminUsersEmpty.
  ///
  /// In ko, this message translates to:
  /// **'가입한 사용자가 없습니다.'**
  String get adminUsersEmpty;

  /// No description provided for @adminNaver.
  ///
  /// In ko, this message translates to:
  /// **'네이버'**
  String get adminNaver;

  /// No description provided for @adminReportPending.
  ///
  /// In ko, this message translates to:
  /// **'검토 대기'**
  String get adminReportPending;

  /// No description provided for @adminUnderReview.
  ///
  /// In ko, this message translates to:
  /// **'검토 중'**
  String get adminUnderReview;

  /// No description provided for @adminReportAccepted.
  ///
  /// In ko, this message translates to:
  /// **'접수 (인정)'**
  String get adminReportAccepted;

  /// No description provided for @adminReportRejected.
  ///
  /// In ko, this message translates to:
  /// **'기각 (미인정)'**
  String get adminReportRejected;

  /// No description provided for @adminDanger.
  ///
  /// In ko, this message translates to:
  /// **'위험'**
  String get adminDanger;

  /// No description provided for @adminWarning.
  ///
  /// In ko, this message translates to:
  /// **'경고'**
  String get adminWarning;

  /// No description provided for @adminSafe.
  ///
  /// In ko, this message translates to:
  /// **'안전'**
  String get adminSafe;

  /// No description provided for @adminFeedbackSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'접수'**
  String get adminFeedbackSubmitted;

  /// No description provided for @adminFeedbackResolved.
  ///
  /// In ko, this message translates to:
  /// **'처리 완료'**
  String get adminFeedbackResolved;

  /// No description provided for @adminFeedbackRejected.
  ///
  /// In ko, this message translates to:
  /// **'반려'**
  String get adminFeedbackRejected;

  /// No description provided for @adminJudgmentTrustworthy.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도가 더 높아요'**
  String get adminJudgmentTrustworthy;

  /// No description provided for @adminJudgmentRisky.
  ///
  /// In ko, this message translates to:
  /// **'위험도가 더 높아요'**
  String get adminJudgmentRisky;

  /// No description provided for @adminJudgmentUndecided.
  ///
  /// In ko, this message translates to:
  /// **'판단 보류'**
  String get adminJudgmentUndecided;

  /// No description provided for @adminReviewDetails.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 상세 정보'**
  String get adminReviewDetails;

  /// No description provided for @adminViewProduct.
  ///
  /// In ko, this message translates to:
  /// **'상품 페이지 보기'**
  String get adminViewProduct;

  /// No description provided for @adminRtiAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'RTI 분석 결과'**
  String get adminRtiAnalysis;

  /// No description provided for @adminScoreUnit.
  ///
  /// In ko, this message translates to:
  /// **'점'**
  String get adminScoreUnit;

  /// No description provided for @adminReviewContent.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 내용'**
  String get adminReviewContent;

  /// No description provided for @adminDetectedSignals.
  ///
  /// In ko, this message translates to:
  /// **'탐지 신호 ({count})'**
  String adminDetectedSignals(int count);

  /// No description provided for @adminVerifiedPurchase.
  ///
  /// In ko, this message translates to:
  /// **'구매 인증'**
  String get adminVerifiedPurchase;

  /// No description provided for @adminVerified.
  ///
  /// In ko, this message translates to:
  /// **'인증됨'**
  String get adminVerified;

  /// No description provided for @adminNotVerified.
  ///
  /// In ko, this message translates to:
  /// **'인증 안됨'**
  String get adminNotVerified;

  /// No description provided for @adminReviewerInfo.
  ///
  /// In ko, this message translates to:
  /// **'작성자 정보'**
  String get adminReviewerInfo;

  /// No description provided for @adminReviewer.
  ///
  /// In ko, this message translates to:
  /// **'작성자'**
  String get adminReviewer;

  /// No description provided for @adminRating.
  ///
  /// In ko, this message translates to:
  /// **'별점'**
  String get adminRating;

  /// No description provided for @adminWrittenAt.
  ///
  /// In ko, this message translates to:
  /// **'작성일'**
  String get adminWrittenAt;

  /// No description provided for @adminSelectedCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 선택됨'**
  String adminSelectedCount(int count);

  /// No description provided for @adminSaved.
  ///
  /// In ko, this message translates to:
  /// **'변경 사항이 저장되었습니다.'**
  String get adminSaved;

  /// No description provided for @adminSaveFailed.
  ///
  /// In ko, this message translates to:
  /// **'저장에 실패했습니다.'**
  String get adminSaveFailed;

  /// No description provided for @adminFeedbackDetails.
  ///
  /// In ko, this message translates to:
  /// **'피드백 상세 정보'**
  String get adminFeedbackDetails;

  /// No description provided for @adminSaveChanges.
  ///
  /// In ko, this message translates to:
  /// **'변경 사항 저장'**
  String get adminSaveChanges;

  /// No description provided for @adminFeedbackId.
  ///
  /// In ko, this message translates to:
  /// **'피드백 ID'**
  String get adminFeedbackId;

  /// No description provided for @adminReviewId.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 ID'**
  String get adminReviewId;

  /// No description provided for @adminProductName.
  ///
  /// In ko, this message translates to:
  /// **'상품명'**
  String get adminProductName;

  /// No description provided for @adminCreatedAt.
  ///
  /// In ko, this message translates to:
  /// **'등록일'**
  String get adminCreatedAt;

  /// No description provided for @adminUpdatedAt.
  ///
  /// In ko, this message translates to:
  /// **'수정일'**
  String get adminUpdatedAt;

  /// No description provided for @adminFeedbackType.
  ///
  /// In ko, this message translates to:
  /// **'피드백 유형'**
  String get adminFeedbackType;

  /// No description provided for @adminUserJudgment.
  ///
  /// In ko, this message translates to:
  /// **'사용자 판단'**
  String get adminUserJudgment;

  /// No description provided for @adminRelatedSignals.
  ///
  /// In ko, this message translates to:
  /// **'관련 신호 ({count})'**
  String adminRelatedSignals(int count);

  /// No description provided for @adminFeedbackContent.
  ///
  /// In ko, this message translates to:
  /// **'피드백 내용'**
  String get adminFeedbackContent;

  /// No description provided for @adminAttachmentLink.
  ///
  /// In ko, this message translates to:
  /// **'첨부 파일 / 링크'**
  String get adminAttachmentLink;

  /// No description provided for @adminReplyEmail.
  ///
  /// In ko, this message translates to:
  /// **'회신 이메일'**
  String get adminReplyEmail;

  /// No description provided for @adminComment.
  ///
  /// In ko, this message translates to:
  /// **'관리자 메모'**
  String get adminComment;

  /// No description provided for @adminCommentHint.
  ///
  /// In ko, this message translates to:
  /// **'검토 내용이나 조치 사항을 입력하세요...'**
  String get adminCommentHint;

  /// No description provided for @adminChangeStatus.
  ///
  /// In ko, this message translates to:
  /// **'상태 변경'**
  String get adminChangeStatus;

  /// No description provided for @adminReportDetails.
  ///
  /// In ko, this message translates to:
  /// **'신고 상세 정보'**
  String get adminReportDetails;

  /// No description provided for @adminSave.
  ///
  /// In ko, this message translates to:
  /// **'저장하기'**
  String get adminSave;

  /// No description provided for @adminReportInfo.
  ///
  /// In ko, this message translates to:
  /// **'신고 정보'**
  String get adminReportInfo;

  /// No description provided for @adminReportId.
  ///
  /// In ko, this message translates to:
  /// **'신고 ID'**
  String get adminReportId;

  /// No description provided for @adminReportReason.
  ///
  /// In ko, this message translates to:
  /// **'신고 사유'**
  String get adminReportReason;

  /// No description provided for @adminReportedAt.
  ///
  /// In ko, this message translates to:
  /// **'신고 시간'**
  String get adminReportedAt;

  /// No description provided for @adminUpdatedTime.
  ///
  /// In ko, this message translates to:
  /// **'수정 시간'**
  String get adminUpdatedTime;

  /// No description provided for @adminReportedReview.
  ///
  /// In ko, this message translates to:
  /// **'신고 대상 리뷰'**
  String get adminReportedReview;

  /// No description provided for @adminReportContent.
  ///
  /// In ko, this message translates to:
  /// **'신고 내용'**
  String get adminReportContent;

  /// No description provided for @adminAttachment.
  ///
  /// In ko, this message translates to:
  /// **'첨부 파일'**
  String get adminAttachment;

  /// No description provided for @adminEvidenceIncluded.
  ///
  /// In ko, this message translates to:
  /// **'AI 증거 포함'**
  String get adminEvidenceIncluded;

  /// No description provided for @adminIncluded.
  ///
  /// In ko, this message translates to:
  /// **'포함'**
  String get adminIncluded;

  /// No description provided for @adminNotIncluded.
  ///
  /// In ko, this message translates to:
  /// **'미포함'**
  String get adminNotIncluded;

  /// No description provided for @adminOptionalCommentHint.
  ///
  /// In ko, this message translates to:
  /// **'메모를 입력하세요. (선택사항)'**
  String get adminOptionalCommentHint;

  /// No description provided for @adminSuspiciousReviewsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'RTI 분석을 통해 탐지된 의심 리뷰를 검토하고 적절한 조치를 취하세요.'**
  String get adminSuspiciousReviewsSubtitle;

  /// No description provided for @adminRtiUpperBound.
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수 상한'**
  String get adminRtiUpperBound;

  /// No description provided for @adminScoreBelow.
  ///
  /// In ko, this message translates to:
  /// **'{score}점 미만'**
  String adminScoreBelow(int score);

  /// No description provided for @adminAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get adminAll;

  /// No description provided for @adminTotalSuspiciousReviews.
  ///
  /// In ko, this message translates to:
  /// **'전체 의심 리뷰'**
  String get adminTotalSuspiciousReviews;

  /// No description provided for @adminCurrentFilter.
  ///
  /// In ko, this message translates to:
  /// **'현재 조회 기준'**
  String get adminCurrentFilter;

  /// No description provided for @adminRtiScore.
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수'**
  String get adminRtiScore;

  /// No description provided for @adminTrustGrade.
  ///
  /// In ko, this message translates to:
  /// **'신뢰 등급'**
  String get adminTrustGrade;

  /// No description provided for @adminSuspiciousReviewsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'표시할 의심 리뷰가 없습니다.'**
  String get adminSuspiciousReviewsEmpty;

  /// No description provided for @adminFeedbacksSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'사용자가 RTI 분석 결과에 대해 제공한 피드백을 검토하고 처리하세요.'**
  String get adminFeedbacksSubtitle;

  /// No description provided for @adminTotalFeedbacks.
  ///
  /// In ko, this message translates to:
  /// **'전체 피드백'**
  String get adminTotalFeedbacks;

  /// No description provided for @adminAllTime.
  ///
  /// In ko, this message translates to:
  /// **'전체 기간 기준'**
  String get adminAllTime;

  /// No description provided for @adminStatus.
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get adminStatus;

  /// No description provided for @adminFeedbacksEmpty.
  ///
  /// In ko, this message translates to:
  /// **'표시할 분석 피드백이 없습니다.'**
  String get adminFeedbacksEmpty;

  /// No description provided for @adminReportsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'사용자 신고를 검토하고 처리 상태를 변경하세요.'**
  String get adminReportsSubtitle;

  /// No description provided for @adminTotalReports.
  ///
  /// In ko, this message translates to:
  /// **'전체 신고'**
  String get adminTotalReports;

  /// No description provided for @adminReportsCountHelper.
  ///
  /// In ko, this message translates to:
  /// **'전체 신고 건수'**
  String get adminReportsCountHelper;

  /// No description provided for @adminPendingReportsHelper.
  ///
  /// In ko, this message translates to:
  /// **'검토가 필요한 신고'**
  String get adminPendingReportsHelper;

  /// No description provided for @adminUnderReviewReportsHelper.
  ///
  /// In ko, this message translates to:
  /// **'현재 검토 중인 신고'**
  String get adminUnderReviewReportsHelper;

  /// No description provided for @adminAcceptedReportsHelper.
  ///
  /// In ko, this message translates to:
  /// **'신고가 접수된 건'**
  String get adminAcceptedReportsHelper;

  /// No description provided for @adminRejectedReportsHelper.
  ///
  /// In ko, this message translates to:
  /// **'신고가 기각된 건'**
  String get adminRejectedReportsHelper;

  /// No description provided for @adminBulkSuccess.
  ///
  /// In ko, this message translates to:
  /// **'{total}건을 처리했습니다.'**
  String adminBulkSuccess(int total);

  /// No description provided for @adminBulkFailure.
  ///
  /// In ko, this message translates to:
  /// **'{total}건 중 {failed}건 처리에 실패했습니다. 실패한 항목은 선택된 상태로 남겨 두었습니다.'**
  String adminBulkFailure(int total, int failed);

  /// No description provided for @adminAcceptReports.
  ///
  /// In ko, this message translates to:
  /// **'접수 처리'**
  String get adminAcceptReports;

  /// No description provided for @adminRejectReports.
  ///
  /// In ko, this message translates to:
  /// **'기각 처리'**
  String get adminRejectReports;

  /// No description provided for @adminEvidence.
  ///
  /// In ko, this message translates to:
  /// **'AI 증거'**
  String get adminEvidence;

  /// No description provided for @adminReportsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'표시할 신고가 없습니다.'**
  String get adminReportsEmpty;

  /// No description provided for @adminDashboardSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석 현황과 처리 대기 업무를 한눈에 확인하세요.'**
  String get adminDashboardSubtitle;

  /// No description provided for @adminModelPerformance.
  ///
  /// In ko, this message translates to:
  /// **'AI 모델 성능'**
  String get adminModelPerformance;

  /// No description provided for @adminPeriodDays.
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String adminPeriodDays(int days);

  /// No description provided for @adminTotalReviews.
  ///
  /// In ko, this message translates to:
  /// **'전체 리뷰'**
  String get adminTotalReviews;

  /// No description provided for @adminTotalReviewsHelper.
  ///
  /// In ko, this message translates to:
  /// **'분석 대상 리뷰 전체'**
  String get adminTotalReviewsHelper;

  /// No description provided for @adminSuspiciousReviews.
  ///
  /// In ko, this message translates to:
  /// **'의심 리뷰'**
  String get adminSuspiciousReviews;

  /// No description provided for @adminRiskyReviews.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰'**
  String get adminRiskyReviews;

  /// No description provided for @adminPendingReports.
  ///
  /// In ko, this message translates to:
  /// **'처리 대기 신고'**
  String get adminPendingReports;

  /// No description provided for @adminPendingFeedbacks.
  ///
  /// In ko, this message translates to:
  /// **'처리 대기 분석 피드백'**
  String get adminPendingFeedbacks;

  /// No description provided for @adminOpenSection.
  ///
  /// In ko, this message translates to:
  /// **'눌러서 바로가기'**
  String get adminOpenSection;

  /// No description provided for @adminCountPercent.
  ///
  /// In ko, this message translates to:
  /// **'{count}건 · {percent}%'**
  String adminCountPercent(String count, String percent);

  /// No description provided for @adminRtiDistribution.
  ///
  /// In ko, this message translates to:
  /// **'RTI 등급 분포'**
  String get adminRtiDistribution;

  /// No description provided for @adminAnalyzedCount.
  ///
  /// In ko, this message translates to:
  /// **'분석 리뷰 {count}건'**
  String adminAnalyzedCount(String count);

  /// No description provided for @adminSuspicious.
  ///
  /// In ko, this message translates to:
  /// **'의심'**
  String get adminSuspicious;

  /// No description provided for @adminAverageRti.
  ///
  /// In ko, this message translates to:
  /// **'전체 평균 RTI'**
  String get adminAverageRti;

  /// No description provided for @adminDailyTrendTitle.
  ///
  /// In ko, this message translates to:
  /// **'일별 평균 RTI · 분석 건수 (최근 {days}일)'**
  String adminDailyTrendTitle(int days);

  /// No description provided for @adminTrendEmpty.
  ///
  /// In ko, this message translates to:
  /// **'기간 내 분석된 리뷰가 없습니다.'**
  String get adminTrendEmpty;

  /// No description provided for @adminTrendTooltip.
  ///
  /// In ko, this message translates to:
  /// **'{date}\n평균 RTI {score} · {count}건'**
  String adminTrendTooltip(String date, String score, String count);

  /// No description provided for @adminUserAgreement.
  ///
  /// In ko, this message translates to:
  /// **'사용자 판정 동의율'**
  String get adminUserAgreement;

  /// No description provided for @adminFeedbackCount.
  ///
  /// In ko, this message translates to:
  /// **'피드백 {count}건'**
  String adminFeedbackCount(String count);

  /// No description provided for @adminAgree.
  ///
  /// In ko, this message translates to:
  /// **'동의'**
  String get adminAgree;

  /// No description provided for @adminDisagree.
  ///
  /// In ko, this message translates to:
  /// **'이의'**
  String get adminDisagree;

  /// No description provided for @adminFeedbackStats.
  ///
  /// In ko, this message translates to:
  /// **'분석 피드백 처리 현황'**
  String get adminFeedbackStats;

  /// No description provided for @adminResolutionRate.
  ///
  /// In ko, this message translates to:
  /// **'처리율 {percent}%'**
  String adminResolutionRate(String percent);

  /// No description provided for @adminApplied.
  ///
  /// In ko, this message translates to:
  /// **'반영'**
  String get adminApplied;

  /// No description provided for @adminDismissed.
  ///
  /// In ko, this message translates to:
  /// **'기각'**
  String get adminDismissed;

  /// 401로 로그아웃됐을 때 알림
  ///
  /// In ko, this message translates to:
  /// **'로그인이 만료됐어요. 다시 로그인해 주세요.'**
  String get sessionExpiredMessage;

  /// 로그인 만료 알림의 이동 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get sessionExpiredLogin;

  /// 계정 카드 로그인 방식 라벨
  ///
  /// In ko, this message translates to:
  /// **'로그인 방식'**
  String get settingsAccountLabelLoginMethod;

  /// 이메일 가입 로그인 방식
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get settingsLoginMethodEmail;

  /// 네이버 로그인 방식
  ///
  /// In ko, this message translates to:
  /// **'네이버'**
  String get settingsLoginMethodNaver;

  /// No description provided for @chatLauncherLabel.
  ///
  /// In ko, this message translates to:
  /// **'AI에게 물어보기'**
  String get chatLauncherLabel;

  /// No description provided for @chatProductCta.
  ///
  /// In ko, this message translates to:
  /// **'AI에게 이 상품 물어보기'**
  String get chatProductCta;

  /// No description provided for @chatEmptyProductTitle.
  ///
  /// In ko, this message translates to:
  /// **'이 상품, 무엇이 궁금하세요?'**
  String get chatEmptyProductTitle;

  /// No description provided for @chatCopy.
  ///
  /// In ko, this message translates to:
  /// **'복사'**
  String get chatCopy;

  /// No description provided for @chatCopied.
  ///
  /// In ko, this message translates to:
  /// **'복사했어요'**
  String get chatCopied;

  /// No description provided for @chatThinkingLong.
  ///
  /// In ko, this message translates to:
  /// **'답변을 만드는 데 시간이 조금 걸리고 있어요'**
  String get chatThinkingLong;

  /// No description provided for @chatThinkingVeryLong.
  ///
  /// In ko, this message translates to:
  /// **'아직 답변을 기다리고 있어요. 창을 닫아도 대화는 유지돼요'**
  String get chatThinkingVeryLong;

  /// No description provided for @chatBlockedTitle.
  ///
  /// In ko, this message translates to:
  /// **'답변할 수 없는 질문이에요'**
  String get chatBlockedTitle;

  /// No description provided for @chatModeStandard.
  ///
  /// In ko, this message translates to:
  /// **'기본'**
  String get chatModeStandard;

  /// No description provided for @chatModePro.
  ///
  /// In ko, this message translates to:
  /// **'프로'**
  String get chatModePro;

  /// No description provided for @chatModeProActive.
  ///
  /// In ko, this message translates to:
  /// **'프로 모드로 더 자세히 답해요'**
  String get chatModeProActive;

  /// No description provided for @chatModeProLocked.
  ///
  /// In ko, this message translates to:
  /// **'프로 모드는 프로 요금제에서 쓸 수 있어요'**
  String get chatModeProLocked;

  /// No description provided for @chatPlanFree.
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get chatPlanFree;

  /// No description provided for @chatPlanPlus.
  ///
  /// In ko, this message translates to:
  /// **'플러스'**
  String get chatPlanPlus;

  /// No description provided for @chatPlanPro.
  ///
  /// In ko, this message translates to:
  /// **'프로'**
  String get chatPlanPro;

  /// No description provided for @planTitle.
  ///
  /// In ko, this message translates to:
  /// **'요금제'**
  String get planTitle;

  /// No description provided for @planSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 어시스턴트를 얼마나 쓸지 고르세요.'**
  String get planSubtitle;

  /// No description provided for @planCurrent.
  ///
  /// In ko, this message translates to:
  /// **'현재 요금제'**
  String get planCurrent;

  /// No description provided for @planUsageToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 {used}/{limit}회 사용'**
  String planUsageToday(int used, int limit);

  /// No description provided for @planUsageUnlimited.
  ///
  /// In ko, this message translates to:
  /// **'오늘 {used}회 사용 · 횟수 제한 없음'**
  String planUsageUnlimited(int used);

  /// No description provided for @planResetAt.
  ///
  /// In ko, this message translates to:
  /// **'{time}에 초기화'**
  String planResetAt(String time);

  /// No description provided for @planExpiresAt.
  ///
  /// In ko, this message translates to:
  /// **'{date}까지 이용'**
  String planExpiresAt(String date);

  /// No description provided for @planDailyQuestions.
  ///
  /// In ko, this message translates to:
  /// **'하루 질문 {count}회'**
  String planDailyQuestions(int count);

  /// No description provided for @planDailyUnlimited.
  ///
  /// In ko, this message translates to:
  /// **'하루 질문 횟수 제한 없음'**
  String get planDailyUnlimited;

  /// No description provided for @planFeatureStandard.
  ///
  /// In ko, this message translates to:
  /// **'기본 답변'**
  String get planFeatureStandard;

  /// No description provided for @planFeatureLimited.
  ///
  /// In ko, this message translates to:
  /// **'하루 질문 수가 가장 적어요'**
  String get planFeatureLimited;

  /// No description provided for @planFeatureMore.
  ///
  /// In ko, this message translates to:
  /// **'무료보다 더 많은 하루 질문'**
  String get planFeatureMore;

  /// No description provided for @planFeatureMost.
  ///
  /// In ko, this message translates to:
  /// **'가장 많은 하루 질문'**
  String get planFeatureMost;

  /// No description provided for @planFeaturePro.
  ///
  /// In ko, this message translates to:
  /// **'프로 모드: 더 자세한 답변'**
  String get planFeaturePro;

  /// No description provided for @planSelect.
  ///
  /// In ko, this message translates to:
  /// **'이 요금제로 변경'**
  String get planSelect;

  /// No description provided for @planCurrentBadge.
  ///
  /// In ko, this message translates to:
  /// **'이용 중'**
  String get planCurrentBadge;

  /// No description provided for @planConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'{plan} 요금제로 변경할까요?'**
  String planConfirmTitle(String plan);

  /// No description provided for @planConfirmBody.
  ///
  /// In ko, this message translates to:
  /// **'지금은 결제 없이 바로 바뀌어요.'**
  String get planConfirmBody;

  /// No description provided for @planConfirmAction.
  ///
  /// In ko, this message translates to:
  /// **'변경'**
  String get planConfirmAction;

  /// No description provided for @planCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get planCancel;

  /// No description provided for @planChanged.
  ///
  /// In ko, this message translates to:
  /// **'{plan} 요금제로 바뀌었어요'**
  String planChanged(String plan);

  /// No description provided for @planChangeUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'요금제 변경은 아직 준비 중이에요.'**
  String get planChangeUnavailable;

  /// No description provided for @planChangeFailed.
  ///
  /// In ko, this message translates to:
  /// **'요금제를 바꾸지 못했어요. 다시 시도해 주세요.'**
  String get planChangeFailed;

  /// No description provided for @planLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'요금제 정보를 불러오지 못했어요.'**
  String get planLoadFailed;

  /// No description provided for @myPageSideNavPlan.
  ///
  /// In ko, this message translates to:
  /// **'요금제'**
  String get myPageSideNavPlan;

  /// No description provided for @chatViewPlans.
  ///
  /// In ko, this message translates to:
  /// **'요금제 보기'**
  String get chatViewPlans;

  /// No description provided for @extProductCollectingTitle.
  ///
  /// In ko, this message translates to:
  /// **'상품 정보를 가져오고 있어요'**
  String get extProductCollectingTitle;

  /// No description provided for @extProductCollectingBody.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑몰에서 상품과 리뷰 정보를 가져오고 있어요. 상품 정보가 준비되면 자동으로 표시돼요.'**
  String get extProductCollectingBody;

  /// No description provided for @extProductCollectingSlow.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑몰에서 상품 정보를 기다리고 있어요. 상품 정보가 준비되면 자동으로 표시돼요.'**
  String get extProductCollectingSlow;

  /// No description provided for @extProductUnavailableTitle.
  ///
  /// In ko, this message translates to:
  /// **'상품 정보를 가져오지 못했어요'**
  String get extProductUnavailableTitle;

  /// No description provided for @extProductUnavailableBody.
  ///
  /// In ko, this message translates to:
  /// **'상품이 없는 것이 아니라 지금 쇼핑몰에서 정보를 받지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get extProductUnavailableBody;

  /// No description provided for @extProductLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'상품을 불러오지 못했어요.'**
  String get extProductLoadFailed;

  /// No description provided for @extProductRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get extProductRetry;

  /// No description provided for @extProductStale.
  ///
  /// In ko, this message translates to:
  /// **'최신 정보로 갱신하고 있어요'**
  String get extProductStale;

  /// No description provided for @extProductVisitShop.
  ///
  /// In ko, this message translates to:
  /// **'{shop}에서 보기'**
  String extProductVisitShop(String shop);

  /// No description provided for @extProductReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 {count}개'**
  String extProductReviewCount(int count);

  /// No description provided for @extProductPrice.
  ///
  /// In ko, this message translates to:
  /// **'{price}원'**
  String extProductPrice(String price);

  /// No description provided for @extProductAnalysisPendingTitle.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 분석 전'**
  String get extProductAnalysisPendingTitle;

  /// No description provided for @extProductAnalysisPendingBody.
  ///
  /// In ko, this message translates to:
  /// **'이 상품의 리뷰는 아직 분석되지 않았어요. 신뢰도 점수는 제공되지 않아요.'**
  String get extProductAnalysisPendingBody;

  /// No description provided for @extProductReviewsTitle.
  ///
  /// In ko, this message translates to:
  /// **'리뷰'**
  String get extProductReviewsTitle;

  /// No description provided for @extProductReviewsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'수집된 리뷰가 없어요.'**
  String get extProductReviewsEmpty;

  /// No description provided for @extProductReviewsMore.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 더 보기'**
  String get extProductReviewsMore;

  /// No description provided for @extProductReviewsMoreFailed.
  ///
  /// In ko, this message translates to:
  /// **'리뷰를 더 불러오지 못했어요.'**
  String get extProductReviewsMoreFailed;

  /// No description provided for @extProductReviewOption.
  ///
  /// In ko, this message translates to:
  /// **'옵션: {option}'**
  String extProductReviewOption(String option);

  /// No description provided for @chatQuotaRemaining.
  ///
  /// In ko, this message translates to:
  /// **'오늘 남은 질문 {remaining}/{limit}'**
  String chatQuotaRemaining(int remaining, int limit);

  /// No description provided for @chatQuotaUnlimited.
  ///
  /// In ko, this message translates to:
  /// **'질문 횟수 제한 없음'**
  String get chatQuotaUnlimited;

  /// No description provided for @chatQuotaExceededTitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘 질문을 모두 사용했어요'**
  String get chatQuotaExceededTitle;

  /// No description provided for @chatQuotaExceededBody.
  ///
  /// In ko, this message translates to:
  /// **'{time}에 다시 물어볼 수 있어요'**
  String chatQuotaExceededBody(String time);

  /// No description provided for @chatQuotaExceededBodyNoTime.
  ///
  /// In ko, this message translates to:
  /// **'한도가 초기화되면 다시 물어볼 수 있어요'**
  String get chatQuotaExceededBodyNoTime;

  /// No description provided for @chatPlanRequiredTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로 요금제에서 이용할 수 있어요'**
  String get chatPlanRequiredTitle;

  /// No description provided for @chatPlanRequiredAction.
  ///
  /// In ko, this message translates to:
  /// **'기본 모드로 다시 묻기'**
  String get chatPlanRequiredAction;

  /// No description provided for @chatSuggestGeneral3.
  ///
  /// In ko, this message translates to:
  /// **'믿을 만한 리뷰는 어떻게 골라?'**
  String get chatSuggestGeneral3;

  /// No description provided for @adminUserPlanColumn.
  ///
  /// In ko, this message translates to:
  /// **'요금제'**
  String get adminUserPlanColumn;

  /// No description provided for @adminUserPlanChange.
  ///
  /// In ko, this message translates to:
  /// **'요금제 변경'**
  String get adminUserPlanChange;

  /// No description provided for @adminUserPlanTitle.
  ///
  /// In ko, this message translates to:
  /// **'요금제 변경'**
  String get adminUserPlanTitle;

  /// No description provided for @adminUserPlanExpiry.
  ///
  /// In ko, this message translates to:
  /// **'만료일'**
  String get adminUserPlanExpiry;

  /// No description provided for @adminUserPlanUnlimited.
  ///
  /// In ko, this message translates to:
  /// **'무기한'**
  String get adminUserPlanUnlimited;

  /// No description provided for @adminUserPlanThirtyDays.
  ///
  /// In ko, this message translates to:
  /// **'30일'**
  String get adminUserPlanThirtyDays;

  /// No description provided for @adminUserPlanCustomDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜 직접 선택'**
  String get adminUserPlanCustomDate;

  /// No description provided for @adminUserPlanSelectDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜 선택'**
  String get adminUserPlanSelectDate;

  /// No description provided for @adminUserPlanExpired.
  ///
  /// In ko, this message translates to:
  /// **'만료됨'**
  String get adminUserPlanExpired;

  /// No description provided for @adminUserPlanUnknown.
  ///
  /// In ko, this message translates to:
  /// **'확인되지 않음'**
  String get adminUserPlanUnknown;

  /// No description provided for @adminUserPlanSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get adminUserPlanSave;

  /// No description provided for @adminUserPlanCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get adminUserPlanCancel;

  /// No description provided for @adminUserPlanSaving.
  ///
  /// In ko, this message translates to:
  /// **'저장 중'**
  String get adminUserPlanSaving;

  /// No description provided for @adminUserPlanDateRequired.
  ///
  /// In ko, this message translates to:
  /// **'오늘 이후의 만료일을 선택해주세요.'**
  String get adminUserPlanDateRequired;

  /// No description provided for @externalWishAdd.
  ///
  /// In ko, this message translates to:
  /// **'찜하기'**
  String get externalWishAdd;

  /// No description provided for @externalWishRemove.
  ///
  /// In ko, this message translates to:
  /// **'찜 취소'**
  String get externalWishRemove;

  /// No description provided for @externalCartAdd.
  ///
  /// In ko, this message translates to:
  /// **'장바구니 담기'**
  String get externalCartAdd;

  /// No description provided for @externalCartAdded.
  ///
  /// In ko, this message translates to:
  /// **'장바구니에 담김'**
  String get externalCartAdded;

  /// No description provided for @externalReviewMenu.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 메뉴'**
  String get externalReviewMenu;

  /// No description provided for @externalReport.
  ///
  /// In ko, this message translates to:
  /// **'신고하기'**
  String get externalReport;

  /// No description provided for @externalReal.
  ///
  /// In ko, this message translates to:
  /// **'실제 리뷰 같아요'**
  String get externalReal;

  /// No description provided for @externalFake.
  ///
  /// In ko, this message translates to:
  /// **'주의가 필요한 리뷰 같아요'**
  String get externalFake;

  /// No description provided for @externalNotCollected.
  ///
  /// In ko, this message translates to:
  /// **'상품 수집이 끝난 뒤 다시 시도해주세요.'**
  String get externalNotCollected;

  /// No description provided for @externalUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'데이터 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.'**
  String get externalUnavailable;

  /// No description provided for @externalReportDuplicate.
  ///
  /// In ko, this message translates to:
  /// **'이미 신고한 리뷰입니다.'**
  String get externalReportDuplicate;

  /// No description provided for @externalFeedbackDuplicate.
  ///
  /// In ko, this message translates to:
  /// **'이미 피드백을 남긴 리뷰입니다.'**
  String get externalFeedbackDuplicate;

  /// No description provided for @externalFailed.
  ///
  /// In ko, this message translates to:
  /// **'요청을 처리하지 못했습니다. 다시 시도해주세요.'**
  String get externalFailed;

  /// No description provided for @externalSuccess.
  ///
  /// In ko, this message translates to:
  /// **'처리되었습니다.'**
  String get externalSuccess;

  /// No description provided for @externalUnanalyzed.
  ///
  /// In ko, this message translates to:
  /// **'분석 전'**
  String get externalUnanalyzed;

  /// No description provided for @externalReason.
  ///
  /// In ko, this message translates to:
  /// **'신고 사유'**
  String get externalReason;

  /// No description provided for @externalDetail.
  ///
  /// In ko, this message translates to:
  /// **'상세 내용'**
  String get externalDetail;

  /// No description provided for @externalDetailValidation.
  ///
  /// In ko, this message translates to:
  /// **'상세 내용을 20자 이상 500자 이내로 작성해주세요.'**
  String get externalDetailValidation;

  /// No description provided for @externalAttachment.
  ///
  /// In ko, this message translates to:
  /// **'첨부 URL (선택)'**
  String get externalAttachment;

  /// No description provided for @externalAttachmentValidation.
  ///
  /// In ko, this message translates to:
  /// **'올바른 http 또는 https URL을 입력해주세요.'**
  String get externalAttachmentValidation;

  /// No description provided for @externalEvidence.
  ///
  /// In ko, this message translates to:
  /// **'분석 근거 포함'**
  String get externalEvidence;

  /// No description provided for @externalCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get externalCancel;

  /// No description provided for @externalSubmit.
  ///
  /// In ko, this message translates to:
  /// **'제출'**
  String get externalSubmit;

  /// No description provided for @externalReasonFake.
  ///
  /// In ko, this message translates to:
  /// **'가짜 리뷰 의심'**
  String get externalReasonFake;

  /// No description provided for @externalReasonAi.
  ///
  /// In ko, this message translates to:
  /// **'자동 생성 의심'**
  String get externalReasonAi;

  /// No description provided for @externalReasonIrrelevant.
  ///
  /// In ko, this message translates to:
  /// **'상품과 무관한 내용'**
  String get externalReasonIrrelevant;

  /// No description provided for @externalReasonInappropriate.
  ///
  /// In ko, this message translates to:
  /// **'부적절한 표현 / 개인정보'**
  String get externalReasonInappropriate;

  /// No description provided for @externalReasonAd.
  ///
  /// In ko, this message translates to:
  /// **'광고성 리뷰'**
  String get externalReasonAd;

  /// No description provided for @externalReasonRepeated.
  ///
  /// In ko, this message translates to:
  /// **'반복 내용'**
  String get externalReasonRepeated;

  /// No description provided for @externalReasonOffensive.
  ///
  /// In ko, this message translates to:
  /// **'모욕적인 내용'**
  String get externalReasonOffensive;

  /// No description provided for @externalReasonOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get externalReasonOther;

  /// No description provided for @productImageEnlarge.
  ///
  /// In ko, this message translates to:
  /// **'상품 이미지 확대'**
  String get productImageEnlarge;

  /// No description provided for @productImagePrevious.
  ///
  /// In ko, this message translates to:
  /// **'이전 상품 이미지'**
  String get productImagePrevious;

  /// No description provided for @productImageNext.
  ///
  /// In ko, this message translates to:
  /// **'다음 상품 이미지'**
  String get productImageNext;

  /// No description provided for @imagePreviewOpen.
  ///
  /// In ko, this message translates to:
  /// **'사진 확대'**
  String get imagePreviewOpen;

  /// No description provided for @imagePreviewTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 미리보기'**
  String get imagePreviewTitle;

  /// No description provided for @imagePreviewPrevious.
  ///
  /// In ko, this message translates to:
  /// **'이전 사진'**
  String get imagePreviewPrevious;

  /// No description provided for @imagePreviewNext.
  ///
  /// In ko, this message translates to:
  /// **'다음 사진'**
  String get imagePreviewNext;

  /// No description provided for @chatFreshContext.
  ///
  /// In ko, this message translates to:
  /// **'새 대화 · 이전 기록은 유지돼요'**
  String get chatFreshContext;

  /// No description provided for @chatHistoryContext.
  ///
  /// In ko, this message translates to:
  /// **'기록에서 연 대화'**
  String get chatHistoryContext;

  /// No description provided for @chatActiveContext.
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 대화'**
  String get chatActiveContext;

  /// No description provided for @chatGeneralContext.
  ///
  /// In ko, this message translates to:
  /// **'일반 대화 · 상품 지정 없음'**
  String get chatGeneralContext;

  /// No description provided for @chatTargetProduct.
  ///
  /// In ko, this message translates to:
  /// **'질문 대상 상품'**
  String get chatTargetProduct;

  /// No description provided for @chatQuotaLoading.
  ///
  /// In ko, this message translates to:
  /// **'질문 한도를 확인하고 있어요.'**
  String get chatQuotaLoading;

  /// No description provided for @chatQuotaUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'한도를 다시 확인하지 못했어요. 마지막 확인 값은 유지돼요.'**
  String get chatQuotaUnavailable;

  /// No description provided for @chatQuotaRefresh.
  ///
  /// In ko, this message translates to:
  /// **'다시 확인'**
  String get chatQuotaRefresh;

  /// No description provided for @chatClosePreserve.
  ///
  /// In ko, this message translates to:
  /// **'닫기 (대화는 유지)'**
  String get chatClosePreserve;

  /// No description provided for @chatHistoryWait.
  ///
  /// In ko, this message translates to:
  /// **'대화 기록은 전송이 끝난 뒤 열 수 있어요.'**
  String get chatHistoryWait;

  /// No description provided for @extProductReviewPreferencesNote.
  ///
  /// In ko, this message translates to:
  /// **'정렬 설정은 불러온 리뷰에 적용돼요. 제공되지 않은 구매 인증·신뢰도 정보로 리뷰를 숨기거나 분류하지 않아요.'**
  String get extProductReviewPreferencesNote;

  /// No description provided for @extProductSummaryLoading.
  ///
  /// In ko, this message translates to:
  /// **'상품 기본 정보를 확인하고 있어요.'**
  String get extProductSummaryLoading;

  /// No description provided for @extProductListSummary.
  ///
  /// In ko, this message translates to:
  /// **'목록에서 받은 상품 정보예요. 최신 상세 정보와 리뷰를 확인하고 있어요.'**
  String get extProductListSummary;

  /// No description provided for @extProductPreviousSummary.
  ///
  /// In ko, this message translates to:
  /// **'이전에 확인한 상품 정보예요. 최신 상세 정보와 리뷰를 확인하고 있어요.'**
  String get extProductPreviousSummary;

  /// No description provided for @recentRecordFailed.
  ///
  /// In ko, this message translates to:
  /// **'최근 본 기록을 확인하지 못했어요. 다시 시도'**
  String get recentRecordFailed;

  /// No description provided for @recentRecordUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'최근 본 기록에 필요한 상품 식별 정보를 확인하지 못했어요.'**
  String get recentRecordUnavailable;

  /// No description provided for @reviewPhotoOnly.
  ///
  /// In ko, this message translates to:
  /// **'사진 있는 리뷰'**
  String get reviewPhotoOnly;

  /// No description provided for @reviewListView.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 목록'**
  String get reviewListView;

  /// No description provided for @reviewPhotosView.
  ///
  /// In ko, this message translates to:
  /// **'사진 모아보기'**
  String get reviewPhotosView;

  /// No description provided for @reviewPhotoScope.
  ///
  /// In ko, this message translates to:
  /// **'불러온 리뷰 {loaded}개 · 사진 있는 리뷰 {photos}개'**
  String reviewPhotoScope(int loaded, int photos);

  /// No description provided for @reviewPhotosEmpty.
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 리뷰에 유효한 사진이 없어요.'**
  String get reviewPhotosEmpty;

  /// No description provided for @externalForbidden.
  ///
  /// In ko, this message translates to:
  /// **'이 작업을 할 권한이 없어요.'**
  String get externalForbidden;

  /// No description provided for @externalAuthRequestFailed.
  ///
  /// In ko, this message translates to:
  /// **'이 요청의 인증을 확인하지 못했어요. 현재 로그인 상태를 확인한 뒤 다시 시도해주세요.'**
  String get externalAuthRequestFailed;

  /// No description provided for @externalNetworkFailure.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인하고 다시 시도해주세요.'**
  String get externalNetworkFailure;

  /// No description provided for @externalTimeout.
  ///
  /// In ko, this message translates to:
  /// **'요청 시간이 초과됐어요. 다시 시도해주세요.'**
  String get externalTimeout;

  /// No description provided for @reportTitle.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도 리포트'**
  String get reportTitle;

  /// No description provided for @reportDetails.
  ///
  /// In ko, this message translates to:
  /// **'상세 분석 보기'**
  String get reportDetails;

  /// No description provided for @reportClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get reportClose;

  /// No description provided for @reportBefore.
  ///
  /// In ko, this message translates to:
  /// **'분석 전'**
  String get reportBefore;

  /// No description provided for @reportCollecting.
  ///
  /// In ko, this message translates to:
  /// **'상품·리뷰 정보를 수집하고 있어요. 분석 진행 상태와는 별개예요.'**
  String get reportCollecting;

  /// No description provided for @reportRunning.
  ///
  /// In ko, this message translates to:
  /// **'분석이 진행 중이에요.'**
  String get reportRunning;

  /// No description provided for @reportFailed.
  ///
  /// In ko, this message translates to:
  /// **'분석 결과를 가져오지 못했어요.'**
  String get reportFailed;

  /// No description provided for @reportDisabled.
  ///
  /// In ko, this message translates to:
  /// **'현재 분석 기능이 비활성화되어 있어요.'**
  String get reportDisabled;

  /// No description provided for @reportStale.
  ///
  /// In ko, this message translates to:
  /// **'기존 분석 결과가 최신 상태가 아니에요.'**
  String get reportStale;

  /// No description provided for @reportUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'분석 상태를 확인할 수 없어요.'**
  String get reportUnavailable;

  /// No description provided for @reportDone.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석 결과가 준비됐어요. 상세 분석에서 판단 근거를 확인해보세요.'**
  String get reportDone;

  /// No description provided for @reportLoadedScope.
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 리뷰의 분석 결과예요. 상품 전체 분석 범위와 다를 수 있어요.'**
  String get reportLoadedScope;

  /// No description provided for @reportInputCount.
  ///
  /// In ko, this message translates to:
  /// **'분석에 입력한 리뷰'**
  String get reportInputCount;

  /// No description provided for @reportSourceCount.
  ///
  /// In ko, this message translates to:
  /// **'수집된 원본 리뷰'**
  String get reportSourceCount;

  /// No description provided for @reportSampled.
  ///
  /// In ko, this message translates to:
  /// **'일부 리뷰 표본 분석'**
  String get reportSampled;

  /// No description provided for @reportFull.
  ///
  /// In ko, this message translates to:
  /// **'전체 수집 리뷰 분석'**
  String get reportFull;

  /// No description provided for @reportModel.
  ///
  /// In ko, this message translates to:
  /// **'모델 버전'**
  String get reportModel;

  /// No description provided for @reportPolicy.
  ///
  /// In ko, this message translates to:
  /// **'정책 버전'**
  String get reportPolicy;

  /// No description provided for @reportNoReviewResults.
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 리뷰에 제공된 분석 결과가 없어요.'**
  String get reportNoReviewResults;

  /// No description provided for @reportReasons.
  ///
  /// In ko, this message translates to:
  /// **'제공된 판단 근거'**
  String get reportReasons;

  /// No description provided for @reportCurrentCount.
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 분석 리뷰'**
  String get reportCurrentCount;

  /// No description provided for @reportCatalogAverage.
  ///
  /// In ko, this message translates to:
  /// **'상품 평균 RTI'**
  String get reportCatalogAverage;

  /// No description provided for @reportCatalogSource.
  ///
  /// In ko, this message translates to:
  /// **'상품 목록에서 제공된 집계입니다. 상세 리뷰 결과와 업데이트 시점이 다를 수 있어요.'**
  String get reportCatalogSource;

  /// No description provided for @reviewAnalysisSafe.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 높음'**
  String get reviewAnalysisSafe;

  /// No description provided for @reviewAnalysisWarn.
  ///
  /// In ko, this message translates to:
  /// **'주의'**
  String get reviewAnalysisWarn;

  /// No description provided for @reviewAnalysisDanger.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 낮음'**
  String get reviewAnalysisDanger;

  /// No description provided for @reviewAnalysisMissing.
  ///
  /// In ko, this message translates to:
  /// **'이 리뷰에 제공된 분석 결과가 없어요.'**
  String get reviewAnalysisMissing;

  /// No description provided for @reportIntro.
  ///
  /// In ko, this message translates to:
  /// **'구매 전, 리뷰의 신뢰도를 살펴보세요.'**
  String get reportIntro;

  /// No description provided for @reportScoreLabel.
  ///
  /// In ko, this message translates to:
  /// **'상품 리뷰 신뢰도'**
  String get reportScoreLabel;

  /// No description provided for @reportStateReady.
  ///
  /// In ko, this message translates to:
  /// **'분석 결과'**
  String get reportStateReady;

  /// No description provided for @reportStateCollecting.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 수집 중'**
  String get reportStateCollecting;

  /// No description provided for @reportStateRunning.
  ///
  /// In ko, this message translates to:
  /// **'분석 중'**
  String get reportStateRunning;

  /// No description provided for @reportStateFailed.
  ///
  /// In ko, this message translates to:
  /// **'결과 확인 필요'**
  String get reportStateFailed;

  /// No description provided for @reportStateStale.
  ///
  /// In ko, this message translates to:
  /// **'업데이트 필요'**
  String get reportStateStale;

  /// No description provided for @reportStateDisabled.
  ///
  /// In ko, this message translates to:
  /// **'분석 미제공'**
  String get reportStateDisabled;

  /// No description provided for @reportStateUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'상태 확인 필요'**
  String get reportStateUnavailable;

  /// No description provided for @reportPendingBody.
  ///
  /// In ko, this message translates to:
  /// **'아직 분석 결과가 없어요. 결과가 준비되면 리뷰 신뢰도와 판단 근거를 여기에서 확인할 수 있어요.'**
  String get reportPendingBody;

  /// No description provided for @reportOverview.
  ///
  /// In ko, this message translates to:
  /// **'분석 요약'**
  String get reportOverview;

  /// No description provided for @reportCoverage.
  ///
  /// In ko, this message translates to:
  /// **'분석 범위'**
  String get reportCoverage;

  /// No description provided for @reportReviewResults.
  ///
  /// In ko, this message translates to:
  /// **'리뷰별 결과와 근거'**
  String get reportReviewResults;

  /// No description provided for @reviewOriginal.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 원문'**
  String get reviewOriginal;

  /// No description provided for @reviewResultTitle.
  ///
  /// In ko, this message translates to:
  /// **'이 리뷰의 분석 결과'**
  String get reviewResultTitle;

  /// No description provided for @reviewIndividualScope.
  ///
  /// In ko, this message translates to:
  /// **'선택한 리뷰 한 건의 결과예요. 상품 전체 리포트와 분석 범위가 달라요.'**
  String get reviewIndividualScope;

  /// No description provided for @reviewLoadedAggregate.
  ///
  /// In ko, this message translates to:
  /// **'함께 불러온 리뷰의 집계'**
  String get reviewLoadedAggregate;

  /// No description provided for @evidenceRepetitionLabel.
  ///
  /// In ko, this message translates to:
  /// **'반복 표현'**
  String get evidenceRepetitionLabel;

  /// No description provided for @evidenceRepetitionBody.
  ///
  /// In ko, this message translates to:
  /// **'같은 표현이 반복해서 사용됐어요.'**
  String get evidenceRepetitionBody;

  /// No description provided for @evidenceShortLabel.
  ///
  /// In ko, this message translates to:
  /// **'짧은 리뷰'**
  String get evidenceShortLabel;

  /// No description provided for @evidenceShortBody.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 내용이 짧아 확인할 정보가 적어요.'**
  String get evidenceShortBody;

  /// No description provided for @evidenceExclamationLabel.
  ///
  /// In ko, this message translates to:
  /// **'잦은 느낌표'**
  String get evidenceExclamationLabel;

  /// No description provided for @evidenceExclamationBody.
  ///
  /// In ko, this message translates to:
  /// **'느낌표가 많이 사용됐어요.'**
  String get evidenceExclamationBody;

  /// No description provided for @evidencePositiveLabel.
  ///
  /// In ko, this message translates to:
  /// **'강한 긍정 표현'**
  String get evidencePositiveLabel;

  /// No description provided for @evidencePositiveBody.
  ///
  /// In ko, this message translates to:
  /// **'강한 긍정 표현이 감지됐어요. 이것만으로 광고를 뜻하지는 않아요.'**
  String get evidencePositiveBody;

  /// No description provided for @evidencePurchaseLabel.
  ///
  /// In ko, this message translates to:
  /// **'구매 인증 미확인'**
  String get evidencePurchaseLabel;

  /// No description provided for @evidencePurchaseBody.
  ///
  /// In ko, this message translates to:
  /// **'구매 인증이 확인되지 않은 리뷰예요.'**
  String get evidencePurchaseBody;

  /// No description provided for @evidenceNewAccountLabel.
  ///
  /// In ko, this message translates to:
  /// **'가입 초기 작성'**
  String get evidenceNewAccountLabel;

  /// No description provided for @evidenceNewAccountBody.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 작성 당시 가입한 지 얼마 되지 않은 계정이었어요.'**
  String get evidenceNewAccountBody;

  /// No description provided for @evidenceDailyLabel.
  ///
  /// In ko, this message translates to:
  /// **'하루에 여러 리뷰'**
  String get evidenceDailyLabel;

  /// No description provided for @evidenceDailyBody.
  ///
  /// In ko, this message translates to:
  /// **'같은 작성자가 하루에 여러 리뷰를 작성했어요.'**
  String get evidenceDailyBody;

  /// No description provided for @evidenceSimilarLabel.
  ///
  /// In ko, this message translates to:
  /// **'비슷한 리뷰 내용'**
  String get evidenceSimilarLabel;

  /// No description provided for @evidenceSimilarBody.
  ///
  /// In ko, this message translates to:
  /// **'내용이 비슷한 다른 리뷰가 확인됐어요. 유사성만으로 조작을 단정하지 않아요.'**
  String get evidenceSimilarBody;

  /// No description provided for @evidenceClusterLabel.
  ///
  /// In ko, this message translates to:
  /// **'유사 리뷰 묶음'**
  String get evidenceClusterLabel;

  /// No description provided for @evidenceClusterBody.
  ///
  /// In ko, this message translates to:
  /// **'내용이 서로 비슷한 리뷰 묶음이 확인됐어요. 조작 여부가 확정된 것은 아니에요.'**
  String get evidenceClusterBody;

  /// No description provided for @evidenceQualityLabel.
  ///
  /// In ko, this message translates to:
  /// **'낮은 내용 품질 점수'**
  String get evidenceQualityLabel;

  /// No description provided for @evidenceQualityBody.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 내용의 품질 점수가 낮게 평가됐어요.'**
  String get evidenceQualityBody;

  /// No description provided for @evidenceUnknownPurchaseLabel.
  ///
  /// In ko, this message translates to:
  /// **'구매 여부 불명확'**
  String get evidenceUnknownPurchaseLabel;

  /// No description provided for @evidenceUnknownPurchaseBody.
  ///
  /// In ko, this message translates to:
  /// **'제공된 정보로는 구매 여부를 확인할 수 없어요.'**
  String get evidenceUnknownPurchaseBody;

  /// No description provided for @evidenceTrialLabel.
  ///
  /// In ko, this message translates to:
  /// **'체험·무상 제공 가능성'**
  String get evidenceTrialLabel;

  /// No description provided for @evidenceTrialBody.
  ///
  /// In ko, this message translates to:
  /// **'체험단 또는 무상 제공 리뷰일 가능성이 제시됐어요.'**
  String get evidenceTrialBody;

  /// No description provided for @evidenceNoImageLabel.
  ///
  /// In ko, this message translates to:
  /// **'첨부 사진 없음'**
  String get evidenceNoImageLabel;

  /// No description provided for @evidenceNoImageBody.
  ///
  /// In ko, this message translates to:
  /// **'리뷰에 첨부된 사진이 없어요.'**
  String get evidenceNoImageBody;

  /// No description provided for @evidenceRepurchaseLabel.
  ///
  /// In ko, this message translates to:
  /// **'재구매 신호'**
  String get evidenceRepurchaseLabel;

  /// No description provided for @evidenceRepurchaseBody.
  ///
  /// In ko, this message translates to:
  /// **'재구매를 나타내는 정보가 확인됐어요.'**
  String get evidenceRepurchaseBody;

  /// No description provided for @evidenceUnknownLabel.
  ///
  /// In ko, this message translates to:
  /// **'추가 분석 근거'**
  String get evidenceUnknownLabel;

  /// No description provided for @evidenceUnknownBody.
  ///
  /// In ko, this message translates to:
  /// **'추가 근거가 제공됐지만 아직 설명 문구를 지원하지 않아요.'**
  String get evidenceUnknownBody;

  /// No description provided for @homeSearchSuggestionsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'연관 검색어가 없어요. 입력한 단어로 검색할 수 있어요.'**
  String get homeSearchSuggestionsEmpty;

  /// No description provided for @homeSearchSuggestionsError.
  ///
  /// In ko, this message translates to:
  /// **'연관 검색어를 불러오지 못했어요. 입력한 단어로 검색하거나 다시 시도해 주세요.'**
  String get homeSearchSuggestionsError;

  /// No description provided for @homeSearchSuggestionsRetry.
  ///
  /// In ko, this message translates to:
  /// **'연관 검색어 다시 불러오기'**
  String get homeSearchSuggestionsRetry;

  /// No description provided for @authAccountHelp.
  ///
  /// In ko, this message translates to:
  /// **'계정 도움말'**
  String get authAccountHelp;

  /// No description provided for @authAccountHelpBody.
  ///
  /// In ko, this message translates to:
  /// **'이메일 계정의 비밀번호는 비밀번호 찾기에서 재설정할 수 있습니다. 구글·네이버 계정은 가입할 때 사용한 소셜 로그인 버튼을 이용해 주세요.'**
  String get authAccountHelpBody;

  /// No description provided for @authForgotPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 찾기'**
  String get authForgotPassword;

  /// No description provided for @authSignup.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get authSignup;

  /// No description provided for @authClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get authClose;

  /// No description provided for @authLogin.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get authLogin;

  /// No description provided for @authLoginDescription.
  ///
  /// In ko, this message translates to:
  /// **'Re:view 계정으로 로그인하고 저장한 상품과 신뢰 필터를 불러오세요.'**
  String get authLoginDescription;

  /// No description provided for @authEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력하세요'**
  String get authEmailHint;

  /// No description provided for @authPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력하세요'**
  String get authPasswordHint;

  /// No description provided for @authShow.
  ///
  /// In ko, this message translates to:
  /// **'보기'**
  String get authShow;

  /// No description provided for @authHide.
  ///
  /// In ko, this message translates to:
  /// **'숨김'**
  String get authHide;

  /// No description provided for @authRememberMe.
  ///
  /// In ko, this message translates to:
  /// **'로그인 상태 유지'**
  String get authRememberMe;

  /// No description provided for @authOr.
  ///
  /// In ko, this message translates to:
  /// **'또는'**
  String get authOr;

  /// No description provided for @authContinueNaver.
  ///
  /// In ko, this message translates to:
  /// **'네이버 계정으로 계속하기'**
  String get authContinueNaver;

  /// No description provided for @authContinueGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google 계정으로 계속하기'**
  String get authContinueGoogle;

  /// No description provided for @authNoAccount.
  ///
  /// In ko, this message translates to:
  /// **'아직 계정이 없나요?'**
  String get authNoAccount;

  /// No description provided for @authSignupAction.
  ///
  /// In ko, this message translates to:
  /// **'회원가입하기'**
  String get authSignupAction;

  /// No description provided for @authPrivacyNotice.
  ///
  /// In ko, this message translates to:
  /// **'개인화 정보는 계정에 안전하게 저장되며, 저장 상품과 분석 기록은 로그인한 사용자에게만 표시됩니다.'**
  String get authPrivacyNotice;

  /// No description provided for @authSignupDescription.
  ///
  /// In ko, this message translates to:
  /// **'Re:view 계정을 만들고 저장 상품, 신뢰 필터, 알림 설정을 시작하세요.'**
  String get authSignupDescription;

  /// No description provided for @authName.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get authName;

  /// No description provided for @authNameHint.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력하세요'**
  String get authNameHint;

  /// No description provided for @authPasswordGuidance.
  ///
  /// In ko, this message translates to:
  /// **'영문, 숫자, 특수문자를 포함해 8자 이상으로 설정해주세요.'**
  String get authPasswordGuidance;

  /// No description provided for @authConfirmPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get authConfirmPassword;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 한 번 더 입력하세요'**
  String get authConfirmPasswordHint;

  /// No description provided for @authSignupOnboarding.
  ///
  /// In ko, this message translates to:
  /// **'회원가입하고 온보딩 시작'**
  String get authSignupOnboarding;

  /// No description provided for @authSignupNaver.
  ///
  /// In ko, this message translates to:
  /// **'네이버 계정으로 가입하기'**
  String get authSignupNaver;

  /// No description provided for @authSignupGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google 계정으로 가입하기'**
  String get authSignupGoogle;

  /// No description provided for @authHasAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있나요?'**
  String get authHasAccount;

  /// No description provided for @authLoginAction.
  ///
  /// In ko, this message translates to:
  /// **'로그인하기'**
  String get authLoginAction;

  /// No description provided for @authTermsConsent.
  ///
  /// In ko, this message translates to:
  /// **'이용약관 및 개인정보처리방침에 동의합니다. (필수)'**
  String get authTermsConsent;

  /// No description provided for @authMarketingConsent.
  ///
  /// In ko, this message translates to:
  /// **'저장 상품 알림과 신뢰도 변화 알림을 받겠습니다. (선택)'**
  String get authMarketingConsent;

  /// No description provided for @authOnboardingNotice.
  ///
  /// In ko, this message translates to:
  /// **'다음 단계는 온보딩입니다. 가입 후 관심 카테고리와 기본 RTI 필터를 설정합니다.'**
  String get authOnboardingNotice;

  /// No description provided for @authResetTitle.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 재설정'**
  String get authResetTitle;

  /// No description provided for @authResetDescription.
  ///
  /// In ko, this message translates to:
  /// **'가입한 이메일을 확인하고 새 비밀번호를 등록하세요.'**
  String get authResetDescription;

  /// No description provided for @authRememberAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정이 기억났나요?'**
  String get authRememberAccount;

  /// No description provided for @authBackToLogin.
  ///
  /// In ko, this message translates to:
  /// **'로그인으로 돌아가기'**
  String get authBackToLogin;

  /// No description provided for @authRegisteredEmail.
  ///
  /// In ko, this message translates to:
  /// **'가입 이메일'**
  String get authRegisteredEmail;

  /// No description provided for @authSendVerification.
  ///
  /// In ko, this message translates to:
  /// **'인증 이메일 발송'**
  String get authSendVerification;

  /// No description provided for @authEmailSent.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 발송했습니다'**
  String get authEmailSent;

  /// No description provided for @authEmailSentGuide.
  ///
  /// In ko, this message translates to:
  /// **'이메일의 링크를 클릭하거나, 받은 토큰을 확인한 후 다음 단계로 진행하세요.'**
  String get authEmailSentGuide;

  /// No description provided for @authNext.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get authNext;

  /// No description provided for @authResendEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일 다시 받기'**
  String get authResendEmail;

  /// No description provided for @authNewPassword.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호'**
  String get authNewPassword;

  /// No description provided for @authNewPasswordHint.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호를 입력하세요'**
  String get authNewPasswordHint;

  /// No description provided for @authNewPasswordGuide.
  ///
  /// In ko, this message translates to:
  /// **'이전에 사용한 비밀번호와 다르게 설정하고, 영문·숫자·특수문자를 조합해 주세요.'**
  String get authNewPasswordGuide;

  /// No description provided for @authConfirmNewPassword.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호 확인'**
  String get authConfirmNewPassword;

  /// No description provided for @authConfirmNewPasswordHint.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호를 한 번 더 입력하세요'**
  String get authConfirmNewPasswordHint;

  /// No description provided for @authCompleteReset.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경 완료'**
  String get authCompleteReset;

  /// No description provided for @authResendVerification.
  ///
  /// In ko, this message translates to:
  /// **'인증 이메일 다시 받기'**
  String get authResendVerification;

  /// No description provided for @authMinLength.
  ///
  /// In ko, this message translates to:
  /// **'8자 이상'**
  String get authMinLength;

  /// No description provided for @authLettersNumbers.
  ///
  /// In ko, this message translates to:
  /// **'영문과 숫자 포함'**
  String get authLettersNumbers;

  /// No description provided for @authSymbolsRecommended.
  ///
  /// In ko, this message translates to:
  /// **'특수문자 포함 권장'**
  String get authSymbolsRecommended;

  /// No description provided for @authNoEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 받지 못했나요?'**
  String get authNoEmail;

  /// No description provided for @authNoEmailGuide.
  ///
  /// In ko, this message translates to:
  /// **'스팸함을 확인하거나, 가입한 이메일이 맞는지 다시 확인해 주세요.'**
  String get authNoEmailGuide;

  /// No description provided for @authVerifyEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일 확인'**
  String get authVerifyEmail;

  /// No description provided for @authVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드'**
  String get authVerificationCode;

  /// No description provided for @authResetSuccess.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 변경되었습니다'**
  String get authResetSuccess;

  /// No description provided for @authResetSuccessGuide.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호로 로그인해 주세요.'**
  String get authResetSuccessGuide;

  /// No description provided for @authGoToLogin.
  ///
  /// In ko, this message translates to:
  /// **'로그인하러 가기'**
  String get authGoToLogin;

  /// No description provided for @searchFilterTitle.
  ///
  /// In ko, this message translates to:
  /// **'필터'**
  String get searchFilterTitle;

  /// No description provided for @searchFilterReset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get searchFilterReset;

  /// No description provided for @searchFilterCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get searchFilterCategory;

  /// No description provided for @searchFilterPriceRange.
  ///
  /// In ko, this message translates to:
  /// **'가격대'**
  String get searchFilterPriceRange;

  /// No description provided for @searchFilterWon.
  ///
  /// In ko, this message translates to:
  /// **'원'**
  String get searchFilterWon;

  /// No description provided for @searchFilterSeller.
  ///
  /// In ko, this message translates to:
  /// **'판매처'**
  String get searchFilterSeller;

  /// No description provided for @searchFilterSellerHint.
  ///
  /// In ko, this message translates to:
  /// **'판매처를 선택하세요'**
  String get searchFilterSellerHint;

  /// No description provided for @searchFilterRtiScore.
  ///
  /// In ko, this message translates to:
  /// **'RTI 신뢰 점수'**
  String get searchFilterRtiScore;

  /// No description provided for @searchFilterAllRti.
  ///
  /// In ko, this message translates to:
  /// **'전체 (분석 전 포함)'**
  String get searchFilterAllRti;

  /// No description provided for @searchFilterZeroPoints.
  ///
  /// In ko, this message translates to:
  /// **'0점'**
  String get searchFilterZeroPoints;

  /// No description provided for @searchFilterHundredPoints.
  ///
  /// In ko, this message translates to:
  /// **'100점'**
  String get searchFilterHundredPoints;

  /// No description provided for @searchFilterEightyMinimum.
  ///
  /// In ko, this message translates to:
  /// **'80점 이상'**
  String get searchFilterEightyMinimum;

  /// No description provided for @searchFilterNinetyMinimum.
  ///
  /// In ko, this message translates to:
  /// **'90점 이상'**
  String get searchFilterNinetyMinimum;

  /// No description provided for @searchFilterNinetyFiveMinimum.
  ///
  /// In ko, this message translates to:
  /// **'95점 이상'**
  String get searchFilterNinetyFiveMinimum;

  /// No description provided for @searchFilterInfoStatus.
  ///
  /// In ko, this message translates to:
  /// **'정보 상태'**
  String get searchFilterInfoStatus;

  /// No description provided for @searchFilterReviewConditions.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 조건'**
  String get searchFilterReviewConditions;

  /// No description provided for @searchFilterSelectSeller.
  ///
  /// In ko, this message translates to:
  /// **'판매처 선택'**
  String get searchFilterSelectSeller;

  /// No description provided for @searchFilterAllSellers.
  ///
  /// In ko, this message translates to:
  /// **'전체 판매처'**
  String get searchFilterAllSellers;

  /// No description provided for @searchFilterUnanalyzedOnly.
  ///
  /// In ko, this message translates to:
  /// **'분석 전만'**
  String get searchFilterUnanalyzedOnly;

  /// No description provided for @searchFilterMissingPriceOnly.
  ///
  /// In ko, this message translates to:
  /// **'가격 정보 없음만'**
  String get searchFilterMissingPriceOnly;

  /// No description provided for @searchFilterMinimumReviews.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 50개 이상'**
  String get searchFilterMinimumReviews;

  /// No description provided for @searchFilterUnderTenThousand.
  ///
  /// In ko, this message translates to:
  /// **'1만원 이하'**
  String get searchFilterUnderTenThousand;

  /// No description provided for @searchFilterTenToThirtyThousand.
  ///
  /// In ko, this message translates to:
  /// **'10~30만원'**
  String get searchFilterTenToThirtyThousand;

  /// No description provided for @searchFilterAboveThreeHundredThousand.
  ///
  /// In ko, this message translates to:
  /// **'30만원 이상'**
  String get searchFilterAboveThreeHundredThousand;

  /// No description provided for @searchFilterPriceAmount.
  ///
  /// In ko, this message translates to:
  /// **'{amount}원'**
  String searchFilterPriceAmount(String amount);

  /// No description provided for @searchFilterMinimumScore.
  ///
  /// In ko, this message translates to:
  /// **'{score}점 이상'**
  String searchFilterMinimumScore(int score);

  /// No description provided for @searchFilterShowResults.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 결과 보기'**
  String searchFilterShowResults(int count);

  /// No description provided for @analysisPolicyIndex.
  ///
  /// In ko, this message translates to:
  /// **'RTI'**
  String get analysisPolicyIndex;

  /// No description provided for @analysisNotCalculable.
  ///
  /// In ko, this message translates to:
  /// **'계산 불가'**
  String get analysisNotCalculable;

  /// No description provided for @analysisPolicyExplanation.
  ///
  /// In ko, this message translates to:
  /// **'정책 기준에 따른 상대 지수입니다.'**
  String get analysisPolicyExplanation;

  /// No description provided for @analysisTextScore.
  ///
  /// In ko, this message translates to:
  /// **'텍스트 점수'**
  String get analysisTextScore;

  /// No description provided for @analysisBehaviorScore.
  ///
  /// In ko, this message translates to:
  /// **'행동 점수'**
  String get analysisBehaviorScore;

  /// No description provided for @analysisNetworkScore.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 점수'**
  String get analysisNetworkScore;

  /// No description provided for @analysisScore.
  ///
  /// In ko, this message translates to:
  /// **'RTI'**
  String get analysisScore;

  /// No description provided for @analysisSeparateContracts.
  ///
  /// In ko, this message translates to:
  /// **'서로 다른 계약의 점수는 별도로 표시합니다.'**
  String get analysisSeparateContracts;

  /// No description provided for @analysisPolicyAverage.
  ///
  /// In ko, this message translates to:
  /// **'상품 평균 RTI'**
  String get analysisPolicyAverage;

  /// 상품 안내 캐릭터 이름
  ///
  /// In ko, this message translates to:
  /// **'리뷰엉이'**
  String get owlGuideName;

  /// Product detail collection and analysis progress: ProductStep
  ///
  /// In ko, this message translates to:
  /// **'상품 정보 수집'**
  String get extProgressProductStep;

  /// Product detail collection and analysis progress: ReviewsStep
  ///
  /// In ko, this message translates to:
  /// **'리뷰 수집'**
  String get extProgressReviewsStep;

  /// Product detail collection and analysis progress: AnalysisStep
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석'**
  String get extProgressAnalysisStep;

  /// Product detail collection and analysis progress: StatusComplete
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get extProgressStatusComplete;

  /// Product detail collection and analysis progress: StatusInProgress
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get extProgressStatusInProgress;

  /// Product detail collection and analysis progress: StatusWaiting
  ///
  /// In ko, this message translates to:
  /// **'대기'**
  String get extProgressStatusWaiting;

  /// Product detail collection and analysis progress: StatusFailed
  ///
  /// In ko, this message translates to:
  /// **'실패'**
  String get extProgressStatusFailed;

  /// Product detail collection and analysis progress: StatusNotAnalyzed
  ///
  /// In ko, this message translates to:
  /// **'아직 분석 전'**
  String get extProgressStatusNotAnalyzed;

  /// Product detail collection and analysis progress: StatusUnknown
  ///
  /// In ko, this message translates to:
  /// **'확인 중'**
  String get extProgressStatusUnknown;

  /// Product detail collection and analysis progress: StatusRefreshing
  ///
  /// In ko, this message translates to:
  /// **'새로 수집 중'**
  String get extProgressStatusRefreshing;

  /// Product detail collection and analysis progress: StatusDisabled
  ///
  /// In ko, this message translates to:
  /// **'비활성화됨'**
  String get extProgressStatusDisabled;

  /// Product detail collection and analysis progress: StatusUnavailable
  ///
  /// In ko, this message translates to:
  /// **'정보 없음'**
  String get extProgressStatusUnavailable;

  /// Product detail collection and analysis progress: StatusPartial
  ///
  /// In ko, this message translates to:
  /// **'일부 완료'**
  String get extProgressStatusPartial;

  /// Product detail collection and analysis progress: NoticeCollecting
  ///
  /// In ko, this message translates to:
  /// **'상품 정보와 리뷰의 수집 작업을 기다리고 있어요.'**
  String get extProgressNoticeCollecting;

  /// Product detail collection and analysis progress: NoticeRefreshing
  ///
  /// In ko, this message translates to:
  /// **'이전에 수집한 정보를 보여드리고 있어요. 새 수집 작업이 대기 중이거나 진행 중이에요.'**
  String get extProgressNoticeRefreshing;

  /// Product detail collection and analysis progress: NoticeAnalyzing
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석이 대기 중이거나 진행 중이에요.'**
  String get extProgressNoticeAnalyzing;

  /// Product detail collection and analysis progress: NoticeNotAnalyzed
  ///
  /// In ko, this message translates to:
  /// **'아직 리뷰 분석 전이에요.'**
  String get extProgressNoticeNotAnalyzed;

  /// Product detail collection and analysis progress: NoticeComplete
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석이 완료됐어요.'**
  String get extProgressNoticeComplete;

  /// Product detail collection and analysis progress: NoticeFailed
  ///
  /// In ko, this message translates to:
  /// **'수집·분석 과정에서 문제가 확인됐어요. 단계별 상태를 확인해 주세요.'**
  String get extProgressNoticeFailed;

  /// Product detail collection and analysis progress: NoticeDelayed
  ///
  /// In ko, this message translates to:
  /// **'시간이 걸리고 있어요. 다시 확인해 주세요.'**
  String get extProgressNoticeDelayed;

  /// Product detail collection and analysis progress: NoticeChecking
  ///
  /// In ko, this message translates to:
  /// **'현재 수집·분석 상태를 확인 중이에요.'**
  String get extProgressNoticeChecking;

  /// Product detail collection and analysis progress: NoticeDisabled
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석이 비활성화되어 있어요.'**
  String get extProgressNoticeDisabled;

  /// Product detail collection and analysis progress: NoticeUnavailable
  ///
  /// In ko, this message translates to:
  /// **'현재 리뷰 분석 정보를 확인할 수 없어요.'**
  String get extProgressNoticeUnavailable;

  /// Product detail collection and analysis progress: Retry
  ///
  /// In ko, this message translates to:
  /// **'다시 확인'**
  String get extProgressRetry;

  /// Product detail collection and analysis progress: StepSemantics
  ///
  /// In ko, this message translates to:
  /// **'{step}, {status}'**
  String extProgressStepSemantics(String step, String status);

  /// Product detail summary and loaded-review evidence: Title
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석 요약'**
  String get extSummaryTitle;

  /// Product detail summary and loaded-review evidence: FallbackTitle
  ///
  /// In ko, this message translates to:
  /// **'분석 상태·근거 안내'**
  String get extSummaryFallbackTitle;

  /// Product detail summary and loaded-review evidence: FallbackIntro
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 리뷰의 분석 상태와 신뢰도 근거를 정리했어요.'**
  String get extSummaryFallbackIntro;

  /// Product detail summary and loaded-review evidence: NoEvidence
  ///
  /// In ko, this message translates to:
  /// **'분석은 끝났지만 요약할 근거가 아직 없어요.'**
  String get extSummaryNoEvidence;

  /// Product detail summary and loaded-review evidence: NotAnalyzed
  ///
  /// In ko, this message translates to:
  /// **'아직 분석 전이라 표시할 요약이 없어요.'**
  String get extSummaryNotAnalyzed;

  /// Product detail summary and loaded-review evidence: InProgress
  ///
  /// In ko, this message translates to:
  /// **'분석 진행 상태는 위 단계에서 확인해 주세요.'**
  String get extSummaryInProgress;

  /// Product detail summary and loaded-review evidence: Failed
  ///
  /// In ko, this message translates to:
  /// **'분석에 실패해 요약을 표시할 수 없어요.'**
  String get extSummaryFailed;

  /// Product detail summary and loaded-review evidence: Disabled
  ///
  /// In ko, this message translates to:
  /// **'분석이 비활성화되어 요약을 표시하지 않아요.'**
  String get extSummaryDisabled;

  /// Product detail summary and loaded-review evidence: Unavailable
  ///
  /// In ko, this message translates to:
  /// **'요약을 표시할 분석 상태가 아직 확인되지 않았어요.'**
  String get extSummaryUnavailable;

  /// Product detail summary and loaded-review evidence: MissingValue
  ///
  /// In ko, this message translates to:
  /// **'미제공'**
  String get extSummaryMissingValue;

  /// Product detail summary and loaded-review evidence: Sampling
  ///
  /// In ko, this message translates to:
  /// **'표본 여부'**
  String get extSummarySampling;

  /// Product detail summary and loaded-review evidence: NotSampled
  ///
  /// In ko, this message translates to:
  /// **'표본 분석 아님'**
  String get extSummaryNotSampled;

  /// Product detail summary and loaded-review evidence: LoadedScope
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 리뷰 {count}개 기준'**
  String extSummaryLoadedScope(int count);

  /// Product detail summary and loaded-review evidence: V2Grades
  ///
  /// In ko, this message translates to:
  /// **'RTI 기준 등급'**
  String get extSummaryV2Grades;

  /// Product detail summary and loaded-review evidence: LegacyGrades
  ///
  /// In ko, this message translates to:
  /// **'RTI 기준 등급'**
  String get extSummaryLegacyGrades;

  /// Product detail summary and loaded-review evidence: UnknownVersion
  ///
  /// In ko, this message translates to:
  /// **'분석 버전 미상'**
  String get extSummaryUnknownVersion;

  /// Product detail summary and loaded-review evidence: GradeCount
  ///
  /// In ko, this message translates to:
  /// **'{grade}: {count}개'**
  String extSummaryGradeCount(String grade, int count);

  /// Product detail summary and loaded-review evidence: GradeSafe
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 높음'**
  String get extSummaryGradeSafe;

  /// Product detail summary and loaded-review evidence: GradeWarn
  ///
  /// In ko, this message translates to:
  /// **'주의'**
  String get extSummaryGradeWarn;

  /// Product detail summary and loaded-review evidence: GradeDanger
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 낮음'**
  String get extSummaryGradeDanger;

  /// Product detail summary and loaded-review evidence: EvidenceTitle
  ///
  /// In ko, this message translates to:
  /// **'자주 확인된 신뢰도 근거'**
  String get extSummaryEvidenceTitle;

  /// Product detail summary and loaded-review evidence: EvidenceScope
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 리뷰의 신뢰도 분석 근거이며, 상품 품질 평가는 아니에요.'**
  String get extSummaryEvidenceScope;

  /// Product detail summary and loaded-review evidence: ReasonCount
  ///
  /// In ko, this message translates to:
  /// **'{count}개 리뷰에서 확인'**
  String extSummaryReasonCount(int count);

  /// Product detail summary and loaded-review evidence: NoLoadedReviews
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 리뷰가 없어 등급 분포를 표시할 수 없어요.'**
  String get extSummaryNoLoadedReviews;

  /// Product detail summary and loaded-review evidence: Fact
  ///
  /// In ko, this message translates to:
  /// **'{label}: {value}'**
  String extSummaryFact(String label, String value);

  /// Product trust report: DetailSource
  ///
  /// In ko, this message translates to:
  /// **'상세 분석 결과'**
  String get extTrustDetailSource;

  /// Product trust report: CatalogSource
  ///
  /// In ko, this message translates to:
  /// **'목록에서 확인한 평균'**
  String get extTrustCatalogSource;

  /// Product trust report: NoAverage
  ///
  /// In ko, this message translates to:
  /// **'표시할 리뷰 신뢰도 점수와 등급 정보가 없어요.'**
  String get extTrustNoAverage;

  /// Product trust report: Before
  ///
  /// In ko, this message translates to:
  /// **'아직 분석 전이라 상품 점수가 없어요.'**
  String get extTrustBefore;

  /// Product trust report: Running
  ///
  /// In ko, this message translates to:
  /// **'분석이 진행 중이라 상품 점수를 표시하지 않아요.'**
  String get extTrustRunning;

  /// Product trust report: GradeMissing
  ///
  /// In ko, this message translates to:
  /// **'등급 정보 없음'**
  String get extTrustGradeMissing;

  /// Product trust report: GuideSafe
  ///
  /// In ko, this message translates to:
  /// **'분석한 리뷰의 신뢰 신호가 대체로 안정적이에요.'**
  String get extTrustGuideSafe;

  /// Product trust report: GuideCaution
  ///
  /// In ko, this message translates to:
  /// **'판단 근거를 함께 확인해 보세요.'**
  String get extTrustGuideCaution;

  /// Product trust report: GuideUnknown
  ///
  /// In ko, this message translates to:
  /// **'점수의 출처와 제공된 근거를 함께 확인해 보세요.'**
  String get extTrustGuideUnknown;

  /// Product trust report: NoEvidence
  ///
  /// In ko, this message translates to:
  /// **'제공된 상품 분석 근거가 없어요.'**
  String get extTrustNoEvidence;

  /// Product trust report: Components
  ///
  /// In ko, this message translates to:
  /// **'세부 점수'**
  String get extTrustComponents;

  /// Product trust report: TextExplanation
  ///
  /// In ko, this message translates to:
  /// **'리뷰 문장의 표현과 반복 패턴을 살펴본 점수예요.'**
  String get extTrustTextExplanation;

  /// Product trust report: BehaviorExplanation
  ///
  /// In ko, this message translates to:
  /// **'리뷰 작성자의 활동 패턴을 살펴본 점수예요.'**
  String get extTrustBehaviorExplanation;

  /// Product trust report: NetworkExplanation
  ///
  /// In ko, this message translates to:
  /// **'리뷰·작성자 사이의 연결 패턴을 살펴본 점수예요.'**
  String get extTrustNetworkExplanation;

  /// Product trust report: CoverageInSummary
  ///
  /// In ko, this message translates to:
  /// **'분석 범위와 버전은 위 요약 카드에서 확인할 수 있어요.'**
  String get extTrustCoverageInSummary;

  /// Product trust report: ScoreValue
  ///
  /// In ko, this message translates to:
  /// **'{label} {score} / 100'**
  String extTrustScoreValue(String label, String score);

  /// No description provided for @extNavProgress.
  ///
  /// In ko, this message translates to:
  /// **'분석 진행'**
  String get extNavProgress;

  /// No description provided for @extNavSummary.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 요약'**
  String get extNavSummary;

  /// No description provided for @extNavReport.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 리포트'**
  String get extNavReport;

  /// No description provided for @extNavReviews.
  ///
  /// In ko, this message translates to:
  /// **'리뷰'**
  String get extNavReviews;

  /// No description provided for @extNavLabel.
  ///
  /// In ko, this message translates to:
  /// **'섹션 바로가기'**
  String get extNavLabel;

  /// Product description section: extDescriptionTitle
  ///
  /// In ko, this message translates to:
  /// **'상품 상세 설명'**
  String get extDescriptionTitle;

  /// Product description section: extDescriptionSource
  ///
  /// In ko, this message translates to:
  /// **'쇼핑몰 상세 페이지 내용'**
  String get extDescriptionSource;

  /// Product description section: extDescriptionExpand
  ///
  /// In ko, this message translates to:
  /// **'상세 설명 펼치기'**
  String get extDescriptionExpand;

  /// Product description section: extDescriptionCollapse
  ///
  /// In ko, this message translates to:
  /// **'상세 설명 접기'**
  String get extDescriptionCollapse;

  /// Product description section: extDescriptionImage
  ///
  /// In ko, this message translates to:
  /// **'상세 이미지 {index}'**
  String extDescriptionImage(int index);

  /// Product description section: extNavDescription
  ///
  /// In ko, this message translates to:
  /// **'상세 설명'**
  String get extNavDescription;

  /// Shared failure presentation: failureTitleOffline
  ///
  /// In ko, this message translates to:
  /// **'연결을 확인해 주세요'**
  String get failureTitleOffline;

  /// Shared failure presentation: failureMessageOffline
  ///
  /// In ko, this message translates to:
  /// **'서버에 연결할 수 없어요. 인터넷 연결을 확인하고 다시 시도해 주세요.'**
  String get failureMessageOffline;

  /// Shared failure presentation: failureTitleTimeout
  ///
  /// In ko, this message translates to:
  /// **'응답이 지연되고 있어요'**
  String get failureTitleTimeout;

  /// Shared failure presentation: failureMessageTimeout
  ///
  /// In ko, this message translates to:
  /// **'연결 또는 응답 대기 시간이 초과됐어요. 잠시 후 다시 시도해 주세요.'**
  String get failureMessageTimeout;

  /// Shared failure presentation: failureTitleUnauthorized
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요해요'**
  String get failureTitleUnauthorized;

  /// Shared failure presentation: failureMessageUnauthorized
  ///
  /// In ko, this message translates to:
  /// **'로그인 정보가 없거나 만료됐어요. 다시 로그인해 주세요.'**
  String get failureMessageUnauthorized;

  /// Shared failure presentation: failureTitleForbidden
  ///
  /// In ko, this message translates to:
  /// **'접근 권한이 없어요'**
  String get failureTitleForbidden;

  /// Shared failure presentation: failureMessageForbidden
  ///
  /// In ko, this message translates to:
  /// **'이 기능을 이용할 권한이 없어요.'**
  String get failureMessageForbidden;

  /// Shared failure presentation: failureTitleNotFound
  ///
  /// In ko, this message translates to:
  /// **'요청한 내용을 찾을 수 없어요'**
  String get failureTitleNotFound;

  /// Shared failure presentation: failureMessageNotFound
  ///
  /// In ko, this message translates to:
  /// **'요청한 정보가 없거나 더 이상 제공되지 않아요.'**
  String get failureMessageNotFound;

  /// Shared failure presentation: failureTitleRateLimited
  ///
  /// In ko, this message translates to:
  /// **'요청이 많아요'**
  String get failureTitleRateLimited;

  /// Shared failure presentation: failureMessageRateLimited
  ///
  /// In ko, this message translates to:
  /// **'요청이 많아 잠시 후 다시 시도해 주세요.'**
  String get failureMessageRateLimited;

  /// Shared failure presentation: failureTitleServer
  ///
  /// In ko, this message translates to:
  /// **'서버에서 문제가 발생했어요'**
  String get failureTitleServer;

  /// Shared failure presentation: failureMessageServer
  ///
  /// In ko, this message translates to:
  /// **'서버 오류가 발생했어요. 잠시 후 다시 시도해 주세요.'**
  String get failureMessageServer;

  /// Shared failure presentation: failureTitleCancelled
  ///
  /// In ko, this message translates to:
  /// **'요청이 취소됐어요'**
  String get failureTitleCancelled;

  /// Shared failure presentation: failureMessageCancelled
  ///
  /// In ko, this message translates to:
  /// **'요청이 취소되어 결과를 불러오지 않았어요.'**
  String get failureMessageCancelled;

  /// Shared failure presentation: failureTitleBadResponse
  ///
  /// In ko, this message translates to:
  /// **'응답을 확인할 수 없어요'**
  String get failureTitleBadResponse;

  /// Shared failure presentation: failureMessageBadResponse
  ///
  /// In ko, this message translates to:
  /// **'응답을 처리하지 못했어요. 다시 확인해 주세요.'**
  String get failureMessageBadResponse;

  /// Shared failure presentation: failureTitleUnknown
  ///
  /// In ko, this message translates to:
  /// **'문제가 발생했어요'**
  String get failureTitleUnknown;

  /// Shared failure presentation: failureMessageUnknown
  ///
  /// In ko, this message translates to:
  /// **'요청을 완료하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get failureMessageUnknown;

  /// Shared failure presentation: failureRetry
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get failureRetry;

  /// Shared failure presentation: failureSearchRetry
  ///
  /// In ko, this message translates to:
  /// **'다시 검색'**
  String get failureSearchRetry;

  /// No description provided for @analysisPending.
  ///
  /// In ko, this message translates to:
  /// **'분석 중'**
  String get analysisPending;

  /// No description provided for @analysisTextCaution.
  ///
  /// In ko, this message translates to:
  /// **'본문의 반복·홍보·설명문 표현을 확인해 주세요.'**
  String get analysisTextCaution;

  /// No description provided for @analysisAttentionReviews.
  ///
  /// In ko, this message translates to:
  /// **'주의 리뷰 {count}건'**
  String analysisAttentionReviews(int count);

  /// No description provided for @scrollToTop.
  ///
  /// In ko, this message translates to:
  /// **'맨 위로'**
  String get scrollToTop;

  /// No description provided for @actionUndo.
  ///
  /// In ko, this message translates to:
  /// **'되돌리기'**
  String get actionUndo;

  /// No description provided for @wishlistRemoved.
  ///
  /// In ko, this message translates to:
  /// **'찜에서 뺐어요'**
  String get wishlistRemoved;

  /// No description provided for @cartRemoved.
  ///
  /// In ko, this message translates to:
  /// **'장바구니에서 뺐어요'**
  String get cartRemoved;

  /// Shown when an item is saved to the wishlist but remains in the cart.
  ///
  /// In ko, this message translates to:
  /// **'찜에는 저장했지만 장바구니에서 빼지 못했어요'**
  String get cartWishlistRemovalFailed;

  /// Tries removing an already saved item from the cart again.
  ///
  /// In ko, this message translates to:
  /// **'다시 빼기'**
  String get cartRetryRemoval;

  /// No description provided for @listLoading.
  ///
  /// In ko, this message translates to:
  /// **'불러오는 중'**
  String get listLoading;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'장바구니가 비어 있어요'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'마음에 드는 상품을 담아보세요.'**
  String get cartEmptyDescription;

  /// No description provided for @emptyViewWishlist.
  ///
  /// In ko, this message translates to:
  /// **'찜 목록 보기'**
  String get emptyViewWishlist;

  /// No description provided for @recentProductsEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'최근 본 상품이 없어요'**
  String get recentProductsEmptyTitle;

  /// No description provided for @recentProductsEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'궁금한 상품을 둘러보세요. 최근 조회 기록은 여기에 모여요.'**
  String get recentProductsEmptyDescription;

  /// No description provided for @warningProductsEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'주의 상품이 없어요'**
  String get warningProductsEmptyTitle;

  /// No description provided for @warningProductsFilteredEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'선택한 등급의 주의 상품이 없어요'**
  String get warningProductsFilteredEmptyTitle;

  /// No description provided for @warningProductsEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'다른 상품도 둘러보고 관심 있는 상품을 찜해보세요.'**
  String get warningProductsEmptyDescription;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없어요'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyQueryDescription.
  ///
  /// In ko, this message translates to:
  /// **'상품명이나 카테고리를 입력해 검색해보세요.'**
  String get searchEmptyQueryDescription;

  /// No description provided for @searchEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'다른 검색어나 더 넓은 카테고리로 다시 검색해보세요.'**
  String get searchEmptyDescription;

  /// No description provided for @searchFilteredEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'필터에 맞는 상품이 없어요'**
  String get searchFilteredEmptyTitle;

  /// No description provided for @searchFilteredEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'필터를 초기화하거나 조건을 조금 넓혀보세요.'**
  String get searchFilteredEmptyDescription;

  /// No description provided for @searchResetFilters.
  ///
  /// In ko, this message translates to:
  /// **'필터 초기화'**
  String get searchResetFilters;

  /// No description provided for @extProductVisitShopGeneric.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑몰에서 보기'**
  String get extProductVisitShopGeneric;

  /// No description provided for @headerSupport.
  ///
  /// In ko, this message translates to:
  /// **'고객센터'**
  String get headerSupport;

  /// No description provided for @headerSellerRegistration.
  ///
  /// In ko, this message translates to:
  /// **'판매자 입점'**
  String get headerSellerRegistration;

  /// No description provided for @headerAppDownload.
  ///
  /// In ko, this message translates to:
  /// **'앱 다운로드'**
  String get headerAppDownload;

  /// No description provided for @headerCart.
  ///
  /// In ko, this message translates to:
  /// **'장바구니'**
  String get headerCart;

  /// No description provided for @headerMyAccount.
  ///
  /// In ko, this message translates to:
  /// **'내 계정'**
  String get headerMyAccount;

  /// No description provided for @headerMember.
  ///
  /// In ko, this message translates to:
  /// **'회원'**
  String get headerMember;

  /// No description provided for @headerMemberName.
  ///
  /// In ko, this message translates to:
  /// **'{name}님'**
  String headerMemberName(String name);

  /// No description provided for @headerMemberBadge.
  ///
  /// In ko, this message translates to:
  /// **'Re:view 멤버'**
  String get headerMemberBadge;

  /// No description provided for @headerOrderActivity.
  ///
  /// In ko, this message translates to:
  /// **'주문/활동'**
  String get headerOrderActivity;

  /// No description provided for @homeNavBest.
  ///
  /// In ko, this message translates to:
  /// **'베스트'**
  String get homeNavBest;

  /// No description provided for @homeNavNew.
  ///
  /// In ko, this message translates to:
  /// **'신상품'**
  String get homeNavNew;

  /// No description provided for @homeNavReviewRanking.
  ///
  /// In ko, this message translates to:
  /// **'리뷰랭킹'**
  String get homeNavReviewRanking;

  /// No description provided for @homePopularCategoriesNow.
  ///
  /// In ko, this message translates to:
  /// **'지금 인기 카테고리'**
  String get homePopularCategoriesNow;

  /// No description provided for @homeCategoryPickTitle.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 추천 PICK'**
  String get homeCategoryPickTitle;

  /// No description provided for @homeAllCategoriesTitle.
  ///
  /// In ko, this message translates to:
  /// **'모든 카테고리를 한눈에'**
  String get homeAllCategoriesTitle;

  /// No description provided for @homeAllCategoriesDescription.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 데이터 기반 인기 상품과 카테고리를 확인해보세요.'**
  String get homeAllCategoriesDescription;

  /// No description provided for @homeCategoryViewAll.
  ///
  /// In ko, this message translates to:
  /// **'{category} 전체보기  >'**
  String homeCategoryViewAll(String category);

  /// No description provided for @homeBannerFallbackNotice.
  ///
  /// In ko, this message translates to:
  /// **'배너를 불러오지 못해 기본 배너를 표시합니다.'**
  String get homeBannerFallbackNotice;

  /// No description provided for @homeProductsLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'상품을 불러오지 못했습니다.'**
  String get homeProductsLoadFailed;

  /// No description provided for @homeViewAllProducts.
  ///
  /// In ko, this message translates to:
  /// **'전체 상품 보기'**
  String get homeViewAllProducts;

  /// No description provided for @homeBannerLinkFailed.
  ///
  /// In ko, this message translates to:
  /// **'배너 링크를 열지 못했습니다.'**
  String get homeBannerLinkFailed;

  /// No description provided for @homePriceUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'가격 정보 없음'**
  String get homePriceUnavailable;

  /// No description provided for @homeRecommendationsPending.
  ///
  /// In ko, this message translates to:
  /// **'추천 상품 API 연결 대기 중'**
  String get homeRecommendationsPending;

  /// No description provided for @homeRecommendationsPendingDescription.
  ///
  /// In ko, this message translates to:
  /// **'임의 상품을 만들지 않고 실제 상품 데이터가 연결되면 카드 목록으로 표시됩니다.'**
  String get homeRecommendationsPendingDescription;

  /// No description provided for @homeTrustTitle.
  ///
  /// In ko, this message translates to:
  /// **'Re:view가 더 믿을 수 있는 이유'**
  String get homeTrustTitle;

  /// No description provided for @homeTrustIndexTitle.
  ///
  /// In ko, this message translates to:
  /// **'RTI 리뷰 신뢰도 지수'**
  String get homeTrustIndexTitle;

  /// No description provided for @homeFooterAbout.
  ///
  /// In ko, this message translates to:
  /// **'서비스 소개'**
  String get homeFooterAbout;

  /// No description provided for @homeFooterTerms.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get homeFooterTerms;

  /// No description provided for @homeFooterPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침'**
  String get homeFooterPrivacy;

  /// No description provided for @homeSuggestedProductsPending.
  ///
  /// In ko, this message translates to:
  /// **'추천상품 API 연결 대기 중'**
  String get homeSuggestedProductsPending;

  /// No description provided for @homeRtiChecking.
  ///
  /// In ko, this message translates to:
  /// **'RTI 확인 중'**
  String get homeRtiChecking;

  /// No description provided for @homeTrustAnalyzedProduct.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 분석 상품'**
  String get homeTrustAnalyzedProduct;

  /// No description provided for @homeBannerPlay.
  ///
  /// In ko, this message translates to:
  /// **'재생'**
  String get homeBannerPlay;

  /// No description provided for @homeBannerPause.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get homeBannerPause;

  /// No description provided for @homeBannerPrevious.
  ///
  /// In ko, this message translates to:
  /// **'이전 배너'**
  String get homeBannerPrevious;

  /// No description provided for @homeBannerNext.
  ///
  /// In ko, this message translates to:
  /// **'다음 배너'**
  String get homeBannerNext;

  /// No description provided for @homeBannerPosition.
  ///
  /// In ko, this message translates to:
  /// **'배너 {index}/{count}'**
  String homeBannerPosition(int index, int count);

  /// No description provided for @homeBannerTrustLabel.
  ///
  /// In ko, this message translates to:
  /// **'{badge}\n신뢰도 확인'**
  String homeBannerTrustLabel(String badge);

  /// No description provided for @landingHomeTooltip.
  ///
  /// In ko, this message translates to:
  /// **'홈으로'**
  String get landingHomeTooltip;

  /// No description provided for @landingFeatureRti.
  ///
  /// In ko, this message translates to:
  /// **'RTI 기반'**
  String get landingFeatureRti;

  /// No description provided for @landingFeatureAdPatterns.
  ///
  /// In ko, this message translates to:
  /// **'광고성 패턴 분석'**
  String get landingFeatureAdPatterns;

  /// No description provided for @landingFeatureEvidence.
  ///
  /// In ko, this message translates to:
  /// **'판별 근거 제공'**
  String get landingFeatureEvidence;

  /// No description provided for @landingHeroDescription.
  ///
  /// In ko, this message translates to:
  /// **'상품별 리뷰를 분석하고, RTI로 판단한 신뢰 지수를 제공해\n더 믿을 수 있는 구매 결정을 도와드려요.'**
  String get landingHeroDescription;

  /// No description provided for @landingHeroHeadline.
  ///
  /// In ko, this message translates to:
  /// **'가짜 리뷰에 흔들리지 않는\n더 똑똑한 쇼핑, '**
  String get landingHeroHeadline;

  /// No description provided for @landingStart.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get landingStart;

  /// No description provided for @landingLearnRti.
  ///
  /// In ko, this message translates to:
  /// **'RTI 알아보기'**
  String get landingLearnRti;

  /// No description provided for @landingCloseHint.
  ///
  /// In ko, this message translates to:
  /// **'언제든 닫고 홈으로 이동할 수 있어요'**
  String get landingCloseHint;

  /// No description provided for @landingGradeHigh.
  ///
  /// In ko, this message translates to:
  /// **'신뢰 높음'**
  String get landingGradeHigh;

  /// No description provided for @landingRtiReliabilityScore.
  ///
  /// In ko, this message translates to:
  /// **'RTI 신뢰도 {score}%'**
  String landingRtiReliabilityScore(String score);

  /// No description provided for @landingRtiAnalyzing.
  ///
  /// In ko, this message translates to:
  /// **'RTI 신뢰도 분석 중'**
  String get landingRtiAnalyzing;

  /// No description provided for @landingSummaryLowAd.
  ///
  /// In ko, this message translates to:
  /// **'광고 패턴 낮음'**
  String get landingSummaryLowAd;

  /// No description provided for @landingSummaryFewRepeats.
  ///
  /// In ko, this message translates to:
  /// **'반복 문구 적음'**
  String get landingSummaryFewRepeats;

  /// No description provided for @landingSummaryNoAnomalies.
  ///
  /// In ko, this message translates to:
  /// **'이상 징후 없음'**
  String get landingSummaryNoAnomalies;

  /// No description provided for @landingAnalysisSummary.
  ///
  /// In ko, this message translates to:
  /// **'Re:view 분석 요약'**
  String get landingAnalysisSummary;

  /// No description provided for @landingAnalysisDisclaimer.
  ///
  /// In ko, this message translates to:
  /// **'실제 사용자 리뷰를 기반으로 분석하여\n광고성/조작 신호는 필터링되어 분석에 반영됩니다.'**
  String get landingAnalysisDisclaimer;

  /// No description provided for @settingsEditInterests.
  ///
  /// In ko, this message translates to:
  /// **'관심 카테고리·알림 설정 다시 편집'**
  String get settingsEditInterests;

  /// No description provided for @homeCategoryBenefitReviewBased.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 데이터 기반 추천'**
  String get homeCategoryBenefitReviewBased;

  /// No description provided for @homeCategoryBenefitRtiRanking.
  ///
  /// In ko, this message translates to:
  /// **'RTI 랭킹 확인'**
  String get homeCategoryBenefitRtiRanking;

  /// No description provided for @homeCategoryBenefitFastShippingProducts.
  ///
  /// In ko, this message translates to:
  /// **'빠른 배송 상품'**
  String get homeCategoryBenefitFastShippingProducts;

  /// No description provided for @homeCategoryBenefitAllOffers.
  ///
  /// In ko, this message translates to:
  /// **'혜택 모아보기'**
  String get homeCategoryBenefitAllOffers;

  /// No description provided for @homeCategoryBenefitSize.
  ///
  /// In ko, this message translates to:
  /// **'사이즈 추천'**
  String get homeCategoryBenefitSize;

  /// No description provided for @homeCategoryBenefitStyle.
  ///
  /// In ko, this message translates to:
  /// **'스타일 추천'**
  String get homeCategoryBenefitStyle;

  /// No description provided for @homeCategoryBenefitGenderDeals.
  ///
  /// In ko, this message translates to:
  /// **'성별 핫딜'**
  String get homeCategoryBenefitGenderDeals;

  /// No description provided for @homeCategoryBenefitGifts.
  ///
  /// In ko, this message translates to:
  /// **'베스트 선물'**
  String get homeCategoryBenefitGifts;

  /// No description provided for @homeCategoryBenefitAuthenticityCheck.
  ///
  /// In ko, this message translates to:
  /// **'정품 인증'**
  String get homeCategoryBenefitAuthenticityCheck;

  /// No description provided for @homeCategoryBenefitBrandEvents.
  ///
  /// In ko, this message translates to:
  /// **'브랜드 기획전'**
  String get homeCategoryBenefitBrandEvents;

  /// No description provided for @homeCategoryBenefitGiftWrapping.
  ///
  /// In ko, this message translates to:
  /// **'선물 포장 서비스'**
  String get homeCategoryBenefitGiftWrapping;

  /// No description provided for @homeCategoryBenefitFreeReturns.
  ///
  /// In ko, this message translates to:
  /// **'무료 반품'**
  String get homeCategoryBenefitFreeReturns;

  /// No description provided for @homeCategoryBenefitIngredients.
  ///
  /// In ko, this message translates to:
  /// **'성분으로 찾기'**
  String get homeCategoryBenefitIngredients;

  /// No description provided for @homeCategoryBenefitSkinType.
  ///
  /// In ko, this message translates to:
  /// **'피부 타입 추천'**
  String get homeCategoryBenefitSkinType;

  /// No description provided for @homeCategoryBenefitReviewRanking.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 랭킹'**
  String get homeCategoryBenefitReviewRanking;

  /// No description provided for @homeCategoryBenefitSamples.
  ///
  /// In ko, this message translates to:
  /// **'샘플 체험'**
  String get homeCategoryBenefitSamples;

  /// No description provided for @homeCategoryBenefitDawnDelivery.
  ///
  /// In ko, this message translates to:
  /// **'새벽배송'**
  String get homeCategoryBenefitDawnDelivery;

  /// No description provided for @homeCategoryBenefitBulkDiscount.
  ///
  /// In ko, this message translates to:
  /// **'대용량 할인'**
  String get homeCategoryBenefitBulkDiscount;

  /// No description provided for @homeCategoryBenefitReviewFavorites.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 인기상품'**
  String get homeCategoryBenefitReviewFavorites;

  /// No description provided for @homeCategoryBenefitSubscriptions.
  ///
  /// In ko, this message translates to:
  /// **'정기배송'**
  String get homeCategoryBenefitSubscriptions;

  /// No description provided for @homeCategoryBenefitTodayDeals.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 특가'**
  String get homeCategoryBenefitTodayDeals;

  /// No description provided for @homeCategoryBenefitHousewarming.
  ///
  /// In ko, this message translates to:
  /// **'집들이 추천'**
  String get homeCategoryBenefitHousewarming;

  /// No description provided for @homeCategoryBenefitFastShipping.
  ///
  /// In ko, this message translates to:
  /// **'빠른배송'**
  String get homeCategoryBenefitFastShipping;

  /// No description provided for @homeCategoryBenefitByRoom.
  ///
  /// In ko, this message translates to:
  /// **'공간별 추천'**
  String get homeCategoryBenefitByRoom;

  /// No description provided for @homeCategoryBenefitPopularInteriors.
  ///
  /// In ko, this message translates to:
  /// **'인기 인테리어'**
  String get homeCategoryBenefitPopularInteriors;

  /// No description provided for @homeCategoryBenefitInstallation.
  ///
  /// In ko, this message translates to:
  /// **'설치 서비스'**
  String get homeCategoryBenefitInstallation;

  /// No description provided for @homeCategoryBenefitSeasonalDecor.
  ///
  /// In ko, this message translates to:
  /// **'시즌 데코'**
  String get homeCategoryBenefitSeasonalDecor;

  /// No description provided for @homeCategoryBenefitBeginners.
  ///
  /// In ko, this message translates to:
  /// **'입문자 추천'**
  String get homeCategoryBenefitBeginners;

  /// No description provided for @homeCategoryBenefitTopGear.
  ///
  /// In ko, this message translates to:
  /// **'베스트 장비'**
  String get homeCategoryBenefitTopGear;

  /// No description provided for @homeCategoryBenefitSeasonalOutdoors.
  ///
  /// In ko, this message translates to:
  /// **'시즌 아웃도어'**
  String get homeCategoryBenefitSeasonalOutdoors;

  /// No description provided for @homeCategoryBenefitQuickCompare.
  ///
  /// In ko, this message translates to:
  /// **'빠른 비교'**
  String get homeCategoryBenefitQuickCompare;

  /// No description provided for @homeCategoryBenefitCarCare.
  ///
  /// In ko, this message translates to:
  /// **'차량관리 필수템'**
  String get homeCategoryBenefitCarCare;

  /// No description provided for @homeCategoryBenefitMaintenance.
  ///
  /// In ko, this message translates to:
  /// **'정비용품 추천'**
  String get homeCategoryBenefitMaintenance;

  /// No description provided for @homeCategoryBenefitBrandDeals.
  ///
  /// In ko, this message translates to:
  /// **'브랜드 특가'**
  String get homeCategoryBenefitBrandDeals;

  /// No description provided for @homeCategoryBenefitSafetyGear.
  ///
  /// In ko, this message translates to:
  /// **'안전장비 모음'**
  String get homeCategoryBenefitSafetyGear;

  /// No description provided for @homeCategoryBenefitParenting.
  ///
  /// In ko, this message translates to:
  /// **'육아 필수템'**
  String get homeCategoryBenefitParenting;

  /// No description provided for @homeCategoryBenefitByAge.
  ///
  /// In ko, this message translates to:
  /// **'연령별 추천'**
  String get homeCategoryBenefitByAge;

  /// No description provided for @homeCategoryBenefitSafetyCertification.
  ///
  /// In ko, this message translates to:
  /// **'안전인증'**
  String get homeCategoryBenefitSafetyCertification;

  /// No description provided for @homeCategoryBenefitSpecialOffers.
  ///
  /// In ko, this message translates to:
  /// **'기획전'**
  String get homeCategoryBenefitSpecialOffers;

  /// No description provided for @homeCategoryBenefitPopularTreats.
  ///
  /// In ko, this message translates to:
  /// **'인기 간식'**
  String get homeCategoryBenefitPopularTreats;

  /// No description provided for @homeCategoryBenefitVetPicks.
  ///
  /// In ko, this message translates to:
  /// **'수의사 추천'**
  String get homeCategoryBenefitVetPicks;

  /// No description provided for @homeCategoryBenefitPetPersonalized.
  ///
  /// In ko, this message translates to:
  /// **'우리 아이 맞춤'**
  String get homeCategoryBenefitPetPersonalized;

  /// No description provided for @homeCategoryBenefitMerchandiserPicks.
  ///
  /// In ko, this message translates to:
  /// **'MD 추천'**
  String get homeCategoryBenefitMerchandiserPicks;

  /// No description provided for @homeCategoryBenefitPreorders.
  ///
  /// In ko, this message translates to:
  /// **'예약판매'**
  String get homeCategoryBenefitPreorders;

  /// No description provided for @homeCategoryBenefitLimitedMerch.
  ///
  /// In ko, this message translates to:
  /// **'한정판 굿즈'**
  String get homeCategoryBenefitLimitedMerch;

  /// No description provided for @homeCategoryBenefitBestsellers.
  ///
  /// In ko, this message translates to:
  /// **'베스트셀러'**
  String get homeCategoryBenefitBestsellers;

  /// No description provided for @homeCategoryBenefitTravelChecklist.
  ///
  /// In ko, this message translates to:
  /// **'여행 준비 체크리스트'**
  String get homeCategoryBenefitTravelChecklist;

  /// No description provided for @homeCategoryBenefitPopularStays.
  ///
  /// In ko, this message translates to:
  /// **'인기 숙소'**
  String get homeCategoryBenefitPopularStays;

  /// No description provided for @homeCategoryBenefitDiscountTickets.
  ///
  /// In ko, this message translates to:
  /// **'할인 티켓'**
  String get homeCategoryBenefitDiscountTickets;

  /// No description provided for @homeCategoryBenefitSubscriptionOffers.
  ///
  /// In ko, this message translates to:
  /// **'구독 혜택'**
  String get homeCategoryBenefitSubscriptionOffers;

  /// No description provided for @homeCategoryBenefitAuthenticityGuarantee.
  ///
  /// In ko, this message translates to:
  /// **'정품 보증'**
  String get homeCategoryBenefitAuthenticityGuarantee;

  /// No description provided for @homeCategoryBenefitBrandWeek.
  ///
  /// In ko, this message translates to:
  /// **'브랜드 위크'**
  String get homeCategoryBenefitBrandWeek;

  /// No description provided for @homeCategoryBenefitPremiumOffers.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 혜택'**
  String get homeCategoryBenefitPremiumOffers;

  /// No description provided for @homeCategoryBenefitExclusiveOffers.
  ///
  /// In ko, this message translates to:
  /// **'단독 오퍼'**
  String get homeCategoryBenefitExclusiveOffers;

  /// No description provided for @homeCategoryRecommendedLabel.
  ///
  /// In ko, this message translates to:
  /// **'추천'**
  String get homeCategoryRecommendedLabel;

  /// No description provided for @authLoginContinue.
  ///
  /// In ko, this message translates to:
  /// **'내 관심 상품을 이어서 관리하세요.'**
  String get authLoginContinue;

  /// No description provided for @authLoginTrackHeadline.
  ///
  /// In ko, this message translates to:
  /// **'내 관심 상품의 리뷰 신뢰도를\n계속 추적하세요.'**
  String get authLoginTrackHeadline;

  /// No description provided for @authLoginManageDescription.
  ///
  /// In ko, this message translates to:
  /// **'로그인하면 저장한 상품, 신뢰 필터 설정, 분석 피드백 내역을 한 계정에서 이어서 관리할 수 있습니다.'**
  String get authLoginManageDescription;

  /// No description provided for @authLoginSafeShopping.
  ///
  /// In ko, this message translates to:
  /// **'안전한 쇼핑을 위한 로그인'**
  String get authLoginSafeShopping;

  /// No description provided for @authLoginRecentProducts.
  ///
  /// In ko, this message translates to:
  /// **'최근 확인한 상품'**
  String get authLoginRecentProducts;

  /// No description provided for @authLoginRestoreRecords.
  ///
  /// In ko, this message translates to:
  /// **'로그인 후 저장 상품과 분석 기록을 불러옵니다.'**
  String get authLoginRestoreRecords;

  /// No description provided for @authLoginKeepTrackingRti.
  ///
  /// In ko, this message translates to:
  /// **'RTI 계속 추적'**
  String get authLoginKeepTrackingRti;

  /// No description provided for @authMetricText.
  ///
  /// In ko, this message translates to:
  /// **'텍스트'**
  String get authMetricText;

  /// No description provided for @authMetricBehavior.
  ///
  /// In ko, this message translates to:
  /// **'행동'**
  String get authMetricBehavior;

  /// No description provided for @authMetricPurchaseContext.
  ///
  /// In ko, this message translates to:
  /// **'구매맥락'**
  String get authMetricPurchaseContext;

  /// No description provided for @authProductUncategorized.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 미분류'**
  String get authProductUncategorized;

  /// No description provided for @authLoginSavedProducts.
  ///
  /// In ko, this message translates to:
  /// **'저장 상품 관리'**
  String get authLoginSavedProducts;

  /// No description provided for @authLoginSavedProductsDescription.
  ///
  /// In ko, this message translates to:
  /// **'관심 상품을 모아두고 RTI 변화 위협 신호를 확인합니다.'**
  String get authLoginSavedProductsDescription;

  /// No description provided for @authLoginPersonalFilters.
  ///
  /// In ko, this message translates to:
  /// **'개인 신뢰 필터'**
  String get authLoginPersonalFilters;

  /// No description provided for @authLoginPersonalFiltersDescription.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰 숨김, 최소 RTI 기준 등 나에게 맞는 필터를 유지합니다.'**
  String get authLoginPersonalFiltersDescription;

  /// No description provided for @authLoginFeedbackTracking.
  ///
  /// In ko, this message translates to:
  /// **'분석 피드백 추적'**
  String get authLoginFeedbackTracking;

  /// No description provided for @authLoginFeedbackTrackingDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고와 피드백 처리 상태를 한곳에서 확인합니다.'**
  String get authLoginFeedbackTrackingDescription;

  /// No description provided for @authFooterContact.
  ///
  /// In ko, this message translates to:
  /// **'문의'**
  String get authFooterContact;

  /// No description provided for @authSignupFilterHeadline.
  ///
  /// In ko, this message translates to:
  /// **'내 쇼핑 기준에 맞는\n리뷰 신뢰 필터를\n만들어보세요.'**
  String get authSignupFilterHeadline;

  /// No description provided for @authSignupFilterDescription.
  ///
  /// In ko, this message translates to:
  /// **'회원가입 후 관심 카테고리와 기본 신뢰 필터를 설정하면, 상품을 볼 때마다 내 기준에 맞는 RTI 신호와 알림을 받을 수 있습니다.'**
  String get authSignupFilterDescription;

  /// No description provided for @authSignupCreateAccount.
  ///
  /// In ko, this message translates to:
  /// **'새 계정 만들기'**
  String get authSignupCreateAccount;

  /// No description provided for @authSignupAccountStep.
  ///
  /// In ko, this message translates to:
  /// **'계정 생성'**
  String get authSignupAccountStep;

  /// No description provided for @authSignupAccountStepDescription.
  ///
  /// In ko, this message translates to:
  /// **'이름과 이메일로 Re:view 계정을 만듭니다.'**
  String get authSignupAccountStepDescription;

  /// No description provided for @authSignupCurrentStep.
  ///
  /// In ko, this message translates to:
  /// **'현재 단계'**
  String get authSignupCurrentStep;

  /// No description provided for @authSignupInterestStep.
  ///
  /// In ko, this message translates to:
  /// **'관심 카테고리 선택'**
  String get authSignupInterestStep;

  /// No description provided for @authSignupInterestStepDescription.
  ///
  /// In ko, this message translates to:
  /// **'관심사가 쌓이면 더 나은 신뢰 신호를 제공합니다.'**
  String get authSignupInterestStepDescription;

  /// No description provided for @authSignupFilterStep.
  ///
  /// In ko, this message translates to:
  /// **'신뢰 필터 설정'**
  String get authSignupFilterStep;

  /// No description provided for @authSignupFilterStepDescription.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰 숨김, 최소 RTI 기준을 설정합니다.'**
  String get authSignupFilterStepDescription;

  /// No description provided for @authSignupFollowupFlow.
  ///
  /// In ko, this message translates to:
  /// **'가입 후 바로 이어지는 흐름'**
  String get authSignupFollowupFlow;

  /// No description provided for @authSignupFollowupDescription.
  ///
  /// In ko, this message translates to:
  /// **'회원가입이 끝나면 온보딩에서 관심 카테고리와 기본 필터를 설정합니다.'**
  String get authSignupFollowupDescription;

  /// No description provided for @authSignupPersonalizedBrowse.
  ///
  /// In ko, this message translates to:
  /// **'개인화된 상품 탐색'**
  String get authSignupPersonalizedBrowse;

  /// No description provided for @authSignupPersonalizedBrowseDescription.
  ///
  /// In ko, this message translates to:
  /// **'관심 카테고리에 맞는 신뢰 피드를 먼저 확인합니다.'**
  String get authSignupPersonalizedBrowseDescription;

  /// No description provided for @authSignupSavedAlerts.
  ///
  /// In ko, this message translates to:
  /// **'저장 상품 알림'**
  String get authSignupSavedAlerts;

  /// No description provided for @authSignupSavedAlertsDescription.
  ///
  /// In ko, this message translates to:
  /// **'관심 상품의 위험 신호가 증가하면 알림을 받을 수 있습니다.'**
  String get authSignupSavedAlertsDescription;

  /// No description provided for @authSignupFeedbackHistory.
  ///
  /// In ko, this message translates to:
  /// **'피드백 기록 관리'**
  String get authSignupFeedbackHistory;

  /// No description provided for @authSignupFeedbackHistoryDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고와 분석 피드백 처리 상태를 추적합니다.'**
  String get authSignupFeedbackHistoryDescription;

  /// No description provided for @authSetupMinutes.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 설정'**
  String authSetupMinutes(int minutes);

  /// No description provided for @authValidationNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해주세요.'**
  String get authValidationNameRequired;

  /// No description provided for @authValidationEmailRequired.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요.'**
  String get authValidationEmailRequired;

  /// No description provided for @authValidationEmailInvalid.
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식으로 입력해주세요.'**
  String get authValidationEmailInvalid;

  /// No description provided for @authValidationPasswordRequired.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요.'**
  String get authValidationPasswordRequired;

  /// No description provided for @authValidationPasswordComposition.
  ///
  /// In ko, this message translates to:
  /// **'영문, 숫자, 특수문자를 모두 포함해주세요.'**
  String get authValidationPasswordComposition;

  /// No description provided for @authValidationPasswordConfirmRequired.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 한 번 더 입력해주세요.'**
  String get authValidationPasswordConfirmRequired;

  /// No description provided for @authValidationPasswordMismatch.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않습니다.'**
  String get authValidationPasswordMismatch;

  /// No description provided for @authValidationTermsRequired.
  ///
  /// In ko, this message translates to:
  /// **'필수 약관에 동의해주세요.'**
  String get authValidationTermsRequired;

  /// No description provided for @authValidationPasswordMinLength.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 {minLength}자 이상이어야 합니다.'**
  String authValidationPasswordMinLength(int minLength);

  /// No description provided for @authResetVerifyHeadline.
  ///
  /// In ko, this message translates to:
  /// **'안전하게 인증하고\n'**
  String get authResetVerifyHeadline;

  /// No description provided for @authResetHeadlineEmphasis.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 다시 설정'**
  String get authResetHeadlineEmphasis;

  /// No description provided for @authResetHeadlineEnd.
  ///
  /// In ko, this message translates to:
  /// **' 하세요.'**
  String get authResetHeadlineEnd;

  /// No description provided for @authResetValueDescription.
  ///
  /// In ko, this message translates to:
  /// **'Re:view 계정의 저장 상품, 신뢰 필터, 피드백 내역을 보호하기 위해 이메일 후 새 비밀번호를 설정합니다.'**
  String get authResetValueDescription;

  /// No description provided for @authResetRecoveryBadge.
  ///
  /// In ko, this message translates to:
  /// **'계정 복구'**
  String get authResetRecoveryBadge;

  /// No description provided for @authResetEmailStepDescription.
  ///
  /// In ko, this message translates to:
  /// **'가입한 이메일 주소로 인증 코드를 발송합니다.'**
  String get authResetEmailStepDescription;

  /// No description provided for @authResetCodeStep.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 입력'**
  String get authResetCodeStep;

  /// No description provided for @authResetNewPasswordStep.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호 설정'**
  String get authResetNewPasswordStep;

  /// No description provided for @authResetNewPasswordStepDescription.
  ///
  /// In ko, this message translates to:
  /// **'보안 기준을 만족하는 새 비밀번호를 등록합니다.'**
  String get authResetNewPasswordStepDescription;

  /// No description provided for @authResetProcessTitle.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 재설정 과정'**
  String get authResetProcessTitle;

  /// No description provided for @authResetProcessDescription.
  ///
  /// In ko, this message translates to:
  /// **'계정 소유 확인 후 안전하게 비밀번호를 변경합니다.'**
  String get authResetProcessDescription;

  /// No description provided for @authResetSecurityBadge.
  ///
  /// In ko, this message translates to:
  /// **'보안 인증'**
  String get authResetSecurityBadge;

  /// No description provided for @authResetKeepData.
  ///
  /// In ko, this message translates to:
  /// **'계정 데이터 유지'**
  String get authResetKeepData;

  /// No description provided for @authResetKeepDataDescription.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 바꿔도 저장 필터 설정은 그대로'**
  String get authResetKeepDataDescription;

  /// No description provided for @authResetProtectCode.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 보호'**
  String get authResetProtectCode;

  /// No description provided for @authResetProtectCodeDescription.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드는 일정 시간 후 만료되며 타인에게 공유하지 않아야 합니다.'**
  String get authResetProtectCodeDescription;

  /// No description provided for @authResetSignInAgain.
  ///
  /// In ko, this message translates to:
  /// **'로그인 재확인'**
  String get authResetSignInAgain;

  /// No description provided for @authResetSignInAgainDescription.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경 후 새 다시 로그인합니다.'**
  String get authResetSignInAgainDescription;

  /// No description provided for @authResetCodeStepDescription.
  ///
  /// In ko, this message translates to:
  /// **'메일로 받은 {digits}자리 코드를 입력해 계정을 확인합니다.'**
  String authResetCodeStepDescription(int digits);

  /// No description provided for @authOAuthLoginFailed.
  ///
  /// In ko, this message translates to:
  /// **'OAuth 로그인에 실패했습니다.'**
  String get authOAuthLoginFailed;

  /// No description provided for @onboardingCategoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'관심 있는 카테고리를 선택해 주세요'**
  String get onboardingCategoryTitle;

  /// No description provided for @onboardingCategoryDescription.
  ///
  /// In ko, this message translates to:
  /// **'선택하지 않아도 진행할 수 있습니다. 관심 설정은 나중에 설정에서 다시 변경할 수 있어요.'**
  String get onboardingCategoryDescription;

  /// No description provided for @onboardingUnanalyzedNotice.
  ///
  /// In ko, this message translates to:
  /// **'분석 전 상품을 안전한 상품으로 판정하지 않습니다.'**
  String get onboardingUnanalyzedNotice;

  /// No description provided for @onboardingSkipExisting.
  ///
  /// In ko, this message translates to:
  /// **'기존 설정으로 건너뛰기'**
  String get onboardingSkipExisting;

  /// No description provided for @onboardingTrustThreshold.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 기준: {score}점'**
  String onboardingTrustThreshold(int score);

  /// No description provided for @onboardingNotificationDescription.
  ///
  /// In ko, this message translates to:
  /// **'알림함에서 받을 알림을 선택하세요. 실제 분석 결과가 생성된 경우에만 관련 알림을 받을 수 있어요.'**
  String get onboardingNotificationDescription;

  /// No description provided for @onboardingFeedbackResults.
  ///
  /// In ko, this message translates to:
  /// **'피드백 처리 결과'**
  String get onboardingFeedbackResults;

  /// No description provided for @onboardingMarketingConsent.
  ///
  /// In ko, this message translates to:
  /// **'마케팅·이벤트 알림 동의'**
  String get onboardingMarketingConsent;

  /// No description provided for @onboardingNotificationAvailability.
  ///
  /// In ko, this message translates to:
  /// **'브라우저 푸시·이메일·문자 및 주간 리포트는 현재 제공되지 않습니다. 이 화면은 알림함 설정을 저장합니다.'**
  String get onboardingNotificationAvailability;

  /// No description provided for @onboardingPrevious.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get onboardingPrevious;

  /// No description provided for @onboardingSaveComplete.
  ///
  /// In ko, this message translates to:
  /// **'저장하고 완료'**
  String get onboardingSaveComplete;

  /// No description provided for @onboardingPreferredCategories.
  ///
  /// In ko, this message translates to:
  /// **'선호 카테고리'**
  String get onboardingPreferredCategories;

  /// No description provided for @onboardingReload.
  ///
  /// In ko, this message translates to:
  /// **'다시 불러오기'**
  String get onboardingReload;

  /// No description provided for @reportSubmit.
  ///
  /// In ko, this message translates to:
  /// **'신고 접수하기'**
  String get reportSubmit;

  /// No description provided for @reportReceived.
  ///
  /// In ko, this message translates to:
  /// **'신고 접수'**
  String get reportReceived;

  /// No description provided for @reportReceivedDescription.
  ///
  /// In ko, this message translates to:
  /// **'대상 리뷰와 신고 사유가 저장됩니다.'**
  String get reportReceivedDescription;

  /// No description provided for @reportAssistedReview.
  ///
  /// In ko, this message translates to:
  /// **'AI 보조 검토'**
  String get reportAssistedReview;

  /// No description provided for @reportAssistedReviewDescription.
  ///
  /// In ko, this message translates to:
  /// **'RTI 신호와 유사 리뷰 이력을 함께 확인합니다.'**
  String get reportAssistedReviewDescription;

  /// No description provided for @reportTeamDecision.
  ///
  /// In ko, this message translates to:
  /// **'운영팀 판단'**
  String get reportTeamDecision;

  /// No description provided for @reportTeamDecisionDescription.
  ///
  /// In ko, this message translates to:
  /// **'허위/악의성이면 무선 검토 상태가 갱신됩니다.'**
  String get reportTeamDecisionDescription;

  /// No description provided for @reportResultNotification.
  ///
  /// In ko, this message translates to:
  /// **'결과 알림'**
  String get reportResultNotification;

  /// No description provided for @reportResultNotificationDescription.
  ///
  /// In ko, this message translates to:
  /// **'검토 완료되면 피드백 내역에 결과가 반영됩니다.'**
  String get reportResultNotificationDescription;

  /// No description provided for @reportProcessTitle.
  ///
  /// In ko, this message translates to:
  /// **'처리 절차'**
  String get reportProcessTitle;

  /// No description provided for @reportProcessDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고 접수 후 운영팀이 검토하는 흐름이에요.'**
  String get reportProcessDescription;

  /// No description provided for @reportGuideRepeated.
  ///
  /// In ko, this message translates to:
  /// **'반복 문구를 구체적으로 적기'**
  String get reportGuideRepeated;

  /// No description provided for @reportGuideRepeatedDescription.
  ///
  /// In ko, this message translates to:
  /// **'정확한 위치/문장/패턴 등 눈에 띄는 표현을 적어주세요.'**
  String get reportGuideRepeatedDescription;

  /// No description provided for @reportGuideContext.
  ///
  /// In ko, this message translates to:
  /// **'상품 사용 맥락 확인'**
  String get reportGuideContext;

  /// No description provided for @reportGuideContextDescription.
  ///
  /// In ko, this message translates to:
  /// **'실제 사용 경험이 없거나 상품과 무관한 부분을 알려주세요.'**
  String get reportGuideContextDescription;

  /// No description provided for @reportGuideAttachments.
  ///
  /// In ko, this message translates to:
  /// **'첨부 자료 첨부'**
  String get reportGuideAttachments;

  /// No description provided for @reportGuideAttachmentsDescription.
  ///
  /// In ko, this message translates to:
  /// **'해당 근거가 여러 상황에 반복된다면 첨부가 좋습니다.'**
  String get reportGuideAttachmentsDescription;

  /// No description provided for @reportGuideTitle.
  ///
  /// In ko, this message translates to:
  /// **'신고 가이드'**
  String get reportGuideTitle;

  /// No description provided for @reportGuideDescription.
  ///
  /// In ko, this message translates to:
  /// **'이런 경우 신고가 더 잘 처리돼요.'**
  String get reportGuideDescription;

  /// No description provided for @reportSummaryTitle.
  ///
  /// In ko, this message translates to:
  /// **'접수 요약'**
  String get reportSummaryTitle;

  /// No description provided for @reportSummaryDescription.
  ///
  /// In ko, this message translates to:
  /// **'제출 전 입력한 내용을 확인하세요.'**
  String get reportSummaryDescription;

  /// No description provided for @reportLiveBadge.
  ///
  /// In ko, this message translates to:
  /// **'실시간'**
  String get reportLiveBadge;

  /// No description provided for @reportSelectedReasons.
  ///
  /// In ko, this message translates to:
  /// **'선택 사유'**
  String get reportSelectedReasons;

  /// No description provided for @reportAnalysisEvidence.
  ///
  /// In ko, this message translates to:
  /// **'AI 근거'**
  String get reportAnalysisEvidence;

  /// No description provided for @reportTargetReviews.
  ///
  /// In ko, this message translates to:
  /// **'대상 리뷰'**
  String get reportTargetReviews;

  /// No description provided for @reportReasonTitle.
  ///
  /// In ko, this message translates to:
  /// **'신고 사유 선택'**
  String get reportReasonTitle;

  /// No description provided for @reportReasonDescription.
  ///
  /// In ko, this message translates to:
  /// **'카드를 탭해서 선택하세요 · 여러 개 선택 가능합니다.'**
  String get reportReasonDescription;

  /// No description provided for @reportViewCriteria.
  ///
  /// In ko, this message translates to:
  /// **'신고 기준 보기'**
  String get reportViewCriteria;

  /// No description provided for @reportStepTarget.
  ///
  /// In ko, this message translates to:
  /// **'대상 확인'**
  String get reportStepTarget;

  /// No description provided for @reportStepTargetDescription.
  ///
  /// In ko, this message translates to:
  /// **'상품과 리뷰 정보 확인'**
  String get reportStepTargetDescription;

  /// No description provided for @reportStepReasonDescription.
  ///
  /// In ko, this message translates to:
  /// **'문제 유형 선택'**
  String get reportStepReasonDescription;

  /// No description provided for @reportStepDetails.
  ///
  /// In ko, this message translates to:
  /// **'상세 근거'**
  String get reportStepDetails;

  /// No description provided for @reportStepDetailsDescription.
  ///
  /// In ko, this message translates to:
  /// **'추가 설명 입력'**
  String get reportStepDetailsDescription;

  /// No description provided for @reportStepComplete.
  ///
  /// In ko, this message translates to:
  /// **'접수 완료'**
  String get reportStepComplete;

  /// No description provided for @reportStepCompleteDescription.
  ///
  /// In ko, this message translates to:
  /// **'검토 상태 추적'**
  String get reportStepCompleteDescription;

  /// No description provided for @reportTargetDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고하려는 상품과 리뷰가 맞는지 확인해주세요.'**
  String get reportTargetDescription;

  /// No description provided for @reportFromAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'분석 팝업에서 이동'**
  String get reportFromAnalysis;

  /// No description provided for @reportPrivacyConsent.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 수집 및 신고 처리 안내에 동의합니다.'**
  String get reportPrivacyConsent;

  /// No description provided for @reportPrivacyDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고 내용은 리뷰 접수, 처리 결과 안내, 모델 품질 개선을 위해 사용되며 필요한 기간 동안 보관됩니다.'**
  String get reportPrivacyDescription;

  /// No description provided for @reportTruthConsent.
  ///
  /// In ko, this message translates to:
  /// **'허위 신고가 아님을 확인합니다.'**
  String get reportTruthConsent;

  /// No description provided for @reportTruthDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고 내용이 사실과 다를 경우 처리 우선순위가 낮아질 수 있습니다.'**
  String get reportTruthDescription;

  /// No description provided for @reportTitleText.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신고 접수'**
  String get reportTitleText;

  /// No description provided for @reportDescription.
  ///
  /// In ko, this message translates to:
  /// **'의심 리뷰의 문제 유형과 근거를 남겨주세요. 제출된 신고는 운영 검수와 모델 개선 피드백에 함께 활용됩니다.'**
  String get reportDescription;

  /// No description provided for @reportViewMyFeedback.
  ///
  /// In ko, this message translates to:
  /// **'내 피드백 내역 보기'**
  String get reportViewMyFeedback;

  /// No description provided for @reportReportBreadcrumb.
  ///
  /// In ko, this message translates to:
  /// **'리포트'**
  String get reportReportBreadcrumb;

  /// No description provided for @reportEvidenceTitle.
  ///
  /// In ko, this message translates to:
  /// **'분석 근거 함께 제출 (선택)'**
  String get reportEvidenceTitle;

  /// No description provided for @reportEvidenceDescription.
  ///
  /// In ko, this message translates to:
  /// **'현재 리뷰의 RTI 분석 신호를 신고 근거로 첨부할 수 있어요.'**
  String get reportEvidenceDescription;

  /// No description provided for @reportAttachEvidence.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 근거 첨부'**
  String get reportAttachEvidence;

  /// No description provided for @reportAttachEvidenceDescription.
  ///
  /// In ko, this message translates to:
  /// **'RTI 신호 데이터가 신고 근거와 함께 제출돼요.'**
  String get reportAttachEvidenceDescription;

  /// No description provided for @reportViewEvidence.
  ///
  /// In ko, this message translates to:
  /// **'근거 보기'**
  String get reportViewEvidence;

  /// No description provided for @reportDetailsTitle.
  ///
  /// In ko, this message translates to:
  /// **'상세 근거 입력'**
  String get reportDetailsTitle;

  /// No description provided for @reportDetailsDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고 판단에 도움이 되는 내용을 남겨주세요.'**
  String get reportDetailsDescription;

  /// No description provided for @reportType.
  ///
  /// In ko, this message translates to:
  /// **'신고 유형'**
  String get reportType;

  /// No description provided for @reportVisibility.
  ///
  /// In ko, this message translates to:
  /// **'처리 결과 공개 범위'**
  String get reportVisibility;

  /// No description provided for @reportDetailHint.
  ///
  /// In ko, this message translates to:
  /// **'구체적인 문제 내용과 맥락을 입력해주세요.'**
  String get reportDetailHint;

  /// No description provided for @reportAttachments.
  ///
  /// In ko, this message translates to:
  /// **'첨부 자료 '**
  String get reportAttachments;

  /// No description provided for @reportOptional.
  ///
  /// In ko, this message translates to:
  /// **'(선택)'**
  String get reportOptional;

  /// No description provided for @reportAttachmentsFull.
  ///
  /// In ko, this message translates to:
  /// **'첨부 가능한 개수를 모두 채웠어요'**
  String get reportAttachmentsFull;

  /// No description provided for @reportAttachmentsHint.
  ///
  /// In ko, this message translates to:
  /// **'스크린샷이나 추가 근거를 첨부해주세요'**
  String get reportAttachmentsHint;

  /// No description provided for @reportChooseFiles.
  ///
  /// In ko, this message translates to:
  /// **'파일 선택'**
  String get reportChooseFiles;

  /// No description provided for @reportConsentsRequired.
  ///
  /// In ko, this message translates to:
  /// **'동의 항목을 모두 확인해주세요.'**
  String get reportConsentsRequired;

  /// No description provided for @reportSubmittedTitle.
  ///
  /// In ko, this message translates to:
  /// **'신고 접수 완료'**
  String get reportSubmittedTitle;

  /// No description provided for @reportSubmittedDescription.
  ///
  /// In ko, this message translates to:
  /// **'신고가 접수되었습니다.\n처리 결과는 피드백 내역에서 확인할 수 있어요.'**
  String get reportSubmittedDescription;

  /// No description provided for @reportViewFeedback.
  ///
  /// In ko, this message translates to:
  /// **'피드백 내역 보기'**
  String get reportViewFeedback;

  /// No description provided for @reportAlreadyReportedTitle.
  ///
  /// In ko, this message translates to:
  /// **'이미 신고한 리뷰'**
  String get reportAlreadyReportedTitle;

  /// No description provided for @reportAlreadyReportedDescription.
  ///
  /// In ko, this message translates to:
  /// **'이 리뷰는 이미 신고하셨습니다.\n중복 신고는 접수되지 않아요.'**
  String get reportAlreadyReportedDescription;

  /// No description provided for @reportReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}건'**
  String reportReviewCount(int count);

  /// No description provided for @reportAverageReviewRound.
  ///
  /// In ko, this message translates to:
  /// **'평균 {round}차 검토'**
  String reportAverageReviewRound(int round);

  /// No description provided for @reportRiskyReviewScore.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰 · RTI {score}'**
  String reportRiskyReviewScore(String score);

  /// No description provided for @reportMaxAttachments.
  ///
  /// In ko, this message translates to:
  /// **'최대 {count}개까지만 첨부할 수 있어요.'**
  String reportMaxAttachments(int count);

  /// No description provided for @reportFileTooLarge.
  ///
  /// In ko, this message translates to:
  /// **'{name}은 {size}MB를 초과합니다.'**
  String reportFileTooLarge(String name, int size);

  /// No description provided for @reportMinimumCharacters.
  ///
  /// In ko, this message translates to:
  /// **'최소 {count}자 이상 입력해주세요.'**
  String reportMinimumCharacters(int count);

  /// No description provided for @reportMinimumCharactersHelp.
  ///
  /// In ko, this message translates to:
  /// **'최소 {count}자 이상 입력하면 운영팀 검토에 더 도움이 돼요.'**
  String reportMinimumCharactersHelp(int count);

  /// No description provided for @reportCharacterCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}자'**
  String reportCharacterCount(int count);

  /// No description provided for @reportAttachmentLimits.
  ///
  /// In ko, this message translates to:
  /// **'PNG, JPG, PDF · 최대 {size}MB · 최대 {count}개'**
  String reportAttachmentLimits(int size, int count);

  /// No description provided for @reportReasonRequired.
  ///
  /// In ko, this message translates to:
  /// **'신고 사유를 {count}개 이상 선택해주세요.'**
  String reportReasonRequired(int count);

  /// No description provided for @reportDetailsRequired.
  ///
  /// In ko, this message translates to:
  /// **'상세 설명을 {count}자 이상 입력해주세요.'**
  String reportDetailsRequired(int count);

  /// No description provided for @reportReasonFake.
  ///
  /// In ko, this message translates to:
  /// **'가짜 리뷰 / 리뷰 날바 의심'**
  String get reportReasonFake;

  /// No description provided for @reportReasonGenerated.
  ///
  /// In ko, this message translates to:
  /// **'AI 생성 흔적 의심'**
  String get reportReasonGenerated;

  /// No description provided for @reportReasonFakeDescription.
  ///
  /// In ko, this message translates to:
  /// **'반복되고, 과도한 칭찬, 구매 이력 복수가 동조하는 가능성이 있는 리뷰예요.'**
  String get reportReasonFakeDescription;

  /// No description provided for @reportReasonGeneratedDescription.
  ///
  /// In ko, this message translates to:
  /// **'반복이 지나치게 정밀하거나, 동일한 문장 구조가 반복되는 리뷰예요.'**
  String get reportReasonGeneratedDescription;

  /// No description provided for @reportReasonIrrelevantDescription.
  ///
  /// In ko, this message translates to:
  /// **'실제 상품 사용 경험과 관련이 없는 내용이거나 다른 상품/페이지의 내용을 포함해요.'**
  String get reportReasonIrrelevantDescription;

  /// No description provided for @reportReasonInappropriateDescription.
  ///
  /// In ko, this message translates to:
  /// **'비방, 혐오 표현, 이름 등 개인정보가 포함된 리뷰예요.'**
  String get reportReasonInappropriateDescription;

  /// No description provided for @reportReasonAdDescription.
  ///
  /// In ko, this message translates to:
  /// **'광고 리뷰입니다.'**
  String get reportReasonAdDescription;

  /// No description provided for @reportReasonRepeatDescription.
  ///
  /// In ko, this message translates to:
  /// **'반복되는 내용입니다.'**
  String get reportReasonRepeatDescription;

  /// No description provided for @reportReasonOtherDescription.
  ///
  /// In ko, this message translates to:
  /// **'기타 신고 사유입니다.'**
  String get reportReasonOtherDescription;

  /// No description provided for @reportTypeRepetition.
  ///
  /// In ko, this message translates to:
  /// **'반복 문구'**
  String get reportTypeRepetition;

  /// No description provided for @reportTypeNewAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정 생성 직후'**
  String get reportTypeNewAccount;

  /// No description provided for @reportTypeSimilarCluster.
  ///
  /// In ko, this message translates to:
  /// **'유사 리뷰 군집'**
  String get reportTypeSimilarCluster;

  /// No description provided for @reportPrivate.
  ///
  /// In ko, this message translates to:
  /// **'비공개'**
  String get reportPrivate;

  /// No description provided for @reportOnlyMe.
  ///
  /// In ko, this message translates to:
  /// **'나에게만 공개'**
  String get reportOnlyMe;

  /// No description provided for @reportTeamOnly.
  ///
  /// In ko, this message translates to:
  /// **'운영팀 공유'**
  String get reportTeamOnly;

  /// No description provided for @reportSelectPrompt.
  ///
  /// In ko, this message translates to:
  /// **'선택해주세요'**
  String get reportSelectPrompt;

  /// No description provided for @reportGuideBadge.
  ///
  /// In ko, this message translates to:
  /// **'안내'**
  String get reportGuideBadge;

  /// No description provided for @paymentTestCartTitle.
  ///
  /// In ko, this message translates to:
  /// **'장바구니 토스 TEST 결제'**
  String get paymentTestCartTitle;

  /// No description provided for @paymentTestServiceTitle.
  ///
  /// In ko, this message translates to:
  /// **'토스 TEST 서비스 결제'**
  String get paymentTestServiceTitle;

  /// No description provided for @paymentTestCartDescription.
  ///
  /// In ko, this message translates to:
  /// **'TEST 주문·결제 전용입니다. 실제 상품 배송과 실결제는 진행하지 않습니다. 판매·배송 가능 상품과 최종 금액은 서버 견적으로 확인합니다.'**
  String get paymentTestCartDescription;

  /// No description provided for @paymentTestServiceDescription.
  ///
  /// In ko, this message translates to:
  /// **'테스트 전용입니다. 외부 쇼핑몰 상품 주문·실결제·자동 플랜 변경을 진행하지 않습니다.'**
  String get paymentTestServiceDescription;

  /// No description provided for @paymentTestLoginRequired.
  ///
  /// In ko, this message translates to:
  /// **'주문 조회와 결제는 로그인이 필요합니다. 결제 콜백 주소는 로그인 후 다시 열어 주세요.'**
  String get paymentTestLoginRequired;

  /// No description provided for @paymentTestNotConfigured.
  ///
  /// In ko, this message translates to:
  /// **'TEST 결제 키와 서버 주문·승인 계약이 아직 준비되지 않았습니다. 현재 결제를 시작하거나 완료할 수 없습니다.'**
  String get paymentTestNotConfigured;

  /// No description provided for @paymentTestWebOnly.
  ///
  /// In ko, this message translates to:
  /// **'현재 TEST 결제는 웹 브라우저에서만 지원합니다.'**
  String get paymentTestWebOnly;

  /// No description provided for @paymentTestOrder.
  ///
  /// In ko, this message translates to:
  /// **'TEST 주문'**
  String get paymentTestOrder;

  /// No description provided for @paymentTestReloadTargets.
  ///
  /// In ko, this message translates to:
  /// **'결제 대상 다시 조회'**
  String get paymentTestReloadTargets;

  /// No description provided for @paymentTestOpening.
  ///
  /// In ko, this message translates to:
  /// **'TEST 결제창 여는 중'**
  String get paymentTestOpening;

  /// No description provided for @paymentTestOpen.
  ///
  /// In ko, this message translates to:
  /// **'TEST 결제창 열기'**
  String get paymentTestOpen;

  /// No description provided for @paymentTestReloadWindow.
  ///
  /// In ko, this message translates to:
  /// **'결제창 다시 불러오기'**
  String get paymentTestReloadWindow;

  /// No description provided for @paymentTestReloadApproval.
  ///
  /// In ko, this message translates to:
  /// **'서버 승인 상태 다시 조회'**
  String get paymentTestReloadApproval;

  /// No description provided for @paymentTestBackToOrders.
  ///
  /// In ko, this message translates to:
  /// **'TEST 주문 선택으로 돌아가기'**
  String get paymentTestBackToOrders;

  /// No description provided for @paymentTestCheckPlan.
  ///
  /// In ko, this message translates to:
  /// **'현재 플랜 확인'**
  String get paymentTestCheckPlan;

  /// No description provided for @paymentCheckoutTitle.
  ///
  /// In ko, this message translates to:
  /// **'장바구니 TEST 주문'**
  String get paymentCheckoutTitle;

  /// No description provided for @paymentCheckoutDescription.
  ///
  /// In ko, this message translates to:
  /// **'실결제·실제 배송은 진행하지 않습니다. 쇼핑몰 상품을 이 서비스가 판매·배송할 수 있는지 서버 확인이 필요합니다. 표시 가격은 참고용이며 배송비·최종 금액은 서버 견적으로 확인합니다.'**
  String get paymentCheckoutDescription;

  /// No description provided for @paymentCheckoutNotConfigured.
  ///
  /// In ko, this message translates to:
  /// **'TEST 공개 키와 장바구니 견적·주문·승인 API가 아직 없습니다. 주문 저장과 결제는 사용할 수 없습니다. 주소는 서버에 보내거나 저장하지 않습니다.'**
  String get paymentCheckoutNotConfigured;

  /// No description provided for @paymentCheckoutLoginSelect.
  ///
  /// In ko, this message translates to:
  /// **'로그인 후 주문 선택'**
  String get paymentCheckoutLoginSelect;

  /// No description provided for @paymentCheckoutNoSelection.
  ///
  /// In ko, this message translates to:
  /// **'현재 계정의 선택 상품이 없습니다. 장바구니에서 상품을 선택해 주세요.'**
  String get paymentCheckoutNoSelection;

  /// No description provided for @paymentCheckoutRecipient.
  ///
  /// In ko, this message translates to:
  /// **'수령인'**
  String get paymentCheckoutRecipient;

  /// No description provided for @paymentCheckoutPhone.
  ///
  /// In ko, this message translates to:
  /// **'연락처'**
  String get paymentCheckoutPhone;

  /// No description provided for @paymentCheckoutPostalCode.
  ///
  /// In ko, this message translates to:
  /// **'우편번호'**
  String get paymentCheckoutPostalCode;

  /// No description provided for @paymentCheckoutAddress.
  ///
  /// In ko, this message translates to:
  /// **'주소'**
  String get paymentCheckoutAddress;

  /// No description provided for @paymentCheckoutAddressDetail.
  ///
  /// In ko, this message translates to:
  /// **'상세 주소 (선택)'**
  String get paymentCheckoutAddressDetail;

  /// No description provided for @paymentCheckoutRequired.
  ///
  /// In ko, this message translates to:
  /// **'입력해 주세요.'**
  String get paymentCheckoutRequired;

  /// No description provided for @paymentCheckoutPhoneInvalid.
  ///
  /// In ko, this message translates to:
  /// **'연락처 형식을 확인해 주세요.'**
  String get paymentCheckoutPhoneInvalid;

  /// No description provided for @paymentCheckoutQuote.
  ///
  /// In ko, this message translates to:
  /// **'서버 TEST 견적 확인'**
  String get paymentCheckoutQuote;

  /// No description provided for @paymentCheckoutBack.
  ///
  /// In ko, this message translates to:
  /// **'장바구니로 돌아가기'**
  String get paymentCheckoutBack;

  /// No description provided for @paymentCheckoutUnitPrice.
  ///
  /// In ko, this message translates to:
  /// **'참고 개당 {price}원'**
  String paymentCheckoutUnitPrice(String price);

  /// No description provided for @paymentCheckoutQuantity.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 · {price}'**
  String paymentCheckoutQuantity(int count, String price);

  /// No description provided for @paymentCheckoutPostalLength.
  ///
  /// In ko, this message translates to:
  /// **'우편번호 {count}자리를 입력해 주세요.'**
  String paymentCheckoutPostalLength(int count);

  /// No description provided for @paymentTestRequestFailed.
  ///
  /// In ko, this message translates to:
  /// **'결제창 요청이 취소되었거나 실패했습니다. 결제 완료로 처리하지 않았습니다.'**
  String get paymentTestRequestFailed;

  /// No description provided for @paymentTestLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'TEST 결제창을 불러오지 못했습니다. 네트워크와 설정을 확인한 뒤 다시 시도해 주세요.'**
  String get paymentTestLoadFailed;

  /// No description provided for @paymentTestWebBrowserOnly.
  ///
  /// In ko, this message translates to:
  /// **'TEST 결제는 웹 브라우저에서만 사용할 수 있습니다.'**
  String get paymentTestWebBrowserOnly;

  /// No description provided for @planRefreshFailed.
  ///
  /// In ko, this message translates to:
  /// **'요금제 변경 요청은 처리됐지만 현재 플랜과 한도를 확인하지 못했습니다. 다시 불러와 확인해 주세요.'**
  String get planRefreshFailed;

  /// No description provided for @detailSettingsRetry.
  ///
  /// In ko, this message translates to:
  /// **'표시 설정을 불러오지 못했습니다. 재시도'**
  String get detailSettingsRetry;

  /// No description provided for @detailHelpfulUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'도움 횟수가 제공되지 않아 기존 리뷰 순서로 표시합니다.'**
  String get detailHelpfulUnavailable;

  /// No description provided for @detailNoReviews.
  ///
  /// In ko, this message translates to:
  /// **'아직 등록된 리뷰가 없습니다.'**
  String get detailNoReviews;

  /// No description provided for @detailNoMatchingReviews.
  ///
  /// In ko, this message translates to:
  /// **'해당 조건에 맞는 리뷰가 없습니다.'**
  String get detailNoMatchingReviews;

  /// No description provided for @detailVerified.
  ///
  /// In ko, this message translates to:
  /// **'구매인증'**
  String get detailVerified;

  /// No description provided for @detailSortRti.
  ///
  /// In ko, this message translates to:
  /// **'RTI 높은순'**
  String get detailSortRti;

  /// No description provided for @detailViewReviewAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 분석 보기'**
  String get detailViewReviewAnalysis;

  /// No description provided for @detailHelpful.
  ///
  /// In ko, this message translates to:
  /// **'도움이 됐어요'**
  String get detailHelpful;

  /// No description provided for @detailNotHelpful.
  ///
  /// In ko, this message translates to:
  /// **'도움이 안 됐어요'**
  String get detailNotHelpful;

  /// No description provided for @detailFeedbackSubmitted.
  ///
  /// In ko, this message translates to:
  /// **'피드백이 제출됐습니다.'**
  String get detailFeedbackSubmitted;

  /// No description provided for @detailFeedbackFailed.
  ///
  /// In ko, this message translates to:
  /// **'피드백 제출에 실패했습니다. 다시 시도해주세요.'**
  String get detailFeedbackFailed;

  /// No description provided for @detailShowHiddenReviews.
  ///
  /// In ko, this message translates to:
  /// **'설정 기준 이하 리뷰 {count}개 표시'**
  String detailShowHiddenReviews(int count);

  /// No description provided for @detailMoreReviewsRemaining.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 더보기 ({count}개 남음)'**
  String detailMoreReviewsRemaining(int count);

  /// No description provided for @detailLowestPrice.
  ///
  /// In ko, this message translates to:
  /// **'최저가'**
  String get detailLowestPrice;

  /// No description provided for @detailShipping.
  ///
  /// In ko, this message translates to:
  /// **'배송'**
  String get detailShipping;

  /// No description provided for @detailCompareAllSellers.
  ///
  /// In ko, this message translates to:
  /// **'전체 {count}개 판매처 가격 비교'**
  String detailCompareAllSellers(int count);

  /// No description provided for @detailInsights.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 인사이트'**
  String get detailInsights;

  /// No description provided for @detailMentionedKeywords.
  ///
  /// In ko, this message translates to:
  /// **'많이 언급된 키워드'**
  String get detailMentionedKeywords;

  /// No description provided for @detailPositivePoints.
  ///
  /// In ko, this message translates to:
  /// **'만족 포인트'**
  String get detailPositivePoints;

  /// No description provided for @detailNegativePoints.
  ///
  /// In ko, this message translates to:
  /// **'아쉬운 포인트'**
  String get detailNegativePoints;

  /// No description provided for @detailMoreInsights.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 인사이트 더보기'**
  String get detailMoreInsights;

  /// No description provided for @detailRiskSummary.
  ///
  /// In ko, this message translates to:
  /// **'종합 위험 요약'**
  String get detailRiskSummary;

  /// No description provided for @detailRiskSummaryTooltip.
  ///
  /// In ko, this message translates to:
  /// **'이 상품의 전체 리뷰에 대한\nAI 신뢰도 분석 결과입니다.'**
  String get detailRiskSummaryTooltip;

  /// No description provided for @detailScoreTooltip.
  ///
  /// In ko, this message translates to:
  /// **'RTI 신뢰도 점수는 구매 인증, 텍스트 신뢰도,\n반복 표현, 시점 패턴 등을 종합해 산출됩니다.'**
  String get detailScoreTooltip;

  /// No description provided for @detailDisclaimer.
  ///
  /// In ko, this message translates to:
  /// **'분석 결과는 참고용이며 최종 판단은 여러 리뷰를 함께 확인해주세요.'**
  String get detailDisclaimer;

  /// No description provided for @detailCriteria.
  ///
  /// In ko, this message translates to:
  /// **'분석 기준'**
  String get detailCriteria;

  /// No description provided for @detailReported.
  ///
  /// In ko, this message translates to:
  /// **'신고 완료'**
  String get detailReported;

  /// No description provided for @detailReportReview.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신고'**
  String get detailReportReview;

  /// No description provided for @detailSignalsTitle.
  ///
  /// In ko, this message translates to:
  /// **'RTI 구성 신호'**
  String get detailSignalsTitle;

  /// No description provided for @detailSignalsTooltip.
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수를 구성하는 신호와 각각의 점수입니다.\n텍스트·행동·네트워크 분석을 종합해 산출합니다.'**
  String get detailSignalsTooltip;

  /// No description provided for @detailEvidenceTooltip.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도를 판단한 구체적인 근거와\n각 근거가 점수에 기여한 비중입니다.'**
  String get detailEvidenceTooltip;

  /// No description provided for @detailAlsoViewed.
  ///
  /// In ko, this message translates to:
  /// **'이 제품을 본 고객이 함께 본 제품'**
  String get detailAlsoViewed;

  /// No description provided for @detailKeySignals.
  ///
  /// In ko, this message translates to:
  /// **'주요 판단 신호'**
  String get detailKeySignals;

  /// No description provided for @detailTrend.
  ///
  /// In ko, this message translates to:
  /// **'위험도 추이'**
  String get detailTrend;

  /// No description provided for @detailTrendDescription.
  ///
  /// In ko, this message translates to:
  /// **'상품 리뷰의 평균 RTI와 위험 리뷰 비율 변화를 보여줘요.'**
  String get detailTrendDescription;

  /// No description provided for @detailTrendPending.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 완료 후 위험도 추이를 확인할 수 있습니다'**
  String get detailTrendPending;

  /// No description provided for @detailTrendEmptyPeriod.
  ///
  /// In ko, this message translates to:
  /// **'선택한 기간에 분석 기록이 없어요.'**
  String get detailTrendEmptyPeriod;

  /// Average RTI score when only one trend observation is available.
  ///
  /// In ko, this message translates to:
  /// **'평균 RTI {score}점'**
  String detailTrendSingleScore(double score);

  /// No description provided for @detailAverageRti.
  ///
  /// In ko, this message translates to:
  /// **'평균 RTI'**
  String get detailAverageRti;

  /// No description provided for @detailRiskyReviewRatio.
  ///
  /// In ko, this message translates to:
  /// **'위험 리뷰 비율'**
  String get detailRiskyReviewRatio;

  /// No description provided for @detailToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get detailToday;

  /// No description provided for @detailRecentReviewOrder.
  ///
  /// In ko, this message translates to:
  /// **'최신 리뷰 순서'**
  String get detailRecentReviewOrder;

  /// No description provided for @detailAnalyzing.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 중'**
  String get detailAnalyzing;

  /// No description provided for @detailNoAnalyzedReviews.
  ///
  /// In ko, this message translates to:
  /// **'분석된 리뷰가 없습니다.'**
  String get detailNoAnalyzedReviews;

  /// No description provided for @detailOfficialSeller.
  ///
  /// In ko, this message translates to:
  /// **'공식 판매처'**
  String get detailOfficialSeller;

  /// No description provided for @detailTrustHigh.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도 높음'**
  String get detailTrustHigh;

  /// No description provided for @detailTrustMedium.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도 보통'**
  String get detailTrustMedium;

  /// No description provided for @detailTrustLow.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도 낮음'**
  String get detailTrustLow;

  /// No description provided for @detailFormattedReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 {count}개'**
  String detailFormattedReviewCount(String count);

  /// No description provided for @detailBrand.
  ///
  /// In ko, this message translates to:
  /// **'브랜드'**
  String get detailBrand;

  /// No description provided for @detailAverageRating.
  ///
  /// In ko, this message translates to:
  /// **'평균 별점'**
  String get detailAverageRating;

  /// No description provided for @detailSellerCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}곳'**
  String detailSellerCount(int count);

  /// No description provided for @detailRatingReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'{rating} (리뷰 {count}개)'**
  String detailRatingReviewCount(String rating, String count);

  /// No description provided for @detailAnalysisInProgress.
  ///
  /// In ko, this message translates to:
  /// **'AI 리뷰 분석 진행 중'**
  String get detailAnalysisInProgress;

  /// No description provided for @detailAnalysisInProgressDescription.
  ///
  /// In ko, this message translates to:
  /// **'Re:view AI가 리뷰를 실시간 분석하고 있습니다. 완료 후 신뢰도 점수가 자동으로 업데이트됩니다.'**
  String get detailAnalysisInProgressDescription;

  /// No description provided for @detailInformation.
  ///
  /// In ko, this message translates to:
  /// **'상품 정보'**
  String get detailInformation;

  /// No description provided for @detailReviewTabCount.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 {count}'**
  String detailReviewTabCount(String count);

  /// No description provided for @detailComparisonTabCount.
  ///
  /// In ko, this message translates to:
  /// **'가격비교 {count}'**
  String detailComparisonTabCount(int count);

  /// No description provided for @searchGridView.
  ///
  /// In ko, this message translates to:
  /// **'카드형 보기'**
  String get searchGridView;

  /// No description provided for @searchListView.
  ///
  /// In ko, this message translates to:
  /// **'리스트형 보기'**
  String get searchListView;

  /// No description provided for @searchSort.
  ///
  /// In ko, this message translates to:
  /// **'정렬'**
  String get searchSort;

  /// No description provided for @searchPageSize.
  ///
  /// In ko, this message translates to:
  /// **'페이지당 상품 수'**
  String get searchPageSize;

  /// No description provided for @searchResultCountLabel.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 결과'**
  String searchResultCountLabel(int count);

  /// No description provided for @searchPageSizeCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개씩 보기'**
  String searchPageSizeCount(int count);

  /// No description provided for @searchCartAdded.
  ///
  /// In ko, this message translates to:
  /// **'장바구니에 담겼습니다.'**
  String get searchCartAdded;

  /// No description provided for @searchCartAddFailed.
  ///
  /// In ko, this message translates to:
  /// **'장바구니 담기에 실패했습니다.'**
  String get searchCartAddFailed;

  /// No description provided for @searchFormattedReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'(리뷰 {count})'**
  String searchFormattedReviewCount(String count);

  /// No description provided for @searchAllProducts.
  ///
  /// In ko, this message translates to:
  /// **'전체 상품'**
  String get searchAllProducts;

  /// No description provided for @searchCategoryProducts.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 상품'**
  String get searchCategoryProducts;

  /// No description provided for @searchResultsTitle.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과'**
  String get searchResultsTitle;

  /// No description provided for @searchAboutRti.
  ///
  /// In ko, this message translates to:
  /// **'Re:view Trust Index(RTI)란?'**
  String get searchAboutRti;

  /// No description provided for @searchAboutRtiDescription.
  ///
  /// In ko, this message translates to:
  /// **'실제 구매자 리뷰의 신뢰도를 종합해 산출한 지표입니다.'**
  String get searchAboutRtiDescription;

  /// No description provided for @searchFormattedProductCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 상품'**
  String searchFormattedProductCount(String count);

  /// No description provided for @searchQuickFilterAllCount.
  ///
  /// In ko, this message translates to:
  /// **'전체 {count}'**
  String searchQuickFilterAllCount(int count);

  /// No description provided for @searchMultiStoreTitle.
  ///
  /// In ko, this message translates to:
  /// **'멀티 스토어 통합 검색'**
  String get searchMultiStoreTitle;

  /// No description provided for @searchComparedProducts.
  ///
  /// In ko, this message translates to:
  /// **'비교 상품'**
  String get searchComparedProducts;

  /// No description provided for @searchCollectedReviews.
  ///
  /// In ko, this message translates to:
  /// **'수집 리뷰'**
  String get searchCollectedReviews;

  /// No description provided for @searchNotCounted.
  ///
  /// In ko, this message translates to:
  /// **'미집계'**
  String get searchNotCounted;

  /// No description provided for @searchReviewBasedComparison.
  ///
  /// In ko, this message translates to:
  /// **'실사용 리뷰 기반 비교'**
  String get searchReviewBasedComparison;

  /// No description provided for @searchComparisonDescription.
  ///
  /// In ko, this message translates to:
  /// **'가격과 리뷰, RTI 신뢰도를 한 번에 비교해 신뢰도 높은 상품을 빠르게 골라보세요.'**
  String get searchComparisonDescription;

  /// No description provided for @searchLowestPriceComparison.
  ///
  /// In ko, this message translates to:
  /// **'최저가 비교'**
  String get searchLowestPriceComparison;

  /// No description provided for @searchReviewTrust.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도'**
  String get searchReviewTrust;

  /// No description provided for @searchFastDelivery.
  ///
  /// In ko, this message translates to:
  /// **'빠른 배송'**
  String get searchFastDelivery;

  /// No description provided for @searchOfficialStores.
  ///
  /// In ko, this message translates to:
  /// **'공식몰 포함'**
  String get searchOfficialStores;

  /// No description provided for @searchVeryHighTrust.
  ///
  /// In ko, this message translates to:
  /// **'매우 신뢰 높음'**
  String get searchVeryHighTrust;

  /// No description provided for @searchModerateTrust.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get searchModerateTrust;

  /// No description provided for @searchLowTrust.
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get searchLowTrust;

  /// No description provided for @searchComparedProductCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String searchComparedProductCount(String count);

  /// No description provided for @searchCollectedReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}건'**
  String searchCollectedReviewCount(String count);

  /// No description provided for @searchUnconfirmedCategoriesNotice.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑몰 상품은 카테고리 이름으로 검색하며, 분류가 확정되지 않은 결과도 함께 표시합니다. 상세 분류는 쇼핑몰 원문을 확인해 주세요.'**
  String get searchUnconfirmedCategoriesNotice;

  /// No description provided for @searchCatalogPageScope.
  ///
  /// In ko, this message translates to:
  /// **'필터와 정렬은 현재 페이지에만 적용돼요.'**
  String get searchCatalogPageScope;

  /// No description provided for @searchCatalogParentScope.
  ///
  /// In ko, this message translates to:
  /// **'필터와 정렬은 현재 페이지에만 적용돼요. 전체 상품 수와 페이지는 대분류 기준이에요.'**
  String get searchCatalogParentScope;

  /// No description provided for @searchLoadedProductsScope.
  ///
  /// In ko, this message translates to:
  /// **'현재 불러온 {count}개 상품에서 필터·정렬합니다. 키워드 검색은 최대 {limit}개 결과이며 전체 쇼핑몰 상품 검색 필터가 아닙니다. 배송·판매량·출시일·사진 리뷰 정보는 제공되지 않아 해당 조건은 지원하지 않습니다.'**
  String searchLoadedProductsScope(int count, int limit);

  /// No description provided for @searchSortAccuracy.
  ///
  /// In ko, this message translates to:
  /// **'추천순'**
  String get searchSortAccuracy;

  /// No description provided for @searchSortRti.
  ///
  /// In ko, this message translates to:
  /// **'RTI순'**
  String get searchSortRti;

  /// No description provided for @searchSortReviewCount.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 많은순'**
  String get searchSortReviewCount;

  /// No description provided for @searchSortSales.
  ///
  /// In ko, this message translates to:
  /// **'판매 많은순'**
  String get searchSortSales;

  /// No description provided for @searchSortPriceLow.
  ///
  /// In ko, this message translates to:
  /// **'최저가순'**
  String get searchSortPriceLow;

  /// No description provided for @searchSortPriceHigh.
  ///
  /// In ko, this message translates to:
  /// **'높은 가격순'**
  String get searchSortPriceHigh;

  /// No description provided for @searchSortNewest.
  ///
  /// In ko, this message translates to:
  /// **'신상품순'**
  String get searchSortNewest;

  /// No description provided for @searchMissingClassification.
  ///
  /// In ko, this message translates to:
  /// **'분류 정보 없음'**
  String get searchMissingClassification;

  /// No description provided for @cartSelectionSummary.
  ///
  /// In ko, this message translates to:
  /// **'선택 상품 요약'**
  String get cartSelectionSummary;

  /// No description provided for @cartUnknownPriceExcluded.
  ///
  /// In ko, this message translates to:
  /// **'가격 정보가 없는 상품은 합계에서 제외했어요.'**
  String get cartUnknownPriceExcluded;

  /// No description provided for @cartReferencePriceNotice.
  ///
  /// In ko, this message translates to:
  /// **'표시 가격은 참고용입니다. 구매와 배송비·쿠폰 확인은 각 쇼핑몰에서 진행해 주세요.'**
  String get cartReferencePriceNotice;

  /// No description provided for @cartViewSelectedSellers.
  ///
  /// In ko, this message translates to:
  /// **'선택 상품 구매처 확인'**
  String get cartViewSelectedSellers;

  /// No description provided for @cartContinueShopping.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑 계속하기'**
  String get cartContinueShopping;

  /// No description provided for @cartShippingConditions.
  ///
  /// In ko, this message translates to:
  /// **'배송 조건은 구매처에서 확인'**
  String get cartShippingConditions;

  /// No description provided for @cartSaveLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에 담기'**
  String get cartSaveLater;

  /// No description provided for @cartDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get cartDelete;

  /// No description provided for @cartTrustLevel.
  ///
  /// In ko, this message translates to:
  /// **'신뢰도 {level}'**
  String cartTrustLevel(String level);

  /// No description provided for @cartPriceReduction.
  ///
  /// In ko, this message translates to:
  /// **'{price} 인하'**
  String cartPriceReduction(String price);

  /// No description provided for @cartEstimatedArrival.
  ///
  /// In ko, this message translates to:
  /// **'{date} 도착 예정'**
  String cartEstimatedArrival(String date);

  /// No description provided for @cartStockRemaining.
  ///
  /// In ko, this message translates to:
  /// **'재고 {count}개 남음'**
  String cartStockRemaining(int count);

  /// No description provided for @cartDeleteSelected.
  ///
  /// In ko, this message translates to:
  /// **'선택 삭제'**
  String get cartDeleteSelected;

  /// No description provided for @cartMoveToWishlist.
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품으로 이동'**
  String get cartMoveToWishlist;

  /// No description provided for @cartSelectAllCount.
  ///
  /// In ko, this message translates to:
  /// **'전체 선택 ({selected}/{total})'**
  String cartSelectAllCount(int selected, int total);

  /// No description provided for @cartSellersTitle.
  ///
  /// In ko, this message translates to:
  /// **'구매처 확인'**
  String get cartSellersTitle;

  /// No description provided for @cartSellersDescription.
  ///
  /// In ko, this message translates to:
  /// **'상품 상세에서 제공되는 쇼핑몰 구매 링크를 이용해 주세요. TEST 주문 기능은 별도 화면에서 준비하며 현재 서버 판매·배송 계약은 없습니다.'**
  String get cartSellersDescription;

  /// No description provided for @cartViewProductAndSeller.
  ///
  /// In ko, this message translates to:
  /// **'상품 상세 및 구매처 보기'**
  String get cartViewProductAndSeller;

  /// No description provided for @cartDescription.
  ///
  /// In ko, this message translates to:
  /// **'담아둔 상품을 확인하고 주문 전 리뷰 신뢰도도 함께 비교하세요.'**
  String get cartDescription;

  /// No description provided for @cartTrustCheckTitle.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도 체크'**
  String get cartTrustCheckTitle;

  /// No description provided for @cartTrustCheckDescription.
  ///
  /// In ko, this message translates to:
  /// **'제품별 RTI 지수를 확인하고, 신뢰할 수 있는 리뷰가 많은 상품을 선택해보세요.'**
  String get cartTrustCheckDescription;

  /// No description provided for @cartTotalProducts.
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개 상품'**
  String cartTotalProducts(int count);

  /// No description provided for @wishlistCountItems.
  ///
  /// In ko, this message translates to:
  /// **'{count}개'**
  String wishlistCountItems(int count);

  /// No description provided for @wishlistShoppingMall.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑몰'**
  String get wishlistShoppingMall;

  /// No description provided for @wishlistPriceComparisonUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'서버에서 가격하락 비교 정보를 제공하지 않고 있어요. 가격이 변하지 않았다는 뜻은 아니에요.'**
  String get wishlistPriceComparisonUnavailable;

  /// No description provided for @wishlistUncategorized.
  ///
  /// In ko, this message translates to:
  /// **'미분류'**
  String get wishlistUncategorized;

  /// No description provided for @wishlistShopUnknown.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑몰 정보 없음'**
  String get wishlistShopUnknown;

  /// No description provided for @myPageTrustUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'찜 상품의 분석 정보를 확인할 수 없어요.'**
  String get myPageTrustUnavailable;

  /// No description provided for @myPageTrustScope.
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품 중 분석된 RTI의 평균과 서버 주의 등급 기준입니다.'**
  String get myPageTrustScope;

  /// No description provided for @myPageTrustScorePoints.
  ///
  /// In ko, this message translates to:
  /// **'{score}점'**
  String myPageTrustScorePoints(int score);

  /// No description provided for @myPageBack.
  ///
  /// In ko, this message translates to:
  /// **'마이페이지로 돌아가기'**
  String get myPageBack;

  /// No description provided for @myPageActivityLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'최근 활동을 불러오지 못했어요.'**
  String get myPageActivityLoadFailed;

  /// No description provided for @myPageActivityRecent.
  ///
  /// In ko, this message translates to:
  /// **'최근'**
  String get myPageActivityRecent;

  /// No description provided for @myPageActivityJustNow.
  ///
  /// In ko, this message translates to:
  /// **'방금 전'**
  String get myPageActivityJustNow;

  /// No description provided for @myPageActivityDaysAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}일 전'**
  String myPageActivityDaysAgo(int count);

  /// No description provided for @myPageActivityHoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}시간 전'**
  String myPageActivityHoursAgo(int count);

  /// No description provided for @myPageNamedDescription.
  ///
  /// In ko, this message translates to:
  /// **'{name}님의 정보와 저장한 상품 활동을 관리해요.'**
  String myPageNamedDescription(String name);

  /// No description provided for @myPageWarningScope.
  ///
  /// In ko, this message translates to:
  /// **'찜한 상품 중 서버가 의심·위험 등급으로 분석한 상품이에요. 분석 전 상품은 포함하지 않아요.'**
  String get myPageWarningScope;

  /// No description provided for @myPageCheckList.
  ///
  /// In ko, this message translates to:
  /// **'목록 확인'**
  String get myPageCheckList;

  /// No description provided for @myPageAllWarnings.
  ///
  /// In ko, this message translates to:
  /// **'전체 주의'**
  String get myPageAllWarnings;

  /// No description provided for @myPageLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'주의 상품을 확인할 수 없어요.'**
  String get myPageLoadFailed;

  /// No description provided for @myPageViewListCount.
  ///
  /// In ko, this message translates to:
  /// **'목록 보기 ({count})'**
  String myPageViewListCount(int count);

  /// No description provided for @recentProductsScope.
  ///
  /// In ko, this message translates to:
  /// **'서버의 최근 {count}개 조회 기록에서 중복 상품을 제외했어요. 전체 기간의 상품 수와는 다를 수 있어요.'**
  String recentProductsScope(int count);

  /// No description provided for @recentProductsLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'최근 본 상품을 불러오지 못했어요.'**
  String get recentProductsLoadFailed;

  /// No description provided for @notificationsAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 알림'**
  String get notificationsAll;

  /// No description provided for @notificationsPriceAlerts.
  ///
  /// In ko, this message translates to:
  /// **'가격 알림'**
  String get notificationsPriceAlerts;

  /// No description provided for @notificationsSavedSettings.
  ///
  /// In ko, this message translates to:
  /// **'저장된 알림 수신 설정'**
  String get notificationsSavedSettings;

  /// No description provided for @notificationsMore.
  ///
  /// In ko, this message translates to:
  /// **'더 보기'**
  String get notificationsMore;

  /// No description provided for @notificationsTargetUnsupported.
  ///
  /// In ko, this message translates to:
  /// **'이 알림의 이동 대상은 아직 지원되지 않습니다.'**
  String get notificationsTargetUnsupported;

  /// No description provided for @notificationsCheckingUnreadShort.
  ///
  /// In ko, this message translates to:
  /// **'읽지 않은 알림 확인 중'**
  String get notificationsCheckingUnreadShort;

  /// No description provided for @notificationsUnreadFailedShort.
  ///
  /// In ko, this message translates to:
  /// **'알림 수를 확인하지 못했어요.'**
  String get notificationsUnreadFailedShort;

  /// No description provided for @notificationsManageInboxAndPrices.
  ///
  /// In ko, this message translates to:
  /// **'알림함 · 가격 알림 관리'**
  String get notificationsManageInboxAndPrices;

  /// No description provided for @notificationsServiceTitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 알림'**
  String get notificationsServiceTitle;

  /// No description provided for @notificationsCheckingUnread.
  ///
  /// In ko, this message translates to:
  /// **'읽지 않은 알림을 확인하고 있어요.'**
  String get notificationsCheckingUnread;

  /// No description provided for @notificationsUnreadFailed.
  ///
  /// In ko, this message translates to:
  /// **'읽지 않은 알림 수를 확인하지 못했어요.'**
  String get notificationsUnreadFailed;

  /// No description provided for @notificationsSettingsFailed.
  ///
  /// In ko, this message translates to:
  /// **'저장된 알림 설정을 불러오지 못했어요.'**
  String get notificationsSettingsFailed;

  /// No description provided for @notificationsSettingsChecking.
  ///
  /// In ko, this message translates to:
  /// **'저장된 알림 설정 확인 중'**
  String get notificationsSettingsChecking;

  /// No description provided for @notificationsReviewSettings.
  ///
  /// In ko, this message translates to:
  /// **'알림·리뷰 설정'**
  String get notificationsReviewSettings;

  /// No description provided for @notificationsMonitoringNotice.
  ///
  /// In ko, this message translates to:
  /// **'위험 변화 자동 감시는 서버 연동이 필요해요. 수신 설정을 켜는 것만으로 감시가 시작되지는 않아요.'**
  String get notificationsMonitoringNotice;

  /// No description provided for @notificationsInboxNotice.
  ///
  /// In ko, this message translates to:
  /// **'알림함에 저장된 알림을 확인해요. 브라우저 푸시·이메일·문자는 지원하지 않아요.'**
  String get notificationsInboxNotice;

  /// No description provided for @notificationsUnreadCount.
  ///
  /// In ko, this message translates to:
  /// **'읽지 않은 알림 {count}개'**
  String notificationsUnreadCount(int count);

  /// No description provided for @notificationsReceiving.
  ///
  /// In ko, this message translates to:
  /// **'받음'**
  String get notificationsReceiving;

  /// No description provided for @notificationsNotReceiving.
  ///
  /// In ko, this message translates to:
  /// **'받지 않음'**
  String get notificationsNotReceiving;

  /// No description provided for @notificationsRiskStatus.
  ///
  /// In ko, this message translates to:
  /// **'위험 감지 {status}'**
  String notificationsRiskStatus(String status);

  /// No description provided for @notificationsAnalysisStatus.
  ///
  /// In ko, this message translates to:
  /// **'분석 결과 {status}'**
  String notificationsAnalysisStatus(String status);

  /// No description provided for @notificationsFeedbackStatus.
  ///
  /// In ko, this message translates to:
  /// **'처리 결과 {status}'**
  String notificationsFeedbackStatus(String status);

  /// No description provided for @priceWatchTitle.
  ///
  /// In ko, this message translates to:
  /// **'가격하락 · 가격 알림 관리'**
  String get priceWatchTitle;

  /// No description provided for @priceWatchHistoryNotice.
  ///
  /// In ko, this message translates to:
  /// **'가격 알림 이력·구독 저장은 아직 지원되지 않아요. 아래는 알림 기록이 아닌 찜 상품의 서버 가격하락 표시입니다.'**
  String get priceWatchHistoryNotice;

  /// No description provided for @priceWatchComparisonUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'서버가 찜 상품의 비교 가격 정보를 제공하지 않아 하락 여부를 확인할 수 없어요.'**
  String get priceWatchComparisonUnavailable;

  /// No description provided for @priceWatchRefreshWishlistPrices.
  ///
  /// In ko, this message translates to:
  /// **'찜 가격 정보 새로고침'**
  String get priceWatchRefreshWishlistPrices;

  /// No description provided for @priceWatchViewWishlist.
  ///
  /// In ko, this message translates to:
  /// **'찜 상품 확인'**
  String get priceWatchViewWishlist;

  /// No description provided for @priceWatchSubscriptionNotice.
  ///
  /// In ko, this message translates to:
  /// **'서버 가격이력·구독 저장 연동 후 신청할 수 있어요.'**
  String get priceWatchSubscriptionNotice;

  /// No description provided for @priceWatchSubscriptionUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'가격 알림 신청 · 미지원'**
  String get priceWatchSubscriptionUnavailable;

  /// No description provided for @priceWatchDropIndicator.
  ///
  /// In ko, this message translates to:
  /// **'서버 가격하락 표시 · 하락액/비율 정보 없음'**
  String get priceWatchDropIndicator;

  /// No description provided for @priceWatchLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'가격하락 표시를 확인하지 못했어요. {message}'**
  String priceWatchLoadFailed(String message);

  /// No description provided for @priceWatchDropCounts.
  ///
  /// In ko, this message translates to:
  /// **'찜 {total}개 중 가격하락 정보가 있는 {known}개에서 {drops}개가 하락으로 표시됐어요. 기준 가격·시점은 제공되지 않았어요.'**
  String priceWatchDropCounts(int total, int known, int drops);

  /// No description provided for @extProgressPreviousComplete.
  ///
  /// In ko, this message translates to:
  /// **'수집·분석 완료 · 이전 수집 정보'**
  String get extProgressPreviousComplete;

  /// No description provided for @extProgressPreviousInfo.
  ///
  /// In ko, this message translates to:
  /// **'이전에 수집한 정보'**
  String get extProgressPreviousInfo;

  /// No description provided for @extReviewSummaryTitle.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 요약'**
  String get extReviewSummaryTitle;

  /// No description provided for @extReviewRatingSummary.
  ///
  /// In ko, this message translates to:
  /// **'불러온 리뷰 {count}개 · 평균 {rating}점 · {distribution}'**
  String extReviewRatingSummary(int count, String rating, String distribution);

  /// No description provided for @extReviewStarCount.
  ///
  /// In ko, this message translates to:
  /// **'{stars}점 {count}개'**
  String extReviewStarCount(int stars, int count);

  /// No description provided for @extReviewKeywords.
  ///
  /// In ko, this message translates to:
  /// **'자주 언급된 표현: {keywords}'**
  String extReviewKeywords(String keywords);

  /// No description provided for @extReviewPositive.
  ///
  /// In ko, this message translates to:
  /// **'긍정 리뷰: “{excerpt}”'**
  String extReviewPositive(String excerpt);

  /// No description provided for @extReviewNegative.
  ///
  /// In ko, this message translates to:
  /// **'아쉬운 리뷰: “{excerpt}”'**
  String extReviewNegative(String excerpt);

  /// No description provided for @extReviewSummaryRequest.
  ///
  /// In ko, this message translates to:
  /// **'AI로 리뷰 요약 받기'**
  String get extReviewSummaryRequest;

  /// No description provided for @extReviewSummaryQuestion.
  ///
  /// In ko, this message translates to:
  /// **'이 상품 리뷰들을 장점과 아쉬운 점으로 짧게 요약해 줘'**
  String get extReviewSummaryQuestion;

  /// No description provided for @extSummaryEvidenceToggle.
  ///
  /// In ko, this message translates to:
  /// **'분석 상태·근거 보기'**
  String get extSummaryEvidenceToggle;

  /// No description provided for @chatHistoryProductLoading.
  ///
  /// In ko, this message translates to:
  /// **'상품 정보 불러오는 중'**
  String get chatHistoryProductLoading;

  /// No description provided for @chatHistoryEmptyHint.
  ///
  /// In ko, this message translates to:
  /// **'새 대화를 시작하면 이곳에서 다시 볼 수 있어요.'**
  String get chatHistoryEmptyHint;

  /// No description provided for @chatHistoryConversationCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 대화'**
  String chatHistoryConversationCount(int count);

  /// No description provided for @chatHistoryToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 {time}'**
  String chatHistoryToday(String time);

  /// No description provided for @chatHistoryMenu.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get chatHistoryMenu;

  /// No description provided for @chatHistoryDelete.
  ///
  /// In ko, this message translates to:
  /// **'대화 삭제'**
  String get chatHistoryDelete;

  /// No description provided for @chatHistoryDeleteAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 삭제'**
  String get chatHistoryDeleteAll;

  /// No description provided for @chatHistoryDeleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 기기의 대화 목록에서 삭제할까요?'**
  String get chatHistoryDeleteConfirm;

  /// No description provided for @chatHistoryDeleteAllConfirm.
  ///
  /// In ko, this message translates to:
  /// **'모든 대화를 이 기기의 대화 목록에서 삭제할까요?'**
  String get chatHistoryDeleteAllConfirm;

  /// No description provided for @chatHistoryCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get chatHistoryCancel;

  /// No description provided for @chatHistoryDeleteError.
  ///
  /// In ko, this message translates to:
  /// **'대화를 삭제하지 못했어요. 다시 시도해 주세요.'**
  String get chatHistoryDeleteError;

  /// No description provided for @extSummaryCompleteBadge.
  ///
  /// In ko, this message translates to:
  /// **'수집·분석 완료'**
  String get extSummaryCompleteBadge;

  /// No description provided for @extSummaryReviewBasis.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 {count}개'**
  String extSummaryReviewBasis(String count);

  /// No description provided for @extSummaryFrequentPhrases.
  ///
  /// In ko, this message translates to:
  /// **'자주 나온 표현'**
  String get extSummaryFrequentPhrases;

  /// No description provided for @extSummaryPositiveLabel.
  ///
  /// In ko, this message translates to:
  /// **'긍정 리뷰'**
  String get extSummaryPositiveLabel;

  /// No description provided for @extSummaryNegativeLabel.
  ///
  /// In ko, this message translates to:
  /// **'아쉬운 점'**
  String get extSummaryNegativeLabel;

  /// No description provided for @extSummaryQuotaHint.
  ///
  /// In ko, this message translates to:
  /// **'하루 질문 한도 1회 사용'**
  String get extSummaryQuotaHint;

  /// No description provided for @extSummaryLayoutComment.
  ///
  /// In ko, this message translates to:
  /// **'불러온 리뷰의 별점과 자주 나온 표현을 모았어요.'**
  String get extSummaryLayoutComment;

  /// No description provided for @extSummaryRatedReviewBasis.
  ///
  /// In ko, this message translates to:
  /// **'별점 있는 리뷰 {count}개 기준'**
  String extSummaryRatedReviewBasis(String count);

  /// No description provided for @extTrustLoadedSource.
  ///
  /// In ko, this message translates to:
  /// **'불러온 리뷰 {count}개 기준'**
  String extTrustLoadedSource(String count);

  /// No description provided for @extTrustLoadedAverage.
  ///
  /// In ko, this message translates to:
  /// **'평균 RTI'**
  String get extTrustLoadedAverage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
