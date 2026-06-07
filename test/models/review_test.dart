import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/review.dart';

// Manual Fake for DocumentSnapshot
class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;
}

void main() {
  group('Review Tests', () {
    test('fromFirestore parses complete data correctly', () {
      final now = DateTime.now();
      final doc = FakeDocumentSnapshot('review123', {
        'userId': 'user456',
        'userName': 'John Doe',
        'userPhotoUrl': 'https://example.com/photo.jpg',
        'rating': 4.5,
        'comment': 'Great course!',
        'createdAt': Timestamp.fromDate(now),
      });

      final review = Review.fromFirestore(doc);

      expect(review.id, 'review123');
      expect(review.userId, 'user456');
      expect(review.userName, 'John Doe');
      expect(review.userPhotoUrl, 'https://example.com/photo.jpg');
      expect(review.rating, 4.5);
      expect(review.comment, 'Great course!');
      expect(review.createdAt, now);
    });

    test('fromFirestore provides default values for missing data', () {
      final doc = FakeDocumentSnapshot('review123', {});

      final review = Review.fromFirestore(doc);

      expect(review.id, 'review123');
      expect(review.userId, '');
      expect(review.userName, 'Anonymous');
      expect(review.userPhotoUrl, isNull);
      expect(review.rating, 0.0);
      expect(review.comment, '');
      // Cannot exactly match DateTime.now(), so checking if it is close
      expect(DateTime.now().difference(review.createdAt).inSeconds, lessThan(5));
    });

    test('fromFirestore handles null data from DocumentSnapshot', () {
      final doc = FakeDocumentSnapshot('review123', null);

      final review = Review.fromFirestore(doc);

      expect(review.id, 'review123');
      expect(review.userId, '');
      expect(review.userName, 'Anonymous');
      expect(review.userPhotoUrl, isNull);
      expect(review.rating, 0.0);
      expect(review.comment, '');
      expect(DateTime.now().difference(review.createdAt).inSeconds, lessThan(5));
    });

    test('fromFirestore parses rating correctly when provided as int', () {
      final now = DateTime.now();
      final doc = FakeDocumentSnapshot('review123', {
        'userId': 'user456',
        'userName': 'John Doe',
        'rating': 5, // int instead of double
        'comment': 'Perfect!',
        'createdAt': Timestamp.fromDate(now),
      });

      final review = Review.fromFirestore(doc);
      expect(review.rating, 5.0);
    });
  });
}
