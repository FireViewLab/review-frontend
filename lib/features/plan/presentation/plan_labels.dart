import 'package:re_view_front/l10n/generated/app_localizations.dart';

/// 요금제 코드를 화면 이름으로 바꾼다. 모르는 코드는 서버가 준 이름이나 코드를 그대로 쓴다.
String planLabel(AppLocalizations l10n, String code, {String? fallback}) {
  return switch (code.toUpperCase()) {
    'FREE' => l10n.chatPlanFree,
    'PLUS' => l10n.chatPlanPlus,
    'PRO' => l10n.chatPlanPro,
    _ => fallback == null || fallback.isEmpty ? code : fallback,
  };
}
