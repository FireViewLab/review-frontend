import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/payments/data/test_payment_contract.dart';
import 'package:re_view_front/features/payments/data/test_payment_repository_impl.dart';
import 'package:re_view_front/features/payments/domain/repositories/test_payment_repository.dart';
import 'package:re_view_front/features/payments/presentation/view_models/test_payment_state.dart';
import 'package:re_view_front/features/payments/presentation/view_models/test_payment_view_model.dart';

final testPaymentClientKeyProvider = Provider<String>((ref) {
  const value = String.fromEnvironment('TOSS_TEST_CLIENT_KEY');
  return value.startsWith('test_gck_') ? value : '';
});
final testPaymentContractProvider = Provider<TestPaymentContract?>(
  (ref) => TestPaymentContract.fromEnvironment(),
);
final testPaymentRepositoryProvider = Provider<TestPaymentRepository>(
  (ref) => TestPaymentRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(testPaymentContractProvider),
  ),
);
final testPaymentViewModelProvider =
    NotifierProvider.autoDispose<TestPaymentViewModel, TestPaymentState>(
      TestPaymentViewModel.new,
    );
