import 'package:flutter/widgets.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

String? localizedAuthValidationError(BuildContext context, String? message) {
  final l10n = AppLocalizations.of(context);
  return {
        "이름을 입력해주세요.": l10n.authValidationNameRequired,
        "이메일을 입력해주세요.": l10n.authValidationEmailRequired,
        "올바른 이메일 형식으로 입력해주세요.": l10n.authValidationEmailInvalid,
        "비밀번호를 입력해주세요.": l10n.authValidationPasswordRequired,
        "영문, 숫자, 특수문자를 모두 포함해주세요.": l10n.authValidationPasswordComposition,
        "비밀번호를 한 번 더 입력해주세요.": l10n.authValidationPasswordConfirmRequired,
        "비밀번호가 일치하지 않습니다.": l10n.authValidationPasswordMismatch,
        "필수 약관에 동의해주세요.": l10n.authValidationTermsRequired,
        '비밀번호는 8자 이상이어야 합니다.': l10n.authValidationPasswordMinLength(8),
      }[message] ??
      message;
}
