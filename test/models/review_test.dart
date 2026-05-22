import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/review.dart';

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final String id;
  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this.id, this._data);

  @override
  Map<String, dynamic>? data() => _data;
}

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

  group('Review.fromFirestore', () {
    test('parses full data correctly', () {
      final now = DateTime.now();
      final doc = FakeDocumentSnapshot('review123', {
        'userId': 'user123',
        'userName': 'Test User',
        'userPhotoUrl': 'https://example.com/photo.png',
        'rating': 4.5,
        'comment': 'Great course!',
        'createdAt': Timestamp.fromDate(now),
      });

      final review = Review.fromFirestore(doc);

      expect(review.id, 'review123');
      expect(review.userId, 'user123');
      expect(review.userName, 'Test User');
      expect(review.userPhotoUrl, 'https://example.com/photo.png');
      expect(review.rating, 4.5);
      expect(review.comment, 'Great course!');
      expect(review.createdAt, now);
    });

    test('uses default values when data is missing', () {
      final doc = FakeDocumentSnapshot('review123', {});

      final review = Review.fromFirestore(doc);

      expect(review.id, 'review123');
      expect(review.userId, '');
      expect(review.userName, 'Anonymous');
      expect(review.userPhotoUrl, isNull);
      expect(review.rating, 0.0);
      expect(review.comment, '');
      // createdAt defaults to DateTime.now(), so we check if it's recent
      expect(DateTime.now().difference(review.createdAt).inSeconds, lessThan(2));
    });

    test('handles null data correctly (if snapshot.data() is null)', () {
      final doc = FakeDocumentSnapshot('review123', null);

      final review = Review.fromFirestore(doc);

      expect(review.id, 'review123');
      expect(review.userId, '');
      expect(review.userName, 'Anonymous');
      expect(review.userPhotoUrl, isNull);
      expect(review.rating, 0.0);
      expect(review.comment, '');
      expect(DateTime.now().difference(review.createdAt).inSeconds, lessThan(2));
    });
  });
}
