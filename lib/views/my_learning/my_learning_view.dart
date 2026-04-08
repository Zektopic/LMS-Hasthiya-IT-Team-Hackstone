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
  int _selectedTabIndex = 0;

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
                    _buildTab('In Progress', 0),
                    _buildTab('Completed', 1),
                    _buildTab('Saved', 2),
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

  Widget _buildTab(String label, int index) {
    final isActive = _selectedTabIndex == index;

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
              setState(() {
                _selectedTabIndex = index;
              });
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
    IconData icon;
    String title;
    String subtitle;

    switch (_selectedTabIndex) {
      case 1:
        icon = Icons.emoji_events_rounded;
        title = 'No Completed Courses';
        subtitle = 'Keep learning! Your completed\ncourses will appear here.';
        break;
      case 2:
        icon = Icons.bookmark_rounded;
        title = 'No Saved Courses';
        subtitle = 'Save courses you are interested in\nto find them quickly later.';
        break;
      case 0:
      default:
        icon = Icons.school_rounded;
        title = 'Start Learning';
        subtitle = 'Your enrolled courses and progress\nwill appear here.';
        break;
    }

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
                icon,
                size: 44,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.explore_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Browse Courses',
                    style: TextStyle(
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
