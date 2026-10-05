/// 수집기 이름을 쇼핑몰 표시 이름으로 바꾼다. 모르는 이름은 그대로 보여 준다.
String externalPlatformLabel(String platform, {required String localeName}) {
  final names = localeName.startsWith('ko') ? _korean : _latin;
  return names[platform.toLowerCase()] ?? platform;
}

const _korean = {
  'naver': '네이버',
  'kurly': '컬리',
  'elevenst': '11번가',
  'ably': '에이블리',
  'auction': '옥션',
  'gmarket': 'G마켓',
  'musinsa': '무신사',
  'ohouse': '오늘의집',
  'oliveyoung': '올리브영',
};

const _latin = {
  'naver': 'Naver',
  'kurly': 'Kurly',
  'elevenst': '11st',
  'ably': 'Ably',
  'auction': 'Auction',
  'gmarket': 'Gmarket',
  'musinsa': 'Musinsa',
  'ohouse': 'Ohouse',
  'oliveyoung': 'Olive Young',
};
