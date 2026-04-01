import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/models/course.dart';
import 'package:hackston_lms/services/course_service.dart';

// Manual Fakes
class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {
  final Map<String, FakeCollectionReference> collections = {};

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    if (!collections.containsKey(collectionPath)) {
      collections[collectionPath] = FakeCollectionReference();
    }
    return collections[collectionPath]!
        as CollectionReference<Map<String, dynamic>>;
  }
}

class FakeCollectionReference extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  List<FakeDocumentSnapshot> documents = [];
  bool shouldThrowError = false;

  @override
  Query<Map<String, dynamic>> limit(int limit) {
    return FakeQuery(
      documents: documents,
      shouldThrowError: shouldThrowError,
      appliedLimit: limit,
    );
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    if (shouldThrowError) {
      throw Exception('Simulated network error');
    }
    return FakeQuerySnapshot(documents: documents);
  }
}

class FakeQuery extends Fake implements Query<Map<String, dynamic>> {
  final List<FakeDocumentSnapshot> documents;
  final bool shouldThrowError;
  final int appliedLimit;

  FakeQuery({
    required this.documents,
    required this.shouldThrowError,
    required this.appliedLimit,
  });

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    if (shouldThrowError) {
      throw Exception('Simulated network error');
    }
    return FakeQuerySnapshot(documents: documents.take(appliedLimit).toList());
  }
}

class FakeQuerySnapshot extends Fake
    implements QuerySnapshot<Map<String, dynamic>> {
  final List<FakeDocumentSnapshot> documents;

  FakeQuerySnapshot({required this.documents});

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => documents;
}

class FakeDocumentSnapshot extends Fake
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic> data() => _data ?? {};
}

void main() {
  group('CourseService Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late CourseService courseService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      courseService = CourseService(db: fakeFirestore);
    });

    test('getRecommendedCourses successfully fetches courses without limit', () async {
      final collection =
          fakeFirestore.collection('courses') as FakeCollectionReference;
      collection.documents = [
        FakeDocumentSnapshot('course1', {
          'title': 'Test Course 1',
          'description': 'Description 1',
          'thumbnailUrl': 'thumb1',
          'rating': 4.5,
          'category': 'Programming',
          'studentCount': 100,
          'lessons': [],
        }),
        FakeDocumentSnapshot('course2', {
          'title': 'Test Course 2',
          'description': 'Description 2',
          'thumbnailUrl': 'thumb2',
          'rating': 4.8,
          'category': 'Design',
          'studentCount': 200,
          'lessons': [],
        }),
      ];

      final courses = await courseService.getRecommendedCourses();

      expect(courses.length, 2);
      expect(courses[0].id, 'course1');
      expect(courses[0].title, 'Test Course 1');
      expect(courses[0].category, 'Programming');

      expect(courses[1].id, 'course2');
      expect(courses[1].title, 'Test Course 2');
      expect(courses[1].category, 'Design');
    });

    test('getRecommendedCourses successfully fetches courses with limit', () async {
      final collection =
          fakeFirestore.collection('courses') as FakeCollectionReference;
      collection.documents = [
        FakeDocumentSnapshot('course1', {
          'title': 'Test Course 1',
        }),
        FakeDocumentSnapshot('course2', {
          'title': 'Test Course 2',
        }),
        FakeDocumentSnapshot('course3', {
          'title': 'Test Course 3',
        }),
      ];

      final courses = await courseService.getRecommendedCourses(limit: 2);

      expect(courses.length, 2);
      expect(courses[0].id, 'course1');
      expect(courses[1].id, 'course2');
    });

    test('getRecommendedCourses handles errors and returns an empty list', () async {
      final collection =
          fakeFirestore.collection('courses') as FakeCollectionReference;
      collection.shouldThrowError = true;

      final courses = await courseService.getRecommendedCourses();

      expect(courses, isEmpty);
    });
  });
}
