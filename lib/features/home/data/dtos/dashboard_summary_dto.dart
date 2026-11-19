import 'package:re_view_front/features/home/data/dtos/dashboard_product_dto.dart';
import 'package:re_view_front/features/home/data/dtos/trending_keyword_dto.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/entities/trending_keyword.dart';

class DashboardSummaryDto {
  const DashboardSummaryDto({
    required this.recommendedProducts,
    this.recentProducts = const [],
    this.riskyProducts = const [],
    required this.trendingKeywords,
  });

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) {
    final data = _unwrapData(json);

    return DashboardSummaryDto(
      recommendedProducts:
          _readList(data, [
                'recommendedProducts',
                'recommendProducts',
                'recommendations',
                'products',
                'items',
              ])
              .whereType<Map<String, dynamic>>()
              .map(DashboardProductDto.fromJson)
              .toList(growable: false),
      recentProducts:
          _readList(data, ['recentProducts', 'recentViewedProducts'])
              .whereType<Map<String, dynamic>>()
              .map(DashboardProductDto.fromJson)
              .toList(growable: false),
      riskyProducts: _readList(data, ['riskyProducts', 'dangerProducts'])
          .whereType<Map<String, dynamic>>()
          .map(DashboardProductDto.fromJson)
          .toList(growable: false),
      trendingKeywords:
          _readList(data, [
                'trendingKeywords',
                'popularKeywords',
                'keywords',
                'searchKeywords',
              ])
              .asMap()
              .entries
              .map((entry) {
                return TrendingKeywordDto.fromValue(
                  entry.value,
                  rank: entry.key + 1,
                );
              })
              .where((item) => item.keyword.isNotEmpty)
              .toList(growable: false),
    );
  }

  final List<DashboardProductDto> recommendedProducts;
  final List<DashboardProductDto> recentProducts;
  final List<DashboardProductDto> riskyProducts;
  final List<TrendingKeywordDto> trendingKeywords;

  DashboardSummary toEntity() {
    final recentIds = <String>{};
    return DashboardSummary(
      recommendedProducts: recommendedProducts
          .map((item) => item.toEntity())
          .where((item) => item.name.isNotEmpty)
          .toList(growable: false),
      recentProducts: recentProducts
          .map((item) => item.toEntity())
          .where(
            (item) =>
                item.name.isNotEmpty &&
                recentIds.add(item.externalRef?.externalId ?? item.id),
          )
          .toList(growable: false),
      riskyProducts: riskyProducts
          .map((item) => item.toEntity())
          .where((item) => item.name.isNotEmpty)
          .toList(growable: false),
      trendingKeywords: _uniqueKeywords(trendingKeywords),
    );
  }
}

Map<String, dynamic> _unwrapData(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is Map<String, dynamic>) {
    return data;
  }
  final result = json['result'];
  if (result is Map<String, dynamic>) {
    return result;
  }
  return json;
}

List<Object?> _readList(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is List) {
      return value;
    }
    if (value is Map<String, dynamic>) {
      final nestedItems = value['items'] ?? value['content'] ?? value['data'];
      if (nestedItems is List) {
        return nestedItems;
      }
    }
  }
  return const [];
}

/// 서버 키워드의 앞뒤 공백을 지우고, 대소문자만 다른 중복은 앞 순위 하나만 남긴다.
/// 순위는 남은 순서대로 다시 매긴다.
List<TrendingKeyword> _uniqueKeywords(List<TrendingKeywordDto> items) {
  final seen = <String>{};
  final result = <TrendingKeyword>[];
  for (final item in items) {
    final keyword = item.keyword.trim();
    if (keyword.isEmpty || !seen.add(keyword.toLowerCase())) continue;
    result.add(TrendingKeyword(keyword: keyword, rank: result.length + 1));
  }
  return List.unmodifiable(result);
}
