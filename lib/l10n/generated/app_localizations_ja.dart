// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => 'ホーム';

  @override
  String get navSearch => '検索';

  @override
  String get navCart => 'カート';

  @override
  String get navWishlist => '保存済み';

  @override
  String get navMyPage => 'マイページ';

  @override
  String get navSettings => '設定';

  @override
  String get actionSave => '保存';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionConfirm => '確認';

  @override
  String get actionRetry => '再試行';

  @override
  String get actionBack => '戻る';

  @override
  String get actionLogin => 'ログイン';

  @override
  String get actionLogout => 'ログアウト';

  @override
  String get actionSignup => '新規登録';

  @override
  String get actionViewAll => 'すべて見る';

  @override
  String get stateLoading => '読み込み中…';

  @override
  String get stateError => 'エラーが発生しました。';

  @override
  String get stateEmpty => '表示する項目がありません。';

  @override
  String get settingsSaved => '設定を保存しました。';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsNotifications => '通知設定';

  @override
  String get settingsFilters => '分析フィルター設定';

  @override
  String get langKorean => '한국어';

  @override
  String get langEnglish => 'English';

  @override
  String get langJapanese => '日本語';

  @override
  String get langChinese => '中文(简体)';

  @override
  String get sideNavOrders => '注文/配送';

  @override
  String get sideNavRecentlyViewed => '最近見た商品';

  @override
  String get sideNavReviewActivity => 'レビュー活動';

  @override
  String get sideNavAccountSettings => 'アカウント設定';

  @override
  String get sideNavFeedbackHistory => 'フィードバック履歴';

  @override
  String get settingsSubtitle => '通知、フィルター、アカウント設定を管理します。';

  @override
  String settingsSubtitleNamed(String nickname) {
    return '$nicknameさんの通知、フィルター、アカウント設定を管理します。';
  }

  @override
  String get settingsNotificationEmail => 'メール通知を受け取る';

  @override
  String get settingsNotificationEmailDesc => '商品価格の変動、レビュー更新をメールで受け取ります。';

  @override
  String get settingsNotificationPush => 'アプリプッシュ通知を受け取る';

  @override
  String get settingsNotificationPushDesc => '保存した商品のリアルタイム通知をブラウザで受け取ります。';

  @override
  String get settingsNotificationAdEmail => 'メール広告の受信';

  @override
  String get settingsNotificationAdEmailDesc => 'プロモーションやカスタム特典情報をメールで受け取ります。';

  @override
  String get settingsFilterHighlightLowRti => '注意商品を先に表示';

  @override
  String get settingsFilterHighlightLowRtiDesc => 'レビュー信頼度が低い商品をリストの上部に表示します。';

  @override
  String get settingsFilterWishlistAlert => '保存商品の通知を受け取る';

  @override
  String get settingsFilterWishlistAlertDesc => 'お気に入り商品のRTI変化があるときに通知します。';

  @override
  String get settingsFilterCategory => 'カテゴリフィルター';

  @override
  String get settingsFilterCategoryDesc => '選択したカテゴリの商品を基準に分析結果を優先表示します。';

  @override
  String get settingsFilterCategoryAll => '全カテゴリ';

  @override
  String get settingsFilterMinReview => 'レビュー最小件数';

  @override
  String get settingsFilterMinReviewDesc => 'この件数以上のレビューがある商品のみ分析結果に反映します。';

  @override
  String get settingsFilterMinReviewSuffix => '件';

  @override
  String get settingsFilterLowRti => '低RTI警告基準';

  @override
  String get settingsFilterLowRtiDesc => 'RTIスコアがこの値以下の場合、注意商品として分類します。';

  @override
  String get settingsFilterLowRtiSuffix => '点';

  @override
  String get settingsAccountTitle => 'アカウント';

  @override
  String get settingsAccountChangePassword => 'パスワード変更';

  @override
  String get settingsAccountLabelName => '名前';

  @override
  String get settingsAccountLabelEmail => 'メール';

  @override
  String get settingsAccountLabelJoinDate => '登録日';

  @override
  String get settingsAccountLabelMemberType => '会員種別';

  @override
  String get settingsAccountDefaultName => 'ユーザー';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role会員';
  }

  @override
  String get settingsLanguageSection => '言語設定';

  @override
  String get settingsLanguageApplyNow => '変更はすぐに適用されます。';

  @override
  String get settingsSavedFeedback => '保存しました';

  @override
  String get wishlistTitle => 'お気に入り';

  @override
  String get wishlistSubtitle => '保存した商品を一目で確認し、価格とレビュー信頼度をチェックしましょう。';

  @override
  String wishlistCount(int count) {
    return 'お気に入り$count件';
  }

  @override
  String get wishlistEmpty => 'お気に入りはありません';

  @override
  String get wishlistEmptyDesc => '商品カードのハートを押してお気に入りに追加しましょう。';

  @override
  String get wishlistBrowse => '商品を探す';

  @override
  String get wishlistFilteredEmpty => '選択したフィルターに該当するお気に入りはありません。';

  @override
  String get wishlistSummaryTitle => 'お気に入りリスト概要';

  @override
  String wishlistSummaryTotal(int count) {
    return '合計$count件';
  }

  @override
  String get wishlistSummaryPriceDrop => '価格下落';

  @override
  String get wishlistSummaryNewAlert => '新着通知';

  @override
  String get wishlistSummaryTotalReview => '総レビュー';

  @override
  String get wishlistProductView => '商品を見る';

  @override
  String get wishlistProductPriceDrop => '価格下落';

  @override
  String get wishlistSortRecent => '最近保存順';

  @override
  String get wishlistSortPriceLow => '低価格順';

  @override
  String get wishlistSortPriceHigh => '高価格順';

  @override
  String get wishlistSortRti => 'RTI高い順';

  @override
  String get wishlistSortReviewCount => 'レビュー多い順';

  @override
  String get wishlistFilterAll => '全体';

  @override
  String get wishlistFilterPriceDrop => '価格下落';

  @override
  String get wishlistFilterRti => 'RTIスコア';

  @override
  String get wishlistFilterLowestPrice => '最安値';

  @override
  String get wishlistFilterBrand => 'ブランド';

  @override
  String get wishlistFilterCategory => 'カテゴリ';

  @override
  String get myPageTitle => 'マイページ';

  @override
  String get myPageLoading => 'マイページ情報を読み込み中です。';

  @override
  String get myPageWishlistLoading => '保存した商品を読み込み中です。';

  @override
  String get myPageWishlistEmpty => '保存した商品はありません。';

  @override
  String get myPageInterestProducts => 'お気に入り商品';

  @override
  String get myPageDefaultName => 'ユーザー';

  @override
  String get myPageMemberBasic => '一般会員（無料）';

  @override
  String get myPageSideNavMyPage => 'マイページ';

  @override
  String get myPageSideNavOrders => '注文/配送';

  @override
  String get myPageSideNavWishlist => '保存した商品';

  @override
  String get myPageSideNavRecentlyViewed => '最近見た商品';

  @override
  String get myPageSideNavRiskyProducts => '注意商品';

  @override
  String get myPageSideNavAlerts => '通知';

  @override
  String get myPageRecentActivity => '最近の活動';

  @override
  String get myPageRecentActivityEmpty => '最近の活動はありません。';

  @override
  String get myPageRecentLabel => '最近';

  @override
  String get myPageReviewTrustSummary => 'レビュー信頼サマリー';

  @override
  String get myPageAvgRti => 'お気に入り商品の平均RTI';

  @override
  String get myPageRtiSaveHint => 'お気に入りを保存するとレビュー信頼度サマリーが表示されます。';

  @override
  String get myPageRiskyNone => '現在ダッシュボードに注意が必要な商品はありません。';

  @override
  String myPageRiskyCount(int count) {
    return '注意商品$count件を確認してください。';
  }

  @override
  String get myPageHighlightLowRti => '注意商品を先に表示';

  @override
  String get myPageWishlistAlertLabel => '保存商品の通知を受け取る';

  @override
  String get myPageAccountInfo => 'アカウント情報';

  @override
  String get myPageAccountInfoSubtitle => '個人情報および基本情報を管理します。';

  @override
  String myPageAccountNickname(String nickname) {
    return 'ニックネーム: $nickname';
  }

  @override
  String myPageAccountEmail(String email) {
    return 'メール: $email';
  }

  @override
  String myPageAccountMemberType(String role) {
    return '会員種別: $role';
  }

  @override
  String get myPageDefaultMemberRole => '一般会員';

  @override
  String get myPageLoginInfo => 'ログイン情報';

  @override
  String get myPageLoginInfoSubtitle => 'メール、ログイン手段を管理します。';

  @override
  String myPageLoginEmail(String email) {
    return 'ログインメール: $email';
  }

  @override
  String get myPageLoginStatus => '認証状態: ログイン済み';

  @override
  String get myPageOnboardingComplete => '完了';

  @override
  String get myPageOnboardingIncomplete => '未完了';

  @override
  String myPageOnboarding(String status) {
    return 'オンボーディング: $status';
  }

  @override
  String get myPageChangePassword => 'パスワード変更';

  @override
  String get myPageChangePasswordSubtitle => '安全なパスワードで管理してください。';

  @override
  String get myPageNotificationSettings => '通知設定';

  @override
  String get myPageNotificationSettingsSubtitle => 'メールおよびプッシュ通知を設定します。';

  @override
  String get myPageAccountSecurity => 'アカウント / セキュリティ';

  @override
  String get navCategory => 'カテゴリ';

  @override
  String get navWishShort => '保存済み';

  @override
  String get navMyShort => 'マイ';

  @override
  String get homeSearchHint => 'レビューを基準に商品を検索してみましょう';

  @override
  String get homeSearchSuggestionsTitle => '関連検索語';

  @override
  String get homeSearchSuggestionsLoading => '関連検索語を読み込んでいます。';

  @override
  String get homeSearchSuggestionsHint => '2文字以上入力すると関連検索語が表示されます。';

  @override
  String get homeRecentSearchTitle => '最近の検索';

  @override
  String get homeRecentSearchDeleteAll => '全て削除';

  @override
  String get homeRecentSearchEmpty => '最近の検索語がありません。';

  @override
  String get homePopularSearchTitle => '人気検索';

  @override
  String get homeSearchProductsTitle => 'おすすめ商品';

  @override
  String get homeTrendingTitle => '今よく検索されているキーワード';

  @override
  String get homeKeywordsEmpty => '表示するキーワードがありません。';

  @override
  String get homeRecommendedTitle => 'エディターが選んだレビュー基準のおすすめ商品';

  @override
  String get homeViewAll => '全て見る';

  @override
  String get homeLoginRequired => 'ログインが必要です。';

  @override
  String get homeBenefitTitle => '初回購入のお客様へのご特典';

  @override
  String get homeBenefitSubtitle => 'レビュー基準のショッピングを始めると受け取れる会員特典です。';

  @override
  String get homeBenefitButton => '特典を受け取る';

  @override
  String get homeTrustDescription =>
      '広告・操作レビューをフィルタリングし、実使用レビューを分析して信頼度を提供します。';

  @override
  String get homeTrustViewMore => '詳しく見る';

  @override
  String get homeTrustLabel1 => '実使用レビュー分析';

  @override
  String get homeTrustLabel2 => '広告/操作フィルタリング';

  @override
  String get homeTrustLabel3 => '信頼度スコア提供';

  @override
  String get homePopularCategoryTitle => '人気カテゴリ';

  @override
  String get homeCategoryEmpty => '表示するカテゴリがありません。';

  @override
  String get feedbackHistoryTitle => 'フィードバック履歴';

  @override
  String get feedbackHistorySubtitle => '投稿した商品・レビューのフィードバック履歴を確認できます。';

  @override
  String get feedbackHistoryLoading => 'フィードバック履歴を読み込んでいます。';

  @override
  String get feedbackHistoryEmpty => '投稿したフィードバックがありません。';

  @override
  String get feedbackHistoryEmptyDesc => '商品詳細ページでレビューフィードバックを投稿できます。';

  @override
  String feedbackHistoryCount(int count) {
    return '$count件のフィードバック';
  }

  @override
  String get feedbackHistoryViewProduct => '商品を見る';

  @override
  String get feedbackStatusSubmitted => '受付';

  @override
  String get feedbackStatusPending => '審査中';

  @override
  String get feedbackStatusAccepted => '処理済み';

  @override
  String get feedbackStatusRejected => '却下';

  @override
  String get adminSidebarTitle => '管理者';

  @override
  String get adminMenuDashboard => 'ダッシュボード';

  @override
  String get adminMenuSuspiciousReviews => '不審なレビュー管理';

  @override
  String get adminMenuReports => '通報管理';

  @override
  String get adminMenuAnalysisFeedbacks => '分析フィードバック管理';

  @override
  String get adminMenuUsers => 'ユーザー管理';

  @override
  String get adminMenuLogout => 'ログアウト';

  @override
  String get adminDashboardTitle => '運営ダッシュボード';

  @override
  String get adminPlaceholderMessage => '現在準備中の画面です。';

  @override
  String get adminTopBarSearchHint => 'ユーザー、レビュー、通報IDで検索';

  @override
  String get adminTopBarNotifications => '通知';

  @override
  String get chatLauncherTooltip => 'AIアシスタントを開く';

  @override
  String get chatTitle => 'Re:view AI';

  @override
  String get chatSubtitle => 'レビューと購入判断をお手伝いします';

  @override
  String get chatNewConversation => '新しい会話';

  @override
  String get chatClose => '閉じる';

  @override
  String get chatInputHint => '質問を入力してください';

  @override
  String get chatSend => '送信';

  @override
  String get chatProductContext => 'この商品のレビューをもとに回答します';

  @override
  String get chatOtherProductNotice => '別の商品についての会話が続いています';

  @override
  String get chatStartWithThisProduct => 'この商品で新しい会話';

  @override
  String get chatEmptyTitle => 'レビューで気になることを聞いてください';

  @override
  String get chatEmptyBody => 'レビューの信頼度や広告レビューの見分け方をお手伝いします。';

  @override
  String get chatSuggestProduct1 => 'この商品のレビューは信頼できる？';

  @override
  String get chatSuggestProduct2 => '広告っぽいレビューは多い？';

  @override
  String get chatSuggestProduct3 => '実際の購入者が挙げる欠点は？';

  @override
  String get chatSuggestGeneral1 => 'RTIスコアはどう決まる？';

  @override
  String get chatSuggestGeneral2 => '広告レビューはどう見分ける？';

  @override
  String get chatThinking => '回答を準備しています';

  @override
  String get chatLoginTitle => 'ログインしてAIに質問しましょう';

  @override
  String get chatLoginBody => '会話はアカウントに保存されます。';

  @override
  String get chatLoginButton => 'ログイン';

  @override
  String get chatErrorUnavailable => 'チャットボットが一時的に応答できません。しばらくしてから再度お試しください。';

  @override
  String get chatErrorTimeout => '回答に時間がかかっています。もう一度お試しください。';

  @override
  String get chatErrorNetwork => 'ネットワーク接続を確認してください。';

  @override
  String get chatErrorUnknown => '回答を取得できませんでした。';

  @override
  String get chatRetry => '再試行';

  @override
  String get chatDisclaimer => 'AIの回答は参考情報であり、誤りを含む場合があります。';

  @override
  String get settingsReviewDisplay => 'レビュー表示';

  @override
  String get settingsPrivacy => '個人情報';

  @override
  String get settingsRtiThreshold => '最低RTI基準';

  @override
  String get settingsRtiThresholdDesc => 'このRTI値を下回るレビューを絞り込む基準です。';

  @override
  String get settingsReviewSort => 'レビューの初期並び順';

  @override
  String get settingsSortVerifiedRecent => '購入確認済み・新しい順';

  @override
  String get settingsSortRecent => '新しい順';

  @override
  String get settingsSortHelpful => '役に立った順';

  @override
  String get settingsRtiLabel => 'RTIラベルの表示';

  @override
  String get settingsLabelSmall => '小さなバッジ';

  @override
  String get settingsLabelLarge => '大きなバッジ';

  @override
  String get settingsLabelNone => '表示しない';

  @override
  String get settingsCardDensity => '商品カードの密度';

  @override
  String get settingsDensityComfortable => 'ゆったり';

  @override
  String get settingsDensityCompact => 'コンパクト';

  @override
  String get settingsLoading => '設定を読み込んでいます。';

  @override
  String get settingsLoadFailed => '設定を読み込めませんでした。';

  @override
  String get settingsSaveFailed => '設定を保存できませんでした。';

  @override
  String get settingsRiskyProduct => '危険な商品の通知';

  @override
  String get settingsRiskyProductDesc => '保存した商品の危険度が上がると通知します。';

  @override
  String get settingsAnalysisComplete => '分析完了の通知';

  @override
  String get settingsAnalysisCompleteDesc => '商品の分析が完了すると通知します。';

  @override
  String get settingsFeedbackResult => 'フィードバック結果の通知';

  @override
  String get settingsFeedbackResultDesc => '報告とフィードバックの処理結果を通知します。';

  @override
  String get settingsMarketing => 'マーケティング通知';

  @override
  String get settingsMarketingDesc => 'おすすめ商品やマーケティング通知を受け取ります。';

  @override
  String get settingsHideRisky => '危険なレビューを隠す';

  @override
  String get settingsHideRiskyDesc => '危険なレビューを最初は折りたたんで表示します。';

  @override
  String get settingsSuspiciousLabel => '疑わしいレビューのラベル';

  @override
  String get settingsSuspiciousLabelDesc => '疑わしいレビューにラベルを表示します。';

  @override
  String get settingsVerifiedFirst => '購入確認済みレビューを優先';

  @override
  String get settingsVerifiedFirstDesc => '購入確認済みのレビューを先に表示します。';

  @override
  String get settingsAutoAnalysis => '分析ポップアップを自動表示';

  @override
  String get settingsAutoAnalysisDesc => '危険なレビューをクリックすると分析詳細を開きます。';

  @override
  String get settingsDataAnalysis => 'レビュー分析データの利用に同意';

  @override
  String get settingsDataAnalysisDesc => 'レビュー分析のためのデータ利用に同意します。';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsMarkAllRead => 'すべて既読';

  @override
  String get notificationsLoading => '通知を読み込んでいます';

  @override
  String get notificationsEmpty => '通知はありません';

  @override
  String get notificationsEmptyBody => '通報・フィードバックの処理結果や分析完了をここでお知らせします。';

  @override
  String get headerNotifications => '通知';

  @override
  String get chatPreviousConversations => '以前の会話';

  @override
  String get chatBackToConversation => '会話に戻る';

  @override
  String get chatHistoryLoading => '以前の会話を読み込んでいます。';

  @override
  String get chatHistoryEmpty => '以前の会話はありません。';

  @override
  String get chatHistoryLoadError => '以前の会話を読み込めませんでした。もう一度お試しください。';

  @override
  String get chatHistoryLoadMore => 'さらに読み込む';

  @override
  String get chatHistoryUntitled => 'タイトルのない会話';

  @override
  String get adminUsersSubtitle => '登録ユーザーを登録日の新しい順に確認できます。';

  @override
  String get adminRefresh => '更新';

  @override
  String get adminTotalUsers => '全ユーザー';

  @override
  String get adminRetry => '再試行';

  @override
  String get adminEmail => 'メール';

  @override
  String get adminNickname => 'ニックネーム';

  @override
  String get adminRole => '権限';

  @override
  String get adminSignupProvider => '登録方法';

  @override
  String get adminAtiScore => 'ATIスコア';

  @override
  String get adminJoinedAt => '登録日';

  @override
  String get adminUserRole => 'ユーザー';

  @override
  String get adminUsersEmpty => '登録ユーザーはいません。';

  @override
  String get adminNaver => 'Naver';

  @override
  String get adminReportPending => '確認待ち';

  @override
  String get adminUnderReview => '確認中';

  @override
  String get adminReportAccepted => '承認';

  @override
  String get adminReportRejected => '却下';

  @override
  String get adminDanger => '危険';

  @override
  String get adminWarning => '警告';

  @override
  String get adminSafe => '安全';

  @override
  String get adminFeedbackSubmitted => '受付済み';

  @override
  String get adminFeedbackResolved => '対応済み';

  @override
  String get adminFeedbackRejected => '差し戻し';

  @override
  String get adminJudgmentTrustworthy => '信頼度がもっと高い';

  @override
  String get adminJudgmentRisky => '危険度がもっと高い';

  @override
  String get adminJudgmentUndecided => '判断保留';

  @override
  String get adminReviewDetails => 'レビュー詳細';

  @override
  String get adminViewProduct => '商品ページを開く';

  @override
  String get adminRtiAnalysis => 'RTI分析結果';

  @override
  String get adminScoreUnit => '点';

  @override
  String get adminReviewContent => 'レビュー内容';

  @override
  String adminDetectedSignals(int count) {
    return '検出シグナル（$count）';
  }

  @override
  String get adminVerifiedPurchase => '購入認証';

  @override
  String get adminVerified => '認証済み';

  @override
  String get adminNotVerified => '未認証';

  @override
  String get adminReviewerInfo => '投稿者情報';

  @override
  String get adminReviewer => '投稿者';

  @override
  String get adminRating => '評価';

  @override
  String get adminWrittenAt => '投稿日';

  @override
  String adminSelectedCount(int count) {
    return '$count件選択中';
  }

  @override
  String get adminSaved => '変更を保存しました。';

  @override
  String get adminSaveFailed => '保存に失敗しました。';

  @override
  String get adminFeedbackDetails => 'フィードバック詳細';

  @override
  String get adminSaveChanges => '変更を保存';

  @override
  String get adminFeedbackId => 'フィードバックID';

  @override
  String get adminReviewId => 'レビューID';

  @override
  String get adminProductName => '商品名';

  @override
  String get adminCreatedAt => '登録日';

  @override
  String get adminUpdatedAt => '更新日';

  @override
  String get adminFeedbackType => 'フィードバック種類';

  @override
  String get adminUserJudgment => 'ユーザー判断';

  @override
  String adminRelatedSignals(int count) {
    return '関連シグナル（$count）';
  }

  @override
  String get adminFeedbackContent => 'フィードバック内容';

  @override
  String get adminAttachmentLink => '添付ファイル／リンク';

  @override
  String get adminReplyEmail => '返信先メール';

  @override
  String get adminComment => '管理者メモ';

  @override
  String get adminCommentHint => '確認内容や対応事項を入力してください…';

  @override
  String get adminChangeStatus => 'ステータス変更';

  @override
  String get adminReportDetails => '通報詳細';

  @override
  String get adminSave => '保存';

  @override
  String get adminReportInfo => '通報情報';

  @override
  String get adminReportId => '通報ID';

  @override
  String get adminReportReason => '通報理由';

  @override
  String get adminReportedAt => '通報日時';

  @override
  String get adminUpdatedTime => '更新日時';

  @override
  String get adminReportedReview => '通報対象レビュー';

  @override
  String get adminReportContent => '通報内容';

  @override
  String get adminAttachment => '添付ファイル';

  @override
  String get adminEvidenceIncluded => 'AI証拠の添付';

  @override
  String get adminIncluded => 'あり';

  @override
  String get adminNotIncluded => 'なし';

  @override
  String get adminOptionalCommentHint => 'メモを入力してください（任意）。';

  @override
  String get adminSuspiciousReviewsSubtitle =>
      'RTI分析で検出された疑わしいレビューを確認し、適切に対応してください。';

  @override
  String get adminRtiUpperBound => 'RTIスコア上限';

  @override
  String adminScoreBelow(int score) {
    return '$score点未満';
  }

  @override
  String get adminAll => 'すべて';

  @override
  String get adminTotalSuspiciousReviews => '疑わしいレビュー総数';

  @override
  String get adminCurrentFilter => '現在の検索条件';

  @override
  String get adminRtiScore => 'RTIスコア';

  @override
  String get adminTrustGrade => '信頼ランク';

  @override
  String get adminSuspiciousReviewsEmpty => '表示する疑わしいレビューはありません。';

  @override
  String get adminFeedbacksSubtitle => 'RTI分析結果に対するユーザーのフィードバックを確認し、対応してください。';

  @override
  String get adminTotalFeedbacks => 'フィードバック総数';

  @override
  String get adminAllTime => '全期間';

  @override
  String get adminStatus => 'ステータス';

  @override
  String get adminFeedbacksEmpty => '表示する分析フィードバックはありません。';

  @override
  String get adminReportsSubtitle => 'ユーザーの通報を確認し、対応状況を更新してください。';

  @override
  String get adminTotalReports => '通報総数';

  @override
  String get adminReportsCountHelper => '全通報件数';

  @override
  String get adminPendingReportsHelper => '確認が必要な通報';

  @override
  String get adminUnderReviewReportsHelper => '確認中の通報';

  @override
  String get adminAcceptedReportsHelper => '承認された通報';

  @override
  String get adminRejectedReportsHelper => '却下された通報';

  @override
  String adminBulkSuccess(int total) {
    return '$total件を処理しました。';
  }

  @override
  String adminBulkFailure(int total, int failed) {
    return '$total件中$failed件の処理に失敗しました。失敗した項目は選択したままです。';
  }

  @override
  String get adminAcceptReports => '承認する';

  @override
  String get adminRejectReports => '却下する';

  @override
  String get adminEvidence => 'AI証拠';

  @override
  String get adminReportsEmpty => '表示する通報はありません。';

  @override
  String get adminDashboardSubtitle => 'レビュー分析状況と対応待ちの業務を一覧で確認できます。';

  @override
  String get adminModelPerformance => 'AIモデル性能';

  @override
  String adminPeriodDays(int days) {
    return '$days日';
  }

  @override
  String get adminTotalReviews => '全レビュー';

  @override
  String get adminTotalReviewsHelper => '分析対象の全レビュー';

  @override
  String get adminSuspiciousReviews => '疑わしいレビュー';

  @override
  String get adminRiskyReviews => '危険なレビュー';

  @override
  String get adminPendingReports => '対応待ちの通報';

  @override
  String get adminPendingFeedbacks => '対応待ちの分析フィードバック';

  @override
  String get adminOpenSection => 'クリックして開く';

  @override
  String adminCountPercent(String count, String percent) {
    return '$count件 · $percent%';
  }

  @override
  String get adminRtiDistribution => 'RTIランク分布';

  @override
  String adminAnalyzedCount(String count) {
    return '分析済みレビュー$count件';
  }

  @override
  String get adminSuspicious => '疑わしい';

  @override
  String get adminAverageRti => '全体の平均RTI';

  @override
  String adminDailyTrendTitle(int days) {
    return '日別平均RTI · 分析件数（過去$days日）';
  }

  @override
  String get adminTrendEmpty => '期間内に分析されたレビューはありません。';

  @override
  String adminTrendTooltip(String date, String score, String count) {
    return '$date\n平均RTI $score · $count件';
  }

  @override
  String get adminUserAgreement => 'ユーザー判定の同意率';

  @override
  String adminFeedbackCount(String count) {
    return 'フィードバック$count件';
  }

  @override
  String get adminAgree => '同意';

  @override
  String get adminDisagree => '異議';

  @override
  String get adminFeedbackStats => '分析フィードバックの対応状況';

  @override
  String adminResolutionRate(String percent) {
    return '対応率$percent%';
  }

  @override
  String get adminApplied => '反映済み';

  @override
  String get adminDismissed => '却下';

  @override
  String get sessionExpiredMessage => 'ログインの有効期限が切れました。もう一度ログインしてください。';

  @override
  String get sessionExpiredLogin => 'ログイン';

  @override
  String get settingsAccountLabelLoginMethod => 'ログイン方法';

  @override
  String get settingsLoginMethodEmail => 'メール';

  @override
  String get settingsLoginMethodNaver => 'NAVER';

  @override
  String get chatLauncherLabel => 'AIに聞く';

  @override
  String get chatLauncherProductLabel => 'この商品のレビューを聞く';

  @override
  String get chatProductCta => 'この商品についてAIに聞く';

  @override
  String get chatEmptyProductTitle => 'この商品の何が気になりますか？';

  @override
  String get chatCopy => 'コピー';

  @override
  String get chatCopied => 'コピーしました';

  @override
  String get chatThinkingLong => '回答の作成に少し時間がかかっています';

  @override
  String get chatThinkingVeryLong => 'まだ回答を待っています。閉じても会話は残ります';

  @override
  String get chatBlockedTitle => 'この質問には回答できません';

  @override
  String get chatModeStandard => '標準';

  @override
  String get chatModePro => 'プロ';

  @override
  String get chatModeProActive => 'プロモードでより詳しく回答します';

  @override
  String get chatModeProLocked => 'プロモードはプロプランで利用できます';

  @override
  String get chatPlanFree => '無料';

  @override
  String get chatPlanPlus => 'プラス';

  @override
  String get chatPlanPro => 'プロ';

  @override
  String get planTitle => 'プラン';

  @override
  String get planSubtitle => 'AIアシスタントの利用量を選びましょう。';

  @override
  String get planCurrent => '現在のプラン';

  @override
  String planUsageToday(int used, int limit) {
    return '今日 $used/$limit 回使用';
  }

  @override
  String planUsageUnlimited(int used) {
    return '今日 $used 回使用 · 回数制限なし';
  }

  @override
  String planResetAt(String time) {
    return '$timeにリセット';
  }

  @override
  String planExpiresAt(String date) {
    return '$dateまで利用';
  }

  @override
  String planDailyQuestions(int count) {
    return '1日 $count 回の質問';
  }

  @override
  String get planDailyUnlimited => '1日の質問回数制限なし';

  @override
  String get planFeatureStandard => '標準の回答';

  @override
  String get planFeatureLimited => '1日の質問数が最も少ない';

  @override
  String get planFeatureMore => '無料より多い1日の質問数';

  @override
  String get planFeatureMost => '最も多い1日の質問数';

  @override
  String get planFeaturePro => 'プロモード：より詳しい回答';

  @override
  String get planSelect => 'このプランに変更';

  @override
  String get planCurrentBadge => '利用中';

  @override
  String planConfirmTitle(String plan) {
    return '$planプランに変更しますか？';
  }

  @override
  String get planConfirmBody => '現在は決済なしですぐに変更されます。';

  @override
  String get planConfirmAction => '変更';

  @override
  String get planCancel => 'キャンセル';

  @override
  String planChanged(String plan) {
    return '$planプランに変更しました';
  }

  @override
  String get planChangeUnavailable => 'プラン変更はまだ準備中です。';

  @override
  String get planChangeFailed => 'プランを変更できませんでした。もう一度お試しください。';

  @override
  String get planLoadFailed => 'プラン情報を読み込めませんでした。';

  @override
  String get planRetry => '再試行';

  @override
  String get myPageSideNavPlan => 'プラン';

  @override
  String get chatViewPlans => 'プランを見る';

  @override
  String get extProductCollectingTitle => '商品情報を取得しています';

  @override
  String get extProductCollectingBody =>
      'ショップから商品とレビューの情報を取得しています。商品情報が準備でき次第、自動で表示します。';

  @override
  String get extProductCollectingSlow =>
      'ショップからの商品情報を待っています。商品情報が準備でき次第、自動で表示します。';

  @override
  String get extProductUnavailableTitle => '商品情報を取得できませんでした';

  @override
  String get extProductUnavailableBody =>
      '商品が存在しないのではなく、現在ショップから情報を取得できません。しばらくしてからもう一度お試しください。';

  @override
  String get extProductLoadFailed => '商品を読み込めませんでした。';

  @override
  String get extProductRetry => '再試行';

  @override
  String get extProductStale => '最新情報に更新しています';

  @override
  String extProductVisitShop(String shop) {
    return '$shopで見る';
  }

  @override
  String extProductReviewCount(int count) {
    return 'レビュー $count件';
  }

  @override
  String extProductPrice(String price) {
    return '$priceウォン';
  }

  @override
  String get extProductAnalysisPendingTitle => '信頼度分析前';

  @override
  String get extProductAnalysisPendingBody =>
      'この商品のレビューはまだ分析されていません。信頼度スコアは提供されていません。';

  @override
  String get extProductReviewsTitle => 'レビュー';

  @override
  String get extProductReviewsEmpty => '収集されたレビューはありません。';

  @override
  String get extProductReviewsMore => 'レビューをもっと見る';

  @override
  String get extProductReviewsMoreFailed => 'レビューをさらに読み込めませんでした。';

  @override
  String extProductReviewOption(String option) {
    return 'オプション: $option';
  }

  @override
  String chatQuotaRemaining(int remaining, int limit) {
    return '今日の残り質問 $remaining/$limit';
  }

  @override
  String get chatQuotaUnlimited => '質問回数の制限なし';

  @override
  String get chatQuotaExceededTitle => '今日の質問をすべて使いました';

  @override
  String chatQuotaExceededBody(String time) {
    return '$timeにまた質問できます';
  }

  @override
  String get chatQuotaExceededBodyNoTime => '上限がリセットされたらまた質問できます';

  @override
  String get chatPlanRequiredTitle => 'プロプランで利用できます';

  @override
  String get chatPlanRequiredAction => '標準モードでもう一度聞く';

  @override
  String get chatSuggestGeneral3 => '信頼できるレビューの選び方は？';

  @override
  String get adminUserPlanColumn => 'プラン';

  @override
  String get adminUserPlanChange => 'プラン変更';

  @override
  String get adminUserPlanTitle => 'プラン変更';

  @override
  String get adminUserPlanExpiry => '有効期限';

  @override
  String get adminUserPlanUnlimited => '無期限';

  @override
  String get adminUserPlanThirtyDays => '30日';

  @override
  String get adminUserPlanCustomDate => '日付を指定';

  @override
  String get adminUserPlanSelectDate => '日付を選択';

  @override
  String get adminUserPlanExpired => '期限切れ';

  @override
  String get adminUserPlanUnknown => '不明';

  @override
  String get adminUserPlanSave => '保存';

  @override
  String get adminUserPlanCancel => 'キャンセル';

  @override
  String get adminUserPlanSaving => '保存中';

  @override
  String get adminUserPlanDateRequired => '今日以降の有効期限を選択してください。';

  @override
  String get externalWishAdd => 'お気に入り';

  @override
  String get externalWishRemove => 'お気に入り解除';

  @override
  String get externalCartAdd => 'カートに追加';

  @override
  String get externalCartAdded => '追加済み';

  @override
  String get externalReviewMenu => 'レビューメニュー';

  @override
  String get externalReport => '報告する';

  @override
  String get externalReal => '本物のレビューだと思う';

  @override
  String get externalFake => '偽物のレビューだと思う';

  @override
  String get externalNotCollected => '商品収集の完了後に再試行してください。';

  @override
  String get externalUnavailable => 'データサーバーに接続できません。後ほど再試行してください。';

  @override
  String get externalReportDuplicate => 'このレビューは報告済みです。';

  @override
  String get externalFeedbackDuplicate => 'このレビューには回答済みです。';

  @override
  String get externalFailed => '処理できませんでした。再試行してください。';

  @override
  String get externalSuccess => '完了しました。';

  @override
  String get externalUnanalyzed => '分析前';

  @override
  String get externalReason => '報告理由';

  @override
  String get externalDetail => '詳細';

  @override
  String get externalDetailValidation => '20〜500文字で入力してください。';

  @override
  String get externalAttachment => '添付URL（任意）';

  @override
  String get externalAttachmentValidation => '有効なhttpまたはhttps URLを入力してください。';

  @override
  String get externalEvidence => '分析根拠を含める';

  @override
  String get externalCancel => 'キャンセル';

  @override
  String get externalSubmit => '送信';

  @override
  String get externalReasonFake => '偽物の疑い';

  @override
  String get externalReasonAi => '自動生成の疑い';

  @override
  String get externalReasonIrrelevant => '商品と無関係';

  @override
  String get externalReasonInappropriate => '不適切な表現・個人情報';

  @override
  String get externalReasonAd => '広告';

  @override
  String get externalReasonRepeated => '繰り返しの内容';

  @override
  String get externalReasonOffensive => '侮辱的な内容';

  @override
  String get externalReasonOther => 'その他';

  @override
  String get productImageEnlarge => '商品画像を拡大';

  @override
  String get productImagePrevious => '前の商品画像';

  @override
  String get productImageNext => '次の商品画像';
}
