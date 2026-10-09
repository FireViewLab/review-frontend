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

  /// 앱 이름
  ///
  /// In ko, this message translates to:
  /// **'Re:view'**
  String get appTitle;

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

  /// 장바구니 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'장바구니'**
  String get navCart;

  /// 위시리스트 네비게이션 항목
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품'**
  String get navWishlist;

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

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get actionCancel;

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

  /// 뒤로가기 버튼
  ///
  /// In ko, this message translates to:
  /// **'뒤로'**
  String get actionBack;

  /// 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get actionLogin;

  /// 로그아웃 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get actionLogout;

  /// 회원가입 버튼
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get actionSignup;

  /// 전체 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 보기'**
  String get actionViewAll;

  /// 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'불러오는 중입니다.'**
  String get stateLoading;

  /// 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다.'**
  String get stateError;

  /// 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'표시할 항목이 없습니다.'**
  String get stateEmpty;

  /// 설정 저장 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'설정이 저장되었습니다.'**
  String get settingsSaved;

  /// 언어 설정 레이블
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguage;

  /// 알림 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get settingsNotifications;

  /// 분석 필터 설정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'분석 필터 설정'**
  String get settingsFilters;

  /// 언어명 한국어
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get langKorean;

  /// 언어명 영어
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// 언어명 일본어
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get langJapanese;

  /// 언어명 중국어 간체
  ///
  /// In ko, this message translates to:
  /// **'中文(简体)'**
  String get langChinese;

  /// 사이드 네비게이션 주문/배송
  ///
  /// In ko, this message translates to:
  /// **'주문/배송'**
  String get sideNavOrders;

  /// 사이드 네비게이션 최근 본 상품
  ///
  /// In ko, this message translates to:
  /// **'최근 본 상품'**
  String get sideNavRecentlyViewed;

  /// 사이드 네비게이션 리뷰 활동
  ///
  /// In ko, this message translates to:
  /// **'리뷰 활동'**
  String get sideNavReviewActivity;

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

  /// 이메일 알림 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'이메일 알림 받기'**
  String get settingsNotificationEmail;

  /// 이메일 알림 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'상품 가격 변동, 리뷰 업데이트를 이메일로 받아요.'**
  String get settingsNotificationEmailDesc;

  /// 푸시 알림 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'앱 푸시 알림 받기'**
  String get settingsNotificationPush;

  /// 푸시 알림 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'저장한 상품의 실시간 알림을 브라우저에서 받아요.'**
  String get settingsNotificationPushDesc;

  /// 광고 이메일 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'이메일 광고 수신'**
  String get settingsNotificationAdEmail;

  /// 광고 이메일 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'프로모션 및 맞춤 혜택 정보를 이메일로 받아요.'**
  String get settingsNotificationAdEmailDesc;

  /// 주의 상품 강조 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'주의 상품 먼저 보기'**
  String get settingsFilterHighlightLowRti;

  /// 주의 상품 강조 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'리뷰 신뢰도가 낮은 상품을 목록 상단에 표시해요.'**
  String get settingsFilterHighlightLowRtiDesc;

  /// 저장 상품 알림 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'저장 상품 알림 받기'**
  String get settingsFilterWishlistAlert;

  /// 저장 상품 알림 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'관심 상품의 RTI 변화가 있을 때 알림을 드려요.'**
  String get settingsFilterWishlistAlertDesc;

  /// 카테고리 필터 레이블
  ///
  /// In ko, this message translates to:
  /// **'카테고리 필터'**
  String get settingsFilterCategory;

  /// 카테고리 필터 설명
  ///
  /// In ko, this message translates to:
  /// **'선택한 카테고리 상품을 기준으로 분석 결과를 우선 표시해요.'**
  String get settingsFilterCategoryDesc;

  /// 카테고리 전체 선택 옵션
  ///
  /// In ko, this message translates to:
  /// **'전체 카테고리'**
  String get settingsFilterCategoryAll;

  /// 최소 리뷰 개수 필터 레이블
  ///
  /// In ko, this message translates to:
  /// **'리뷰 최소 개수'**
  String get settingsFilterMinReview;

  /// 최소 리뷰 개수 필터 설명
  ///
  /// In ko, this message translates to:
  /// **'이 개수 이상 리뷰가 있는 상품만 분석 결과에 반영해요.'**
  String get settingsFilterMinReviewDesc;

  /// 리뷰 개수 단위
  ///
  /// In ko, this message translates to:
  /// **'개'**
  String get settingsFilterMinReviewSuffix;

  /// 낮은 RTI 경고 기준 레이블
  ///
  /// In ko, this message translates to:
  /// **'낮은 RTI 경고 기준'**
  String get settingsFilterLowRti;

  /// 낮은 RTI 경고 기준 설명
  ///
  /// In ko, this message translates to:
  /// **'RTI 점수가 이 값 이하면 주의 상품으로 분류해요.'**
  String get settingsFilterLowRtiDesc;

  /// RTI 점수 단위
  ///
  /// In ko, this message translates to:
  /// **'점'**
  String get settingsFilterLowRtiSuffix;

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
  /// **'찜한 상품이 없습니다'**
  String get wishlistEmpty;

  /// 위시리스트 빈 상태 설명
  ///
  /// In ko, this message translates to:
  /// **'상품 카드의 하트를 눌러 찜 목록에 추가해보세요.'**
  String get wishlistEmptyDesc;

  /// 위시리스트 빈 상태 탐색 버튼
  ///
  /// In ko, this message translates to:
  /// **'상품 탐색하러 가기'**
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

  /// 브랜드 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'브랜드'**
  String get wishlistFilterBrand;

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

  /// 일반 회원 표시 문구
  ///
  /// In ko, this message translates to:
  /// **'일반 회원 (무료)'**
  String get myPageMemberBasic;

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

  /// 최근 날짜 표시
  ///
  /// In ko, this message translates to:
  /// **'최근'**
  String get myPageRecentLabel;

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

  /// 주의 상품 먼저 보기 레이블
  ///
  /// In ko, this message translates to:
  /// **'주의 상품 먼저 보기'**
  String get myPageHighlightLowRti;

  /// 저장 상품 알림 레이블
  ///
  /// In ko, this message translates to:
  /// **'저장 상품 알림 받기'**
  String get myPageWishlistAlertLabel;

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

  /// 구현 대기 중인 관리자 페이지 안내
  ///
  /// In ko, this message translates to:
  /// **'준비 중인 화면입니다.'**
  String get adminPlaceholderMessage;

  /// 관리자 상단 검색바 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'사용자, 리뷰, 신고 ID로 검색'**
  String get adminTopBarSearchHint;

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

  /// 패널 닫기 버튼
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get chatClose;

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

  /// 상품 상세에서 연 대화 안내
  ///
  /// In ko, this message translates to:
  /// **'이 상품의 리뷰를 바탕으로 답해요'**
  String get chatProductContext;

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

  /// No description provided for @chatLauncherProductLabel.
  ///
  /// In ko, this message translates to:
  /// **'이 상품 리뷰 물어보기'**
  String get chatLauncherProductLabel;

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

  /// No description provided for @planRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get planRetry;

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
  /// **'가짜 리뷰 같아요'**
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
  /// **'사진 리뷰만 보기'**
  String get reviewPhotoOnly;

  /// No description provided for @reviewListView.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 목록'**
  String get reviewListView;

  /// No description provided for @reviewPhotosView.
  ///
  /// In ko, this message translates to:
  /// **'사진만 보기'**
  String get reviewPhotosView;

  /// No description provided for @reviewPhotoScope.
  ///
  /// In ko, this message translates to:
  /// **'불러온 리뷰 {loaded}개 중 사진 리뷰 {photos}개예요. 전체 상품 리뷰 수와 다르며 더보기를 눌러 계속 확인할 수 있어요.'**
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
