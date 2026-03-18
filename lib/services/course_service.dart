import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Course>> getRecommendedCourses() async {
    try {
      final snapshot = await _db.collection('courses').get();
      return snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }
}
