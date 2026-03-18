import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final double rating;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.rating,
    required this.lessons,
  });

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Course(
      id: doc.id,
      title: data?['title'] ?? '',
      description: data?['description'] ?? '',
      thumbnailUrl: data?['thumbnailUrl'] ?? '',
      rating: (data?['rating'] ?? 0.0).toDouble(),
      lessons: (data?['lessons'] as List<dynamic>?)
              ?.map((lessonData) => Lesson.fromJson(lessonData as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String videoUrl;
  final Duration duration;

  Lesson({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.duration,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      duration: Duration(minutes: json['durationMinutes'] ?? 0),
    );
  }
}
