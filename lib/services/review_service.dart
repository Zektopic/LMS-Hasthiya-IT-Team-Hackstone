import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// The top-level Firestore collection that holds the content documents.
  /// Use 'courses' for course reviews, 'videos' for video reviews.
  final String contentCollection;

  ReviewService({this.contentCollection = 'courses'});

  CollectionReference<Map<String, dynamic>> _reviewsRef(String contentId) {
    return _db
        .collection(contentCollection)
        .doc(contentId)
        .collection('reviews');
  }

  /// Real-time stream of all reviews for a piece of content, newest first.
  Stream<List<Review>> getReviews(String contentId) {
    return _reviewsRef(contentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  /// Returns the current user's review, or null if they haven't reviewed yet.
  Future<Review?> getUserReview(String contentId, String userId) async {
    try {
      final doc = await _reviewsRef(contentId).doc(userId).get();
      if (doc.exists) return Review.fromFirestore(doc);
      return null;
    } catch (e) {
      debugPrint('Error fetching user review: $e');
      return null;
    }
  }

  /// Adds or updates a review. Uses userId as the document ID to enforce
  /// one review per user per content item.
  Future<void> addReview(String contentId, Review review) async {
    await _reviewsRef(contentId).doc(review.userId).set(review.toMap());
  }

  /// Deletes the user's review.
  Future<void> deleteReview(String contentId, String userId) async {
    await _reviewsRef(contentId).doc(userId).delete();
  }
}
