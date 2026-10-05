import 'package:re_view_front/features/chat/domain/entities/chat_quota.dart';
import 'package:re_view_front/features/plan/domain/entities/plan_option.dart';

enum PlanStatus { loading, ready, failure }

/// 요금제 변경 결과. 화면에서 문구로 바꿔 보여 준다.
enum PlanNotice {
  changed,

  /// 서버에 본인 요금제 변경 기능이 아직 없다.
  unavailable,
  failed,
}

class PlanState {
  const PlanState({
    this.status = PlanStatus.loading,
    this.quota,
    this.expiresAt,
    this.options = PlanOption.fallback,
    this.changingCode,
    this.notice,
    this.noticeCode,
  });

  final PlanStatus status;

  /// 현재 요금제와 오늘 사용량. 서버가 만료까지 반영해 알려 준 값이다.
  final ChatQuota? quota;
  final DateTime? expiresAt;
  final List<PlanOption> options;

  /// 지금 바꾸는 중인 요금제 코드.
  final String? changingCode;
  final PlanNotice? notice;

  /// [notice]가 가리키는 요금제 코드.
  final String? noticeCode;

  bool get isChanging => changingCode != null;

  PlanState copyWith({
    PlanStatus? status,
    ChatQuota? quota,
    DateTime? expiresAt,
    bool clearExpiresAt = false,
    List<PlanOption>? options,
    String? changingCode,
    bool clearChanging = false,
    PlanNotice? notice,
    String? noticeCode,
    bool clearNotice = false,
  }) {
    return PlanState(
      status: status ?? this.status,
      quota: quota ?? this.quota,
      expiresAt: clearExpiresAt ? null : (expiresAt ?? this.expiresAt),
      options: options ?? this.options,
      changingCode: clearChanging ? null : (changingCode ?? this.changingCode),
      notice: clearNotice ? null : (notice ?? this.notice),
      noticeCode: clearNotice ? null : (noticeCode ?? this.noticeCode),
    );
  }
}
