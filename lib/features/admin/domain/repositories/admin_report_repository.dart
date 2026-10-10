import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_page.dart';
import 'package:re_view_front/features/admin/domain/entities/admin_report.dart';

abstract interface class AdminReportRepository {
  /// 신고 목록 조회. [status]가 null이면 전체.
  Future<Result<AdminPage<AdminReport>>> getReports({
    ReportStatus? status,
    required int page,
    required int size,
  });

  /// 특정 상태의 전체 건수 조회 (KPI용). [status]가 null이면 전체.
  Future<Result<int>> countByStatus(ReportStatus? status);

  /// 신고 상태 변경 + 운영자 코멘트. 성공 시 true.
  Future<Result<bool>> updateStatus({
    required int reportId,
    required ReportStatus status,
    String? adminComment,
  });
}
