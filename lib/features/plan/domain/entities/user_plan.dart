class UserPlan {
  const UserPlan({required this.code, this.expiresAt});
  final String code;
  final DateTime? expiresAt;
  factory UserPlan.fromJson(Map<String, dynamic> json) {
    final code = json['planTier']?.toString().toUpperCase();
    if (!const {'FREE', 'PLUS', 'PRO'}.contains(code)) {
      throw const FormatException('Invalid user plan');
    }
    return UserPlan(
      code: code!,
      expiresAt: DateTime.tryParse(json['planExpiresAt']?.toString() ?? ''),
    );
  }
}
