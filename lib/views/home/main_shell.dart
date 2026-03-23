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
  // Optimization: Track visited tabs to lazy-load them
  final Set<int> _visitedTabs = {0};

  void _switchTab(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
        _visitedTabs.add(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Optimization: Only initialize views once they are visited to prevent
          // redundant API calls and rendering on app launch
          HomeView(onSearchTap: () => _switchTab(1)),
          _visitedTabs.contains(1)
              ? const ExploreView()
              : const SizedBox.shrink(),
          _visitedTabs.contains(2)
              ? MyLearningView(onExplore: () => _switchTab(1))
              : const SizedBox.shrink(),
          _visitedTabs.contains(3)
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
