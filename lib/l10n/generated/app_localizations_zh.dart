// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Re:view';

  @override
  String get navHome => '首页';

  @override
  String get navSearch => '搜索';

  @override
  String get navCart => '购物车';

  @override
  String get navWishlist => '收藏';

  @override
  String get navMyPage => '我的页面';

  @override
  String get navSettings => '设置';

  @override
  String get actionSave => '保存';

  @override
  String get actionCancel => '取消';

  @override
  String get actionConfirm => '确认';

  @override
  String get actionRetry => '重试';

  @override
  String get actionBack => '返回';

  @override
  String get actionLogin => '登录';

  @override
  String get actionLogout => '退出登录';

  @override
  String get actionSignup => '注册';

  @override
  String get actionViewAll => '查看全部';

  @override
  String get stateLoading => '加载中…';

  @override
  String get stateError => '发生错误。';

  @override
  String get stateEmpty => '暂无内容。';

  @override
  String get settingsSaved => '设置已保存。';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsNotifications => '通知设置';

  @override
  String get settingsFilters => '分析筛选设置';

  @override
  String get langKorean => '한국어';

  @override
  String get langEnglish => 'English';

  @override
  String get langJapanese => '日本語';

  @override
  String get langChinese => '中文(简体)';

  @override
  String get sideNavOrders => '订单/配送';

  @override
  String get sideNavRecentlyViewed => '最近浏览的商品';

  @override
  String get sideNavReviewActivity => '评价活动';

  @override
  String get sideNavAccountSettings => '账户设置';

  @override
  String get sideNavFeedbackHistory => '反馈记录';

  @override
  String get settingsSubtitle => '管理通知、过滤器和账户设置。';

  @override
  String settingsSubtitleNamed(String nickname) {
    return '管理$nickname的通知、过滤器和账户设置。';
  }

  @override
  String get settingsNotificationEmail => '接收邮件通知';

  @override
  String get settingsNotificationEmailDesc => '通过邮件接收商品价格变动和评价更新。';

  @override
  String get settingsNotificationPush => '接收应用推送通知';

  @override
  String get settingsNotificationPushDesc => '在浏览器中接收已保存商品的实时通知。';

  @override
  String get settingsNotificationAdEmail => '接收邮件广告';

  @override
  String get settingsNotificationAdEmailDesc => '通过邮件接收促销和专属优惠信息。';

  @override
  String get settingsFilterHighlightLowRti => '优先显示注意商品';

  @override
  String get settingsFilterHighlightLowRtiDesc => '将评价可信度较低的商品显示在列表顶部。';

  @override
  String get settingsFilterWishlistAlert => '接收已保存商品通知';

  @override
  String get settingsFilterWishlistAlertDesc => '当收藏商品的RTI发生变化时发送通知。';

  @override
  String get settingsFilterCategory => '分类过滤器';

  @override
  String get settingsFilterCategoryDesc => '优先显示所选分类商品的分析结果。';

  @override
  String get settingsFilterCategoryAll => '全部分类';

  @override
  String get settingsFilterMinReview => '最低评价数量';

  @override
  String get settingsFilterMinReviewDesc => '仅将拥有该数量以上评价的商品纳入分析结果。';

  @override
  String get settingsFilterMinReviewSuffix => '条';

  @override
  String get settingsFilterLowRti => '低RTI警告标准';

  @override
  String get settingsFilterLowRtiDesc => 'RTI分数低于此值的商品将被分类为注意商品。';

  @override
  String get settingsFilterLowRtiSuffix => '分';

  @override
  String get settingsAccountTitle => '账户';

  @override
  String get settingsAccountChangePassword => '更改密码';

  @override
  String get settingsAccountLabelName => '姓名';

  @override
  String get settingsAccountLabelEmail => '邮箱';

  @override
  String get settingsAccountLabelJoinDate => '注册日期';

  @override
  String get settingsAccountLabelMemberType => '会员类型';

  @override
  String get settingsAccountDefaultName => '用户';

  @override
  String settingsAccountMemberLabel(String role) {
    return '$role会员';
  }

  @override
  String get settingsLanguageSection => '语言设置';

  @override
  String get settingsLanguageApplyNow => '更改将立即生效。';

  @override
  String get settingsSavedFeedback => '已保存';

  @override
  String get wishlistTitle => '收藏商品';

  @override
  String get wishlistSubtitle => '一目了然地查看已保存的商品，确认价格和评价可信度。';

  @override
  String wishlistCount(int count) {
    return '收藏商品$count件';
  }

  @override
  String get wishlistEmpty => '暂无收藏商品';

  @override
  String get wishlistEmptyDesc => '点击商品卡片上的爱心即可添加到收藏列表。';

  @override
  String get wishlistBrowse => '去浏览商品';

  @override
  String get wishlistFilteredEmpty => '没有符合所选过滤条件的收藏商品。';

  @override
  String get wishlistSummaryTitle => '收藏列表概览';

  @override
  String wishlistSummaryTotal(int count) {
    return '共$count件';
  }

  @override
  String get wishlistSummaryPriceDrop => '价格下降';

  @override
  String get wishlistSummaryNewAlert => '新通知';

  @override
  String get wishlistSummaryTotalReview => '总评价';

  @override
  String get wishlistProductView => '查看商品';

  @override
  String get wishlistProductPriceDrop => '价格下降';

  @override
  String get wishlistSortRecent => '最近保存';

  @override
  String get wishlistSortPriceLow => '价格从低到高';

  @override
  String get wishlistSortPriceHigh => '价格从高到低';

  @override
  String get wishlistSortRti => 'RTI从高到低';

  @override
  String get wishlistSortReviewCount => '评价最多';

  @override
  String get wishlistFilterAll => '全部';

  @override
  String get wishlistFilterPriceDrop => '价格下降';

  @override
  String get wishlistFilterRti => 'RTI分数';

  @override
  String get wishlistFilterLowestPrice => '最低价格';

  @override
  String get wishlistFilterBrand => '品牌';

  @override
  String get wishlistFilterCategory => '分类';

  @override
  String get myPageTitle => '我的页面';

  @override
  String get myPageLoading => '正在加载我的页面信息。';

  @override
  String get myPageWishlistLoading => '正在加载已保存的商品。';

  @override
  String get myPageWishlistEmpty => '暂无已保存的商品。';

  @override
  String get myPageInterestProducts => '收藏商品';

  @override
  String get myPageDefaultName => '用户';

  @override
  String get myPageMemberBasic => '普通会员（免费）';

  @override
  String get myPageSideNavMyPage => '我的页面';

  @override
  String get myPageSideNavOrders => '订单/配送';

  @override
  String get myPageSideNavWishlist => '已保存商品';

  @override
  String get myPageSideNavRecentlyViewed => '最近浏览的商品';

  @override
  String get myPageSideNavRiskyProducts => '注意商品';

  @override
  String get myPageSideNavAlerts => '通知';

  @override
  String get myPageRecentActivity => '最近活动';

  @override
  String get myPageRecentActivityEmpty => '暂无最近活动。';

  @override
  String get myPageRecentLabel => '最近';

  @override
  String get myPageReviewTrustSummary => '评价信任概览';

  @override
  String get myPageAvgRti => '收藏商品平均RTI';

  @override
  String get myPageRtiSaveHint => '保存收藏商品后将显示评价可信度概览。';

  @override
  String get myPageRiskyNone => '当前仪表盘中没有需要注意的商品。';

  @override
  String myPageRiskyCount(int count) {
    return '请查看$count件注意商品。';
  }

  @override
  String get myPageHighlightLowRti => '优先显示注意商品';

  @override
  String get myPageWishlistAlertLabel => '接收已保存商品通知';

  @override
  String get myPageAccountInfo => '账户信息';

  @override
  String get myPageAccountInfoSubtitle => '管理个人信息和基本信息。';

  @override
  String myPageAccountNickname(String nickname) {
    return '昵称：$nickname';
  }

  @override
  String myPageAccountEmail(String email) {
    return '邮箱：$email';
  }

  @override
  String myPageAccountMemberType(String role) {
    return '会员类型：$role';
  }

  @override
  String get myPageDefaultMemberRole => '普通会员';

  @override
  String get myPageLoginInfo => '登录信息';

  @override
  String get myPageLoginInfoSubtitle => '管理邮箱和登录方式。';

  @override
  String myPageLoginEmail(String email) {
    return '登录邮箱：$email';
  }

  @override
  String get myPageLoginStatus => '认证状态：已登录';

  @override
  String get myPageOnboardingComplete => '已完成';

  @override
  String get myPageOnboardingIncomplete => '未完成';

  @override
  String myPageOnboarding(String status) {
    return '引导：$status';
  }

  @override
  String get myPageChangePassword => '更改密码';

  @override
  String get myPageChangePasswordSubtitle => '请使用安全密码进行管理。';

  @override
  String get myPageNotificationSettings => '通知设置';

  @override
  String get myPageNotificationSettingsSubtitle => '设置邮件和推送通知。';

  @override
  String get myPageAccountSecurity => '账户 / 安全';

  @override
  String get navCategory => '分类';

  @override
  String get navWishShort => '收藏';

  @override
  String get navMyShort => '我的';

  @override
  String get homeSearchHint => '基于评价搜索商品';

  @override
  String get homeSearchSuggestionsTitle => '相关搜索词';

  @override
  String get homeSearchSuggestionsLoading => '正在加载相关搜索词。';

  @override
  String get homeSearchSuggestionsHint => '输入2个以上字符即可显示相关搜索词。';

  @override
  String get homeRecentSearchTitle => '最近搜索';

  @override
  String get homeRecentSearchDeleteAll => '全部删除';

  @override
  String get homeRecentSearchEmpty => '暂无最近搜索词。';

  @override
  String get homePopularSearchTitle => '热门搜索';

  @override
  String get homeSearchProductsTitle => '推荐商品';

  @override
  String get homeTrendingTitle => '热门搜索关键词';

  @override
  String get homeKeywordsEmpty => '暂无可显示的关键词。';

  @override
  String get homeRecommendedTitle => '编辑精选基于评价的推荐商品';

  @override
  String get homeViewAll => '查看全部';

  @override
  String get homeLoginRequired => '需要登录。';

  @override
  String get homeBenefitTitle => '首次购买专属优惠';

  @override
  String get homeBenefitSubtitle => '开始基于评价的购物即可享受会员福利。';

  @override
  String get homeBenefitButton => '领取优惠';

  @override
  String get homeTrustDescription => '过滤广告和操纵评价，分析真实用户评价并提供可信度。';

  @override
  String get homeTrustViewMore => '了解更多';

  @override
  String get homeTrustLabel1 => '真实评价分析';

  @override
  String get homeTrustLabel2 => '广告/操纵过滤';

  @override
  String get homeTrustLabel3 => '可信度评分提供';

  @override
  String get homePopularCategoryTitle => '热门分类';

  @override
  String get homeCategoryEmpty => '暂无可显示的分类。';

  @override
  String get feedbackHistoryTitle => '我的反馈记录';

  @override
  String get feedbackHistorySubtitle => '查看您提交的商品/评论反馈记录。';

  @override
  String get feedbackHistoryLoading => '正在加载反馈记录。';

  @override
  String get feedbackHistoryEmpty => '暂无提交的反馈。';

  @override
  String get feedbackHistoryEmptyDesc => '您可以在商品详情页提交评论反馈。';

  @override
  String feedbackHistoryCount(int count) {
    return '$count条反馈';
  }

  @override
  String get feedbackHistoryViewProduct => '查看商品';

  @override
  String get feedbackStatusSubmitted => '已提交';

  @override
  String get feedbackStatusPending => '审核中';

  @override
  String get feedbackStatusAccepted => '已处理';

  @override
  String get feedbackStatusRejected => '已拒绝';

  @override
  String get adminSidebarTitle => '管理员';

  @override
  String get adminMenuDashboard => '仪表盘';

  @override
  String get adminMenuSuspiciousReviews => '可疑评论管理';

  @override
  String get adminMenuReports => '举报管理';

  @override
  String get adminMenuAnalysisFeedbacks => '分析反馈管理';

  @override
  String get adminMenuUsers => '用户管理';

  @override
  String get adminMenuLogout => '退出登录';

  @override
  String get adminDashboardTitle => '运营仪表盘';

  @override
  String get adminPlaceholderMessage => '页面正在准备中。';

  @override
  String get adminTopBarSearchHint => '搜索用户、评论、举报 ID';

  @override
  String get adminTopBarNotifications => '通知';

  @override
  String get chatLauncherTooltip => '打开 AI 助手';

  @override
  String get chatTitle => 'Re:view AI';

  @override
  String get chatSubtitle => '帮你看懂评论、做出购买判断';

  @override
  String get chatNewConversation => '新对话';

  @override
  String get chatClose => '关闭';

  @override
  String get chatInputHint => '请输入问题';

  @override
  String get chatSend => '发送';

  @override
  String get chatProductContext => '基于该商品的评论回答';

  @override
  String get chatOtherProductNotice => '此对话保留了与当前页面不同的上下文。';

  @override
  String get chatStartWithThisProduct => '以此商品开始新对话';

  @override
  String get chatEmptyTitle => '问问你想了解的评论问题';

  @override
  String get chatEmptyBody => '推荐问题仅填入输入框。请确认内容后发送。';

  @override
  String get chatSuggestProduct1 => '这个商品的评论可信吗？';

  @override
  String get chatSuggestProduct2 => '广告评论多吗？';

  @override
  String get chatSuggestProduct3 => '真实用户提到的缺点是什么？';

  @override
  String get chatSuggestGeneral1 => 'RTI 分数是如何计算的？';

  @override
  String get chatSuggestGeneral2 => '如何识别广告评论？';

  @override
  String get chatThinking => '正在准备回答';

  @override
  String get chatLoginTitle => '登录后向 AI 提问';

  @override
  String get chatLoginBody => '对话会保存到您的账户。';

  @override
  String get chatLoginButton => '登录';

  @override
  String get chatErrorUnavailable => '聊天机器人暂时无法响应，请稍后再试。';

  @override
  String get chatErrorTimeout => '回答耗时过长，请重试。';

  @override
  String get chatErrorNetwork => '请检查网络连接。';

  @override
  String get chatErrorUnknown => '未能获取回答。';

  @override
  String get chatRetry => '重试';

  @override
  String get chatDisclaimer => 'AI 回答仅供参考，可能有误。';

  @override
  String get settingsReviewDisplay => '评论显示';

  @override
  String get settingsPrivacy => '隐私';

  @override
  String get settingsRtiThreshold => '最低 RTI 阈值';

  @override
  String get settingsRtiThresholdDesc => '用于筛选低于此 RTI 分数的评论。';

  @override
  String get settingsReviewSort => '评论默认排序';

  @override
  String get settingsSortVerifiedRecent => '已验证购买，最新优先';

  @override
  String get settingsSortRecent => '最新优先';

  @override
  String get settingsSortHelpful => '最有帮助';

  @override
  String get settingsRtiLabel => 'RTI 标签样式';

  @override
  String get settingsLabelSmall => '小徽章';

  @override
  String get settingsLabelLarge => '大徽章';

  @override
  String get settingsLabelNone => '不显示';

  @override
  String get settingsCardDensity => '商品卡片密度';

  @override
  String get settingsDensityComfortable => '宽松';

  @override
  String get settingsDensityCompact => '紧凑';

  @override
  String get settingsLoading => '正在加载设置。';

  @override
  String get settingsLoadFailed => '无法加载设置。';

  @override
  String get settingsSaveFailed => '无法保存设置。';

  @override
  String get settingsRiskyProduct => '风险商品通知';

  @override
  String get settingsRiskyProductDesc => '收藏商品的风险比例升高时通知。';

  @override
  String get settingsAnalysisComplete => '分析完成通知';

  @override
  String get settingsAnalysisCompleteDesc => '商品分析完成时通知。';

  @override
  String get settingsFeedbackResult => '反馈结果通知';

  @override
  String get settingsFeedbackResultDesc => '接收举报和反馈的处理结果。';

  @override
  String get settingsMarketing => '营销通知';

  @override
  String get settingsMarketingDesc => '接收推荐商品和营销通知。';

  @override
  String get settingsHideRisky => '隐藏风险评论';

  @override
  String get settingsHideRiskyDesc => '默认折叠风险评论。';

  @override
  String get settingsSuspiciousLabel => '显示可疑评论标签';

  @override
  String get settingsSuspiciousLabelDesc => '为可疑评论显示标签。';

  @override
  String get settingsVerifiedFirst => '优先显示已验证购买评论';

  @override
  String get settingsVerifiedFirstDesc => '先显示已验证购买的评论。';

  @override
  String get settingsAutoAnalysis => '自动打开分析弹窗';

  @override
  String get settingsAutoAnalysisDesc => '点击风险评论时自动打开分析详情。';

  @override
  String get settingsDataAnalysis => '允许使用评论分析数据';

  @override
  String get settingsDataAnalysisDesc => '同意将数据用于评论分析。';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsMarkAllRead => '全部已读';

  @override
  String get notificationsLoading => '正在加载通知';

  @override
  String get notificationsEmpty => '暂无通知';

  @override
  String get notificationsEmptyBody => '举报、反馈处理结果和分析完成通知会显示在这里。';

  @override
  String get headerNotifications => '通知';

  @override
  String get chatPreviousConversations => '历史对话';

  @override
  String get chatBackToConversation => '返回对话';

  @override
  String get chatHistoryLoading => '正在加载历史对话。';

  @override
  String get chatHistoryEmpty => '暂无历史对话。';

  @override
  String get chatHistoryLoadError => '无法加载历史对话，请重试。';

  @override
  String get chatHistoryLoadMore => '加载更多';

  @override
  String get chatHistoryUntitled => '无标题对话';

  @override
  String get adminUsersSubtitle => '按注册时间从新到旧查看用户。';

  @override
  String get adminRefresh => '刷新';

  @override
  String get adminTotalUsers => '用户总数';

  @override
  String get adminRetry => '重试';

  @override
  String get adminEmail => '邮箱';

  @override
  String get adminNickname => '昵称';

  @override
  String get adminRole => '权限';

  @override
  String get adminSignupProvider => '注册方式';

  @override
  String get adminAtiScore => 'ATI 分数';

  @override
  String get adminJoinedAt => '注册日期';

  @override
  String get adminUserRole => '用户';

  @override
  String get adminUsersEmpty => '暂无注册用户。';

  @override
  String get adminNaver => 'Naver';

  @override
  String get adminReportPending => '待审核';

  @override
  String get adminUnderReview => '审核中';

  @override
  String get adminReportAccepted => '已采纳';

  @override
  String get adminReportRejected => '已驳回';

  @override
  String get adminDanger => '危险';

  @override
  String get adminWarning => '警告';

  @override
  String get adminSafe => '安全';

  @override
  String get adminFeedbackSubmitted => '已提交';

  @override
  String get adminFeedbackResolved => '已处理';

  @override
  String get adminFeedbackRejected => '已退回';

  @override
  String get adminJudgmentTrustworthy => '更可信';

  @override
  String get adminJudgmentRisky => '风险更高';

  @override
  String get adminJudgmentUndecided => '暂不判断';

  @override
  String get adminReviewDetails => '评论详情';

  @override
  String get adminViewProduct => '查看商品';

  @override
  String get adminRtiAnalysis => 'RTI 分析结果';

  @override
  String get adminScoreUnit => '分';

  @override
  String get adminReviewContent => '评论内容';

  @override
  String adminDetectedSignals(int count) {
    return '检测信号（$count）';
  }

  @override
  String get adminVerifiedPurchase => '购买认证';

  @override
  String get adminVerified => '已认证';

  @override
  String get adminNotVerified => '未认证';

  @override
  String get adminReviewerInfo => '作者信息';

  @override
  String get adminReviewer => '作者';

  @override
  String get adminRating => '评分';

  @override
  String get adminWrittenAt => '发布日期';

  @override
  String adminSelectedCount(int count) {
    return '已选择 $count 项';
  }

  @override
  String get adminSaved => '更改已保存。';

  @override
  String get adminSaveFailed => '保存失败。';

  @override
  String get adminFeedbackDetails => '反馈详情';

  @override
  String get adminSaveChanges => '保存更改';

  @override
  String get adminFeedbackId => '反馈 ID';

  @override
  String get adminReviewId => '评论 ID';

  @override
  String get adminProductName => '商品名称';

  @override
  String get adminCreatedAt => '创建时间';

  @override
  String get adminUpdatedAt => '更新时间';

  @override
  String get adminFeedbackType => '反馈类型';

  @override
  String get adminUserJudgment => '用户判断';

  @override
  String adminRelatedSignals(int count) {
    return '相关信号（$count）';
  }

  @override
  String get adminFeedbackContent => '反馈内容';

  @override
  String get adminAttachmentLink => '附件／链接';

  @override
  String get adminReplyEmail => '回复邮箱';

  @override
  String get adminComment => '管理员备注';

  @override
  String get adminCommentHint => '请输入审核内容或处理措施…';

  @override
  String get adminChangeStatus => '更改状态';

  @override
  String get adminReportDetails => '举报详情';

  @override
  String get adminSave => '保存';

  @override
  String get adminReportInfo => '举报信息';

  @override
  String get adminReportId => '举报 ID';

  @override
  String get adminReportReason => '举报原因';

  @override
  String get adminReportedAt => '举报时间';

  @override
  String get adminUpdatedTime => '更新时间';

  @override
  String get adminReportedReview => '被举报评论';

  @override
  String get adminReportContent => '举报内容';

  @override
  String get adminAttachment => '附件';

  @override
  String get adminEvidenceIncluded => '包含 AI 证据';

  @override
  String get adminIncluded => '包含';

  @override
  String get adminNotIncluded => '不包含';

  @override
  String get adminOptionalCommentHint => '请输入备注（可选）。';

  @override
  String get adminSuspiciousReviewsSubtitle => '审核 RTI 分析检测出的可疑评论并采取适当措施。';

  @override
  String get adminRtiUpperBound => 'RTI 分数上限';

  @override
  String adminScoreBelow(int score) {
    return '低于 $score 分';
  }

  @override
  String get adminAll => '全部';

  @override
  String get adminTotalSuspiciousReviews => '可疑评论总数';

  @override
  String get adminCurrentFilter => '当前筛选条件';

  @override
  String get adminRtiScore => 'RTI 分数';

  @override
  String get adminTrustGrade => '可信等级';

  @override
  String get adminSuspiciousReviewsEmpty => '暂无可疑评论。';

  @override
  String get adminFeedbacksSubtitle => '审核并处理用户对 RTI 分析结果的反馈。';

  @override
  String get adminTotalFeedbacks => '反馈总数';

  @override
  String get adminAllTime => '所有时间';

  @override
  String get adminStatus => '状态';

  @override
  String get adminFeedbacksEmpty => '暂无分析反馈。';

  @override
  String get adminReportsSubtitle => '审核用户举报并更新处理状态。';

  @override
  String get adminTotalReports => '举报总数';

  @override
  String get adminReportsCountHelper => '全部举报数量';

  @override
  String get adminPendingReportsHelper => '需要审核的举报';

  @override
  String get adminUnderReviewReportsHelper => '正在审核的举报';

  @override
  String get adminAcceptedReportsHelper => '已采纳的举报';

  @override
  String get adminRejectedReportsHelper => '已驳回的举报';

  @override
  String adminBulkSuccess(int total) {
    return '已处理 $total 项。';
  }

  @override
  String adminBulkFailure(int total, int failed) {
    return '$total 项中有 $failed 项处理失败。失败项保持选中状态。';
  }

  @override
  String get adminAcceptReports => '采纳';

  @override
  String get adminRejectReports => '驳回';

  @override
  String get adminEvidence => 'AI 证据';

  @override
  String get adminReportsEmpty => '暂无举报。';

  @override
  String get adminDashboardSubtitle => '一览评论分析状况和待处理任务。';

  @override
  String get adminModelPerformance => 'AI 模型性能';

  @override
  String adminPeriodDays(int days) {
    return '$days 天';
  }

  @override
  String get adminTotalReviews => '评论总数';

  @override
  String get adminTotalReviewsHelper => '全部待分析评论';

  @override
  String get adminSuspiciousReviews => '可疑评论';

  @override
  String get adminRiskyReviews => '危险评论';

  @override
  String get adminPendingReports => '待处理举报';

  @override
  String get adminPendingFeedbacks => '待处理分析反馈';

  @override
  String get adminOpenSection => '点击查看';

  @override
  String adminCountPercent(String count, String percent) {
    return '$count 项 · $percent%';
  }

  @override
  String get adminRtiDistribution => 'RTI 等级分布';

  @override
  String adminAnalyzedCount(String count) {
    return '已分析 $count 条评论';
  }

  @override
  String get adminSuspicious => '可疑';

  @override
  String get adminAverageRti => '整体平均 RTI';

  @override
  String adminDailyTrendTitle(int days) {
    return '每日平均 RTI · 分析数量（最近 $days 天）';
  }

  @override
  String get adminTrendEmpty => '此期间没有已分析评论。';

  @override
  String adminTrendTooltip(String date, String score, String count) {
    return '$date\n平均 RTI $score · $count 条评论';
  }

  @override
  String get adminUserAgreement => '用户判断同意率';

  @override
  String adminFeedbackCount(String count) {
    return '$count 条反馈';
  }

  @override
  String get adminAgree => '同意';

  @override
  String get adminDisagree => '异议';

  @override
  String get adminFeedbackStats => '分析反馈处理情况';

  @override
  String adminResolutionRate(String percent) {
    return '处理率 $percent%';
  }

  @override
  String get adminApplied => '已应用';

  @override
  String get adminDismissed => '已驳回';

  @override
  String get sessionExpiredMessage => '登录已过期，请重新登录。';

  @override
  String get sessionExpiredLogin => '登录';

  @override
  String get settingsAccountLabelLoginMethod => '登录方式';

  @override
  String get settingsLoginMethodEmail => '邮箱';

  @override
  String get settingsLoginMethodNaver => 'Naver';

  @override
  String get chatLauncherLabel => '问问 AI';

  @override
  String get chatLauncherProductLabel => '问问这件商品的评论';

  @override
  String get chatProductCta => '向 AI 询问这件商品';

  @override
  String get chatEmptyProductTitle => '这件商品，你想了解什么？';

  @override
  String get chatCopy => '复制';

  @override
  String get chatCopied => '已复制';

  @override
  String get chatThinkingLong => '生成回答需要多一点时间';

  @override
  String get chatThinkingVeryLong => '仍在等待回答。关闭窗口也会保留对话';

  @override
  String get chatBlockedTitle => '无法回答这个问题';

  @override
  String get chatModeStandard => '标准';

  @override
  String get chatModePro => '专业';

  @override
  String get chatModeProActive => '专业模式会给出更详细的回答';

  @override
  String get chatModeProLocked => '专业模式仅限专业版套餐使用';

  @override
  String get chatPlanFree => '免费';

  @override
  String get chatPlanPlus => 'Plus';

  @override
  String get chatPlanPro => 'Pro';

  @override
  String get planTitle => '套餐';

  @override
  String get planSubtitle => '选择 AI 助手的使用量。';

  @override
  String get planCurrent => '当前套餐';

  @override
  String planUsageToday(int used, int limit) {
    return '今日已用 $used/$limit 次';
  }

  @override
  String planUsageUnlimited(int used) {
    return '今日已用 $used 次 · 次数不限';
  }

  @override
  String planResetAt(String time) {
    return '$time 重置';
  }

  @override
  String planExpiresAt(String date) {
    return '有效期至 $date';
  }

  @override
  String planDailyQuestions(int count) {
    return '每天 $count 次提问';
  }

  @override
  String get planDailyUnlimited => '每天提问次数不限';

  @override
  String get planFeatureStandard => '标准回答';

  @override
  String get planFeatureLimited => '每天提问次数最少';

  @override
  String get planFeatureMore => '每天提问次数多于免费版';

  @override
  String get planFeatureMost => '每天提问次数最多';

  @override
  String get planFeaturePro => '专业模式：更详细的回答';

  @override
  String get planSelect => '切换到此套餐';

  @override
  String get planCurrentBadge => '使用中';

  @override
  String planConfirmTitle(String plan) {
    return '要切换到$plan套餐吗？';
  }

  @override
  String get planConfirmBody => '目前无需付款，立即生效。';

  @override
  String get planConfirmAction => '切换';

  @override
  String get planCancel => '取消';

  @override
  String planChanged(String plan) {
    return '已切换到$plan套餐';
  }

  @override
  String get planChangeUnavailable => '套餐变更功能尚在准备中。';

  @override
  String get planChangeFailed => '无法变更套餐，请重试。';

  @override
  String get planLoadFailed => '无法加载套餐信息。';

  @override
  String get planRetry => '重试';

  @override
  String get myPageSideNavPlan => '套餐';

  @override
  String get chatViewPlans => '查看套餐';

  @override
  String get extProductCollectingTitle => '正在获取商品信息';

  @override
  String get extProductCollectingBody => '正在从商城获取商品和评论信息。商品信息就绪后会自动显示。';

  @override
  String get extProductCollectingSlow => '仍在等待商城的商品信息。商品信息就绪后会自动显示。';

  @override
  String get extProductUnavailableTitle => '未能获取商品信息';

  @override
  String get extProductUnavailableBody => '并非商品不存在，而是暂时无法从商城获取信息。请稍后重试。';

  @override
  String get extProductLoadFailed => '无法加载商品。';

  @override
  String get extProductRetry => '重试';

  @override
  String get extProductStale => '正在更新为最新信息';

  @override
  String extProductVisitShop(String shop) {
    return '在$shop查看';
  }

  @override
  String extProductReviewCount(int count) {
    return '$count 条评论';
  }

  @override
  String extProductPrice(String price) {
    return '$price韩元';
  }

  @override
  String get extProductAnalysisPendingTitle => '尚未分析可信度';

  @override
  String get extProductAnalysisPendingBody => '该商品的评论尚未分析，暂无可信度分数。';

  @override
  String get extProductReviewsTitle => '评论';

  @override
  String get extProductReviewsEmpty => '没有收集到评论。';

  @override
  String get extProductReviewsMore => '查看更多评论';

  @override
  String get extProductReviewsMoreFailed => '无法加载更多评论。';

  @override
  String extProductReviewOption(String option) {
    return '选项：$option';
  }

  @override
  String chatQuotaRemaining(int remaining, int limit) {
    return '今日剩余提问 $remaining/$limit';
  }

  @override
  String get chatQuotaUnlimited => '提问次数不限';

  @override
  String get chatQuotaExceededTitle => '今天的提问次数已用完';

  @override
  String chatQuotaExceededBody(String time) {
    return '$time 后可以再次提问';
  }

  @override
  String get chatQuotaExceededBodyNoTime => '额度重置后可以再次提问';

  @override
  String get chatPlanRequiredTitle => '仅限专业版套餐使用';

  @override
  String get chatPlanRequiredAction => '用标准模式重新提问';

  @override
  String get chatSuggestGeneral3 => '怎么挑选可信的评论？';

  @override
  String get adminUserPlanColumn => '套餐';

  @override
  String get adminUserPlanChange => '更改套餐';

  @override
  String get adminUserPlanTitle => '更改套餐';

  @override
  String get adminUserPlanExpiry => '到期日期';

  @override
  String get adminUserPlanUnlimited => '无限期';

  @override
  String get adminUserPlanThirtyDays => '30天';

  @override
  String get adminUserPlanCustomDate => '指定日期';

  @override
  String get adminUserPlanSelectDate => '选择日期';

  @override
  String get adminUserPlanExpired => '已到期';

  @override
  String get adminUserPlanUnknown => '未知';

  @override
  String get adminUserPlanSave => '保存';

  @override
  String get adminUserPlanCancel => '取消';

  @override
  String get adminUserPlanSaving => '保存中';

  @override
  String get adminUserPlanDateRequired => '请选择今天或之后的到期日期。';

  @override
  String get externalWishAdd => '收藏';

  @override
  String get externalWishRemove => '取消收藏';

  @override
  String get externalCartAdd => '加入购物车';

  @override
  String get externalCartAdded => '已加入购物车';

  @override
  String get externalReviewMenu => '评论菜单';

  @override
  String get externalReport => '举报评论';

  @override
  String get externalReal => '像真实评论';

  @override
  String get externalFake => '像虚假评论';

  @override
  String get externalNotCollected => '请在商品采集完成后重试。';

  @override
  String get externalUnavailable => '数据服务器暂不可用，请稍后重试。';

  @override
  String get externalReportDuplicate => '您已举报此评论。';

  @override
  String get externalFeedbackDuplicate => '您已对此评论提交反馈。';

  @override
  String get externalFailed => '请求失败，请重试。';

  @override
  String get externalSuccess => '操作成功。';

  @override
  String get externalUnanalyzed => '尚未分析';

  @override
  String get externalReason => '举报原因';

  @override
  String get externalDetail => '详细内容';

  @override
  String get externalDetailValidation => '请输入20至500个字符。';

  @override
  String get externalAttachment => '附件链接（可选）';

  @override
  String get externalAttachmentValidation => '请输入有效的http或https链接。';

  @override
  String get externalEvidence => '包含分析依据';

  @override
  String get externalCancel => '取消';

  @override
  String get externalSubmit => '提交';

  @override
  String get externalReasonFake => '疑似虚假评论';

  @override
  String get externalReasonAi => '疑似自动生成';

  @override
  String get externalReasonIrrelevant => '无关内容';

  @override
  String get externalReasonInappropriate => '不当内容或个人信息';

  @override
  String get externalReasonAd => '广告';

  @override
  String get externalReasonRepeated => '重复内容';

  @override
  String get externalReasonOffensive => '侮辱性内容';

  @override
  String get externalReasonOther => '其他';

  @override
  String get productImageEnlarge => '放大商品图片';

  @override
  String get productImagePrevious => '上一张商品图片';

  @override
  String get productImageNext => '下一张商品图片';

  @override
  String get imagePreviewOpen => '放大图片';

  @override
  String get imagePreviewTitle => '图片预览';

  @override
  String get imagePreviewPrevious => '上一张图片';

  @override
  String get imagePreviewNext => '下一张图片';

  @override
  String get chatFreshContext => '新对话 · 保留历史记录';

  @override
  String get chatHistoryContext => '从历史记录打开的对话';

  @override
  String get chatActiveContext => '进行中的对话';

  @override
  String get chatGeneralContext => '常规对话 · 未指定商品';

  @override
  String get chatTargetProduct => '提问目标商品';

  @override
  String get chatQuotaLoading => '正在查询提问额度。';

  @override
  String get chatQuotaUnavailable => '无法刷新额度，保留上次确认的数值。';

  @override
  String get chatQuotaRefresh => '重新查询';

  @override
  String get chatClosePreserve => '关闭（保留对话）';

  @override
  String get chatHistoryWait => '发送完成后可打开历史记录。';

  @override
  String get extProductSummaryLoading => '正在获取商品基本信息。';

  @override
  String get extProductListSummary => '这是商品列表中的信息。正在获取最新详情和评论。';

  @override
  String get extProductPreviousSummary => '这是之前查看的商品信息。正在获取最新详情和评论。';

  @override
  String get recentRecordFailed => '无法确认最近浏览记录。重试';

  @override
  String get recentRecordUnavailable => '无法获取服务器浏览记录所需的商品标识。';
}
