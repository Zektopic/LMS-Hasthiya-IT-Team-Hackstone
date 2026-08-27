import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Optimization: Added optional limit parameter to prevent unbounded reads
  Future<List<Course>> getRecommendedCourses({int? limit}) async {
    try {
      Query<Map<String, dynamic>> query = _db.collection('courses');
      if (limit != null) {
        query = query.limit(limit);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }
}
