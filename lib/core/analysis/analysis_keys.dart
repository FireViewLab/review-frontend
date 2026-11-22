/// Wire aliases for the analysis contract; keep Spring field changes here.
/// 이름은 review-backend#255 확정본을 따른다.
abstract final class AnalysisKeys {
  static const version = ['contractVersion', 'contract_version'];
  static const policyIndex = ['policyIndexV4', 'policy_index_v4'];
  static const averagePolicyIndex = ['avgPolicyIndexV4', 'avg_policy_index_v4'];
  static const evidenceLevel = ['levelV4', 'level_v4'];
  static const textProbability = ['textProbabilityV4', 'text_probability_v4'];
  static const modelVersion = ['modelVersionV4', 'model_version_v4'];
  static const policyVersion = ['policyVersionV4', 'policy_version_v4'];
  static const levelCounts = ['v4LevelCounts', 'v4_level_counts'];

  // 롤백할 때 활성 키 목록만 되돌릴 수 있도록 이전 별칭을 보관한다.
  static const policyIndexV3 = ['policyIndexV3', 'policy_index_v3'];
  static const averagePolicyIndexV3 = [
    'avgPolicyIndexV3',
    'avg_policy_index_v3',
  ];
  static const evidenceLevelV3 = ['evidenceLevelV3', 'evidence_level_v3'];
  static const textScoreV3 = ['textScore', 'text_score'];
  static const modelVersionV3 = ['modelVersion', 'model_version'];
  static const policyVersionV3 = ['policyVersion', 'policy_version'];
  static const productSummary = [
    'productSummaryKo',
    'product_summary_ko',
    'summaryKo',
    'summary_ko',
    'analysisSummaryKo',
    'analysis_summary_ko',
  ];
  static const summary = ['analysisSummaryKo', 'analysis_summary_ko'];
  static const rulesReasons = ['rulesReasonsKo', 'rules_reasons_ko'];
  static const evidenceReasonsV3 = ['evidenceReasonsV3', 'evidence_reasons_v3'];
  static const reasonSource = ['reasonSource', 'reason_source'];
  static const textScore = ['textScoreV4', 'text_score_v4'];
  static const behaviorScore = ['behaviorScore', 'behavior_score'];
  static const networkScore = ['networkScore', 'network_score'];
  static const reviewScore = ['reviewerAtiScore', 'rtiScore', 'rti'];
  static const averageScore = [
    'avgRti',
    'avg_rti',
    'averageRti',
    'rtiScore',
    'rti',
    'trustScore',
  ];
  static const level = [
    'level',
    'rtiGrade',
    'trustGrade',
    'grade',
    'trustGradeLabel',
  ];
  static const reasons = ['reasons'];
}
