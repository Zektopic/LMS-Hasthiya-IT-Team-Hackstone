import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? duration;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    this.duration,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['duration'],
    );
  }

  factory Video.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Video(
      id: doc.id,
      title: data?['title'] ?? 'Untitled',
      description: data?['description'] ?? '',
      videoUrl: data?['videoUrl'] ?? '',
      thumbnailUrl: data?['thumbnailUrl'],
      duration: data?['duration'],
    );
  }
}
