import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/review.dart';

void main() {
  group('Review.toMap', () {
    test('correctly maps all properties when userPhotoUrl is provided', () {
      final now = DateTime.now();
      final review = Review(
        id: 'review123',
        userId: 'user123',
        userName: 'Test User',
        userPhotoUrl: 'https://example.com/photo.png',
        rating: 4.5,
        comment: 'Great course!',
        createdAt: now,
      );

      final map = review.toMap();

      expect(map['userId'], 'user123');
      expect(map['userName'], 'Test User');
      expect(map['userPhotoUrl'], 'https://example.com/photo.png');
      expect(map['rating'], 4.5);
      expect(map['comment'], 'Great course!');
      expect(map['createdAt'], isA<Timestamp>());
      expect((map['createdAt'] as Timestamp).toDate(), now);

      // Note: id is deliberately not part of toMap in the implementation
      expect(map.containsKey('id'), isFalse);
    });

    test('correctly maps all properties when userPhotoUrl is null', () {
      final now = DateTime.now();
      final review = Review(
        id: 'review123',
        userId: 'user123',
        userName: 'Test User',
        userPhotoUrl: null,
        rating: 4.5,
        comment: 'Great course!',
        createdAt: now,
      );

      final map = review.toMap();

      expect(map['userId'], 'user123');
      expect(map['userName'], 'Test User');
      expect(map['userPhotoUrl'], isNull);
      expect(map['rating'], 4.5);
      expect(map['comment'], 'Great course!');
      expect(map['createdAt'], isA<Timestamp>());
      expect((map['createdAt'] as Timestamp).toDate(), now);
    });
  });
}
