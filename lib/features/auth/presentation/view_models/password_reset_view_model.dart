import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/send_password_reset_request_use_case.dart';
import 'package:re_view_front/features/auth/presentation/providers/auth_providers.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';

class PasswordResetViewModel extends Notifier<PasswordResetState> {
  PasswordResetViewModel({this.initialToken});

  final String? initialToken;
  int _request = 0;

  SendPasswordResetRequestUseCase get _sendResetRequest =>
      ref.read(sendPasswordResetRequestUseCaseProvider);
  ResetPasswordUseCase get _resetPassword =>
      ref.read(resetPasswordUseCaseProvider);

  @override
  PasswordResetState build() {
    final token = initialToken?.trim();
    return PasswordResetState(
      step: token != null && token.isNotEmpty
          ? PasswordResetStep.newPassword
          : PasswordResetStep.email,
      resetToken: token != null && token.isNotEmpty ? token : null,
    );
  }

  void emailChanged(String value) {
    if (state.isLoading) return;
    state = state.copyWith(
      email: value,
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }

  void newPasswordChanged(String value) {
    if (state.isLoading) return;
    state = state.copyWith(
      newPassword: value,
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }

  void confirmPasswordChanged(String value) {
    if (state.isLoading) return;
    state = state.copyWith(
      confirmPassword: value,
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }

  Future<void> sendVerificationCode() async {
    if (state.isLoading) return;
    final request = ++_request;
    final email = state.email.trim();
    if (email.isEmpty ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '유효한 이메일 주소를 입력해 주세요.',
      );
      return;
    }

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      clearFailureMessage: true,
    );

    final result = await _sendResetRequest(email);

    if (!ref.mounted || request != _request) return;

    state = result.when(
      success: (resetToken) => state.copyWith(
        status: PasswordResetStatus.idle,
        step: PasswordResetStep.emailSent,
        resetToken: resetToken.isEmpty ? null : resetToken,
        clearResetToken: resetToken.isEmpty,
      ),
      failure: (failure) => state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: failure.message,
      ),
    );
  }

  void proceedToNewPassword() {
    if (state.isLoading) return;
    if (state.resetToken == null || state.resetToken!.isEmpty) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '이메일의 비밀번호 재설정 링크를 열어 주세요.',
      );
      return;
    }
    state = state.copyWith(step: PasswordResetStep.newPassword);
  }

  Future<void> resetPassword() async {
    if (state.isLoading || state.isSuccess) return;
    final token = state.resetToken;
    if (token == null || token.isEmpty) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '비밀번호 재설정 링크가 필요합니다. 인증 이메일을 다시 요청해 주세요.',
      );
      return;
    }
    final request = ++_request;
    if (!state.hasMinLength || !state.hasLetterAndNumber) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '비밀번호 조건을 확인해 주세요.',
      );
      return;
    }
    if (!state.passwordsMatch) {
      state = state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: '비밀번호가 일치하지 않습니다.',
      );
      return;
    }

    state = state.copyWith(
      status: PasswordResetStatus.loading,
      clearFailureMessage: true,
    );

    final result = await _resetPassword(
      token: token,
      newPassword: state.newPassword,
    );

    if (!ref.mounted || request != _request) return;

    state = result.when(
      success: (_) => state.copyWith(status: PasswordResetStatus.success),
      failure: (failure) => state.copyWith(
        status: PasswordResetStatus.failure,
        failureMessage: switch (failure.code) {
          'EXPIRED_RESET_TOKEN' => '비밀번호 재설정 링크가 만료되었습니다. 인증 이메일을 다시 요청해 주세요.',
          'INVALID_RESET_TOKEN' =>
            '유효하지 않은 비밀번호 재설정 링크입니다. 인증 이메일을 다시 요청해 주세요.',
          _ => failure.message,
        },
      ),
    );
  }

  Future<void> resendCode() async {
    ++_request;
    state = state.copyWith(
      step: PasswordResetStep.email,
      clearResetToken: true,
      newPassword: '',
      confirmPassword: '',
      status: PasswordResetStatus.idle,
      clearFailureMessage: true,
    );
  }
}
