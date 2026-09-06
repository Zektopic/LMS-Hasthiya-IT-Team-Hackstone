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
      // ⚡ Bolt: Enforced default limit of 10 to prevent unbounded data retrieval and excessive memory allocation.
      query = query.limit(limit ?? 10);
      final snapshot = await query.get();
      // ⚡ Bolt: Use collection for loop to directly construct list
      // avoiding intermediate Iterable allocation from .map().toList()
      return [
        for (final doc in snapshot.docs) Video.fromFirestore(doc),
      ];
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      return [];
    }
  }
}
