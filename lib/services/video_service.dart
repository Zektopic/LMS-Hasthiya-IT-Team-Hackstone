import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/video.dart';

class VideoService {
  final FirebaseFirestore _db;

  VideoService({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  // Optimization: Added optional limit parameter to prevent unbounded reads
  Future<List<Video>> getVideos({int? limit}) async {
    try {
      Query<Map<String, dynamic>> query = _db.collection('videos');
      if (limit != null) {
        query = query.limit(limit);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      return [];
    }
  }
}
