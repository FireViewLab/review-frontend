import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/external_product/data/datasources/external_product_remote_data_source.dart';
import 'package:re_view_front/features/external_product/data/repositories/external_product_repository_impl.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/domain/repositories/external_product_repository.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_state.dart';
import 'package:re_view_front/features/external_product/presentation/view_models/external_product_view_model.dart';

final externalProductRepositoryProvider = Provider<ExternalProductRepository>((
  ref,
) {
  return ExternalProductRepositoryImpl(
    ExternalProductRemoteDataSourceImpl(ref.watch(apiClientProvider)),
  );
});

/// 수집이 끝났는지 확인하는 간격. 서버 안내는 2~3초다.
final externalProductPollIntervalProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 3),
);

final externalProductViewModelProvider = NotifierProvider.autoDispose
    .family<ExternalProductViewModel, ExternalProductState, ExternalProductRef>(
      ExternalProductViewModel.new,
    );

final productSummaryCacheProvider = Provider<ProductSummaryCache>(
  (ref) => ProductSummaryCache(),
);
