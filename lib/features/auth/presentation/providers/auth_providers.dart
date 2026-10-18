import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:re_view_front/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:re_view_front/features/auth/domain/repositories/auth_repository.dart';
import 'package:re_view_front/features/auth/domain/usecases/handle_oauth_callback_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/login_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/logout_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/send_password_reset_request_use_case.dart';
import 'package:re_view_front/features/auth/domain/usecases/signup_use_case.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/login_view_model.dart';
import 'package:re_view_front/features/auth/presentation/view_models/oauth_callback_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/oauth_callback_view_model.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/password_reset_view_model.dart';
import 'package:re_view_front/features/auth/presentation/view_models/signup_state.dart';
import 'package:re_view_front/features/auth/presentation/view_models/signup_view_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStore: ref.read(authTokenStoreProvider.notifier),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);

final signupViewModelProvider = NotifierProvider<SignupViewModel, SignupState>(
  SignupViewModel.new,
);

final handleOAuthCallbackUseCaseProvider = Provider<HandleOAuthCallbackUseCase>(
  (ref) {
    return HandleOAuthCallbackUseCase(ref.watch(authRepositoryProvider));
  },
);

final oauthCallbackViewModelProvider =
    NotifierProvider<OAuthCallbackViewModel, OAuthCallbackState>(
      OAuthCallbackViewModel.new,
    );

final sendPasswordResetRequestUseCaseProvider =
    Provider<SendPasswordResetRequestUseCase>((ref) {
      return SendPasswordResetRequestUseCase(ref.watch(authRepositoryProvider));
    });

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
});

final passwordResetViewModelProvider = NotifierProvider.autoDispose
    .family<PasswordResetViewModel, PasswordResetState, String?>(
      (token) => PasswordResetViewModel(initialToken: token),
    );
