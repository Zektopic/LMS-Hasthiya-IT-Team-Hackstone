import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/course.dart';

class CourseService {
  static const int defaultQueryLimit = 50;
  final FirebaseFirestore _db;

  CourseService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // Optimization: Bound queries with default limit to prevent unbounded reads
  Future<List<Course>> getRecommendedCourses({int? limit}) async {
    try {
      final Query<Map<String, dynamic>> query = _db
          .collection('courses')
          .limit(limit ?? defaultQueryLimit);
      final snapshot = await query.get();
      // ⚡ Bolt: Use collection for loop to directly construct list avoiding intermediate Iterable allocation
      return [
        for (final doc in snapshot.docs) Course.fromFirestore(doc),
      ];
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      return [];
    }
  }
}
