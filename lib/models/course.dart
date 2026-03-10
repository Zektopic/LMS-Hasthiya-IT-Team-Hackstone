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
}
