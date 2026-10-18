import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';

class AdminUserDto {
  const AdminUserDto(this._json);

  final Map<String, dynamic> _json;

  AdminUser toEntity() {
    return AdminUser(
      userId: (_json['userId'] as num?)?.toInt() ?? 0,
      email: _json['email']?.toString() ?? '',
      nickname: _json['nickname']?.toString() ?? '',
      role: _json['role']?.toString() ?? 'USER',
      provider: _json['provider']?.toString(),
      atiScore: (_json['atiScore'] as num?)?.toDouble(),
      createdAt: DateTime.tryParse(_json['createdAt']?.toString() ?? ''),
      planTier: _json['planTier']?.toString(),
      planExpiresAt: DateTime.tryParse(
        _json['planExpiresAt']?.toString() ?? '',
      ),
    );
  }
}
