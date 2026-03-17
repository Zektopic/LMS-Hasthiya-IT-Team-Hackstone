import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../core/app_theme.dart';

class CourseDetailView extends StatelessWidget {
  final Course course;

  const CourseDetailView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(course.title),
              background: Container(
                color: AppTheme.primaryColor.withOpacity(0.2),
                child: const Icon(Icons.play_circle_fill,
                    size: 80, color: Colors.white24),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Bestseller',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Semantics(
                        label: 'Rating: ${course.rating} stars',
                        excludeSemantics: true,
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(course.rating.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Description',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(course.description,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, height: 1.5)),
                  const SizedBox(height: 32),
                  const Text('Course Content',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Dummy lesson list
                  _buildLessonItem('Welcome to the course', '05:00'),
                  _buildLessonItem('Getting started with Flutter', '15:20'),
                  _buildLessonItem('Advanced State Management', '25:45'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          children: [
            Semantics(
              label: 'Total Price: \$49.99',
              excludeSemantics: true,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Price',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                  Text('\$49.99',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Successfully enrolled in the course!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
                child: const Text('Enroll Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(String title, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.play_circle_outline,
                    color: AppTheme.primaryColor),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w500))),
                Text(duration,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
