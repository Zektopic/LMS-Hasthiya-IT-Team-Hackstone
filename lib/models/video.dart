import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String title;
  final String description;
  final String videoUrl;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }

  factory Video.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Video(
      id: doc.id,
      title: data?['title'] ?? 'Untitled',
      description: data?['description'] ?? '',
      videoUrl: data?['videoUrl'] ?? '',
    );
  }
}
