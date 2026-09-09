import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/video.dart';

class VideoService {
  static const int defaultQueryLimit = 50;
  final FirebaseFirestore _db;

  VideoService({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  // Optimization: Bound queries with default limit to prevent unbounded reads
  Future<List<Video>> getVideos({int? limit}) async {
    try {
      final Query<Map<String, dynamic>> query = _db
          .collection('videos')
          .limit(limit ?? defaultQueryLimit);
      final snapshot = await query.get();
      // ⚡ Bolt: Use collection for loop to directly construct list avoiding intermediate Iterable allocation
      return [
        for (final doc in snapshot.docs) Video.fromFirestore(doc),
      ];
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      return [];
    }
  }
}
