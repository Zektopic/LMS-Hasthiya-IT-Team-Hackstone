import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/course.dart';

class CourseService {
  final FirebaseFirestore _db;

  CourseService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // Optimization: Added optional limit parameter to prevent unbounded reads
  Future<List<Course>> getRecommendedCourses({int? limit}) async {
    try {
      Query<Map<String, dynamic>> query = _db.collection('courses');
      // ⚡ Bolt: Enforce a default limit (e.g. 10) on unbounded collection queries to prevent fetching massive datasets unintentionally.
      query = query.limit(limit ?? 10);
      final snapshot = await query.get();
      // ⚡ Bolt: Use collection for loop to directly construct list
      // avoiding intermediate Iterable allocation from .map().toList()
      return [
        for (final doc in snapshot.docs) Course.fromFirestore(doc),
      ];
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      return [];
    }
  }
}
