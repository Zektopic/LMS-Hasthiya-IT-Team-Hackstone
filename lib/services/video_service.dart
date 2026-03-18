import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video.dart';

class VideoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Video>> getVideos(String token) async {
    try {
      final snapshot = await _db.collection('videos').get();
      return snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching videos: $e');
      throw Exception('Failed to load videos: $e');
    }
  }
}
