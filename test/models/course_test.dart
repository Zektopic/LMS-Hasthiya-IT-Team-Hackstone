import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/course.dart';

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;
}

void main() {
  group('Course Model Tests', () {
    test('Course.fromFirestore handles valid data correctly', () {
      final doc = FakeDocumentSnapshot('course123', {
        'title': 'Flutter Mastery',
        'description': 'Learn Flutter from scratch.',
        'thumbnailUrl': 'https://example.com/flutter.png',
        'rating': 4.8,
        'category': 'Programming',
        'studentCount': 1500,
        'lessons': [
          {
            'id': 'lesson1',
            'title': 'Introduction',
            'videoUrl': 'https://example.com/intro.mp4',
            'durationMinutes': 10,
          },
          {
            'id': 'lesson2',
            'title': 'Widgets',
            'videoUrl': 'https://example.com/widgets.mp4',
            'durationMinutes': 25,
          }
        ]
      });

      final course = Course.fromFirestore(doc);

      expect(course.id, 'course123');
      expect(course.title, 'Flutter Mastery');
      expect(course.description, 'Learn Flutter from scratch.');
      expect(course.thumbnailUrl, 'https://example.com/flutter.png');
      expect(course.rating, 4.8);
      expect(course.category, 'Programming');
      expect(course.studentCount, 1500);
      expect(course.lessons.length, 2);

      final lesson1 = course.lessons[0];
      expect(lesson1.id, 'lesson1');
      expect(lesson1.title, 'Introduction');
      expect(lesson1.videoUrl, 'https://example.com/intro.mp4');
      expect(lesson1.duration, const Duration(minutes: 10));

      final lesson2 = course.lessons[1];
      expect(lesson2.id, 'lesson2');
      expect(lesson2.title, 'Widgets');
      expect(lesson2.videoUrl, 'https://example.com/widgets.mp4');
      expect(lesson2.duration, const Duration(minutes: 25));
    });

    test('Course.fromFirestore handles missing/null data with defaults', () {
      final doc = FakeDocumentSnapshot('course456', null);

      final course = Course.fromFirestore(doc);

      expect(course.id, 'course456');
      expect(course.title, '');
      expect(course.description, '');
      expect(course.thumbnailUrl, '');
      expect(course.rating, 0.0);
      expect(course.category, 'General');
      expect(course.studentCount, 0);
      expect(course.lessons, isEmpty);
    });

    test('Course.fromFirestore handles partial missing data with defaults', () {
      final doc = FakeDocumentSnapshot('course789', {
        'title': 'Dart Basics',
        'rating': 4.5,
        // Missing description, thumbnailUrl, category, studentCount, lessons
      });

      final course = Course.fromFirestore(doc);

      expect(course.id, 'course789');
      expect(course.title, 'Dart Basics');
      expect(course.description, '');
      expect(course.thumbnailUrl, '');
      expect(course.rating, 4.5);
      expect(course.category, 'General');
      expect(course.studentCount, 0);
      expect(course.lessons, isEmpty);
    });
  });

  group('Lesson Model Tests', () {
    test('Lesson.fromJson handles valid data correctly', () {
      final json = {
        'id': 'lesson_xyz',
        'title': 'Advanced State Management',
        'videoUrl': 'https://example.com/adv-state.mp4',
        'durationMinutes': 45,
      };

      final lesson = Lesson.fromJson(json);

      expect(lesson.id, 'lesson_xyz');
      expect(lesson.title, 'Advanced State Management');
      expect(lesson.videoUrl, 'https://example.com/adv-state.mp4');
      expect(lesson.duration, const Duration(minutes: 45));
    });

    test('Lesson.fromJson handles missing/null data with defaults', () {
      final json = <String, dynamic>{};

      final lesson = Lesson.fromJson(json);

      expect(lesson.id, '');
      expect(lesson.title, '');
      expect(lesson.videoUrl, '');
      expect(lesson.duration, const Duration(minutes: 0));
    });
  });
}
