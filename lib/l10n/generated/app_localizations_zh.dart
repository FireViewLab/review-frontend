// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navHome => '首页';

  @override
  String get navSearch => '搜索';

  @override
  String get navMyPage => '我的页面';

  @override
  String get navSettings => '设置';

  @override
  String get actionSave => '保存';

  @override
  String get actionConfirm => '确认';

  @override
  String get actionRetry => '重试';

  @override
  String get actionLogin => '登录';

  @override
  String get actionViewAll => '查看全部';

  @override
  String get settingsNotifications => '通知设置';

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
  String get settingsAccountTitle => '账户';

  @override
  String get settingsAccountChangePassword => '更改密码';

  @override
  String get settingsDeleteAccount => '注销账号';

  @override
  String get settingsDeleteAccountConfirmTitle => '注销账号';

  @override
  String get settingsDeleteAccountConfirmBody => '注销后账号及保存的信息将被删除且无法恢复。确定要注销吗？';

  @override
  String get settingsDeleteAccountCancel => '取消';

  @override
  String get settingsDeleteAccountConfirm => '注销';

  @override
  String get settingsDeleteAccountFailed => '未能注销账号，请稍后再试。';

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
  String get chatInputHint => '请输入问题';

  @override
  String get chatSend => '发送';

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
  String get chatSuggestProduct4 => '推荐类似商品';

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
  String get externalFake => '这条评论需要留意';

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
  String get extProductReviewPreferencesNote =>
      '排序设置仅适用于已加载的评论。不会根据未提供的购买认证或可信度隐藏或分类评论。';

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

  @override
  String get reviewPhotoOnly => '带图评论';

  @override
  String get reviewListView => '评论列表';

  @override
  String get reviewPhotosView => '照片合集';

  @override
  String reviewPhotoScope(int loaded, int photos) {
    return '已加载$loaded条评论 · $photos条带图';
  }

  @override
  String get reviewPhotosEmpty => '当前已加载评论没有有效图片。';

  @override
  String get externalForbidden => '没有执行此操作的权限。';

  @override
  String get externalAuthRequestFailed => '无法确认此请求的身份验证。请检查当前登录状态后重试。';

  @override
  String get externalNetworkFailure => '请检查网络连接后重试。';

  @override
  String get externalTimeout => '请求超时，请重试。';

  @override
  String get reportTitle => '评论可信度报告';

  @override
  String get reportDetails => '查看详细分析';

  @override
  String get reportClose => '关闭';

  @override
  String get reportBefore => '尚未分析';

  @override
  String get reportCollecting => '正在收集商品和评论，与分析进度不同。';

  @override
  String get reportRunning => '正在分析。';

  @override
  String get reportFailed => '无法获取分析结果。';

  @override
  String get reportDisabled => '当前分析功能已禁用。';

  @override
  String get reportStale => '以前的分析结果已过期。';

  @override
  String get reportUnavailable => '无法确认分析状态。';

  @override
  String get reportDone => '评论分析结果已准备好。请在详细分析中查看判断依据。';

  @override
  String get reportLoadedScope => '这里展示当前加载评论的分析结果，可能与商品整体分析范围不同。';

  @override
  String get reportInputCount => '分析输入评论';

  @override
  String get reportSourceCount => '收集的原始评论';

  @override
  String get reportSampled => '部分评论抽样分析';

  @override
  String get reportFull => '已收集评论全部分析';

  @override
  String get reportModel => '模型版本';

  @override
  String get reportPolicy => '策略版本';

  @override
  String get reportNoReviewResults => '已加载评论尚无分析结果。';

  @override
  String get reportReasons => '提供的判断依据';

  @override
  String get reportCurrentCount => '已加载的分析评论';

  @override
  String get reportCatalogAverage => '商品平均RTI';

  @override
  String get reportCatalogSource => '此汇总由商品列表提供，更新时间可能与详细评论结果不同。';

  @override
  String get reviewAnalysisSafe => '可信度高';

  @override
  String get reviewAnalysisWarn => '注意';

  @override
  String get reviewAnalysisDanger => '可信度低';

  @override
  String get reviewAnalysisMissing => '此评论尚无分析结果。';

  @override
  String get reportIntro => '购买前，了解评论的可信度。';

  @override
  String get reportScoreLabel => '商品评论可信度';

  @override
  String get reportStateReady => '分析结果';

  @override
  String get reportStateCollecting => '评论收集中';

  @override
  String get reportStateRunning => '分析中';

  @override
  String get reportStateFailed => '无法获取结果';

  @override
  String get reportStateStale => '需要更新';

  @override
  String get reportStateDisabled => '暂未提供分析';

  @override
  String get reportStateUnavailable => '无法确认状态';

  @override
  String get reportPendingBody => '暂无分析结果。结果准备好后，您可以在这里查看评论可信度和判断依据。';

  @override
  String get reportOverview => '分析摘要';

  @override
  String get reportCoverage => '分析范围';

  @override
  String get reportReviewResults => '逐条评论结果与依据';

  @override
  String get reviewOriginal => '评论原文';

  @override
  String get reviewResultTitle => '此评论的分析结果';

  @override
  String get reviewIndividualScope => '结果仅针对所选评论，分析范围与商品报告不同。';

  @override
  String get reviewLoadedAggregate => '已加载评论的汇总';

  @override
  String get evidenceRepetitionLabel => '重复表达';

  @override
  String get evidenceRepetitionBody => '相同表达被反复使用。';

  @override
  String get evidenceShortLabel => '简短评价';

  @override
  String get evidenceShortBody => '评价较短，可核实的信息有限。';

  @override
  String get evidenceExclamationLabel => '频繁使用感叹号';

  @override
  String get evidenceExclamationBody => '使用了较多感叹号。';

  @override
  String get evidencePositiveLabel => '强烈正面表达';

  @override
  String get evidencePositiveBody => '检测到强烈正面表达，仅凭这一点不能认定为广告。';

  @override
  String get evidencePurchaseLabel => '购买认证未确认';

  @override
  String get evidencePurchaseBody => '这条评价未确认购买认证。';

  @override
  String get evidenceNewAccountLabel => '新账号评价';

  @override
  String get evidenceNewAccountBody => '发布评价时，该账号注册时间较短。';

  @override
  String get evidenceDailyLabel => '同日多条评价';

  @override
  String get evidenceDailyBody => '同一作者在一天内发布了多条评价。';

  @override
  String get evidenceSimilarLabel => '相似评价内容';

  @override
  String get evidenceSimilarBody => '发现了内容相似的其他评价，不能仅凭相似性认定为操纵。';

  @override
  String get evidenceClusterLabel => '相似评价群组';

  @override
  String get evidenceClusterBody => '发现了一组内容相似的评价，并不代表已确认操纵。';

  @override
  String get evidenceQualityLabel => '内容质量评分较低';

  @override
  String get evidenceQualityBody => '评价内容的质量评分较低。';

  @override
  String get evidenceUnknownPurchaseLabel => '购买状态未知';

  @override
  String get evidenceUnknownPurchaseBody => '无法通过提供的信息确认是否购买。';

  @override
  String get evidenceTrialLabel => '可能为试用或赠品评价';

  @override
  String get evidenceTrialBody => '该评价可能与试用或免费提供的商品有关。';

  @override
  String get evidenceNoImageLabel => '无附加照片';

  @override
  String get evidenceNoImageBody => '评价未附加照片。';

  @override
  String get evidenceRepurchaseLabel => '再次购买信号';

  @override
  String get evidenceRepurchaseBody => '发现了表明再次购买的信息。';

  @override
  String get evidenceUnknownLabel => '其他分析依据';

  @override
  String get evidenceUnknownBody => '已提供其他依据，但暂不支持其说明。';

  @override
  String get homeSearchSuggestionsEmpty => '没有相关搜索词。您可以搜索已输入的内容。';

  @override
  String get homeSearchSuggestionsError => '无法加载相关搜索词。您可以搜索已输入的内容或重试。';

  @override
  String get homeSearchSuggestionsRetry => '重新加载相关搜索词';

  @override
  String get authAccountHelp => '账户帮助';

  @override
  String get authAccountHelpBody =>
      '邮箱账户的密码可通过“忘记密码”重置。Google或Naver账户请使用注册时的社交登录按钮。';

  @override
  String get authForgotPassword => '忘记密码';

  @override
  String get authSignup => '注册';

  @override
  String get authClose => '关闭';

  @override
  String get authLogin => '登录';

  @override
  String get authLoginDescription => '登录Re:view账户，加载已保存的商品和信任筛选条件。';

  @override
  String get authEmail => '邮箱';

  @override
  String get authEmailHint => '请输入邮箱';

  @override
  String get authPassword => '密码';

  @override
  String get authPasswordHint => '请输入密码';

  @override
  String get authShow => '显示';

  @override
  String get authHide => '隐藏';

  @override
  String get authRememberMe => '保持登录状态';

  @override
  String get authOr => '或';

  @override
  String get authContinueNaver => '使用Naver账户继续';

  @override
  String get authContinueGoogle => '使用Google账户继续';

  @override
  String get authNoAccount => '还没有账户？';

  @override
  String get authSignupAction => '注册账户';

  @override
  String get authPrivacyNotice => '个性化信息安全地保存在账户中，已保存的商品和分析记录仅对登录用户显示。';

  @override
  String get authSignupDescription => '创建Re:view账户，开始保存商品并设置信任筛选条件和通知。';

  @override
  String get authName => '姓名';

  @override
  String get authNameHint => '请输入姓名';

  @override
  String get authPasswordGuidance => '请设置至少8个字符，包含英文字母、数字和特殊字符。';

  @override
  String get authConfirmPassword => '确认密码';

  @override
  String get authConfirmPasswordHint => '请再次输入密码';

  @override
  String get authSignupOnboarding => '注册并开始初始设置';

  @override
  String get authSignupNaver => '使用Naver账户注册';

  @override
  String get authSignupGoogle => '使用Google账户注册';

  @override
  String get authHasAccount => '已有账户？';

  @override
  String get authLoginAction => '登录';

  @override
  String get authTermsConsent => '我同意服务条款和隐私政策。（必选）';

  @override
  String get authMarketingConsent => '接收已保存商品和信任度变化通知。（可选）';

  @override
  String get authOnboardingNotice => '下一步是初始设置。注册后可设置感兴趣的类别和默认RTI筛选条件。';

  @override
  String get authResetTitle => '重置密码';

  @override
  String get authResetDescription => '验证注册邮箱并设置新密码。';

  @override
  String get authRememberAccount => '想起账户了？';

  @override
  String get authBackToLogin => '返回登录';

  @override
  String get authRegisteredEmail => '注册邮箱';

  @override
  String get authSendVerification => '发送验证邮件';

  @override
  String get authEmailSent => '邮件已发送';

  @override
  String get authEmailSentGuide => '点击邮件中的链接或确认收到的令牌后，继续下一步。';

  @override
  String get authNext => '下一步';

  @override
  String get authResendEmail => '重新发送邮件';

  @override
  String get authNewPassword => '新密码';

  @override
  String get authNewPasswordHint => '请输入新密码';

  @override
  String get authNewPasswordGuide => '请设置与之前不同的密码，并组合使用英文字母、数字和特殊字符。';

  @override
  String get authConfirmNewPassword => '确认新密码';

  @override
  String get authConfirmNewPasswordHint => '请再次输入新密码';

  @override
  String get authCompleteReset => '完成密码修改';

  @override
  String get authResendVerification => '重新发送验证邮件';

  @override
  String get authMinLength => '至少8个字符';

  @override
  String get authLettersNumbers => '包含英文字母和数字';

  @override
  String get authSymbolsRecommended => '建议包含特殊字符';

  @override
  String get authNoEmail => '没有收到邮件？';

  @override
  String get authNoEmailGuide => '请检查垃圾邮件文件夹，或再次确认注册邮箱是否正确。';

  @override
  String get authVerifyEmail => '验证邮箱';

  @override
  String get authVerificationCode => '验证码';

  @override
  String get authResetSuccess => '密码已修改';

  @override
  String get authResetSuccessGuide => '请使用新密码登录。';

  @override
  String get authGoToLogin => '前往登录';

  @override
  String get searchFilterTitle => '筛选';

  @override
  String get searchFilterReset => '重置';

  @override
  String get searchFilterCategory => '类别';

  @override
  String get searchFilterPriceRange => '价格范围';

  @override
  String get searchFilterWon => '韩元';

  @override
  String get searchFilterSeller => '商家';

  @override
  String get searchFilterSellerHint => '请选择商家';

  @override
  String get searchFilterRtiScore => 'RTI信任评分';

  @override
  String get searchFilterAllRti => '全部（含未分析）';

  @override
  String get searchFilterZeroPoints => '0分';

  @override
  String get searchFilterHundredPoints => '100分';

  @override
  String get searchFilterEightyMinimum => '80分以上';

  @override
  String get searchFilterNinetyMinimum => '90分以上';

  @override
  String get searchFilterNinetyFiveMinimum => '95分以上';

  @override
  String get searchFilterInfoStatus => '信息状态';

  @override
  String get searchFilterReviewConditions => '评价条件';

  @override
  String get searchFilterSelectSeller => '选择商家';

  @override
  String get searchFilterAllSellers => '全部商家';

  @override
  String get searchFilterUnanalyzedOnly => '仅未分析';

  @override
  String get searchFilterMissingPriceOnly => '仅无价格信息';

  @override
  String get searchFilterMinimumReviews => '至少50条评价';

  @override
  String get searchFilterUnderTenThousand => '1万韩元以下';

  @override
  String get searchFilterTenToThirtyThousand => '10至30万韩元';

  @override
  String get searchFilterAboveThreeHundredThousand => '30万韩元以上';

  @override
  String searchFilterPriceAmount(String amount) {
    return '$amount韩元';
  }

  @override
  String searchFilterMinimumScore(int score) {
    return '$score分以上';
  }

  @override
  String searchFilterShowResults(int count) {
    return '查看$count个结果';
  }

  @override
  String get analysisPolicyIndex => 'RTI';

  @override
  String get analysisNotCalculable => '无法计算';

  @override
  String get analysisPolicyExplanation => '基于政策标准的相对指数。';

  @override
  String get analysisTextScore => '文本分数';

  @override
  String get analysisBehaviorScore => '行为分数';

  @override
  String get analysisNetworkScore => '网络分数';

  @override
  String get analysisScore => 'RTI';

  @override
  String get analysisSeparateContracts => '不同契约的分数分开显示。';

  @override
  String get analysisPolicyAverage => '商品平均RTI';

  @override
  String get owlGuideName => '评论猫头鹰';

  @override
  String get extProgressProductStep => '商品信息采集';

  @override
  String get extProgressReviewsStep => '评论采集';

  @override
  String get extProgressAnalysisStep => '评论分析';

  @override
  String get extProgressStatusComplete => '已完成';

  @override
  String get extProgressStatusInProgress => '进行中';

  @override
  String get extProgressStatusWaiting => '等待中';

  @override
  String get extProgressStatusFailed => '失败';

  @override
  String get extProgressStatusNotAnalyzed => '尚未分析';

  @override
  String get extProgressStatusUnknown => '确认中';

  @override
  String get extProgressStatusRefreshing => '重新采集中';

  @override
  String get extProgressStatusDisabled => '已禁用';

  @override
  String get extProgressStatusUnavailable => '暂无信息';

  @override
  String get extProgressStatusPartial => '部分完成';

  @override
  String get extProgressNoticeCollecting => '正在等待商品信息和评论的采集。';

  @override
  String get extProgressNoticeRefreshing => '当前显示的是之前采集的信息。新的采集任务正在等待或进行中。';

  @override
  String get extProgressNoticeAnalyzing => '评论分析正在等待或进行中。';

  @override
  String get extProgressNoticeNotAnalyzed => '评论尚未进行分析。';

  @override
  String get extProgressNoticeComplete => '评论分析已完成。';

  @override
  String get extProgressNoticeFailed => '采集或分析过程中出现了问题，请查看各阶段的状态。';

  @override
  String get extProgressNoticeDelayed => '需要一些时间，请再次确认。';

  @override
  String get extProgressNoticeChecking => '正在确认当前的采集和分析状态。';

  @override
  String get extProgressNoticeDisabled => '评论分析已禁用。';

  @override
  String get extProgressNoticeUnavailable => '目前无法查看评论分析信息。';

  @override
  String get extProgressRetry => '再次确认';

  @override
  String extProgressStepSemantics(String step, String status) {
    return '$step，$status';
  }

  @override
  String get extSummaryTitle => '评论分析摘要';

  @override
  String get extSummaryFallbackTitle => '分析状态与依据说明';

  @override
  String get extSummaryFallbackIntro => '这里汇总了当前已加载评论的分析状态与可信度依据。';

  @override
  String get extSummaryNoEvidence => '分析已完成，但暂无可供总结的依据。';

  @override
  String get extSummaryNotAnalyzed => '尚未进行分析，暂无可显示的摘要。';

  @override
  String get extSummaryInProgress => '请在上方步骤中查看分析进度。';

  @override
  String get extSummaryFailed => '分析失败，无法显示摘要。';

  @override
  String get extSummaryDisabled => '分析已禁用，不显示摘要。';

  @override
  String get extSummaryUnavailable => '显示摘要所需的分析状态尚未确认。';

  @override
  String get extSummaryMissingValue => '未提供';

  @override
  String get extSummarySampling => '是否为样本分析';

  @override
  String get extSummaryNotSampled => '非样本分析';

  @override
  String extSummaryLoadedScope(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '基于当前已加载的$countString条评论';
  }

  @override
  String get extSummaryV2Grades => 'RTI等级';

  @override
  String get extSummaryLegacyGrades => 'RTI等级';

  @override
  String get extSummaryUnknownVersion => '分析版本未知';

  @override
  String extSummaryGradeCount(String grade, int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$grade：$countString条';
  }

  @override
  String get extSummaryGradeSafe => '可信度高';

  @override
  String get extSummaryGradeWarn => '注意';

  @override
  String get extSummaryGradeDanger => '可信度低';

  @override
  String get extSummaryEvidenceTitle => '最常见的可信度依据';

  @override
  String get extSummaryEvidenceScope => '这些是当前已加载评论的可信度分析依据，并非对商品质量的评价。';

  @override
  String extSummaryReasonCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '在$countString条评论中出现';
  }

  @override
  String get extSummaryNoLoadedReviews => '当前未加载评论，无法显示等级分布。';

  @override
  String extSummaryFact(String label, String value) {
    return '$label：$value';
  }

  @override
  String get extTrustDetailSource => '详细分析结果';

  @override
  String get extTrustCatalogSource => '商品列表中的平均分';

  @override
  String get extTrustNoAverage => '暂无可显示的评价可信度分数或等级。';

  @override
  String get extTrustBefore => '尚未进行分析，暂无商品分数。';

  @override
  String get extTrustRunning => '分析进行中，暂不显示商品分数。';

  @override
  String get extTrustGradeMissing => '未提供等级信息';

  @override
  String get extTrustGuideSafe => '已分析评论的可信度信号整体较为稳定。';

  @override
  String get extTrustGuideCaution => '请同时查看判断依据。';

  @override
  String get extTrustGuideUnknown => '请查看分数来源及已提供的依据。';

  @override
  String get extTrustNoEvidence => '未提供商品分析依据。';

  @override
  String get extTrustComponents => '分项分数';

  @override
  String get extTrustTextExplanation => '根据评论用语和重复模式得出的分数。';

  @override
  String get extTrustBehaviorExplanation => '根据评论作者的活动模式得出的分数。';

  @override
  String get extTrustNetworkExplanation => '根据评论与作者之间的连接模式得出的分数。';

  @override
  String get extTrustCoverageInSummary => '请在上方摘要卡片中查看分析范围和版本。';

  @override
  String extTrustScoreValue(String label, String score) {
    return '$label $score / 100';
  }

  @override
  String get extNavProgress => '分析进度';

  @override
  String get extNavSummary => '评价摘要';

  @override
  String get extNavReport => '可信度报告';

  @override
  String get extNavReviews => '评论';

  @override
  String get extNavLabel => '跳转到版块';

  @override
  String get extDescriptionTitle => '商品详情';

  @override
  String get extDescriptionSource => '来自商城商品详情页的内容';

  @override
  String get extDescriptionExpand => '展开商品详情';

  @override
  String get extDescriptionCollapse => '收起商品详情';

  @override
  String extDescriptionImage(int index) {
    return '详情图片 $index';
  }

  @override
  String get extNavDescription => '商品详情';

  @override
  String get failureTitleOffline => '请检查网络连接';

  @override
  String get failureMessageOffline => '无法连接服务器，请检查网络连接后重试。';

  @override
  String get failureTitleTimeout => '响应时间过长';

  @override
  String get failureMessageTimeout => '连接或等待响应超时，请稍后重试。';

  @override
  String get failureTitleUnauthorized => '需要登录';

  @override
  String get failureMessageUnauthorized => '登录信息缺失或已过期，请重新登录。';

  @override
  String get failureTitleForbidden => '无访问权限';

  @override
  String get failureMessageForbidden => '您没有使用此功能的权限。';

  @override
  String get failureTitleNotFound => '未找到相关内容';

  @override
  String get failureMessageNotFound => '请求的信息不存在或已停止提供。';

  @override
  String get failureTitleRateLimited => '请求过多';

  @override
  String get failureMessageRateLimited => '当前请求过多，请稍后重试。';

  @override
  String get failureTitleServer => '服务器出现问题';

  @override
  String get failureMessageServer => '服务器发生错误，请稍后重试。';

  @override
  String get failureTitleCancelled => '请求已取消';

  @override
  String get failureMessageCancelled => '请求已取消，未加载结果。';

  @override
  String get failureTitleBadResponse => '无法读取响应';

  @override
  String get failureMessageBadResponse => '无法处理响应，请再次确认。';

  @override
  String get failureTitleUnknown => '出现问题';

  @override
  String get failureMessageUnknown => '无法完成请求，请稍后重试。';

  @override
  String get failureRetry => '重试';

  @override
  String get failureSearchRetry => '重新搜索';

  @override
  String get analysisPending => '分析中';

  @override
  String get analysisTextCaution => '请留意正文中的重复、推广或说明性表达。';

  @override
  String analysisAttentionReviews(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '需留意的评论 $countString条';
  }

  @override
  String get scrollToTop => '回到顶部';

  @override
  String get actionUndo => '撤销';

  @override
  String get wishlistRemoved => '已从收藏中移除';

  @override
  String get cartRemoved => '已从购物车移除';

  @override
  String get cartWishlistRemovalFailed => '已添加到收藏，但未能从购物车中移除。';

  @override
  String get cartRetryRemoval => '重试移除';

  @override
  String get listLoading => '正在加载';

  @override
  String get cartEmptyTitle => '购物车是空的';

  @override
  String get cartEmptyDescription => '把喜欢的商品加入购物车吧。';

  @override
  String get emptyViewWishlist => '查看收藏';

  @override
  String get recentProductsEmptyTitle => '暂无最近浏览的商品';

  @override
  String get recentProductsEmptyDescription => '逛逛感兴趣的商品，最近浏览的记录会显示在这里。';

  @override
  String get warningProductsEmptyTitle => '暂无需要留意的商品';

  @override
  String get warningProductsFilteredEmptyTitle => '所选等级下暂无需要留意的商品';

  @override
  String get warningProductsEmptyDescription => '逛逛其他商品，收藏感兴趣的商品吧。';

  @override
  String get searchEmptyTitle => '暂无搜索结果';

  @override
  String get searchEmptyQueryDescription => '试试输入商品名称或分类进行搜索。';

  @override
  String get searchEmptyDescription => '试试其他关键词或更宽泛的分类。';

  @override
  String get searchFilteredEmptyTitle => '没有符合筛选条件的商品';

  @override
  String get searchFilteredEmptyDescription => '请重置筛选或放宽条件。';

  @override
  String get searchResetFilters => '重置筛选';

  @override
  String get extProductVisitShopGeneric => '前往商城查看';

  @override
  String get headerSupport => '客服中心';

  @override
  String get headerSellerRegistration => '商家入驻';

  @override
  String get headerAppDownload => '下载应用';

  @override
  String get headerCart => '购物车';

  @override
  String get headerMyAccount => '我的账户';

  @override
  String get headerMember => '会员';

  @override
  String headerMemberName(String name) {
    return '$name';
  }

  @override
  String get headerMemberBadge => 'Re:view 会员';

  @override
  String get headerOrderActivity => '订单/动态';

  @override
  String get homeNavBest => '热销商品';

  @override
  String get homeNavNew => '新品';

  @override
  String get homeNavReviewRanking => '评价排行';

  @override
  String get homePopularCategoriesNow => '当前热门分类';

  @override
  String get homeCategoryPickTitle => '分类精选 PICK';

  @override
  String get homeAllCategoriesTitle => '一览所有分类';

  @override
  String get homeAllCategoriesDescription => '查看基于评价数据的热门商品和分类。';

  @override
  String homeCategoryViewAll(String category) {
    return '查看全部$category  >';
  }

  @override
  String get homeBannerFallbackNotice => '未能加载横幅，现显示默认横幅。';

  @override
  String get homeProductsLoadFailed => '未能加载商品。';

  @override
  String get homeViewAllProducts => '查看全部商品';

  @override
  String get homeBannerLinkFailed => '无法打开横幅链接。';

  @override
  String get homePriceUnavailable => '暂无价格信息';

  @override
  String get homeRecommendationsPending => '正在等待推荐商品 API 连接';

  @override
  String get homeRecommendationsPendingDescription =>
      '接入真实商品数据后将显示商品卡片列表，不会生成虚构商品。';

  @override
  String get homeTrustTitle => '为什么 Re:view 更值得信赖';

  @override
  String get homeTrustIndexTitle => 'RTI 评价可信度指数';

  @override
  String get homeFooterAbout => '服务介绍';

  @override
  String get homeFooterTerms => '使用条款';

  @override
  String get homeFooterPrivacy => '隐私政策';

  @override
  String get homeSuggestedProductsPending => '正在等待推荐商品 API 连接';

  @override
  String get homeRtiChecking => '正在确认 RTI';

  @override
  String get homeTrustAnalyzedProduct => '已进行可信度分析的商品';

  @override
  String get homeBannerPlay => '播放';

  @override
  String get homeBannerPause => '暂停';

  @override
  String get homeBannerPrevious => '上一个横幅';

  @override
  String get homeBannerNext => '下一个横幅';

  @override
  String homeBannerPosition(int index, int count) {
    return '横幅 $index/$count';
  }

  @override
  String homeBannerTrustLabel(String badge) {
    return '$badge\n查看可信度';
  }

  @override
  String get landingHomeTooltip => '返回首页';

  @override
  String get landingFeatureRti => '基于 RTI';

  @override
  String get landingFeatureAdPatterns => '广告模式分析';

  @override
  String get landingFeatureEvidence => '提供判断依据';

  @override
  String get landingHeroDescription =>
      '我们分析商品评价，并提供基于 RTI 的可信度指数，\n帮助您做出更可靠的购买决策。';

  @override
  String get landingHeroHeadline => '不被虚假评价左右，\n更明智的购物选择，';

  @override
  String get landingStart => '开始使用';

  @override
  String get landingLearnRti => '了解 RTI';

  @override
  String get landingCloseHint => '您可以随时关闭并返回首页';

  @override
  String get landingGradeHigh => '可信度高';

  @override
  String landingRtiReliabilityScore(String score) {
    return 'RTI 可信度 $score%';
  }

  @override
  String get landingRtiAnalyzing => '正在分析 RTI 可信度';

  @override
  String get landingSummaryLowAd => '广告模式较少';

  @override
  String get landingSummaryFewRepeats => '重复措辞较少';

  @override
  String get landingSummaryNoAnomalies => '未见异常迹象';

  @override
  String get landingAnalysisSummary => 'Re:view 分析摘要';

  @override
  String get landingAnalysisDisclaimer => '分析基于真实用户评价，\n广告或操纵信号会被筛选并纳入分析。';

  @override
  String get settingsEditInterests => '重新编辑感兴趣的分类和通知设置';

  @override
  String get homeCategoryBenefitReviewBased => '基于评价数据的推荐';

  @override
  String get homeCategoryBenefitRtiRanking => '查看 RTI 排行';

  @override
  String get homeCategoryBenefitFastShippingProducts => '快速配送商品';

  @override
  String get homeCategoryBenefitAllOffers => '查看所有优惠';

  @override
  String get homeCategoryBenefitSize => '尺码推荐';

  @override
  String get homeCategoryBenefitStyle => '风格推荐';

  @override
  String get homeCategoryBenefitGenderDeals => '按性别精选优惠';

  @override
  String get homeCategoryBenefitGifts => '热门礼物';

  @override
  String get homeCategoryBenefitAuthenticityCheck => '正品认证';

  @override
  String get homeCategoryBenefitBrandEvents => '品牌专场';

  @override
  String get homeCategoryBenefitGiftWrapping => '礼品包装服务';

  @override
  String get homeCategoryBenefitFreeReturns => '免费退货';

  @override
  String get homeCategoryBenefitIngredients => '按成分查找';

  @override
  String get homeCategoryBenefitSkinType => '按肤质推荐';

  @override
  String get homeCategoryBenefitReviewRanking => '评价排行';

  @override
  String get homeCategoryBenefitSamples => '试用体验';

  @override
  String get homeCategoryBenefitDawnDelivery => '清晨配送';

  @override
  String get homeCategoryBenefitBulkDiscount => '大包装优惠';

  @override
  String get homeCategoryBenefitReviewFavorites => '评价热门商品';

  @override
  String get homeCategoryBenefitSubscriptions => '定期配送';

  @override
  String get homeCategoryBenefitTodayDeals => '今日特惠';

  @override
  String get homeCategoryBenefitHousewarming => '乔迁好物推荐';

  @override
  String get homeCategoryBenefitFastShipping => '快速配送';

  @override
  String get homeCategoryBenefitByRoom => '按空间推荐';

  @override
  String get homeCategoryBenefitPopularInteriors => '热门家居装饰';

  @override
  String get homeCategoryBenefitInstallation => '安装服务';

  @override
  String get homeCategoryBenefitSeasonalDecor => '当季装饰';

  @override
  String get homeCategoryBenefitBeginners => '新手推荐';

  @override
  String get homeCategoryBenefitTopGear => '热门装备';

  @override
  String get homeCategoryBenefitSeasonalOutdoors => '当季户外装备';

  @override
  String get homeCategoryBenefitQuickCompare => '快速对比';

  @override
  String get homeCategoryBenefitCarCare => '汽车养护必备';

  @override
  String get homeCategoryBenefitMaintenance => '维修用品推荐';

  @override
  String get homeCategoryBenefitBrandDeals => '品牌特惠';

  @override
  String get homeCategoryBenefitSafetyGear => '安全装备合集';

  @override
  String get homeCategoryBenefitParenting => '育儿必备';

  @override
  String get homeCategoryBenefitByAge => '按年龄推荐';

  @override
  String get homeCategoryBenefitSafetyCertification => '安全认证';

  @override
  String get homeCategoryBenefitSpecialOffers => '专题优惠';

  @override
  String get homeCategoryBenefitPopularTreats => '热门零食';

  @override
  String get homeCategoryBenefitVetPicks => '兽医推荐';

  @override
  String get homeCategoryBenefitPetPersonalized => '为爱宠精选';

  @override
  String get homeCategoryBenefitMerchandiserPicks => '买手推荐';

  @override
  String get homeCategoryBenefitPreorders => '预售';

  @override
  String get homeCategoryBenefitLimitedMerch => '限量周边';

  @override
  String get homeCategoryBenefitBestsellers => '畅销商品';

  @override
  String get homeCategoryBenefitTravelChecklist => '旅行准备清单';

  @override
  String get homeCategoryBenefitPopularStays => '热门住宿';

  @override
  String get homeCategoryBenefitDiscountTickets => '优惠门票';

  @override
  String get homeCategoryBenefitSubscriptionOffers => '订阅优惠';

  @override
  String get homeCategoryBenefitAuthenticityGuarantee => '正品保证';

  @override
  String get homeCategoryBenefitBrandWeek => '品牌周';

  @override
  String get homeCategoryBenefitPremiumOffers => '尊享优惠';

  @override
  String get homeCategoryBenefitExclusiveOffers => '独家优惠';

  @override
  String get homeCategoryRecommendedLabel => '推荐';

  @override
  String get authLoginContinue => '继续管理您关注的商品。';

  @override
  String get authLoginTrackHeadline => '持续追踪您关注商品的\n评价可信度。';

  @override
  String get authLoginManageDescription =>
      '登录后，您可以在一个账户中继续管理收藏商品、可信度筛选设置和分析反馈记录。';

  @override
  String get authLoginSafeShopping => '登录，安心购物';

  @override
  String get authLoginRecentProducts => '最近查看的商品';

  @override
  String get authLoginRestoreRecords => '登录后将加载收藏商品和分析记录。';

  @override
  String get authLoginKeepTrackingRti => '持续追踪 RTI';

  @override
  String get authMetricText => '文本';

  @override
  String get authMetricBehavior => '行为';

  @override
  String get authMetricPurchaseContext => '购买情境';

  @override
  String get authProductUncategorized => '未分类';

  @override
  String get authLoginSavedProducts => '管理收藏商品';

  @override
  String get authLoginSavedProductsDescription => '集中收藏关注的商品，查看 RTI 变化及风险信号。';

  @override
  String get authLoginPersonalFilters => '个人可信度筛选';

  @override
  String get authLoginPersonalFiltersDescription =>
      '保留适合您的筛选设置，如隐藏风险评价和最低 RTI 门槛。';

  @override
  String get authLoginFeedbackTracking => '追踪分析反馈';

  @override
  String get authLoginFeedbackTrackingDescription => '在同一处查看举报和反馈的处理状态。';

  @override
  String get authFooterContact => '联系';

  @override
  String get authSignupFilterHeadline => '创建符合您购物标准的\n评价可信度\n筛选条件。';

  @override
  String get authSignupFilterDescription =>
      '注册后设置感兴趣的分类和默认可信度筛选，浏览商品时即可获得符合您标准的 RTI 信号和通知。';

  @override
  String get authSignupCreateAccount => '创建新账户';

  @override
  String get authSignupAccountStep => '创建账户';

  @override
  String get authSignupAccountStepDescription => '使用姓名和邮箱创建 Re:view 账户。';

  @override
  String get authSignupCurrentStep => '当前步骤';

  @override
  String get authSignupInterestStep => '选择感兴趣的分类';

  @override
  String get authSignupInterestStepDescription => '随着兴趣信息的积累，我们会提供更好的可信度信号。';

  @override
  String get authSignupFilterStep => '设置信任筛选';

  @override
  String get authSignupFilterStepDescription => '设置隐藏风险评价和最低 RTI 门槛。';

  @override
  String get authSignupFollowupFlow => '注册后的下一步';

  @override
  String get authSignupFollowupDescription => '注册完成后，可在引导流程中设置感兴趣的分类和默认筛选。';

  @override
  String get authSignupPersonalizedBrowse => '个性化商品浏览';

  @override
  String get authSignupPersonalizedBrowseDescription => '优先查看符合兴趣分类的可信度信息流。';

  @override
  String get authSignupSavedAlerts => '收藏商品通知';

  @override
  String get authSignupSavedAlertsDescription => '关注商品的风险信号增加时，您可以收到通知。';

  @override
  String get authSignupFeedbackHistory => '管理反馈记录';

  @override
  String get authSignupFeedbackHistoryDescription => '追踪举报和分析反馈的处理状态。';

  @override
  String authSetupMinutes(int minutes) {
    return '$minutes 分钟设置';
  }

  @override
  String get authValidationNameRequired => '请输入姓名。';

  @override
  String get authValidationEmailRequired => '请输入邮箱。';

  @override
  String get authValidationEmailInvalid => '请输入有效的邮箱地址。';

  @override
  String get authValidationPasswordRequired => '请输入密码。';

  @override
  String get authValidationPasswordComposition => '请同时包含英文字母、数字和特殊字符。';

  @override
  String get authValidationPasswordConfirmRequired => '请再次输入密码。';

  @override
  String get authValidationPasswordMismatch => '两次输入的密码不一致。';

  @override
  String get authValidationTermsRequired => '请同意必选条款。';

  @override
  String authValidationPasswordMinLength(int minLength) {
    return '密码至少需要 $minLength 个字符。';
  }

  @override
  String get authResetVerifyHeadline => '安全验证后\n';

  @override
  String get authResetHeadlineEmphasis => '重置密码';

  @override
  String get authResetHeadlineEnd => '。';

  @override
  String get authResetValueDescription =>
      '通过邮箱验证后设置新密码，以保护 Re:view 账户中的收藏商品、可信度筛选和反馈记录。';

  @override
  String get authResetRecoveryBadge => '账户恢复';

  @override
  String get authResetEmailStepDescription => '验证码将发送至注册邮箱。';

  @override
  String get authResetCodeStep => '输入验证码';

  @override
  String get authResetNewPasswordStep => '设置新密码';

  @override
  String get authResetNewPasswordStepDescription => '设置符合安全要求的新密码。';

  @override
  String get authResetProcessTitle => '密码重置流程';

  @override
  String get authResetProcessDescription => '确认账户归属后安全更改密码。';

  @override
  String get authResetSecurityBadge => '安全验证';

  @override
  String get authResetKeepData => '保留账户数据';

  @override
  String get authResetKeepDataDescription => '更改密码后，已保存的筛选设置保持不变';

  @override
  String get authResetProtectCode => '保护验证码';

  @override
  String get authResetProtectCodeDescription => '验证码将在一定时间后失效，请勿与他人分享。';

  @override
  String get authResetSignInAgain => '重新确认登录';

  @override
  String get authResetSignInAgainDescription => '更改密码后，使用新密码重新登录。';

  @override
  String authResetCodeStepDescription(int digits) {
    return '输入邮件中的 $digits 位验证码以验证账户。';
  }

  @override
  String get authOAuthLoginFailed => 'OAuth 登录失败。';

  @override
  String get onboardingCategoryTitle => '请选择感兴趣的分类';

  @override
  String get onboardingCategoryDescription => '不选择也可以继续，之后可在设置中更改兴趣偏好。';

  @override
  String get onboardingUnanalyzedNotice => '未经分析的商品不会被判定为安全商品。';

  @override
  String get onboardingSkipExisting => '使用现有设置跳过';

  @override
  String onboardingTrustThreshold(int score) {
    return '可信度门槛：$score 分';
  }

  @override
  String get onboardingNotificationDescription =>
      '选择通知中心要接收的通知。只有生成实际分析结果时，才会收到相关通知。';

  @override
  String get onboardingFeedbackResults => '反馈处理结果';

  @override
  String get onboardingMarketingConsent => '同意接收营销及活动通知';

  @override
  String get onboardingNotificationAvailability =>
      '目前不提供浏览器推送、邮件、短信及每周报告。此页面用于保存通知中心设置。';

  @override
  String get onboardingPrevious => '上一步';

  @override
  String get onboardingSaveComplete => '保存并完成';

  @override
  String get onboardingPreferredCategories => '偏好分类';

  @override
  String get onboardingReload => '重新加载';

  @override
  String get reportSubmit => '提交举报';

  @override
  String get reportReceived => '受理举报';

  @override
  String get reportReceivedDescription => '将保存目标评价和举报原因。';

  @override
  String get reportAssistedReview => 'AI 辅助审核';

  @override
  String get reportAssistedReviewDescription => '一并查看 RTI 信号和类似评价记录。';

  @override
  String get reportTeamDecision => '运营团队判断';

  @override
  String get reportTeamDecisionDescription => '发现虚假或恶意情况时将更新审核状态。';

  @override
  String get reportResultNotification => '结果通知';

  @override
  String get reportResultNotificationDescription => '审核完成后，结果将显示在反馈记录中。';

  @override
  String get reportProcessTitle => '处理流程';

  @override
  String get reportProcessDescription => '这是运营团队在受理举报后的审核流程。';

  @override
  String get reportGuideRepeated => '具体说明重复措辞';

  @override
  String get reportGuideRepeatedDescription => '请说明具体位置、句子或明显的表达模式。';

  @override
  String get reportGuideContext => '核实商品使用情境';

  @override
  String get reportGuideContextDescription => '请指出缺乏实际使用经历或与商品无关的内容。';

  @override
  String get reportGuideAttachments => '附上相关材料';

  @override
  String get reportGuideAttachmentsDescription => '同类证据在多个情境中重复出现时，建议附上材料。';

  @override
  String get reportGuideTitle => '举报指南';

  @override
  String get reportGuideDescription => '这些信息有助于处理举报。';

  @override
  String get reportSummaryTitle => '提交摘要';

  @override
  String get reportSummaryDescription => '提交前请核对填写内容。';

  @override
  String get reportLiveBadge => '实时';

  @override
  String get reportSelectedReasons => '所选原因';

  @override
  String get reportAnalysisEvidence => 'AI 依据';

  @override
  String get reportTargetReviews => '目标评价';

  @override
  String get reportReasonTitle => '选择举报原因';

  @override
  String get reportReasonDescription => '点击卡片选择 · 可多选。';

  @override
  String get reportViewCriteria => '查看举报标准';

  @override
  String get reportStepTarget => '确认对象';

  @override
  String get reportStepTargetDescription => '核对商品和评价信息';

  @override
  String get reportStepReasonDescription => '选择问题类型';

  @override
  String get reportStepDetails => '详细依据';

  @override
  String get reportStepDetailsDescription => '输入补充说明';

  @override
  String get reportStepComplete => '提交完成';

  @override
  String get reportStepCompleteDescription => '追踪审核状态';

  @override
  String get reportTargetDescription => '请确认要举报的商品和评价是否正确。';

  @override
  String get reportFromAnalysis => '从分析弹窗进入';

  @override
  String get reportPrivacyConsent => '我同意个人信息收集及举报处理说明。';

  @override
  String get reportPrivacyDescription => '举报内容将用于评价受理、处理结果通知和模型质量改进，并在必要期限内保存。';

  @override
  String get reportTruthConsent => '我确认这不是虚假举报。';

  @override
  String get reportTruthDescription => '举报内容与事实不符时，处理优先级可能降低。';

  @override
  String get reportTitleText => '提交评价举报';

  @override
  String get reportDescription => '请填写可疑评价的问题类型和依据。举报将用于运营审核和模型改进反馈。';

  @override
  String get reportViewMyFeedback => '查看我的反馈记录';

  @override
  String get reportReportBreadcrumb => '报告';

  @override
  String get reportEvidenceTitle => '同时提交分析依据（选填）';

  @override
  String get reportEvidenceDescription => '您可以将此评价的 RTI 分析信号附作举报依据。';

  @override
  String get reportAttachEvidence => '附上 AI 分析依据';

  @override
  String get reportAttachEvidenceDescription => 'RTI 信号数据会随举报依据一并提交。';

  @override
  String get reportViewEvidence => '查看依据';

  @override
  String get reportDetailsTitle => '填写详细依据';

  @override
  String get reportDetailsDescription => '请填写有助于判断举报的信息。';

  @override
  String get reportType => '举报类型';

  @override
  String get reportVisibility => '处理结果公开范围';

  @override
  String get reportDetailHint => '请具体说明问题内容和情境。';

  @override
  String get reportAttachments => '附件材料 ';

  @override
  String get reportOptional => '（选填）';

  @override
  String get reportAttachmentsFull => '已达到附件数量上限';

  @override
  String get reportAttachmentsHint => '请附上截图或补充依据';

  @override
  String get reportChooseFiles => '选择文件';

  @override
  String get reportConsentsRequired => '请确认所有同意事项。';

  @override
  String get reportSubmittedTitle => '举报提交成功';

  @override
  String get reportSubmittedDescription => '举报已受理。\n可在反馈记录中查看处理结果。';

  @override
  String get reportViewFeedback => '查看反馈记录';

  @override
  String get reportAlreadyReportedTitle => '已举报的评价';

  @override
  String get reportAlreadyReportedDescription => '您已举报过此评价。\n不受理重复举报。';

  @override
  String reportReviewCount(int count) {
    return '$count 条';
  }

  @override
  String reportAverageReviewRound(int round) {
    return '平均第 $round 轮审核';
  }

  @override
  String reportRiskyReviewScore(String score) {
    return '风险评价 · RTI $score';
  }

  @override
  String reportMaxAttachments(int count) {
    return '最多可添加 $count 个附件。';
  }

  @override
  String reportFileTooLarge(String name, int size) {
    return '$name 超过 ${size}MB。';
  }

  @override
  String reportMinimumCharacters(int count) {
    return '请至少输入 $count 个字符。';
  }

  @override
  String reportMinimumCharactersHelp(int count) {
    return '至少填写 $count 个字符将更有助于运营团队审核。';
  }

  @override
  String reportCharacterCount(int count) {
    return '$count 个字符';
  }

  @override
  String reportAttachmentLimits(int size, int count) {
    return 'PNG, JPG, PDF · 最大 ${size}MB · 最多 $count 个';
  }

  @override
  String reportReasonRequired(int count) {
    return '请至少选择 $count 个举报原因。';
  }

  @override
  String reportDetailsRequired(int count) {
    return '详细说明请至少输入 $count 个字符。';
  }

  @override
  String get reportReasonFake => '疑似虚假评价／有偿评价';

  @override
  String get reportReasonGenerated => '疑似 AI 生成痕迹';

  @override
  String get reportReasonFakeDescription => '存在重复、过度赞美或多个购买记录可能相互呼应的评价。';

  @override
  String get reportReasonGeneratedDescription => '重复过于精确或反复使用相同句式的评价。';

  @override
  String get reportReasonIrrelevantDescription => '内容与实际商品使用无关，或包含其他商品／页面的内容。';

  @override
  String get reportReasonInappropriateDescription => '包含诽谤、仇恨言论或姓名等个人信息的评价。';

  @override
  String get reportReasonAdDescription => '这是广告评价。';

  @override
  String get reportReasonRepeatDescription => '内容重复。';

  @override
  String get reportReasonOtherDescription => '其他举报原因。';

  @override
  String get reportTypeRepetition => '重复措辞';

  @override
  String get reportTypeNewAccount => '账户创建后不久';

  @override
  String get reportTypeSimilarCluster => '相似评价群';

  @override
  String get reportPrivate => '不公开';

  @override
  String get reportOnlyMe => '仅自己可见';

  @override
  String get reportTeamOnly => '与运营团队共享';

  @override
  String get reportSelectPrompt => '请选择';

  @override
  String get reportGuideBadge => '说明';

  @override
  String get paymentTestCartTitle => '购物车 Toss TEST 支付';

  @override
  String get paymentTestServiceTitle => 'Toss TEST 服务支付';

  @override
  String get paymentTestCartDescription =>
      '仅用于 TEST 订单和支付，不会进行真实发货或扣款。可销售配送的商品及最终金额以服务器报价为准。';

  @override
  String get paymentTestServiceDescription => '仅用于测试，不会下单购买外部商城商品、真实扣款或自动更改套餐。';

  @override
  String get paymentTestLoginRequired => '查看订单和支付需要登录。请登录后重新打开支付回调地址。';

  @override
  String get paymentTestNotConfigured =>
      'TEST 支付密钥及服务器订单和审批接口尚未就绪，目前无法发起或完成支付。';

  @override
  String get paymentTestWebOnly => '目前仅网页浏览器支持 TEST 支付。';

  @override
  String get paymentTestOrder => 'TEST 订单';

  @override
  String get paymentTestReloadTargets => '重新查询支付对象';

  @override
  String get paymentTestOpening => '正在打开 TEST 支付窗口';

  @override
  String get paymentTestOpen => '打开 TEST 支付窗口';

  @override
  String get paymentTestReloadWindow => '重新加载支付窗口';

  @override
  String get paymentTestReloadApproval => '重新查询服务器审批状态';

  @override
  String get paymentTestBackToOrders => '返回 TEST 订单选择';

  @override
  String get paymentTestCheckPlan => '查看当前套餐';

  @override
  String get paymentCheckoutTitle => '购物车 TEST 订单';

  @override
  String get paymentCheckoutDescription =>
      '不会真实扣款或发货。此服务能否销售和配送商城商品须由服务器确认。显示价格仅供参考，运费及最终金额以服务器报价为准。';

  @override
  String get paymentCheckoutNotConfigured =>
      'TEST 公钥及购物车报价、订单和审批 API 尚未就绪，无法保存订单或支付。地址不会发送或保存至服务器。';

  @override
  String get paymentCheckoutLoginSelect => '登录后选择订单';

  @override
  String get paymentCheckoutNoSelection => '当前账户未选择商品，请在购物车中选择商品。';

  @override
  String get paymentCheckoutRecipient => '收件人';

  @override
  String get paymentCheckoutPhone => '联系电话';

  @override
  String get paymentCheckoutPostalCode => '邮政编码';

  @override
  String get paymentCheckoutAddress => '地址';

  @override
  String get paymentCheckoutAddressDetail => '详细地址（选填）';

  @override
  String get paymentCheckoutRequired => '请填写。';

  @override
  String get paymentCheckoutPhoneInvalid => '请检查联系电话格式。';

  @override
  String get paymentCheckoutQuote => '查看服务器 TEST 报价';

  @override
  String get paymentCheckoutBack => '返回购物车';

  @override
  String paymentCheckoutUnitPrice(String price) {
    return '参考单价：$price 韩元';
  }

  @override
  String paymentCheckoutQuantity(int count, String price) {
    return '$count 件 · $price';
  }

  @override
  String paymentCheckoutPostalLength(int count) {
    return '请输入 $count 位邮政编码。';
  }

  @override
  String get paymentTestRequestFailed => '支付窗口请求已取消或失败，未将支付标记为完成。';

  @override
  String get paymentTestLoadFailed => '无法加载 TEST 支付窗口，请检查网络和配置后重试。';

  @override
  String get paymentTestWebBrowserOnly => 'TEST 支付仅可在网页浏览器中使用。';

  @override
  String get planRefreshFailed => '套餐更改请求已处理，但未能确认当前套餐和额度，请重新加载确认。';

  @override
  String get detailSettingsRetry => '无法加载显示设置，重试';

  @override
  String get detailHelpfulUnavailable => '未提供有用次数，因此按原评价顺序显示。';

  @override
  String get detailNoReviews => '暂无已发布的评价。';

  @override
  String get detailNoMatchingReviews => '没有符合这些条件的评价。';

  @override
  String get detailVerified => '已验证购买';

  @override
  String get detailSortRti => 'RTI 从高到低';

  @override
  String get detailViewReviewAnalysis => '查看评价分析';

  @override
  String get detailHelpful => '有帮助';

  @override
  String get detailNotHelpful => '没有帮助';

  @override
  String get detailFeedbackSubmitted => '反馈已提交。';

  @override
  String get detailFeedbackFailed => '反馈提交失败，请重试。';

  @override
  String detailShowHiddenReviews(int count) {
    return '显示低于设置门槛的 $count 条评价';
  }

  @override
  String detailMoreReviewsRemaining(int count) {
    return '查看更多评价（剩余 $count 条）';
  }

  @override
  String get detailLowestPrice => '最低价';

  @override
  String get detailShipping => '配送';

  @override
  String detailCompareAllSellers(int count) {
    return '比较全部 $count 家卖家的价格';
  }

  @override
  String get detailInsights => '评价洞察';

  @override
  String get detailMentionedKeywords => '高频提及关键词';

  @override
  String get detailPositivePoints => '满意之处';

  @override
  String get detailNegativePoints => '不足之处';

  @override
  String get detailMoreInsights => '查看更多评价洞察';

  @override
  String get detailRiskSummary => '综合风险摘要';

  @override
  String get detailRiskSummaryTooltip => '此商品全部评价的\nAI 可信度分析结果。';

  @override
  String get detailScoreTooltip => 'RTI 可信度分数综合考虑购买验证、文本可信度、\n重复表达及时间模式等因素。';

  @override
  String get detailDisclaimer => '分析结果仅供参考，请结合多条评价做出最终判断。';

  @override
  String get detailCriteria => '分析标准';

  @override
  String get detailReported => '已举报';

  @override
  String get detailReportReview => '举报评价';

  @override
  String get detailSignalsTitle => 'RTI 组成信号';

  @override
  String get detailSignalsTooltip => '组成 RTI 的信号及各项分数，\n综合文本、行为及网络分析得出。';

  @override
  String get detailEvidenceTooltip => '判断评价可信度的具体依据，\n以及各项依据对分数的贡献比例。';

  @override
  String get detailAlsoViewed => '浏览此商品的用户也看过';

  @override
  String get detailKeySignals => '主要判断信号';

  @override
  String get detailTrend => '风险趋势';

  @override
  String get detailTrendDescription => '显示商品评价平均 RTI 和风险评价比例的变化。';

  @override
  String get detailTrendPending => 'AI 分析完成后可查看风险趋势';

  @override
  String get detailTrendEmptyPeriod => '所选时段内暂无分析数据。';

  @override
  String detailTrendSingleScore(double score) {
    final intl.NumberFormat scoreNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String scoreString = scoreNumberFormat.format(score);

    return '平均 RTI：$scoreString 分';
  }

  @override
  String get detailAverageRti => '平均 RTI';

  @override
  String get detailRiskyReviewRatio => '风险评价比例';

  @override
  String get detailToday => '今天';

  @override
  String get detailRecentReviewOrder => '最新评价顺序';

  @override
  String get detailAnalyzing => 'AI 分析中';

  @override
  String get detailNoAnalyzedReviews => '暂无已分析的评价。';

  @override
  String get detailOfficialSeller => '官方卖家';

  @override
  String get detailTrustHigh => '评价可信度高';

  @override
  String get detailTrustMedium => '评价可信度一般';

  @override
  String get detailTrustLow => '评价可信度低';

  @override
  String detailFormattedReviewCount(String count) {
    return '$count 条评价';
  }

  @override
  String get detailBrand => '品牌';

  @override
  String get detailAverageRating => '平均评分';

  @override
  String detailSellerCount(int count) {
    return '$count 家';
  }

  @override
  String detailRatingReviewCount(String rating, String count) {
    return '$rating（$count 条评价）';
  }

  @override
  String get detailAnalysisInProgress => 'AI 评价分析进行中';

  @override
  String get detailAnalysisInProgressDescription =>
      'Re:view AI 正在实时分析评价，完成后将自动更新可信度分数。';

  @override
  String get detailInformation => '商品信息';

  @override
  String detailReviewTabCount(String count) {
    return '评价 $count';
  }

  @override
  String detailComparisonTabCount(int count) {
    return '比价 $count';
  }

  @override
  String get searchGridView => '卡片视图';

  @override
  String get searchListView => '列表视图';

  @override
  String get searchSort => '排序';

  @override
  String get searchPageSize => '每页商品数';

  @override
  String searchResultCountLabel(int count) {
    return '$count 条结果';
  }

  @override
  String searchPageSizeCount(int count) {
    return '每页显示 $count 件';
  }

  @override
  String get searchCartAdded => '已加入购物车。';

  @override
  String get searchCartAddFailed => '加入购物车失败。';

  @override
  String searchFormattedReviewCount(String count) {
    return '（$count 条评价）';
  }

  @override
  String get searchAllProducts => '全部商品';

  @override
  String get searchCategoryProducts => '分类商品';

  @override
  String get searchResultsTitle => '搜索结果';

  @override
  String get searchAboutRti => '什么是 Re:view Trust Index（RTI）？';

  @override
  String get searchAboutRtiDescription => '综合实际买家评价可信度得出的指标。';

  @override
  String searchFormattedProductCount(String count) {
    return '$count 件商品';
  }

  @override
  String searchQuickFilterAllCount(int count) {
    return '全部 $count';
  }

  @override
  String get searchMultiStoreTitle => '多店铺统一搜索';

  @override
  String get searchComparedProducts => '对比商品';

  @override
  String get searchCollectedReviews => '已收集评价';

  @override
  String get searchNotCounted => '未统计';

  @override
  String get searchReviewBasedComparison => '基于实际使用评价对比';

  @override
  String get searchComparisonDescription => '同时比较价格、评价和 RTI 可信度，快速挑选可信赖的商品。';

  @override
  String get searchLowestPriceComparison => '最低价对比';

  @override
  String get searchReviewTrust => '评价可信度';

  @override
  String get searchFastDelivery => '快速配送';

  @override
  String get searchOfficialStores => '包含官方店铺';

  @override
  String get searchVeryHighTrust => '可信度很高';

  @override
  String get searchModerateTrust => '一般';

  @override
  String get searchLowTrust => '低';

  @override
  String searchComparedProductCount(String count) {
    return '$count 件';
  }

  @override
  String searchCollectedReviewCount(String count) {
    return '$count 条';
  }

  @override
  String get searchUnconfirmedCategoriesNotice =>
      '商城商品按分类名称搜索，也会显示尚未确认分类的结果。详细分类请查看商城原文。';

  @override
  String searchLoadedProductsScope(int count, int limit) {
    return '对当前加载的 $count 件商品进行筛选和排序。关键词搜索最多返回 $limit 条结果，并非针对商城全部商品的搜索筛选。未提供配送、销量、发布日期和图片评价信息，因此不支持这些条件。';
  }

  @override
  String get searchSortAccuracy => '推荐';

  @override
  String get searchSortRti => '按 RTI';

  @override
  String get searchSortReviewCount => '评价最多';

  @override
  String get searchSortSales => '销量最多';

  @override
  String get searchSortPriceLow => '价格从低到高';

  @override
  String get searchSortPriceHigh => '价格从高到低';

  @override
  String get searchSortNewest => '最新商品';

  @override
  String get searchMissingClassification => '暂无分类信息';

  @override
  String get cartSelectionSummary => '所选商品摘要';

  @override
  String get cartUnknownPriceExcluded => '无价格信息的商品已从合计中排除。';

  @override
  String get cartReferencePriceNotice => '显示价格仅供参考，请前往各商城购买并确认运费及优惠券。';

  @override
  String get cartViewSelectedSellers => '查看所选商品购买渠道';

  @override
  String get cartContinueShopping => '继续购物';

  @override
  String get cartShippingConditions => '配送条件请向卖家确认';

  @override
  String get cartSaveLater => '稍后再买';

  @override
  String get cartDelete => '删除';

  @override
  String cartTrustLevel(String level) {
    return '可信度 $level';
  }

  @override
  String cartPriceReduction(String price) {
    return '降价 $price';
  }

  @override
  String cartEstimatedArrival(String date) {
    return '预计 $date 送达';
  }

  @override
  String cartStockRemaining(int count) {
    return '库存剩余 $count 件';
  }

  @override
  String get cartDeleteSelected => '删除所选';

  @override
  String get cartMoveToWishlist => '移至收藏';

  @override
  String cartSelectAllCount(int selected, int total) {
    return '全选（$selected/$total）';
  }

  @override
  String get cartSellersTitle => '查看购买渠道';

  @override
  String get cartSellersDescription =>
      '请使用商品详情提供的商城购买链接。TEST 下单功能正由独立页面筹备，目前尚无服务器销售和配送接口。';

  @override
  String get cartViewProductAndSeller => '查看商品详情及购买渠道';

  @override
  String get cartDescription => '查看已加入的商品，下单前比较评价可信度。';

  @override
  String get cartTrustCheckTitle => '检查评价可信度';

  @override
  String get cartTrustCheckDescription => '查看各商品的 RTI 指数，选择可信评价较多的商品。';

  @override
  String cartTotalProducts(int count) {
    return '共 $count 件商品';
  }

  @override
  String wishlistCountItems(int count) {
    return '$count 项';
  }

  @override
  String get wishlistShoppingMall => '商城';

  @override
  String get wishlistPriceComparisonUnavailable => '服务器未提供降价对比信息，这并不代表价格没有变化。';

  @override
  String get wishlistUncategorized => '未分类';

  @override
  String get wishlistShopUnknown => '暂无商城信息';

  @override
  String get myPageTrustUnavailable => '无法查看收藏商品的分析信息。';

  @override
  String get myPageTrustScope => '以收藏商品已分析的 RTI 平均值及服务器需留意等级为准。';

  @override
  String myPageTrustScorePoints(int score) {
    return '$score 分';
  }

  @override
  String get myPageBack => '返回我的页面';

  @override
  String get myPageActivityLoadFailed => '无法加载近期动态。';

  @override
  String get myPageActivityRecent => '最近';

  @override
  String get myPageActivityJustNow => '刚刚';

  @override
  String myPageActivityDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String myPageActivityHoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String myPageNamedDescription(String name) {
    return '管理 $name 的信息和收藏商品动态。';
  }

  @override
  String get myPageWarningScope => '收藏商品中由服务器分析为可疑或危险等级的商品，不包含尚未分析的商品。';

  @override
  String get myPageCheckList => '查看列表';

  @override
  String get myPageAllWarnings => '全部需留意等级';

  @override
  String get myPageLoadFailed => '无法查看需留意的商品。';

  @override
  String myPageViewListCount(int count) {
    return '查看列表（$count）';
  }

  @override
  String recentProductsScope(int count) {
    return '已从服务器最近 $count 条浏览记录中去除重复商品，数量可能不同于全部历史商品数。';
  }

  @override
  String get recentProductsLoadFailed => '无法加载最近浏览的商品。';

  @override
  String get notificationsAll => '全部通知';

  @override
  String get notificationsPriceAlerts => '价格通知';

  @override
  String get notificationsSavedSettings => '已保存的通知接收设置';

  @override
  String get notificationsMore => '查看更多';

  @override
  String get notificationsTargetUnsupported => '暂不支持此通知的跳转目标。';

  @override
  String get notificationsCheckingUnreadShort => '正在检查未读通知';

  @override
  String get notificationsUnreadFailedShort => '未能查询通知数量。';

  @override
  String get notificationsManageInboxAndPrices => '通知中心 · 管理价格通知';

  @override
  String get notificationsServiceTitle => '服务通知';

  @override
  String get notificationsCheckingUnread => '正在检查未读通知。';

  @override
  String get notificationsUnreadFailed => '未能查询未读通知数量。';

  @override
  String get notificationsSettingsFailed => '无法加载已保存的通知设置。';

  @override
  String get notificationsSettingsChecking => '正在查询已保存的通知设置';

  @override
  String get notificationsReviewSettings => '通知及评价设置';

  @override
  String get notificationsMonitoringNotice => '风险变化自动监测需要服务器接入，仅开启接收设置并不会开始监测。';

  @override
  String get notificationsInboxNotice => '查看保存在通知中心的通知，不支持浏览器推送、邮件和短信。';

  @override
  String notificationsUnreadCount(int count) {
    return '$count 条未读通知';
  }

  @override
  String get notificationsReceiving => '接收';

  @override
  String get notificationsNotReceiving => '不接收';

  @override
  String notificationsRiskStatus(String status) {
    return '风险检测 $status';
  }

  @override
  String notificationsAnalysisStatus(String status) {
    return '分析结果 $status';
  }

  @override
  String notificationsFeedbackStatus(String status) {
    return '处理结果 $status';
  }

  @override
  String get priceWatchTitle => '降价 · 价格通知管理';

  @override
  String get priceWatchHistoryNotice =>
      '暂不支持价格通知记录和订阅保存。下方为收藏商品的服务器降价标记，并非通知记录。';

  @override
  String get priceWatchComparisonUnavailable => '服务器未提供收藏商品的对比价格，无法确认是否降价。';

  @override
  String get priceWatchRefreshWishlistPrices => '刷新收藏商品价格';

  @override
  String get priceWatchViewWishlist => '查看收藏商品';

  @override
  String get priceWatchSubscriptionNotice => '接入服务器价格历史和订阅保存后才可申请。';

  @override
  String get priceWatchSubscriptionUnavailable => '申请价格通知 · 暂不支持';

  @override
  String get priceWatchDropIndicator => '服务器降价标记 · 无降价金额或比例信息';

  @override
  String priceWatchLoadFailed(String message) {
    return '未能查询降价标记。$message';
  }

  @override
  String priceWatchDropCounts(int total, int known, int drops) {
    return '$total 件收藏商品中有 $known 件提供降价信息，其中 $drops 件标记为降价。未提供基准价格及时间。';
  }

  @override
  String get extProgressPreviousComplete => '采集与分析完成 · 先前采集的信息';

  @override
  String get extProgressPreviousInfo => '先前采集的信息';

  @override
  String get extReviewSummaryTitle => '评价摘要';

  @override
  String extReviewRatingSummary(int count, String rating, String distribution) {
    return '已加载$count条评价 · 平均$rating星 · $distribution';
  }

  @override
  String extReviewStarCount(int stars, int count) {
    return '$stars星 $count条';
  }

  @override
  String extReviewKeywords(String keywords) {
    return '常见表达：$keywords';
  }

  @override
  String extReviewPositive(String excerpt) {
    return '好评：“$excerpt”';
  }

  @override
  String extReviewNegative(String excerpt) {
    return '不足之处：“$excerpt”';
  }

  @override
  String get extReviewSummaryRequest => '使用AI总结评价';

  @override
  String get extReviewSummaryQuestion => '请简短总结这款商品评价中的优点与不足';

  @override
  String get extSummaryEvidenceToggle => '查看分析状态与依据';

  @override
  String get chatHistoryProductLoading => '正在加载商品信息';

  @override
  String get chatHistoryEmptyHint => '开始新对话后，可在此再次查看。';

  @override
  String chatHistoryConversationCount(int count) {
    return '$count个对话';
  }

  @override
  String chatHistoryToday(String time) {
    return '今天 $time';
  }

  @override
  String get chatHistoryMenu => '更多选项';

  @override
  String get chatHistoryDelete => '删除对话';

  @override
  String get chatHistoryDeleteAll => '全部删除';

  @override
  String get chatHistoryDeleteConfirm => '要从此设备的对话列表中移除此对话吗？';

  @override
  String get chatHistoryDeleteAllConfirm => '要从此设备的对话列表中移除所有对话吗？';

  @override
  String get chatHistoryCancel => '取消';

  @override
  String get chatHistoryDeleteError => '无法删除对话，请重试。';

  @override
  String get extSummaryCompleteBadge => '采集与分析完成';

  @override
  String extSummaryReviewBasis(String count) {
    return '$count条评价';
  }

  @override
  String get extSummaryFrequentPhrases => '常见表达';

  @override
  String get extSummaryPositiveLabel => '好评';

  @override
  String get extSummaryNegativeLabel => '不足之处';

  @override
  String get extSummaryQuotaHint => '使用1次每日提问额度';

  @override
  String get extSummaryLayoutComment => '已加载评价的评分与常见表达。';

  @override
  String extSummaryRatedReviewBasis(String count) {
    return '基于$count条带评分的评价';
  }

  @override
  String extTrustLoadedSource(String count) {
    return '基于已加载的$count条评价';
  }

  @override
  String get extTrustLoadedAverage => '平均 RTI';
}
