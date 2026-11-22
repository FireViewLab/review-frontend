// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navHome => 'ホーム';

  @override
  String get navSearch => '検索';

  @override
  String get navMyPage => 'マイページ';

  @override
  String get navSettings => '設定';

  @override
  String get actionSave => '保存';

  @override
  String get actionConfirm => '確認';

  @override
  String get actionRetry => '再試行';

  @override
  String get actionLogin => 'ログイン';

  @override
  String get actionViewAll => 'すべて見る';

  @override
  String get settingsNotifications => '通知設定';

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
  String get settingsAccountTitle => 'アカウント';

  @override
  String get settingsAccountChangePassword => 'パスワード変更';

  @override
  String get settingsDeleteAccount => '退会';

  @override
  String get settingsDeleteAccountConfirmTitle => '退会';

  @override
  String get settingsDeleteAccountConfirmBody =>
      '退会するとアカウントと保存した情報が削除され、元に戻せません。退会しますか？';

  @override
  String get settingsDeleteAccountCancel => 'キャンセル';

  @override
  String get settingsDeleteAccountConfirm => '退会';

  @override
  String get settingsDeleteAccountFailed => '退会できませんでした。しばらくしてから再度お試しください。';

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
  String get chatInputHint => '質問を入力してください';

  @override
  String get chatSend => '送信';

  @override
  String get chatOtherProductNotice => 'この会話は現在の画面とは異なる文脈を保持しています。';

  @override
  String get chatStartWithThisProduct => 'この商品で新しい会話';

  @override
  String get chatEmptyTitle => 'レビューで気になることを聞いてください';

  @override
  String get chatEmptyBody => 'おすすめの質問は入力欄に入るだけです。内容を確認してから送信してください。';

  @override
  String get chatSuggestProduct1 => 'この商品のレビューは信頼できる？';

  @override
  String get chatSuggestProduct2 => '広告っぽいレビューは多い？';

  @override
  String get chatSuggestProduct4 => '似た商品をおすすめして';

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
  String get externalFake => '注意が必要なレビューだと思う';

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

  @override
  String get imagePreviewOpen => '画像を拡大';

  @override
  String get imagePreviewTitle => '画像プレビュー';

  @override
  String get imagePreviewPrevious => '前の画像';

  @override
  String get imagePreviewNext => '次の画像';

  @override
  String get chatFreshContext => '新しい会話・履歴は保持されます';

  @override
  String get chatHistoryContext => '履歴から開いた会話';

  @override
  String get chatActiveContext => '進行中の会話';

  @override
  String get chatGeneralContext => '一般の会話・商品指定なし';

  @override
  String get chatTargetProduct => '質問対象の商品';

  @override
  String get chatQuotaLoading => '質問の利用枠を確認しています。';

  @override
  String get chatQuotaUnavailable => '利用枠を更新できませんでした。前回確認した値を保持しています。';

  @override
  String get chatQuotaRefresh => '再確認';

  @override
  String get chatClosePreserve => '閉じる（会話を保持）';

  @override
  String get chatHistoryWait => '送信が完了すると履歴を開けます。';

  @override
  String get extProductReviewPreferencesNote =>
      '並び順の設定は読み込み済みのレビューに適用されます。未提供の購入認証や信頼度でレビューを非表示・分類しません。';

  @override
  String get extProductSummaryLoading => '商品の基本情報を確認しています。';

  @override
  String get extProductListSummary => '一覧で取得した商品情報です。最新の詳細情報とレビューを確認しています。';

  @override
  String get extProductPreviousSummary => '以前表示した商品情報です。最新の詳細情報とレビューを確認しています。';

  @override
  String get recentRecordFailed => '閲覧履歴を確認できませんでした。再試行';

  @override
  String get recentRecordUnavailable => '閲覧履歴に必要な商品識別情報を確認できません。';

  @override
  String get reviewPhotoOnly => '写真付きレビュー';

  @override
  String get reviewListView => 'レビュー一覧';

  @override
  String get reviewPhotosView => '写真一覧';

  @override
  String reviewPhotoScope(int loaded, int photos) {
    return '読み込み済みレビュー$loaded件 · 写真付き$photos件';
  }

  @override
  String get reviewPhotosEmpty => '読み込み済みレビューに有効な写真がありません。';

  @override
  String get externalForbidden => 'この操作の権限がありません。';

  @override
  String get externalAuthRequestFailed =>
      'このリクエストの認証を確認できませんでした。現在のログイン状態を確認して再試行してください。';

  @override
  String get externalNetworkFailure => 'ネットワーク接続を確認して再試行してください。';

  @override
  String get externalTimeout => 'リクエストがタイムアウトしました。再試行してください。';

  @override
  String get reportTitle => 'レビュー信頼度レポート';

  @override
  String get reportDetails => '詳細分析を見る';

  @override
  String get reportClose => '閉じる';

  @override
  String get reportBefore => '分析前';

  @override
  String get reportCollecting => '商品とレビューを収集中です。分析の進行状況とは別です。';

  @override
  String get reportRunning => '分析中です。';

  @override
  String get reportFailed => '分析結果を取得できませんでした。';

  @override
  String get reportDisabled => '現在分析は無効です。';

  @override
  String get reportStale => '以前の分析結果は最新ではありません。';

  @override
  String get reportUnavailable => '分析状況を確認できません。';

  @override
  String get reportDone => 'レビューの分析結果が届きました。詳細分析で判断の根拠をご確認ください。';

  @override
  String get reportLoadedScope => '現在読み込んだレビューの結果です。商品全体の分析範囲と異なる場合があります。';

  @override
  String get reportInputCount => '分析対象レビュー';

  @override
  String get reportSourceCount => '収集した元レビュー';

  @override
  String get reportSampled => '一部レビューをサンプル分析';

  @override
  String get reportFull => '収集レビュー全件を分析';

  @override
  String get reportModel => 'モデル版';

  @override
  String get reportPolicy => 'ポリシー版';

  @override
  String get reportNoReviewResults => '読み込み済みレビューの分析結果がありません。';

  @override
  String get reportReasons => '提供された判断根拠';

  @override
  String get reportCurrentCount => '読み込み済み分析レビュー';

  @override
  String get reportCatalogAverage => '商品の平均RTI';

  @override
  String get reportCatalogSource =>
      '商品一覧から提供された集計です。詳細レビューの結果と更新時点が異なる場合があります。';

  @override
  String get reviewAnalysisSafe => '信頼度が高い';

  @override
  String get reviewAnalysisWarn => '注意';

  @override
  String get reviewAnalysisDanger => '信頼度が低い';

  @override
  String get reviewAnalysisMissing => 'このレビューの分析結果はありません。';

  @override
  String get reportIntro => '購入前に、レビューの信頼度を確認しましょう。';

  @override
  String get reportScoreLabel => '商品レビューの信頼度';

  @override
  String get reportStateReady => '分析結果';

  @override
  String get reportStateCollecting => 'レビュー収集中';

  @override
  String get reportStateRunning => '分析中';

  @override
  String get reportStateFailed => '結果を確認できません';

  @override
  String get reportStateStale => '更新が必要';

  @override
  String get reportStateDisabled => '分析未提供';

  @override
  String get reportStateUnavailable => '状態を確認できません';

  @override
  String get reportPendingBody => '分析結果はまだありません。準備ができると信頼度と判断の根拠をここで確認できます。';

  @override
  String get reportOverview => '分析のまとめ';

  @override
  String get reportCoverage => '分析範囲';

  @override
  String get reportReviewResults => 'レビュー別の結果と根拠';

  @override
  String get reviewOriginal => 'レビュー原文';

  @override
  String get reviewResultTitle => 'このレビューの分析結果';

  @override
  String get reviewIndividualScope => '選択した1件のレビューの結果です。商品のレポートとは分析範囲が異なります。';

  @override
  String get reviewLoadedAggregate => '読み込んだレビューの集計';

  @override
  String get evidenceRepetitionLabel => '繰り返し表現';

  @override
  String get evidenceRepetitionBody => '同じ表現が繰り返し使われています。';

  @override
  String get evidenceShortLabel => '短いレビュー';

  @override
  String get evidenceShortBody => 'レビューが短く、確認できる情報が限られています。';

  @override
  String get evidenceExclamationLabel => '感嘆符が多い';

  @override
  String get evidenceExclamationBody => '感嘆符が多く使われています。';

  @override
  String get evidencePositiveLabel => '強い肯定表現';

  @override
  String get evidencePositiveBody => '強い肯定表現が検出されました。これだけで広告とは判断できません。';

  @override
  String get evidencePurchaseLabel => '購入認証未確認';

  @override
  String get evidencePurchaseBody => '購入認証が確認されていないレビューです。';

  @override
  String get evidenceNewAccountLabel => '登録直後の投稿';

  @override
  String get evidenceNewAccountBody => 'レビュー投稿時、登録から間もないアカウントでした。';

  @override
  String get evidenceDailyLabel => '同日に複数のレビュー';

  @override
  String get evidenceDailyBody => '同じ投稿者が同日に複数のレビューを書いています。';

  @override
  String get evidenceSimilarLabel => '似ているレビュー内容';

  @override
  String get evidenceSimilarBody => '内容が似ている別のレビューが見つかりました。類似性だけで不正とは判断できません。';

  @override
  String get evidenceClusterLabel => '類似レビューの集まり';

  @override
  String get evidenceClusterBody => '内容が似たレビューの集まりが見つかりました。不正が確定したわけではありません。';

  @override
  String get evidenceQualityLabel => '内容品質スコアが低い';

  @override
  String get evidenceQualityBody => 'レビュー内容の品質スコアが低く評価されました。';

  @override
  String get evidenceUnknownPurchaseLabel => '購入の有無が不明';

  @override
  String get evidenceUnknownPurchaseBody => '提供された情報では購入の有無を確認できません。';

  @override
  String get evidenceTrialLabel => '体験・無償提供の可能性';

  @override
  String get evidenceTrialBody => '体験または無償提供によるレビューの可能性が示されています。';

  @override
  String get evidenceNoImageLabel => '添付写真なし';

  @override
  String get evidenceNoImageBody => 'レビューに写真が添付されていません。';

  @override
  String get evidenceRepurchaseLabel => '再購入の手がかり';

  @override
  String get evidenceRepurchaseBody => '再購入を示す情報が確認されました。';

  @override
  String get evidenceUnknownLabel => '追加の分析根拠';

  @override
  String get evidenceUnknownBody => '追加の根拠が提供されましたが、説明文にはまだ対応していません。';

  @override
  String get homeSearchSuggestionsEmpty => '関連検索語はありません。入力した言葉で検索できます。';

  @override
  String get homeSearchSuggestionsError =>
      '関連検索語を読み込めませんでした。入力した言葉で検索するか、再試行してください。';

  @override
  String get homeSearchSuggestionsRetry => '関連検索語を再読み込み';

  @override
  String get authAccountHelp => 'アカウントのヘルプ';

  @override
  String get authAccountHelpBody =>
      'メールアカウントのパスワードは「パスワードをお忘れですか」から再設定できます。Google・Naverアカウントは登録時のソーシャルログインボタンをご利用ください。';

  @override
  String get authForgotPassword => 'パスワードをお忘れですか';

  @override
  String get authSignup => '新規登録';

  @override
  String get authClose => '閉じる';

  @override
  String get authLogin => 'ログイン';

  @override
  String get authLoginDescription =>
      'Re:viewアカウントにログインして、保存した商品と信頼フィルターを読み込みましょう。';

  @override
  String get authEmail => 'メールアドレス';

  @override
  String get authEmailHint => 'メールアドレスを入力してください';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authPasswordHint => 'パスワードを入力してください';

  @override
  String get authShow => '表示';

  @override
  String get authHide => '非表示';

  @override
  String get authRememberMe => 'ログイン状態を保持';

  @override
  String get authOr => 'または';

  @override
  String get authContinueNaver => 'Naverアカウントで続ける';

  @override
  String get authContinueGoogle => 'Googleアカウントで続ける';

  @override
  String get authNoAccount => 'まだアカウントをお持ちでないですか？';

  @override
  String get authSignupAction => '新規登録する';

  @override
  String get authPrivacyNotice =>
      '個人設定はアカウントに安全に保存され、保存した商品と分析履歴はログインしたユーザーにのみ表示されます。';

  @override
  String get authSignupDescription =>
      'Re:viewアカウントを作成して、商品の保存、信頼フィルター、通知の設定を始めましょう。';

  @override
  String get authName => '名前';

  @override
  String get authNameHint => '名前を入力してください';

  @override
  String get authPasswordGuidance => '英字、数字、記号を含む8文字以上で設定してください。';

  @override
  String get authConfirmPassword => 'パスワードの確認';

  @override
  String get authConfirmPasswordHint => 'パスワードをもう一度入力してください';

  @override
  String get authSignupOnboarding => '登録して初期設定を始める';

  @override
  String get authSignupNaver => 'Naverアカウントで登録';

  @override
  String get authSignupGoogle => 'Googleアカウントで登録';

  @override
  String get authHasAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get authLoginAction => 'ログインする';

  @override
  String get authTermsConsent => '利用規約とプライバシーポリシーに同意します。（必須）';

  @override
  String get authMarketingConsent => '保存した商品と信頼度の変化に関する通知を受け取ります。（任意）';

  @override
  String get authOnboardingNotice =>
      '次は初期設定です。登録後、興味のあるカテゴリーとデフォルトのRTIフィルターを設定します。';

  @override
  String get authResetTitle => 'パスワードの再設定';

  @override
  String get authResetDescription => '登録したメールアドレスを確認して新しいパスワードを設定してください。';

  @override
  String get authRememberAccount => 'アカウントを思い出しましたか？';

  @override
  String get authBackToLogin => 'ログインに戻る';

  @override
  String get authRegisteredEmail => '登録メールアドレス';

  @override
  String get authSendVerification => '認証メールを送信';

  @override
  String get authEmailSent => 'メールを送信しました';

  @override
  String get authEmailSentGuide =>
      'メール内のリンクをクリックするか、受信したトークンを確認してから次のステップへ進んでください。';

  @override
  String get authNext => '次へ';

  @override
  String get authResendEmail => 'メールを再送信';

  @override
  String get authNewPassword => '新しいパスワード';

  @override
  String get authNewPasswordHint => '新しいパスワードを入力してください';

  @override
  String get authNewPasswordGuide => '以前のパスワードとは異なるものを設定し、英字・数字・記号を組み合わせてください。';

  @override
  String get authConfirmNewPassword => '新しいパスワードの確認';

  @override
  String get authConfirmNewPasswordHint => '新しいパスワードをもう一度入力してください';

  @override
  String get authCompleteReset => 'パスワードを変更';

  @override
  String get authResendVerification => '認証メールを再送信';

  @override
  String get authMinLength => '8文字以上';

  @override
  String get authLettersNumbers => '英字と数字を含む';

  @override
  String get authSymbolsRecommended => '記号の使用を推奨';

  @override
  String get authNoEmail => 'メールが届きませんか？';

  @override
  String get authNoEmailGuide => '迷惑メールフォルダーを確認するか、登録したメールアドレスが正しいか再度確認してください。';

  @override
  String get authVerifyEmail => 'メールの確認';

  @override
  String get authVerificationCode => '認証コード';

  @override
  String get authResetSuccess => 'パスワードが変更されました';

  @override
  String get authResetSuccessGuide => '新しいパスワードでログインしてください。';

  @override
  String get authGoToLogin => 'ログインへ';

  @override
  String get searchFilterTitle => 'フィルター';

  @override
  String get searchFilterReset => 'リセット';

  @override
  String get searchFilterCategory => 'カテゴリー';

  @override
  String get searchFilterPriceRange => '価格帯';

  @override
  String get searchFilterWon => 'ウォン';

  @override
  String get searchFilterSeller => '販売店';

  @override
  String get searchFilterSellerHint => '販売店を選択してください';

  @override
  String get searchFilterRtiScore => 'RTI信頼スコア';

  @override
  String get searchFilterAllRti => 'すべて（未分析を含む）';

  @override
  String get searchFilterZeroPoints => '0点';

  @override
  String get searchFilterHundredPoints => '100点';

  @override
  String get searchFilterEightyMinimum => '80点以上';

  @override
  String get searchFilterNinetyMinimum => '90点以上';

  @override
  String get searchFilterNinetyFiveMinimum => '95点以上';

  @override
  String get searchFilterInfoStatus => '情報の状態';

  @override
  String get searchFilterReviewConditions => 'レビュー条件';

  @override
  String get searchFilterSelectSeller => '販売店を選択';

  @override
  String get searchFilterAllSellers => 'すべての販売店';

  @override
  String get searchFilterUnanalyzedOnly => '未分析のみ';

  @override
  String get searchFilterMissingPriceOnly => '価格情報なしのみ';

  @override
  String get searchFilterMinimumReviews => 'レビュー50件以上';

  @override
  String get searchFilterUnderTenThousand => '1万ウォン以下';

  @override
  String get searchFilterTenToThirtyThousand => '10～30万ウォン';

  @override
  String get searchFilterAboveThreeHundredThousand => '30万ウォン以上';

  @override
  String searchFilterPriceAmount(String amount) {
    return '$amountウォン';
  }

  @override
  String searchFilterMinimumScore(int score) {
    return '$score点以上';
  }

  @override
  String searchFilterShowResults(int count) {
    return '$count件の結果を表示';
  }

  @override
  String get analysisPolicyIndex => 'ポリシー指数';

  @override
  String get analysisNotCalculable => '算出不可';

  @override
  String get analysisPolicyExplanation => 'ポリシー基準に基づく相対的な指数です。';

  @override
  String get analysisTextScore => 'テキストスコア';

  @override
  String get analysisBehaviorScore => '行動スコア';

  @override
  String get analysisNetworkScore => 'ネットワークスコア';

  @override
  String get analysisScore => '分析スコア';

  @override
  String get analysisSeparateContracts => '異なる契約のスコアは分けて表示します。';

  @override
  String get analysisPolicyAverage => '商品の平均ポリシー指数';

  @override
  String get owlGuideName => 'レビューフクロウ';

  @override
  String get extProgressProductStep => '商品情報の収集';

  @override
  String get extProgressReviewsStep => 'レビューの収集';

  @override
  String get extProgressAnalysisStep => 'レビューの分析';

  @override
  String get extProgressStatusComplete => '完了';

  @override
  String get extProgressStatusInProgress => '進行中';

  @override
  String get extProgressStatusWaiting => '待機中';

  @override
  String get extProgressStatusFailed => '失敗';

  @override
  String get extProgressStatusNotAnalyzed => 'まだ分析されていません';

  @override
  String get extProgressStatusUnknown => '確認中';

  @override
  String get extProgressStatusRefreshing => '再収集中';

  @override
  String get extProgressStatusDisabled => '無効';

  @override
  String get extProgressStatusUnavailable => '情報なし';

  @override
  String get extProgressStatusPartial => '一部完了';

  @override
  String get extProgressNoticeCollecting => '商品情報とレビューの収集を待っています。';

  @override
  String get extProgressNoticeRefreshing =>
      '以前に収集した情報を表示しています。新しい収集処理は待機中または進行中です。';

  @override
  String get extProgressNoticeAnalyzing => 'レビューの分析は待機中または進行中です。';

  @override
  String get extProgressNoticeNotAnalyzed => 'レビューはまだ分析されていません。';

  @override
  String get extProgressNoticeComplete => 'レビューの分析が完了しました。';

  @override
  String get extProgressNoticeFailed => '収集・分析の過程で問題が報告されました。各段階の状態をご確認ください。';

  @override
  String get extProgressNoticeDelayed => '時間がかかっています。もう一度ご確認ください。';

  @override
  String get extProgressNoticeChecking => '現在の収集・分析の状態を確認しています。';

  @override
  String get extProgressNoticeDisabled => 'レビューの分析は無効になっています。';

  @override
  String get extProgressNoticeUnavailable => '現在、レビューの分析情報を確認できません。';

  @override
  String get extProgressRetry => 'もう一度確認';

  @override
  String extProgressStepSemantics(String step, String status) {
    return '$step、$status';
  }

  @override
  String get extSummaryTitle => 'レビュー分析の要約';

  @override
  String get extSummaryFallbackTitle => '分析状況と根拠の案内';

  @override
  String get extSummaryFallbackIntro => '現在読み込まれているレビューの分析状況と信頼性の根拠をまとめました。';

  @override
  String get extSummaryNoEvidence => '分析は完了しましたが、要約できる根拠はまだありません。';

  @override
  String get extSummaryNotAnalyzed => 'まだ分析前のため、表示できる要約はありません。';

  @override
  String get extSummaryInProgress => '分析の進行状況は上のステップでご確認ください。';

  @override
  String get extSummaryFailed => '分析に失敗したため、要約を表示できません。';

  @override
  String get extSummaryDisabled => '分析が無効なため、要約は表示されません。';

  @override
  String get extSummaryUnavailable => '要約の表示に必要な分析状況がまだ確認できていません。';

  @override
  String get extSummaryMissingValue => '未提供';

  @override
  String get extSummarySampling => '標本分析の有無';

  @override
  String get extSummaryNotSampled => '標本分析ではありません';

  @override
  String extSummaryLoadedScope(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '現在読み込まれているレビュー$countString件に基づく集計';
  }

  @override
  String get extSummaryV2Grades => 'ポリシー指数に基づく等級 (v2)';

  @override
  String get extSummaryLegacyGrades => '信頼性の等級 (v0.5)';

  @override
  String get extSummaryUnknownVersion => '分析バージョン不明';

  @override
  String extSummaryGradeCount(String grade, int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$grade：$countString件';
  }

  @override
  String get extSummaryGradeSafe => '信頼度が高い';

  @override
  String get extSummaryGradeWarn => '注意';

  @override
  String get extSummaryGradeDanger => '信頼度が低い';

  @override
  String get extSummaryEvidenceTitle => 'よく見られる信頼性の根拠';

  @override
  String get extSummaryEvidenceScope =>
      '現在読み込まれているレビューの信頼性に関する根拠であり、商品の品質評価ではありません。';

  @override
  String extSummaryReasonCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString件のレビューで確認';
  }

  @override
  String get extSummaryNoLoadedReviews => '現在レビューが読み込まれていないため、等級分布を表示できません。';

  @override
  String extSummaryFact(String label, String value) {
    return '$label：$value';
  }

  @override
  String get extTrustDetailSource => '詳細分析の結果';

  @override
  String get extTrustCatalogSource => '商品一覧で確認した平均';

  @override
  String get extTrustNoAverage => 'この画面では商品の平均点を取得できません。';

  @override
  String get extTrustBefore => 'まだ分析前のため、商品スコアはありません。';

  @override
  String get extTrustRunning => '分析中のため、商品スコアは表示されません。';

  @override
  String get extTrustGradeMissing => '等級情報なし';

  @override
  String get extTrustGuideSafe => '分析したレビューの信頼性のシグナルは、おおむね安定しています。';

  @override
  String get extTrustGuideCaution => '判断の根拠もあわせてご確認ください。';

  @override
  String get extTrustGuideUnknown => 'スコアの出典と、提供されている根拠をご確認ください。';

  @override
  String get extTrustNoEvidence => '商品の分析根拠は提供されていません。';

  @override
  String get extTrustComponents => 'スコアの内訳';

  @override
  String get extTrustTextExplanation => 'レビュー文の表現や繰り返しのパターンを調べたスコアです。';

  @override
  String get extTrustBehaviorExplanation => 'レビュー投稿者の活動パターンを調べたスコアです。';

  @override
  String get extTrustNetworkExplanation => 'レビューと投稿者のつながりのパターンを調べたスコアです。';

  @override
  String get extTrustCoverageInSummary => '分析範囲とバージョンは、上の要約カードで確認できます。';

  @override
  String extTrustScoreValue(String label, String score) {
    return '$label $score / 100';
  }

  @override
  String get extNavProgress => '分析の進行';

  @override
  String get extNavSummary => 'AI要約';

  @override
  String get extNavReport => '信頼度レポート';

  @override
  String get extNavReviews => 'レビュー';

  @override
  String get extNavLabel => 'セクションへ移動';

  @override
  String get extDescriptionTitle => '商品詳細説明';

  @override
  String get extDescriptionSource => 'ショップの商品詳細ページの内容';

  @override
  String get extDescriptionExpand => '詳細説明を開く';

  @override
  String get extDescriptionCollapse => '詳細説明を閉じる';

  @override
  String extDescriptionImage(int index) {
    return '詳細画像 $index';
  }

  @override
  String get extNavDescription => '詳細説明';

  @override
  String get failureTitleOffline => '接続をご確認ください';

  @override
  String get failureMessageOffline =>
      'サーバーに接続できません。インターネット接続を確認して、もう一度お試しください。';

  @override
  String get failureTitleTimeout => '応答に時間がかかっています';

  @override
  String get failureMessageTimeout => '接続または応答の待機時間を超えました。しばらくしてからお試しください。';

  @override
  String get failureTitleUnauthorized => 'ログインが必要です';

  @override
  String get failureMessageUnauthorized =>
      'ログイン情報がないか、有効期限が切れています。もう一度ログインしてください。';

  @override
  String get failureTitleForbidden => 'アクセス権限がありません';

  @override
  String get failureMessageForbidden => 'この機能を利用する権限がありません。';

  @override
  String get failureTitleNotFound => '見つかりませんでした';

  @override
  String get failureMessageNotFound => '指定された情報が存在しないか、提供が終了しています。';

  @override
  String get failureTitleRateLimited => 'リクエストが多すぎます';

  @override
  String get failureMessageRateLimited => 'リクエストが多いため、しばらくしてからお試しください。';

  @override
  String get failureTitleServer => 'サーバーで問題が発生しました';

  @override
  String get failureMessageServer => 'サーバーエラーが発生しました。しばらくしてからお試しください。';

  @override
  String get failureTitleCancelled => 'リクエストがキャンセルされました';

  @override
  String get failureMessageCancelled => 'リクエストがキャンセルされたため、結果は読み込まれていません。';

  @override
  String get failureTitleBadResponse => '応答を確認できません';

  @override
  String get failureMessageBadResponse => '応答を処理できませんでした。もう一度ご確認ください。';

  @override
  String get failureTitleUnknown => '問題が発生しました';

  @override
  String get failureMessageUnknown => 'リクエストを完了できませんでした。しばらくしてからお試しください。';

  @override
  String get failureRetry => 'もう一度試す';

  @override
  String get failureSearchRetry => '再検索';

  @override
  String get analysisPending => '分析中';

  @override
  String get analysisTextCaution => '本文の繰り返し・宣伝・説明文の表現を確認してください。';

  @override
  String analysisAttentionReviews(int count) {
    return '注意が必要なレビュー $count件';
  }

  @override
  String get scrollToTop => '一番上へ';

  @override
  String get actionUndo => '元に戻す';

  @override
  String get wishlistRemoved => 'お気に入りから削除しました';

  @override
  String get cartRemoved => 'カートから削除しました';

  @override
  String get listLoading => '読み込み中';

  @override
  String get cartEmptyTitle => 'カートは空です';

  @override
  String get cartEmptyDescription => '気になる商品をカートに入れてみましょう。';

  @override
  String get emptyViewWishlist => 'お気に入りを見る';

  @override
  String get recentProductsEmptyTitle => '最近見た商品はありません';

  @override
  String get recentProductsEmptyDescription =>
      '気になる商品を見てみましょう。最近見た商品がここに表示されます。';

  @override
  String get warningProductsEmptyTitle => '注意が必要な商品はありません';

  @override
  String get warningProductsFilteredEmptyTitle => '選択した評価に該当する商品はありません';

  @override
  String get warningProductsEmptyDescription =>
      'ほかの商品も見て、気になる商品をお気に入りに追加してみましょう。';

  @override
  String get searchEmptyTitle => '検索結果がありません';

  @override
  String get searchEmptyQueryDescription => '商品名やカテゴリーを入力して検索してみましょう。';

  @override
  String get searchEmptyDescription => '別のキーワードや、より広いカテゴリーで検索してみましょう。';

  @override
  String get searchFilteredEmptyTitle => '条件に合う商品がありません';

  @override
  String get searchFilteredEmptyDescription => 'フィルターをリセットするか、条件を広げてみましょう。';

  @override
  String get searchResetFilters => 'フィルターをリセット';

  @override
  String get extProductVisitShopGeneric => 'ショップで見る';

  @override
  String get headerSupport => 'カスタマーサポート';

  @override
  String get headerSellerRegistration => '出店案内';

  @override
  String get headerAppDownload => 'アプリをダウンロード';

  @override
  String get headerCart => 'カート';

  @override
  String get headerMyAccount => 'マイアカウント';

  @override
  String get headerMember => '会員';

  @override
  String headerMemberName(String name) {
    return '$nameさん';
  }

  @override
  String get headerMemberBadge => 'Re:viewメンバー';

  @override
  String get headerOrderActivity => '注文・アクティビティ';

  @override
  String get homeNavBest => '人気商品';

  @override
  String get homeNavNew => '新着商品';

  @override
  String get homeNavReviewRanking => 'レビューランキング';

  @override
  String get homePopularCategoriesNow => '今人気のカテゴリー';

  @override
  String get homeCategoryPickTitle => 'カテゴリーのおすすめ PICK';

  @override
  String get homeAllCategoriesTitle => 'すべてのカテゴリーをひと目で';

  @override
  String get homeAllCategoriesDescription => 'レビューデータに基づく人気商品やカテゴリーをご覧ください。';

  @override
  String homeCategoryViewAll(String category) {
    return '$categoryをすべて見る  >';
  }

  @override
  String get homeBannerFallbackNotice => 'バナーを読み込めないため、標準のバナーを表示しています。';

  @override
  String get homeProductsLoadFailed => '商品を読み込めませんでした。';

  @override
  String get homeViewAllProducts => 'すべての商品を見る';

  @override
  String get homeBannerLinkFailed => 'バナーのリンクを開けませんでした。';

  @override
  String get homePriceUnavailable => '価格情報なし';

  @override
  String get homeRecommendationsPending => 'おすすめ商品APIへの接続待ち';

  @override
  String get homeRecommendationsPendingDescription =>
      '仮の商品は作成せず、実際の商品データが接続されるとカード一覧に表示します。';

  @override
  String get homeTrustTitle => 'Re:viewをより信頼できる理由';

  @override
  String get homeTrustIndexTitle => 'RTIレビュー信頼度指数';

  @override
  String get homeFooterAbout => 'サービス紹介';

  @override
  String get homeFooterTerms => '利用規約';

  @override
  String get homeFooterPrivacy => 'プライバシーポリシー';

  @override
  String get homeSuggestedProductsPending => 'おすすめ商品APIへの接続待ち';

  @override
  String get homeRtiChecking => 'RTIを確認中';

  @override
  String get homeTrustAnalyzedProduct => '信頼度分析対象商品';

  @override
  String get homeBannerPlay => '再生';

  @override
  String get homeBannerPause => '一時停止';

  @override
  String get homeBannerPrevious => '前のバナー';

  @override
  String get homeBannerNext => '次のバナー';

  @override
  String homeBannerPosition(int index, int count) {
    return 'バナー $index/$count';
  }

  @override
  String homeBannerTrustLabel(String badge) {
    return '$badge\n信頼度を確認';
  }

  @override
  String get landingHomeTooltip => 'ホームへ';

  @override
  String get landingFeatureRti => 'RTIベース';

  @override
  String get landingFeatureAdPatterns => '広告パターン分析';

  @override
  String get landingFeatureEvidence => '判定の根拠を提示';

  @override
  String get landingHeroDescription =>
      '商品ごとのレビューを分析し、RTIによる信頼度指数を提供して\nより信頼できる購入判断をお手伝いします。';

  @override
  String get landingHeroHeadline => '偽レビューに惑わされない\nもっと賢いショッピング、';

  @override
  String get landingStart => 'はじめる';

  @override
  String get landingLearnRti => 'RTIについて';

  @override
  String get landingCloseHint => 'いつでも閉じてホームへ移動できます';

  @override
  String get landingGradeHigh => '信頼度が高い';

  @override
  String landingRtiReliabilityScore(String score) {
    return 'RTI信頼度 $score%';
  }

  @override
  String get landingRtiAnalyzing => 'RTI信頼度を分析中';

  @override
  String get landingSummaryLowAd => '広告パターンが少ない';

  @override
  String get landingSummaryFewRepeats => '繰り返し表現が少ない';

  @override
  String get landingSummaryNoAnomalies => '異常の兆候なし';

  @override
  String get landingAnalysisSummary => 'Re:view分析サマリー';

  @override
  String get landingAnalysisDisclaimer =>
      '実際のユーザーレビューを基に分析し、\n広告・操作の兆候をフィルタリングして分析に反映します。';

  @override
  String get settingsEditInterests => '興味のあるカテゴリー・通知設定を再編集';

  @override
  String get homeCategoryBenefitReviewBased => 'レビューデータに基づくおすすめ';

  @override
  String get homeCategoryBenefitRtiRanking => 'RTIランキングを確認';

  @override
  String get homeCategoryBenefitFastShippingProducts => '配送が早い商品';

  @override
  String get homeCategoryBenefitAllOffers => '特典をまとめて見る';

  @override
  String get homeCategoryBenefitSize => 'サイズのおすすめ';

  @override
  String get homeCategoryBenefitStyle => 'スタイルのおすすめ';

  @override
  String get homeCategoryBenefitGenderDeals => '性別ごとのお得情報';

  @override
  String get homeCategoryBenefitGifts => '人気のギフト';

  @override
  String get homeCategoryBenefitAuthenticityCheck => '正規品認証';

  @override
  String get homeCategoryBenefitBrandEvents => 'ブランド特集';

  @override
  String get homeCategoryBenefitGiftWrapping => 'ギフト包装サービス';

  @override
  String get homeCategoryBenefitFreeReturns => '返品無料';

  @override
  String get homeCategoryBenefitIngredients => '成分で探す';

  @override
  String get homeCategoryBenefitSkinType => '肌タイプ別のおすすめ';

  @override
  String get homeCategoryBenefitReviewRanking => 'レビューランキング';

  @override
  String get homeCategoryBenefitSamples => 'サンプル体験';

  @override
  String get homeCategoryBenefitDawnDelivery => '早朝配送';

  @override
  String get homeCategoryBenefitBulkDiscount => '大容量割引';

  @override
  String get homeCategoryBenefitReviewFavorites => 'レビューで人気の商品';

  @override
  String get homeCategoryBenefitSubscriptions => '定期配送';

  @override
  String get homeCategoryBenefitTodayDeals => '今日の特価';

  @override
  String get homeCategoryBenefitHousewarming => '引っ越し祝いのおすすめ';

  @override
  String get homeCategoryBenefitFastShipping => 'スピード配送';

  @override
  String get homeCategoryBenefitByRoom => '空間別のおすすめ';

  @override
  String get homeCategoryBenefitPopularInteriors => '人気のインテリア';

  @override
  String get homeCategoryBenefitInstallation => '設置サービス';

  @override
  String get homeCategoryBenefitSeasonalDecor => '季節のデコレーション';

  @override
  String get homeCategoryBenefitBeginners => '初心者向けのおすすめ';

  @override
  String get homeCategoryBenefitTopGear => '人気の用具';

  @override
  String get homeCategoryBenefitSeasonalOutdoors => '季節のアウトドア用品';

  @override
  String get homeCategoryBenefitQuickCompare => 'かんたん比較';

  @override
  String get homeCategoryBenefitCarCare => 'カーケアの必需品';

  @override
  String get homeCategoryBenefitMaintenance => 'メンテナンス用品のおすすめ';

  @override
  String get homeCategoryBenefitBrandDeals => 'ブランド特価';

  @override
  String get homeCategoryBenefitSafetyGear => '安全用品をまとめて見る';

  @override
  String get homeCategoryBenefitParenting => '育児の必需品';

  @override
  String get homeCategoryBenefitByAge => '年齢別のおすすめ';

  @override
  String get homeCategoryBenefitSafetyCertification => '安全認証';

  @override
  String get homeCategoryBenefitSpecialOffers => '特集';

  @override
  String get homeCategoryBenefitPopularTreats => '人気のおやつ';

  @override
  String get homeCategoryBenefitVetPicks => '獣医師のおすすめ';

  @override
  String get homeCategoryBenefitPetPersonalized => 'うちの子にぴったり';

  @override
  String get homeCategoryBenefitMerchandiserPicks => 'MDのおすすめ';

  @override
  String get homeCategoryBenefitPreorders => '予約販売';

  @override
  String get homeCategoryBenefitLimitedMerch => '限定グッズ';

  @override
  String get homeCategoryBenefitBestsellers => 'ベストセラー';

  @override
  String get homeCategoryBenefitTravelChecklist => '旅行準備チェックリスト';

  @override
  String get homeCategoryBenefitPopularStays => '人気の宿泊施設';

  @override
  String get homeCategoryBenefitDiscountTickets => '割引チケット';

  @override
  String get homeCategoryBenefitSubscriptionOffers => 'サブスクリプション特典';

  @override
  String get homeCategoryBenefitAuthenticityGuarantee => '正規品保証';

  @override
  String get homeCategoryBenefitBrandWeek => 'ブランドウィーク';

  @override
  String get homeCategoryBenefitPremiumOffers => 'プレミアム特典';

  @override
  String get homeCategoryBenefitExclusiveOffers => '限定オファー';

  @override
  String get homeCategoryRecommendedLabel => 'おすすめ';

  @override
  String get authLoginContinue => '気になる商品の管理を続けましょう。';

  @override
  String get authLoginTrackHeadline => '気になる商品のレビュー信頼度を\n継続して追跡しましょう。';

  @override
  String get authLoginManageDescription =>
      'ログインすると、保存した商品、信頼度フィルター、分析フィードバックをひとつのアカウントで引き続き管理できます。';

  @override
  String get authLoginSafeShopping => '安心して買い物するためにログイン';

  @override
  String get authLoginRecentProducts => '最近確認した商品';

  @override
  String get authLoginRestoreRecords => 'ログイン後、保存した商品と分析記録を読み込みます。';

  @override
  String get authLoginKeepTrackingRti => 'RTIを継続して追跡';

  @override
  String get authMetricText => 'テキスト';

  @override
  String get authMetricBehavior => '行動';

  @override
  String get authMetricPurchaseContext => '購入の背景';

  @override
  String get authProductUncategorized => 'カテゴリー未分類';

  @override
  String get authLoginSavedProducts => '保存商品の管理';

  @override
  String get authLoginSavedProductsDescription =>
      '気になる商品をまとめて、RTIの変化やリスクの兆候を確認します。';

  @override
  String get authLoginPersonalFilters => '個人用の信頼度フィルター';

  @override
  String get authLoginPersonalFiltersDescription =>
      '危険なレビューの非表示や最小RTI基準など、自分に合ったフィルターを維持します。';

  @override
  String get authLoginFeedbackTracking => '分析フィードバックの追跡';

  @override
  String get authLoginFeedbackTrackingDescription =>
      '通報とフィードバックの処理状況をひとつの場所で確認します。';

  @override
  String get authFooterContact => 'お問い合わせ';

  @override
  String get authSignupFilterHeadline =>
      '自分の買い物の基準に合う\nレビュー信頼度フィルターを\n作ってみましょう。';

  @override
  String get authSignupFilterDescription =>
      '登録後に興味のあるカテゴリーと基本の信頼度フィルターを設定すると、商品を見るたびに自分の基準に合うRTIの情報や通知を受け取れます。';

  @override
  String get authSignupCreateAccount => '新しいアカウントを作成';

  @override
  String get authSignupAccountStep => 'アカウント作成';

  @override
  String get authSignupAccountStepDescription =>
      '名前とメールアドレスでRe:viewアカウントを作成します。';

  @override
  String get authSignupCurrentStep => '現在のステップ';

  @override
  String get authSignupInterestStep => '興味のあるカテゴリーを選択';

  @override
  String get authSignupInterestStepDescription =>
      '興味のある情報が増えると、よりよい信頼度の情報を提供します。';

  @override
  String get authSignupFilterStep => '信頼度フィルターを設定';

  @override
  String get authSignupFilterStepDescription => '危険なレビューの非表示や最小RTI基準を設定します。';

  @override
  String get authSignupFollowupFlow => '登録後すぐに続く流れ';

  @override
  String get authSignupFollowupDescription =>
      '登録が完了すると、オンボーディングで興味のあるカテゴリーと基本フィルターを設定します。';

  @override
  String get authSignupPersonalizedBrowse => '自分に合った商品探し';

  @override
  String get authSignupPersonalizedBrowseDescription =>
      '興味のあるカテゴリーに合う信頼度フィードを先に確認します。';

  @override
  String get authSignupSavedAlerts => '保存商品の通知';

  @override
  String get authSignupSavedAlertsDescription =>
      '気になる商品のリスクの兆候が増えたときに通知を受け取れます。';

  @override
  String get authSignupFeedbackHistory => 'フィードバック記録の管理';

  @override
  String get authSignupFeedbackHistoryDescription => '通報と分析フィードバックの処理状況を追跡します。';

  @override
  String authSetupMinutes(int minutes) {
    return '$minutes分で設定';
  }

  @override
  String get authValidationNameRequired => '名前を入力してください。';

  @override
  String get authValidationEmailRequired => 'メールアドレスを入力してください。';

  @override
  String get authValidationEmailInvalid => '正しい形式のメールアドレスを入力してください。';

  @override
  String get authValidationPasswordRequired => 'パスワードを入力してください。';

  @override
  String get authValidationPasswordComposition => '英字、数字、記号をすべて含めてください。';

  @override
  String get authValidationPasswordConfirmRequired => 'パスワードをもう一度入力してください。';

  @override
  String get authValidationPasswordMismatch => 'パスワードが一致しません。';

  @override
  String get authValidationTermsRequired => '必須の規約に同意してください。';

  @override
  String authValidationPasswordMinLength(int minLength) {
    return 'パスワードは$minLength文字以上で入力してください。';
  }

  @override
  String get authResetVerifyHeadline => '安全に認証して\n';

  @override
  String get authResetHeadlineEmphasis => 'パスワードを再設定';

  @override
  String get authResetHeadlineEnd => 'しましょう。';

  @override
  String get authResetValueDescription =>
      'Re:viewアカウントの保存商品、信頼度フィルター、フィードバック履歴を守るため、メール確認後に新しいパスワードを設定します。';

  @override
  String get authResetRecoveryBadge => 'アカウント復旧';

  @override
  String get authResetEmailStepDescription => '登録したメールアドレスに認証コードを送信します。';

  @override
  String get authResetCodeStep => '認証コードを入力';

  @override
  String get authResetNewPasswordStep => '新しいパスワードを設定';

  @override
  String get authResetNewPasswordStepDescription =>
      'セキュリティ基準を満たす新しいパスワードを登録します。';

  @override
  String get authResetProcessTitle => 'パスワード再設定の流れ';

  @override
  String get authResetProcessDescription => 'アカウントの所有を確認してから、安全にパスワードを変更します。';

  @override
  String get authResetSecurityBadge => 'セキュリティ認証';

  @override
  String get authResetKeepData => 'アカウントデータを維持';

  @override
  String get authResetKeepDataDescription => 'パスワードを変更しても保存済みのフィルター設定はそのまま';

  @override
  String get authResetProtectCode => '認証コードを保護';

  @override
  String get authResetProtectCodeDescription =>
      '認証コードは一定時間後に期限切れとなります。他の人に共有しないでください。';

  @override
  String get authResetSignInAgain => 'ログインを再確認';

  @override
  String get authResetSignInAgainDescription => 'パスワード変更後、新しいパスワードで再度ログインします。';

  @override
  String authResetCodeStepDescription(int digits) {
    return 'メールで届いた$digits桁のコードを入力してアカウントを確認します。';
  }

  @override
  String get authOAuthLoginFailed => 'OAuthログインに失敗しました。';

  @override
  String get onboardingCategoryTitle => '興味のあるカテゴリーを選んでください';

  @override
  String get onboardingCategoryDescription =>
      '選択しなくても進めます。興味のあるカテゴリーは後から設定で変更できます。';

  @override
  String get onboardingUnanalyzedNotice => '分析前の商品を安全な商品とは判定しません。';

  @override
  String get onboardingSkipExisting => '現在の設定でスキップ';

  @override
  String onboardingTrustThreshold(int score) {
    return '信頼度の基準：$score点';
  }

  @override
  String get onboardingNotificationDescription =>
      '通知ボックスで受け取る通知を選びましょう。実際の分析結果が生成された場合にのみ関連する通知を受け取れます。';

  @override
  String get onboardingFeedbackResults => 'フィードバックの処理結果';

  @override
  String get onboardingMarketingConsent => 'マーケティング・イベント通知に同意';

  @override
  String get onboardingNotificationAvailability =>
      'ブラウザのプッシュ通知・メール・SMS・週間レポートは現在提供していません。この画面では通知ボックスの設定を保存します。';

  @override
  String get onboardingPrevious => '前へ';

  @override
  String get onboardingSaveComplete => '保存して完了';

  @override
  String get onboardingPreferredCategories => '好みのカテゴリー';

  @override
  String get onboardingReload => '再読み込み';

  @override
  String get reportSubmit => '通報を送信';

  @override
  String get reportReceived => '通報受付';

  @override
  String get reportReceivedDescription => '対象レビューと通報理由を保存します。';

  @override
  String get reportAssistedReview => 'AIによる補助確認';

  @override
  String get reportAssistedReviewDescription => 'RTIの情報と類似レビューの履歴を併せて確認します。';

  @override
  String get reportTeamDecision => '運営チームの判断';

  @override
  String get reportTeamDecisionDescription => '虚偽・悪意がある場合は審査状況が更新されます。';

  @override
  String get reportResultNotification => '結果の通知';

  @override
  String get reportResultNotificationDescription =>
      '確認が完了するとフィードバック履歴に結果が反映されます。';

  @override
  String get reportProcessTitle => '処理の流れ';

  @override
  String get reportProcessDescription => '通報受付後、運営チームが確認する流れです。';

  @override
  String get reportGuideRepeated => '繰り返し表現を具体的に記載';

  @override
  String get reportGuideRepeatedDescription => '目立った箇所・文・パターンを具体的に記載してください。';

  @override
  String get reportGuideContext => '商品を使用した背景を確認';

  @override
  String get reportGuideContextDescription =>
      '実際の使用経験がない内容や、商品と無関係な部分を教えてください。';

  @override
  String get reportGuideAttachments => '参考資料を添付';

  @override
  String get reportGuideAttachmentsDescription =>
      '同じ根拠が複数の場面で繰り返される場合は添付が役立ちます。';

  @override
  String get reportGuideTitle => '通報ガイド';

  @override
  String get reportGuideDescription => 'このような情報が通報の処理に役立ちます。';

  @override
  String get reportSummaryTitle => '受付内容の概要';

  @override
  String get reportSummaryDescription => '送信前に入力内容を確認してください。';

  @override
  String get reportLiveBadge => 'リアルタイム';

  @override
  String get reportSelectedReasons => '選択した理由';

  @override
  String get reportAnalysisEvidence => 'AIの根拠';

  @override
  String get reportTargetReviews => '対象レビュー';

  @override
  String get reportReasonTitle => '通報理由を選択';

  @override
  String get reportReasonDescription => 'カードをタップして選択・複数選択できます。';

  @override
  String get reportViewCriteria => '通報基準を見る';

  @override
  String get reportStepTarget => '対象を確認';

  @override
  String get reportStepTargetDescription => '商品とレビューの情報を確認';

  @override
  String get reportStepReasonDescription => '問題の種類を選択';

  @override
  String get reportStepDetails => '詳しい根拠';

  @override
  String get reportStepDetailsDescription => '追加説明を入力';

  @override
  String get reportStepComplete => '受付完了';

  @override
  String get reportStepCompleteDescription => '確認状況を追跡';

  @override
  String get reportTargetDescription => '通報する商品とレビューが正しいか確認してください。';

  @override
  String get reportFromAnalysis => '分析ポップアップから移動';

  @override
  String get reportPrivacyConsent => '個人情報の収集と通報処理の案内に同意します。';

  @override
  String get reportPrivacyDescription =>
      '通報内容はレビュー受付、処理結果の案内、モデル品質の改善に使用し、必要な期間保管します。';

  @override
  String get reportTruthConsent => '虚偽の通報ではないことを確認します。';

  @override
  String get reportTruthDescription => '通報内容が事実と異なる場合、処理の優先順位が下がることがあります。';

  @override
  String get reportTitleText => 'レビュー通報の受付';

  @override
  String get reportDescription =>
      '疑わしいレビューの問題点と根拠を記載してください。通報は運営の確認とモデル改善のフィードバックに活用します。';

  @override
  String get reportViewMyFeedback => '自分のフィードバック履歴を見る';

  @override
  String get reportReportBreadcrumb => 'レポート';

  @override
  String get reportEvidenceTitle => '分析の根拠を併せて提出（任意）';

  @override
  String get reportEvidenceDescription => '現在のレビューのRTI分析情報を通報の根拠として添付できます。';

  @override
  String get reportAttachEvidence => 'AI分析の根拠を添付';

  @override
  String get reportAttachEvidenceDescription => 'RTIの情報が通報の根拠と一緒に提出されます。';

  @override
  String get reportViewEvidence => '根拠を見る';

  @override
  String get reportDetailsTitle => '詳しい根拠を入力';

  @override
  String get reportDetailsDescription => '通報の判断に役立つ内容を記載してください。';

  @override
  String get reportType => '通報の種類';

  @override
  String get reportVisibility => '処理結果の公開範囲';

  @override
  String get reportDetailHint => '具体的な問題とその背景を入力してください。';

  @override
  String get reportAttachments => '添付資料 ';

  @override
  String get reportOptional => '（任意）';

  @override
  String get reportAttachmentsFull => '添付できる数の上限に達しました';

  @override
  String get reportAttachmentsHint => 'スクリーンショットや追加の根拠を添付してください';

  @override
  String get reportChooseFiles => 'ファイルを選択';

  @override
  String get reportConsentsRequired => 'すべての同意項目を確認してください。';

  @override
  String get reportSubmittedTitle => '通報の受付完了';

  @override
  String get reportSubmittedDescription =>
      '通報を受け付けました。\n処理結果はフィードバック履歴で確認できます。';

  @override
  String get reportViewFeedback => 'フィードバック履歴を見る';

  @override
  String get reportAlreadyReportedTitle => '通報済みのレビュー';

  @override
  String get reportAlreadyReportedDescription =>
      'このレビューはすでに通報済みです。\n重複した通報は受け付けません。';

  @override
  String reportReviewCount(int count) {
    return '$count件';
  }

  @override
  String reportAverageReviewRound(int round) {
    return '平均第$round回確認';
  }

  @override
  String reportRiskyReviewScore(String score) {
    return '危険なレビュー · RTI $score';
  }

  @override
  String reportMaxAttachments(int count) {
    return '最大$count件まで添付できます。';
  }

  @override
  String reportFileTooLarge(String name, int size) {
    return '$nameは${size}MBを超えています。';
  }

  @override
  String reportMinimumCharacters(int count) {
    return '$count文字以上入力してください。';
  }

  @override
  String reportMinimumCharactersHelp(int count) {
    return '$count文字以上入力すると、運営チームの確認に役立ちます。';
  }

  @override
  String reportCharacterCount(int count) {
    return '$count文字';
  }

  @override
  String reportAttachmentLimits(int size, int count) {
    return 'PNG, JPG, PDF · 最大${size}MB · 最大$count件';
  }

  @override
  String reportReasonRequired(int count) {
    return '通報理由を$count件以上選んでください。';
  }

  @override
  String reportDetailsRequired(int count) {
    return '詳しい説明を$count文字以上入力してください。';
  }

  @override
  String get reportReasonFake => '偽レビュー・有償レビュアーの疑い';

  @override
  String get reportReasonGenerated => 'AI生成の痕跡の疑い';

  @override
  String get reportReasonFakeDescription =>
      '繰り返しや過度な称賛があり、複数の購入履歴が連動している可能性のあるレビューです。';

  @override
  String get reportReasonGeneratedDescription =>
      '繰り返しが過度に精密だったり、同じ文の構造が繰り返されるレビューです。';

  @override
  String get reportReasonIrrelevantDescription =>
      '実際の商品使用とは関係がない内容や、別の商品・ページの内容を含みます。';

  @override
  String get reportReasonInappropriateDescription =>
      '誹謗中傷、差別表現、氏名などの個人情報を含むレビューです。';

  @override
  String get reportReasonAdDescription => '広告レビューです。';

  @override
  String get reportReasonRepeatDescription => '繰り返しの内容です。';

  @override
  String get reportReasonOtherDescription => 'その他の通報理由です。';

  @override
  String get reportTypeRepetition => '繰り返しの表現';

  @override
  String get reportTypeNewAccount => 'アカウント作成直後';

  @override
  String get reportTypeSimilarCluster => '類似レビューの集まり';

  @override
  String get reportPrivate => '非公開';

  @override
  String get reportOnlyMe => '自分のみに公開';

  @override
  String get reportTeamOnly => '運営チームと共有';

  @override
  String get reportSelectPrompt => '選択してください';

  @override
  String get reportGuideBadge => 'ご案内';

  @override
  String get paymentTestCartTitle => 'カートのToss TEST決済';

  @override
  String get paymentTestServiceTitle => 'Toss TESTサービス決済';

  @override
  String get paymentTestCartDescription =>
      'TEST注文・決済専用です。実際の配送や決済は行いません。販売・配送可能な商品と最終金額はサーバーの見積もりで確認します。';

  @override
  String get paymentTestServiceDescription =>
      'テスト専用です。外部ショップへの注文、実際の決済、プランの自動変更は行いません。';

  @override
  String get paymentTestLoginRequired =>
      '注文の確認と決済にはログインが必要です。決済のコールバックURLはログイン後に開き直してください。';

  @override
  String get paymentTestNotConfigured =>
      'TEST決済キーとサーバーの注文・承認仕様はまだ準備されていません。現在は決済を開始・完了できません。';

  @override
  String get paymentTestWebOnly => '現在、TEST決済はウェブブラウザのみ対応しています。';

  @override
  String get paymentTestOrder => 'TEST注文';

  @override
  String get paymentTestReloadTargets => '決済対象を再取得';

  @override
  String get paymentTestOpening => 'TEST決済画面を開いています';

  @override
  String get paymentTestOpen => 'TEST決済画面を開く';

  @override
  String get paymentTestReloadWindow => '決済画面を再読み込み';

  @override
  String get paymentTestReloadApproval => 'サーバーの承認状況を再確認';

  @override
  String get paymentTestBackToOrders => 'TEST注文の選択に戻る';

  @override
  String get paymentTestCheckPlan => '現在のプランを確認';

  @override
  String get paymentCheckoutTitle => 'カートのTEST注文';

  @override
  String get paymentCheckoutDescription =>
      '実際の決済・配送は行いません。このサービスでショップの商品を販売・配送できるかサーバーでの確認が必要です。表示価格は参考で、送料と最終金額はサーバーの見積もりで確認します。';

  @override
  String get paymentCheckoutNotConfigured =>
      'TEST公開キーとカートの見積もり・注文・承認APIはまだありません。注文保存と決済は利用できません。住所はサーバーに送信・保存しません。';

  @override
  String get paymentCheckoutLoginSelect => 'ログインして注文を選択';

  @override
  String get paymentCheckoutNoSelection =>
      '現在のアカウントで選択した商品がありません。カートで商品を選んでください。';

  @override
  String get paymentCheckoutRecipient => '受取人';

  @override
  String get paymentCheckoutPhone => '連絡先';

  @override
  String get paymentCheckoutPostalCode => '郵便番号';

  @override
  String get paymentCheckoutAddress => '住所';

  @override
  String get paymentCheckoutAddressDetail => '住所の詳細（任意）';

  @override
  String get paymentCheckoutRequired => '入力してください。';

  @override
  String get paymentCheckoutPhoneInvalid => '連絡先の形式を確認してください。';

  @override
  String get paymentCheckoutQuote => 'サーバーのTEST見積もりを確認';

  @override
  String get paymentCheckoutBack => 'カートに戻る';

  @override
  String paymentCheckoutUnitPrice(String price) {
    return '参考単価：$priceウォン';
  }

  @override
  String paymentCheckoutQuantity(int count, String price) {
    return '$count個 · $price';
  }

  @override
  String paymentCheckoutPostalLength(int count) {
    return '$count桁の郵便番号を入力してください。';
  }

  @override
  String get paymentTestRequestFailed =>
      '決済画面のリクエストがキャンセルされたか失敗しました。決済完了として処理していません。';

  @override
  String get paymentTestLoadFailed =>
      'TEST決済画面を読み込めませんでした。ネットワークと設定を確認して再度お試しください。';

  @override
  String get paymentTestWebBrowserOnly => 'TEST決済はウェブブラウザのみ利用できます。';

  @override
  String get planRefreshFailed =>
      'プラン変更は処理されましたが、現在のプランと上限を確認できませんでした。再読み込みして確認してください。';

  @override
  String get detailSettingsRetry => '表示設定を読み込めませんでした。再試行';

  @override
  String get detailHelpfulUnavailable => '役に立った件数がないため、元のレビュー順で表示します。';

  @override
  String get detailNoReviews => 'まだレビューがありません。';

  @override
  String get detailNoMatchingReviews => '条件に合うレビューがありません。';

  @override
  String get detailVerified => '購入認証';

  @override
  String get detailSortRti => 'RTIが高い順';

  @override
  String get detailViewReviewAnalysis => 'レビュー分析を見る';

  @override
  String get detailHelpful => '役に立ちました';

  @override
  String get detailNotHelpful => '役に立ちませんでした';

  @override
  String get detailFeedbackSubmitted => 'フィードバックを送信しました。';

  @override
  String get detailFeedbackFailed => 'フィードバックを送信できませんでした。再度お試しください。';

  @override
  String detailShowHiddenReviews(int count) {
    return '設定基準未満のレビュー$count件を表示';
  }

  @override
  String detailMoreReviewsRemaining(int count) {
    return 'レビューをもっと見る（残り$count件）';
  }

  @override
  String get detailLowestPrice => '最安値';

  @override
  String get detailShipping => '配送';

  @override
  String detailCompareAllSellers(int count) {
    return '全$count店舗の価格を比較';
  }

  @override
  String get detailInsights => 'レビューのインサイト';

  @override
  String get detailMentionedKeywords => 'よく挙げられるキーワード';

  @override
  String get detailPositivePoints => '満足した点';

  @override
  String get detailNegativePoints => '惜しい点';

  @override
  String get detailMoreInsights => 'レビューのインサイトをもっと見る';

  @override
  String get detailRiskSummary => '総合リスクの概要';

  @override
  String get detailRiskSummaryTooltip => 'この商品の全レビューに対する\nAI信頼度分析の結果です。';

  @override
  String get detailScoreTooltip =>
      'RTI信頼度スコアは購入認証、文章の信頼度、\n繰り返し表現や投稿時期のパターンなどを総合して算出します。';

  @override
  String get detailDisclaimer => '分析結果は参考情報です。最終判断の前に複数のレビューを併せて確認してください。';

  @override
  String get detailCriteria => '分析基準';

  @override
  String get detailReported => '通報済み';

  @override
  String get detailReportReview => 'レビューを通報';

  @override
  String get detailSignalsTitle => 'RTIを構成する情報';

  @override
  String get detailSignalsTooltip =>
      'RTIを構成する情報とそれぞれのスコアです。\n文章・行動・ネットワークの分析を総合して算出します。';

  @override
  String get detailEvidenceTooltip =>
      'レビューの信頼度を判断した具体的な根拠と、\n各根拠がスコアに寄与した割合です。';

  @override
  String get detailAlsoViewed => 'この商品を見たお客様が併せて見た商品';

  @override
  String get detailKeySignals => '主な判断材料';

  @override
  String get detailTrend => 'リスクの推移';

  @override
  String get detailTrendDescription => '商品レビューの平均RTIと危険なレビューの割合の変化を表示します。';

  @override
  String get detailTrendPending => 'AI分析の完了後にリスクの推移を確認できます';

  @override
  String get detailAverageRti => '平均RTI';

  @override
  String get detailRiskyReviewRatio => '危険なレビューの割合';

  @override
  String get detailToday => '今日';

  @override
  String get detailRecentReviewOrder => '新しいレビュー順';

  @override
  String get detailAnalyzing => 'AI分析中';

  @override
  String get detailNoAnalyzedReviews => '分析済みのレビューがありません。';

  @override
  String get detailOfficialSeller => '公式販売店';

  @override
  String get detailTrustHigh => 'レビューの信頼度が高い';

  @override
  String get detailTrustMedium => 'レビューの信頼度は普通';

  @override
  String get detailTrustLow => 'レビューの信頼度が低い';

  @override
  String detailFormattedReviewCount(String count) {
    return 'レビュー$count件';
  }

  @override
  String get detailBrand => 'ブランド';

  @override
  String get detailAverageRating => '平均評価';

  @override
  String detailSellerCount(int count) {
    return '$count店舗';
  }

  @override
  String detailRatingReviewCount(String rating, String count) {
    return '$rating（レビュー$count件）';
  }

  @override
  String get detailAnalysisInProgress => 'AIによるレビュー分析中';

  @override
  String get detailAnalysisInProgressDescription =>
      'Re:view AIがレビューをリアルタイムで分析しています。完了後、信頼度スコアが自動更新されます。';

  @override
  String get detailInformation => '商品情報';

  @override
  String detailReviewTabCount(String count) {
    return 'レビュー $count';
  }

  @override
  String detailComparisonTabCount(int count) {
    return '価格比較 $count';
  }
}
