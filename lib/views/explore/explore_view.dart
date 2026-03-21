import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_theme.dart';
import '../../core/glass_widgets.dart';
import '../../models/video.dart';
import '../../models/course.dart';
import '../../services/video_service.dart';
import '../../services/course_service.dart';
import '../video/video_player_view.dart';
import '../course/course_detail_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final VideoService _videoService = VideoService();
  final CourseService _courseService = CourseService();
  final TextEditingController _searchController = TextEditingController();

  List<Video> _allVideos = [];
  List<Course> _allCourses = [];
  List<Video> _filteredVideos = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  Timer? _debounce;

  static const List<String> _categories = [
    'All',
    'Development',
    'Design',
    'Business',
    'Science',
    'Marketing',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Optimization: Debounce search input to prevent expensive filtering and full widget tree rebuilds on every keystroke
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterContent();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final results = await Future.wait([
      _videoService.getVideos(),
      _courseService.getRecommendedCourses(),
    ]);

    if (!mounted) return;
    setState(() {
      _allVideos = results[0] as List<Video>;
      _allCourses = results[1] as List<Course>;
      _filterContent();
      _isLoading = false;
    });
  }

  void _filterContent() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredVideos = _allVideos.where((v) {
        final matchesSearch = query.isEmpty ||
            v.title.toLowerCase().contains(query) ||
            v.description.toLowerCase().contains(query);
        return matchesSearch;
      }).toList();

      _filteredCourses = _allCourses.where((c) {
        final matchesSearch = query.isEmpty ||
            c.title.toLowerCase().contains(query) ||
            c.description.toLowerCase().contains(query);
        final matchesCategory =
            _selectedCategory == 'All' || c.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Discover new skills and knowledge',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlassCard(
                    borderRadius: 16,
                    padding: EdgeInsets.zero,
                    // Optimization: Use ValueListenableBuilder to localize TextField rebuilds (e.g., toggling the clear icon) instead of rebuilding the entire view
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, child) {
                        return TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search courses and videos...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: value.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterContent();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategory = category);
                              _filterContent();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppTheme.primaryGradient
                                    : null,
                                color: isSelected
                                    ? null
                                    : Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.1)),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryColor))
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      color: AppTheme.primaryColor,
                      backgroundColor: AppTheme.surfaceColor,
                      child: _buildContent(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final hasContent =
        _filteredVideos.isNotEmpty || _filteredCourses.isNotEmpty;

    if (!hasContent) return _buildEmptyState();

    return CustomScrollView(
      slivers: [
        if (_filteredCourses.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12, left: 20, right: 20),
              child: Text(
                'Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _filteredCourses.length,
            itemBuilder: (context, index) {
              final course = _filteredCourses[index];
              final colors = AppTheme
                  .cardGradients[index % AppTheme.cardGradients.length];
              return _buildCourseCard(course, colors);
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
        if (_filteredVideos.isNotEmpty) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12, left: 20, right: 20),
              child: Text(
                'Videos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _filteredVideos.length,
            itemBuilder: (context, index) {
              final video = _filteredVideos[index];
              final colors = AppTheme
                  .cardGradients[index % AppTheme.cardGradients.length];
              return _buildVideoCard(video, colors);
            },
          ),
        ],
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }

  Widget _buildCourseCard(Course course, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
      child: GlassCard(
        borderRadius: 16,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CourseDetailView(course: course)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: course.thumbnailUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              imageUrl: course.thumbnailUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                  size: 28),
                            ),
                          )
                        : const Icon(Icons.auto_stories_rounded,
                            color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              course.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 13),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.play_lesson_rounded,
                                color: AppTheme.textMuted, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${course.lessons.length} lessons',
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppTheme.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(Video video, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
      child: GlassCard(
        borderRadius: 16,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VideoPlayerView(video: video)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          video.description,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppTheme.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _searchController.text.isNotEmpty
                    ? Icons.search_off_rounded
                    : Icons.explore_rounded,
                size: 64,
                color: AppTheme.textMuted,
              ),
              const SizedBox(height: 16),
              Text(
                _searchController.text.isNotEmpty
                    ? 'No results found'
                    : 'Nothing here yet',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _searchController.text.isNotEmpty
                    ? 'Try adjusting your search or filters.'
                    : 'New content will appear here once it\'s added.',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
