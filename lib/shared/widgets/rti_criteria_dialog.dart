import 'package:flutter/material.dart';

void showRtiCriteriaDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: const Text('RTI 분석 기준 안내'),
    content: const SingleChildScrollView(
      child: Text(
        'RTI는 서버에서 반환한 리뷰 신뢰도 분석 결과입니다. 분석 점수·등급·근거가 제공되는 경우 해당 결과를 표시합니다.\n\n'
        '분석 결과가 없는 상품은 “분석 전”으로 표시하며 0점이나 안전 등급으로 바꾸지 않습니다. 실제 0점은 분석 전과 구분합니다.\n\n'
        '쇼핑몰 상품·리뷰 정보 수집과 RTI 분석은 별도 과정입니다. 상품 수집이 끝나도 분석 결과가 없으면 분석 전 상태를 유지합니다.',
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(dialogContext).pop(),
        child: const Text('닫기'),
      ),
    ],
  ),
);
