import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Real-time stream of all reviews for a course, newest first.
  Stream<List<Review>> getReviews(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  /// Returns the current user's review for a course, or null if they haven't reviewed yet.
  Future<Review?> getUserReview(String courseId, String userId) async {
    try {
      final doc = await _db
          .collection('courses')
          .doc(courseId)
          .collection('reviews')
          .doc(userId)
          .get();
      if (doc.exists) return Review.fromFirestore(doc);
      return null;
    } catch (e) {
      debugPrint('Error fetching user review: $e');
      return null;
    }
  }

  /// Adds or updates the user's review. Uses userId as the document ID
  /// to enforce one review per user per course.
  Future<void> addReview(String courseId, Review review) async {
    await _db
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .doc(review.userId)
        .set(review.toMap());
  }

  /// Deletes the user's review.
  Future<void> deleteReview(String courseId, String userId) async {
    await _db
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .doc(userId)
        .delete();
  }
}
