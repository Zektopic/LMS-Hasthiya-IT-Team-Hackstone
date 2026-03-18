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

  void _switchTab(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeView(onSearchTap: () => _switchTab(1)),
          const ExploreView(),
          MyLearningView(onExplore: () => _switchTab(1)),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: GlassNavBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
      ),
    );
  }
}
