import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/external_product/data/datasources/external_actions_remote_data_source.dart';
import 'package:re_view_front/features/external_product/data/repositories/external_actions_repository_impl.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_actions_repository.dart';

final externalActionsRepositoryProvider = Provider<ExternalActionsRepository>(
  (ref) => ExternalActionsRepositoryImpl(
    ExternalActionsRemoteDataSource(ref.watch(apiClientProvider)),
  ),
);
