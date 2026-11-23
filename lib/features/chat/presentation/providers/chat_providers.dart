import 'package:re_view_front/features/external_product/domain/entities/external_product.dart';
import 'package:re_view_front/features/external_product/domain/entities/external_product_ref.dart';
import 'package:re_view_front/features/external_product/presentation/providers/external_product_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:re_view_front/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_state.dart';
import 'package:re_view_front/features/chat/presentation/view_models/chat_view_model.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatRemoteDataSourceProvider));
});

/// 패널을 닫거나 화면을 옮겨도 대화가 남도록 autoDispose를 쓰지 않는다.
final chatViewModelProvider = NotifierProvider<ChatViewModel, ChatState>(
  ChatViewModel.new,
);

/// Keeps completed and in-flight lookups shared for each external product ID.
final chatHistoryProductProvider =
    FutureProvider.family<ExternalProduct?, String>((ref, externalId) async {
      final productRef = ExternalProductRef.resolve(externalId: externalId);
      if (productRef == null) return null;
      final result = await ref
          .read(externalProductRepositoryProvider)
          .getProduct(productRef);
      return result.when(
        success: (snapshot) => snapshot.product,
        failure: (_) => null,
      );
    });
