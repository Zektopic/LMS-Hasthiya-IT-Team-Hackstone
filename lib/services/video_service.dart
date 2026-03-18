import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/video.dart';

class VideoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Video>> getVideos() async {
    try {
      final snapshot = await _db.collection('videos').get();
      return snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      return [];
    }
  }
}
