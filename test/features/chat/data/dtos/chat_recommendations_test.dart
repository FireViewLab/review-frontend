import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_reply_dto.dart';
import 'package:re_view_front/features/chat/data/dtos/chat_message_dto.dart';

Map<String, dynamic> product(String id, {String name = '상품'}) => {
  'externalId': 'kurly-$id',
  'platform': 'kurly',
  'productId': id,
  'name': name,
};

void main() {
  test('absent, null, empty and malformed arrays keep the answer intact', () {
    for (final value in [null, [], 'bad']) {
      final reply = ChatReplyDto({
        'answer': '답변',
        'recommendations': value,
      }).toEntity();
      expect(reply.answer, '답변');
      expect(reply.recommendations, isEmpty);
    }
    expect(
      const ChatReplyDto({'answer': '답변'}).toEntity().recommendations,
      isEmpty,
    );
  });
  test(
    'keeps three valid products, skips invalid names/identities and duplicates',
    () {
      final reply = ChatReplyDto({
        'recommendations': [
          null,
          {'name': '식별자 없음'},
          product('1', name: ' '),
          {'name': '잘못된 식별자', 'externalId': 'bad'},
          {'name': '잘못된 몰', 'platform': '??', 'productId': '1'},
          product('1'),
          product('1'),
          product('2-x'),
          product('3'),
          product('4'),
        ],
      }).toEntity();
      expect(reply.recommendations.map((p) => p.ref.externalId), [
        'kurly-1',
        'kurly-2-x',
        'kurly-3',
      ]);
      expect(reply.recommendations[1].ref.routePath, '/product/kurly/2-x');
    },
  );
  test(
    'null and invalid numeric values stay null, explicit zero stays zero',
    () {
      final reply = ChatReplyDto({
        'recommendations': [
          {...product('1'), 'price': null, 'reviewCount': null, 'rating': null},
          {...product('2'), 'price': 0, 'reviewCount': '0', 'rating': 0},
          {
            ...product('3'),
            'price': 'not a number',
            'reviewCount': 1.5,
            'rating': double.nan,
            'thumbnailUrl': 'javascript:bad',
          },
        ],
      }).toEntity();
      final first = reply.recommendations.first;
      expect(first.price, isNull);
      expect(first.reviewCount, isNull);
      expect(first.rating, isNull);
      final zero = reply.recommendations[1];
      expect(zero.price, 0);
      expect(zero.reviewCount, 0);
      expect(zero.rating, 0);
      final invalid = reply.recommendations[2];
      expect(invalid.price, isNull);
      expect(invalid.reviewCount, isNull);
      expect(invalid.rating, isNull);
      expect(invalid.thumbnailUrl, isNull);
    },
  );
  test(
    'blocked replies and stored history never restore recommendation cards',
    () {
      expect(
        ChatReplyDto({
          'blocked': true,
          'recommendations': [product('1')],
        }).toEntity().recommendations,
        isEmpty,
      );
      expect(
        ChatMessageDto({
          'id': 1,
          'role': 'ASSISTANT',
          'content': '기록',
          'recommendations': [product('1')],
        }).toEntity().recommendations,
        isEmpty,
      );
    },
  );
}
