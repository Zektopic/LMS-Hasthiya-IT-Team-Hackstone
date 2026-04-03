import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../core/glass_widgets.dart';

class MyLearningView extends StatefulWidget {
  final VoidCallback? onExplore;

  const MyLearningView({super.key, this.onExplore});

  @override
  State<MyLearningView> createState() => _MyLearningViewState();
}

class _MyLearningViewState extends State<MyLearningView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Learning',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track your progress',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 24),
              // Tabs
              GlassCard(
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    _buildTab(0, 'In Progress'),
                    _buildTab(1, 'Completed'),
                    _buildTab(2, 'Saved'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildEmptyState()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isActive = _selectedIndex == index;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: isActive ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (_selectedIndex != index) {
                setState(() => _selectedIndex = index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? Colors.white : AppTheme.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final Map<int, Map<String, dynamic>> tabContent = {
      0: {
        'icon': Icons.school_rounded,
        'title': 'Start Learning',
        'desc': 'Your enrolled courses and progress\nwill appear here.',
        'btnText': 'Browse Courses',
      },
      1: {
        'icon': Icons.emoji_events_rounded,
        'title': 'No Completed Courses',
        'desc': 'You haven\'t completed any courses yet.\nKeep learning!',
        'btnText': 'Continue Learning',
      },
      2: {
        'icon': Icons.bookmark_border_rounded,
        'title': 'No Saved Items',
        'desc': 'Courses and videos you save for later\nwill appear here.',
        'btnText': 'Explore Catalog',
      },
    };

    final content = tabContent[_selectedIndex]!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                content['icon'],
                size: 44,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              content['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content['desc'],
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            GlassButton(
              onPressed: widget.onExplore,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.explore_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    content['btnText'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
