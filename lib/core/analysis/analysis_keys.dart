/// Wire aliases for the analysis contract; keep Spring field changes here.
abstract final class AnalysisKeys {
  static const version = ['contractVersion', 'contract_version'];
  static const policyIndex = ['policyIndexV3', 'policy_index_v3'];
  static const averagePolicyIndex = ['avgPolicyIndexV3', 'avg_policy_index_v3'];
  static const evidenceLevel = ['evidenceLevelV3', 'evidence_level_v3'];
  static const summary = ['analysisSummaryKo', 'analysis_summary_ko'];
  static const rulesReasons = ['rulesReasonsKo', 'rules_reasons_ko'];
  static const evidenceReasons = ['evidenceReasonsV3', 'evidence_reasons_v3'];
  static const reasonSource = ['reasonSource', 'reason_source'];
  static const textScore = ['textScore', 'text_score'];
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
