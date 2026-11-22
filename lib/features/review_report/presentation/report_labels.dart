import 'package:re_view_front/l10n/generated/app_localizations.dart';

String reportLabel(AppLocalizations l10n, String value) =>
    {
      "가짜 리뷰 / 리뷰 날바 의심": l10n.reportReasonFake,
      "AI 생성 흔적 의심": l10n.reportReasonGenerated,
      "상품과 무관한 내용": l10n.externalReasonIrrelevant,
      "부적절한 표현 / 개인정보": l10n.externalReasonInappropriate,
      "광고성 리뷰": l10n.externalReasonAd,
      "반복 내용": l10n.externalReasonRepeated,
      "기타": l10n.externalReasonOther,
      "반복되고, 과도한 칭찬, 구매 이력 복수가 동조하는 가능성이 있는 리뷰예요.":
          l10n.reportReasonFakeDescription,
      "반복이 지나치게 정밀하거나, 동일한 문장 구조가 반복되는 리뷰예요.":
          l10n.reportReasonGeneratedDescription,
      "실제 상품 사용 경험과 관련이 없는 내용이거나 다른 상품/페이지의 내용을 포함해요.":
          l10n.reportReasonIrrelevantDescription,
      "비방, 혐오 표현, 이름 등 개인정보가 포함된 리뷰예요.":
          l10n.reportReasonInappropriateDescription,
      "광고 리뷰입니다.": l10n.reportReasonAdDescription,
      "반복되는 내용입니다.": l10n.reportReasonRepeatDescription,
      "기타 신고 사유입니다.": l10n.reportReasonOtherDescription,
      "반복 문구": l10n.reportTypeRepetition,
      "계정 생성 직후": l10n.reportTypeNewAccount,
      "유사 리뷰 군집": l10n.reportTypeSimilarCluster,
      "비공개": l10n.reportPrivate,
      "나에게만 공개": l10n.reportOnlyMe,
      "운영팀 공유": l10n.reportTeamOnly,
      "선택해주세요": l10n.reportSelectPrompt,
      "안내": l10n.reportGuideBadge,
    }[value] ??
    value;
