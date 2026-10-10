import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_view_model.dart';

void main() {
  late _Repository repository;
  late ProviderContainer container;
  setUp(() {
    repository = _Repository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    when(
      () => repository.resetPassword(
        token: any(named: 'token'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer((_) async => const Success<void>(null));
    when(
      () => repository.sendPasswordResetRequest(any()),
    ).thenAnswer((_) async => const Success(''));
  });
  tearDown(() => container.dispose());

  PasswordResetViewModel start(String? token) {
    container.listen(passwordResetViewModelProvider(token), (_, _) {});
    return container.read(passwordResetViewModelProvider(token).notifier);
  }

  void passwords(PasswordResetViewModel vm) {
    vm.newPasswordChanged('Password123!');
    vm.confirmPasswordChanged('Password123!');
  }

  test('email token opens new password step and is used for reset', () async {
    final vm = start('mail-token');
    expect(
      container.read(passwordResetViewModelProvider('mail-token')).step,
      PasswordResetStep.newPassword,
    );
    passwords(vm);
    await vm.resetPassword();
    expect(
      container.read(passwordResetViewModelProvider('mail-token')).isSuccess,
      isTrue,
    );
    verify(
      () => repository.resetPassword(
        token: 'mail-token',
        newPassword: 'Password123!',
      ),
    ).called(1);
    verifyNever(() => repository.sendPasswordResetRequest(any()));
  });

  for (final code in ['EXPIRED_RESET_TOKEN', 'INVALID_RESET_TOKEN']) {
    test('shows recovery message for $code', () async {
      when(
        () => repository.resetPassword(
          token: any(named: 'token'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer(
        (_) async =>
            FailureResult(Failure(message: 'server error', code: code)),
      );
      final vm = start('mail-token');
      passwords(vm);
      await vm.resetPassword();
      final state = container.read(
        passwordResetViewModelProvider('mail-token'),
      );
      expect(state.status, PasswordResetStatus.failure);
      expect(state.failureMessage, contains('인증 이메일을 다시 요청'));
      expect(state.isSuccess, isFalse);
      await vm.resendCode();
      final cleared = container.read(
        passwordResetViewModelProvider('mail-token'),
      );
      expect(cleared.step, PasswordResetStep.email);
      expect(cleared.resetToken, isNull);
      expect(cleared.newPassword, isEmpty);
    });
  }

  test('keeps ordinary API error message', () async {
    when(
      () => repository.resetPassword(
        token: any(named: 'token'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer(
      (_) async => const FailureResult(Failure(message: '서버 연결 오류')),
    );
    final vm = start('mail-token');
    passwords(vm);
    await vm.resetPassword();
    expect(
      container
          .read(passwordResetViewModelProvider('mail-token'))
          .failureMessage,
      '서버 연결 오류',
    );
  });

  test('missing token does not send a reset request', () async {
    final vm = start(null);
    passwords(vm);
    await vm.resetPassword();
    expect(
      container.read(passwordResetViewModelProvider(null)).step,
      PasswordResetStep.email,
    );
    expect(
      container.read(passwordResetViewModelProvider(null)).status,
      PasswordResetStatus.failure,
    );
    verifyNever(
      () => repository.resetPassword(
        token: any(named: 'token'),
        newPassword: any(named: 'newPassword'),
      ),
    );
  });

  test('void reset-request response remains in email sent step', () async {
    final vm = start(null);
    vm.emailChanged('test@example.com');
    await vm.sendVerificationCode();
    expect(
      container.read(passwordResetViewModelProvider(null)).step,
      PasswordResetStep.emailSent,
    );
    expect(
      container.read(passwordResetViewModelProvider(null)).resetToken,
      isNull,
    );
    vm.proceedToNewPassword();
    expect(
      container.read(passwordResetViewModelProvider(null)).step,
      PasswordResetStep.emailSent,
    );
  });

  test('new token does not reuse previous token or form', () {
    final first = start('first');
    passwords(first);
    start('second');
    final state = container.read(passwordResetViewModelProvider('second'));
    expect(state.resetToken, 'second');
    expect(state.newPassword, isEmpty);
  });

  test(
    'duplicate submit ignored and recovery ignores a late response',
    () async {
      final pending = Completer<Result<void>>();
      when(
        () => repository.resetPassword(
          token: any(named: 'token'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) => pending.future);
      final vm = start('mail-token');
      passwords(vm);
      final resetting = vm.resetPassword();
      await vm.resetPassword();
      verify(
        () => repository.resetPassword(
          token: 'mail-token',
          newPassword: 'Password123!',
        ),
      ).called(1);
      await vm.resendCode();
      pending.complete(const Success<void>(null));
      await resetting;
      expect(
        container.read(passwordResetViewModelProvider('mail-token')).step,
        PasswordResetStep.email,
      );
      expect(
        container.read(passwordResetViewModelProvider('mail-token')).isSuccess,
        isFalse,
      );
    },
  );
}

class _Repository extends Mock implements AuthRepository {}
