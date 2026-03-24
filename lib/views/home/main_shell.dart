import 'package:flutter/material.dart';
import '../../core/glass_widgets.dart';
import 'home_view.dart';
import '../explore/explore_view.dart';
import '../my_learning/my_learning_view.dart';
import '../profile/profile_view.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  // Optimization: Track visited tabs to defer eager initialization of background views
  final Set<int> _initializedTabs = {0};

  void _switchTab(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
        _initializedTabs.add(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Build only visited tabs; render SizedBox.shrink for unvisited tabs
          // to prevent redundant API calls during app startup.
          _initializedTabs.contains(0)
              ? HomeView(onSearchTap: () => _switchTab(1))
              : const SizedBox.shrink(),
          _initializedTabs.contains(1)
              ? const ExploreView()
              : const SizedBox.shrink(),
          _initializedTabs.contains(2)
              ? MyLearningView(onExplore: () => _switchTab(1))
              : const SizedBox.shrink(),
          _initializedTabs.contains(3)
              ? const ProfileView()
              : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: GlassNavBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
      ),
    );
  }
}
