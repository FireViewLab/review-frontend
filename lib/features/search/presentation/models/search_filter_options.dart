const defaultSearchPageSize = 30;
const searchPageSizes = [defaultSearchPageSize, 60];

const searchPriceRanges = <String, (int?, int?)>{
  '1만원 이하': (0, 10000),
  '10~30만원': (100000, 300000),
  '30만원 이상': (300000, null),
};

const searchAttributeFilters = ['분석 전만', '가격 정보 없음만'];
const searchReviewConditions = ['리뷰 50개 이상'];

int searchPageCount(int total, int size) =>
    total > 0 ? (total - 1) ~/ size + 1 : 1;
