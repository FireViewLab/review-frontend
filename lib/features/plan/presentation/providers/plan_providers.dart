import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/plan/data/datasources/plan_remote_data_source.dart';
import 'package:re_view_front/features/plan/data/repositories/plan_repository_impl.dart';
import 'package:re_view_front/features/plan/domain/repositories/plan_repository.dart';
import 'package:re_view_front/features/plan/presentation/view_models/plan_state.dart';
import 'package:re_view_front/features/plan/presentation/view_models/plan_view_model.dart';

final planRemoteDataSourceProvider = Provider<PlanRemoteDataSource>((ref) {
  return PlanRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepositoryImpl(ref.watch(planRemoteDataSourceProvider));
});

final planViewModelProvider =
    NotifierProvider.autoDispose<PlanViewModel, PlanState>(PlanViewModel.new);
