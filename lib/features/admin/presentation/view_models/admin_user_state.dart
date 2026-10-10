import 'package:re_view_front/features/admin/domain/entities/admin_user.dart';

class AdminUserState {
  const AdminUserState({
    this.items = const [],
    this.page = 0,
    this.totalPages = 0,
    this.totalElements = 0,
    this.pageSize = 20,
    this.isLoading = false,
    this.errorMessage,
    this.updatingUserIds = const {},
  });

  final List<AdminUser> items;
  final int page;
  final int totalPages;
  final int totalElements;
  final int pageSize;
  final bool isLoading;
  final String? errorMessage;
  final Set<int> updatingUserIds;

  AdminUserState copyWith({
    List<AdminUser>? items,
    int? page,
    int? totalPages,
    int? totalElements,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    Set<int>? updatingUserIds,
  }) {
    return AdminUserState(
      items: items ?? this.items,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      pageSize: pageSize,
      updatingUserIds: updatingUserIds ?? this.updatingUserIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
