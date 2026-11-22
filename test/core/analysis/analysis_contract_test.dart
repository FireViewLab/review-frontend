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
                        'policy_index_v4': '81.5',
                        'level_v4': entry.key,
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
                        'text_score_v4': 91,
                        'behavior_score': '64',
                        'network_score': 0,
                      }
                    : {
                        'contractVersion': 'v2',
                        'policyIndexV4': '81.5',
                        'levelV4': entry.key,
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
                        'textScoreV4': 91,
                        'behaviorScore': '64',
                        'networkScore': 0,
                      },
              );
              expect(result.isV2, isTrue);
              expect(result.score, 81.5);
              expect(result.level, entry.key);
              expect(result.colorHex, entry.value);
              expect(result.summary, isNull);
              expect(result.reasons, isEmpty);
              expect(result.displayReasons, isEmpty);
              expect(result.evidenceReasons, isEmpty);
              expect(result.reasonSource, isNull);
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
                'policyIndexV4': null,
                'textScoreV4': null,
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

      test('hides old rule reasons even when the policy summary is blank', () {
        final result = AnalysisContract.parse({
          'contractVersion': 'v2',
          'analysisSummaryKo': ' ',
          'rulesReasonsKo': ['사유'],
        });
        expect(result.hasResult, isTrue);
        expect(result.summary, isNull);
        expect(result.displayReasons, isEmpty);
      });

      test('inherits the outer v2 contract but honors an explicit version', () {
        expect(
          AnalysisContract.parse({
            'policy_index_v4': 42,
          }, inheritedVersion: 'v2').score,
          42,
        );
        final legacy = AnalysisContract.parse({
          'contractVersion': 'v0.5',
          'rti': 12,
          'policyIndexV4': 80,
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
              'avg_policy_index_v4': entry.key,
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

    group('v4 migration', () {
      test(
        'never uses v3 scores, grades or explanations as a policy fallback',
        () {
          final result = AnalysisContract.parse({
            'contractVersion': 'v2',
            'policyIndexV3': 90,
            'evidenceLevelV3': 'SAFE',
            'textScore': 95,
            'rti': 99,
            'analysisSummaryKo': '이전 요약',
            'rulesReasonsKo': ['이전 이유'],
            'reasons': ['이전 리뷰 근거'],
          });
          expect(result.isAwaitingScore, isTrue);
          expect(result.score, isNull);
          expect(result.level, isNull);
          expect(result.textScore, isNull);
          expect(result.summary, isNull);
          expect(result.displayReasons, isEmpty);
        },
      );
      test(
        'preserves explicit null catalog v4 scores instead of legacy averages',
        () {
          final result = AnalysisContract.parse({
            'avgPolicyIndexV4': null,
            'avgPolicyIndexV3': 91,
            'avgRti': 99,
            'levelV4': 'SAFE',
          }, catalog: true);
          expect(result.isV2, isTrue);
          expect(result.isAwaitingScore, isTrue);
          expect(result.level, isNull);
          expect(result.score, isNull);
        },
      );
      test(
        'recognizes a catalog with v4 counts but no index as still awaiting its score',
        () {
          final result = AnalysisContract.parse({
            'v4LevelCounts': {'SAFE': 4, 'WARN': 2, 'DANGER': 1},
            'avgRti': 99,
          }, catalog: true);
          expect(result.isAwaitingScore, isTrue);
          expect(result.score, isNull);
          expect(result.attentionReviewCount, 3);
        },
      );
      test('keeps a genuine zero v4 index and its danger grade', () {
        final result = AnalysisContract.parse({
          'contractVersion': 'v2',
          'policyIndexV4': 0,
          'levelV4': 'DANGER',
        });
        expect(result.score, 0);
        expect(result.isAwaitingScore, isFalse);
        expect(result.needsAttentionExplanation, isTrue);
      });
      for (final snake in [false, true]) {
        test(
          'parses ${snake ? 'snake' : 'camel'} v4 metadata, probability and catalog counts',
          () {
            final result = AnalysisContract.parse(
              snake
                  ? {
                      'contract_version': 'v2',
                      'avg_policy_index_v4': 50,
                      'text_score_v4': 40,
                      'text_probability_v4': 0.75,
                      'model_version_v4': 'ptext-koelectra-v4.0',
                      'policy_version_v4': 'text-first-v1',
                      'v4_level_counts': {'SAFE': 4, 'WARN': 2, 'DANGER': 1},
                    }
                  : {
                      'contractVersion': 'v2',
                      'avgPolicyIndexV4': 50,
                      'textScoreV4': 40,
                      'textProbabilityV4': 0.75,
                      'modelVersionV4': 'ptext-koelectra-v4.0',
                      'policyVersionV4': 'text-first-v1',
                      'v4LevelCounts': {'SAFE': 4, 'WARN': 2, 'DANGER': 1},
                    },
              catalog: true,
            );
            expect(result.textProbability, 0.75);
            expect(result.modelVersion, 'ptext-koelectra-v4.0');
            expect(result.policyVersion, 'text-first-v1');
            expect(result.levelCounts, {'SAFE': 4, 'WARN': 2, 'DANGER': 1});
            expect(result.attentionReviewCount, 3);
            expect(
              () => result.levelCounts!['WARN'] = 100,
              throwsUnsupportedError,
            );
          },
        );
      }
      test(
        'keeps absent or malformed review counts absent and real zero counts at zero',
        () {
          for (final counts in [
            null,
            {},
            {'SAFE': 1, 'WARN': -1, 'DANGER': 0},
            {'SAFE': 1, 'WARN': 2.5, 'DANGER': 0},
          ]) {
            expect(
              AnalysisContract.parse({
                'contractVersion': 'v2',
                'v4LevelCounts': counts,
              }, catalog: true).attentionReviewCount,
              isNull,
            );
          }
          expect(
            AnalysisContract.parse({
              'contractVersion': 'v2',
              'v4LevelCounts': {'SAFE': 10, 'WARN': 0, 'DANGER': 0},
            }, catalog: true).attentionReviewCount,
            0,
          );
        },
      );
      test('rejects out-of-range or nonfinite model probabilities', () {
        for (final probability in [-0.1, 1.1, double.nan, double.infinity]) {
          expect(
            AnalysisContract.parse({
              'contractVersion': 'v2',
              'textProbabilityV4': probability,
            }).textProbability,
            isNull,
          );
        }
      });
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
