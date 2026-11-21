import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/core/analysis/analysis_contract.dart';
import 'package:re_view_front/core/analysis/analysis_display.dart';
import 'package:re_view_front/core/analysis/analysis_keys.dart';

void main() {
  group(AnalysisContract, () {
    group('parse', () {
      for (final entry in {
        'safe': '#22C55E',
        'warn': '#F59E0B',
        'danger': '#EF4444',
      }.entries) {
        test('reads v0.5 RTI and ${entry.key} without treating it as v2', () {
          final result = AnalysisContract.parse({
            'rti': 72.5,
            'level': entry.key,
            'reasons': [
              ' 정상 리뷰 ',
              {'message': '구체적인 사용 후기'},
            ],
            'analysisSummaryKo': 'v2 전용 요약',
          });
          expect(result.contractVersion, 'v0.5');
          expect(result.isV2, isFalse);
          expect(result.hasResult, isTrue);
          expect(result.score, 72.5);
          expect(result.level, entry.key);
          expect(result.colorHex, entry.value);
          expect(result.summary, isNull);
          expect(result.displayReasons, ['정상 리뷰', '구체적인 사용 후기']);
        });
      }

      for (final snakeCase in [false, true]) {
        for (final entry in {
          'SAFE': '#22C55E',
          'WARN': '#F59E0B',
          'DANGER': '#EF4444',
        }.entries) {
          test(
            'reads v2 ${entry.key} with ${snakeCase ? 'snake_case' : 'camelCase'} fields',
            () {
              final result = AnalysisContract.parse(
                snakeCase
                    ? {
                        'contract_version': 'v2',
                        'policy_index_v3': '81.5',
                        'evidence_level_v3': entry.key,
                        'analysis_summary_ko': ' 상품 분석 요약 ',
                        'rules_reasons_ko': [
                          {'message': '규칙 사유'},
                          {'code': 'RULE_2'},
                          ' 직접 사유 ',
                          '',
                          null,
                        ],
                        'evidence_reasons_v3': ['증거 사유'],
                        'reason_source': 'rules',
                        'text_score': 91,
                        'behavior_score': '64',
                        'network_score': 0,
                      }
                    : {
                        'contractVersion': 'v2',
                        'policyIndexV3': '81.5',
                        'evidenceLevelV3': entry.key,
                        'analysisSummaryKo': ' 상품 분석 요약 ',
                        'rulesReasonsKo': [
                          {'message': '규칙 사유'},
                          {'code': 'RULE_2'},
                          ' 직접 사유 ',
                          '',
                          null,
                        ],
                        'evidenceReasonsV3': ['증거 사유'],
                        'reasonSource': 'rules',
                        'textScore': 91,
                        'behaviorScore': '64',
                        'networkScore': 0,
                      },
              );
              expect(result.isV2, isTrue);
              expect(result.score, 81.5);
              expect(result.level, entry.key);
              expect(result.colorHex, entry.value);
              expect(result.summary, '상품 분석 요약');
              expect(result.reasons, ['규칙 사유', 'RULE_2', '직접 사유']);
              expect(result.displayReasons, ['상품 분석 요약']);
              expect(result.evidenceReasons, ['증거 사유']);
              expect(result.reasonSource, 'rules');
              expect(
                [result.textScore, result.behaviorScore, result.networkScore],
                [91, 64, 0],
              );
            },
          );
        }
      }

      for (final version in ['v0.5', 'v2']) {
        test(
          'preserves absent and explicit null $version scores instead of zero',
          () {
            for (final fields in <Map<String, dynamic>>[
              {},
              {
                'rti': null,
                'policyIndexV3': null,
                'textScore': null,
                'behaviorScore': null,
                'networkScore': null,
              },
            ]) {
              final result = AnalysisContract.parse({
                'contractVersion': version,
                ...fields,
              });
              expect(result.score, isNull);
              expect(result.textScore, isNull);
              expect(result.behaviorScore, isNull);
              expect(result.networkScore, isNull);
            }
          },
        );
      }

      test('treats an empty legacy response as having no analysis', () {
        final result = AnalysisContract.parse({
          'rti': '',
          'level': ' ',
          'reasons': [],
        });
        expect(result.hasResult, isFalse);
        expect(result.score, isNull);
        expect(result.level, isNull);
        expect(result.displayReasons, isEmpty);
      });

      test('preserves an unknown level without assigning a known color', () {
        final result = AnalysisContract.parse({'level': ' NEW_LEVEL '});
        expect(result.level, 'NEW_LEVEL');
        expect(result.colorHex, isNull);
      });

      test('falls back to rule reasons when the v2 summary is blank', () {
        final result = AnalysisContract.parse({
          'contractVersion': 'v2',
          'analysisSummaryKo': ' ',
          'rulesReasonsKo': ['사유'],
        });
        expect(result.hasResult, isTrue);
        expect(result.summary, isNull);
        expect(result.displayReasons, ['사유']);
      });

      test('inherits the outer v2 contract but honors an explicit version', () {
        expect(
          AnalysisContract.parse({
            'policy_index_v3': 42,
          }, inheritedVersion: 'v2').score,
          42,
        );
        final legacy = AnalysisContract.parse({
          'contractVersion': 'v0.5',
          'rti': 12,
          'policyIndexV3': 80,
        }, inheritedVersion: 'v2');
        expect(legacy.isV2, isFalse);
        expect(legacy.score, 12);
      });

      for (final entry in {
        0: 'DANGER',
        39: 'DANGER',
        40: 'WARN',
        69: 'WARN',
        70: 'SAFE',
        100: 'SAFE',
      }.entries) {
        test(
          'infers catalog evidence level ${entry.value} at ${entry.key}',
          () {
            final result = AnalysisContract.parse({
              'avg_policy_index_v3': entry.key,
            }, catalog: true);
            expect(result.isV2, isTrue);
            expect(result.score, entry.key);
            expect(result.level, entry.value);
          },
        );
      }

      test(
        'uses catalog RTI aliases without confusing review and catalog scores',
        () {
          expect(
            AnalysisContract.parse({'avg_rti': 55}, catalog: true).score,
            55,
          );
          expect(AnalysisContract.parse({'rtiScore': 23}).score, 23);
          expect(
            AnalysisContract.parse({'reviewerAtiScore': 0, 'rti': 80}).score,
            0,
          );
        },
      );
    });

    group('score', () {
      test('accepts boundary scores and numeric strings', () {
        for (final value in [0, '0', 100, '100', 42.5, '42.5']) {
          expect(AnalysisContract.score(value), double.parse('$value'));
        }
      });
      test('rejects missing, malformed, out-of-range and nonfinite scores', () {
        for (final value in [
          null,
          '',
          'unknown',
          -1,
          101,
          double.nan,
          double.infinity,
          -double.infinity,
        ]) {
          expect(
            AnalysisContract.score(value),
            isNull,
            reason: '$value must not become a result',
          );
        }
      });
    });

    group('read product summary', () {
      for (final key in [
        'productSummaryKo',
        'product_summary_ko',
        'summaryKo',
        'summary_ko',
        'analysisSummaryKo',
        'analysis_summary_ko',
      ]) {
        test('recognizes the $key summary candidate', () {
          expect(
            AnalysisContract.text(
              AnalysisContract.read({
                key: ' 상품 요약 ',
              }, AnalysisKeys.productSummary),
            ),
            '상품 요약',
          );
        });
      }
      test('prefers the product summary over a review analysis summary', () {
        expect(
          AnalysisContract.read({
            'productSummaryKo': '상품',
            'analysisSummaryKo': '리뷰',
          }, AnalysisKeys.productSummary),
          '상품',
        );
      });
    });
  });
  group(AnalysisDisplay, () {
    test('uses legacy suspicious as a warning color', () {
      expect(const AnalysisDisplay(level: 'suspicious').colorHex, '#F59E0B');
    });
  });
}
