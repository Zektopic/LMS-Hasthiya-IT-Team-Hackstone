import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Course>> getRecommendedCourses() async {
    // This would fetch from Firestore 'courses' collection
    // For now, returning dummy data to allow manual verification
    return [
      Course(
        id: '1',
        title: 'Flutter Advanced',
        description: 'Master advanced Flutter concepts.',
        thumbnailUrl: '',
        rating: 4.9,
        lessons: [],
      ),
      Course(
        id: '2',
        title: 'Firebase Integration',
        description: 'Learn to use Firebase with Flutter.',
        thumbnailUrl: '',
        rating: 4.8,
        lessons: [],
      ),
    ];
  }
}
