import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_theme.dart';
import '../../core/glass_widgets.dart';
import '../../models/review.dart';
import '../../services/review_service.dart';
import '../../viewmodels/auth_viewmodel.dart';

enum _SortBy { newest, topRated }

class ReviewsView extends StatefulWidget {
  final String contentId;
  final String contentTitle;
  final String contentCollection;

  const ReviewsView({
    super.key,
    required this.contentId,
    required this.contentTitle,
    this.contentCollection = 'courses',
  });

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  late final ReviewService _reviewService =
      ReviewService(contentCollection: widget.contentCollection);

  Review? _userReview;
  bool _checkingUserReview = true;
  _SortBy _sortBy = _SortBy.newest;
  late Stream<List<Review>> _reviewsStream;

  @override
  void initState() {
    super.initState();
    _reviewsStream = _reviewService.getReviews(widget.contentId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkUserReview());
  }

  @override
  void didUpdateWidget(covariant ReviewsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentId != widget.contentId) {
      _reviewsStream = _reviewService.getReviews(widget.contentId);
    }
  }

  Future<void> _checkUserReview() async {
    if (!mounted) return;
    final auth = context.read<AuthViewModel>();
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      setState(() => _checkingUserReview = false);
      return;
    }
    final review = await _reviewService.getUserReview(widget.contentId, uid);
    if (mounted) {
      setState(() {
        _userReview = review;
        _checkingUserReview = false;
      });
    }
  }

  List<Review> _sorted(List<Review> reviews) {
    final list = List<Review>.from(reviews);
    if (_sortBy == _SortBy.topRated) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  void _showWriteReviewSheet() {
    final auth = context.read<AuthViewModel>();
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _WriteReviewSheet(
        contentId: widget.contentId,
        contentCollection: widget.contentCollection,
        existingReview: _userReview,
        userName: auth.displayName,
        userPhotoUrl: auth.photoUrl,
        userId: uid,
        onSubmitted: (review) => setState(() => _userReview = review),
      ),
    );
  }

  Future<void> _deleteReview() async {
    final uid = context.read<AuthViewModel>().currentUser?.uid;
    if (uid == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Review'),
        content: const Text(
          'Are you sure you want to delete your review?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _reviewService.deleteReview(widget.contentId, uid);
      if (mounted) setState(() => _userReview = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              widget.contentTitle,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          PopupMenuButton<_SortBy>(
            initialValue: _sortBy,
            onSelected: (v) => setState(() => _sortBy = v),
            color: AppTheme.surfaceColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            icon: Icon(
              _sortBy == _SortBy.newest
                  ? Icons.schedule_rounded
                  : Icons.star_rounded,
              color: Colors.white,
            ),
            itemBuilder: (_) => [
              _sortMenuItem(_SortBy.newest, Icons.schedule_rounded,
                  'Newest First'),
              _sortMenuItem(
                  _SortBy.topRated, Icons.star_rounded, 'Top Rated'),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GradientBackground(
        child: StreamBuilder<List<Review>>(
          stream: _reviewsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primaryColor),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorState();
            }

            final reviews = _sorted(snapshot.data ?? []);

            return ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top +
                    kToolbarHeight +
                    16,
                20,
                40,
              ),
              children: [
                _buildRatingSummary(snapshot.data ?? []),
                const SizedBox(height: 20),
                if (!_checkingUserReview) _buildWriteReviewRow(),
                const SizedBox(height: 20),
                if (reviews.isEmpty)
                  _buildEmptyState()
                else ...[
                  Row(
                    children: [
                      Text(
                        '${reviews.length} Review${reviews.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        _sortBy == _SortBy.newest
                            ? 'Newest first'
                            : 'Top rated',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  for (final review in reviews) _buildReviewCard(review),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  PopupMenuItem<_SortBy> _sortMenuItem(
      _SortBy value, IconData icon, String label) {
    final isActive = _sortBy == value;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppTheme.primaryColor : Colors.white,
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ── Rating summary ─────────────────────────────────────────────────────────

  Widget _buildRatingSummary(List<Review> reviews) {
    final avg = reviews.isEmpty
        ? 0.0
        : reviews.fold(0.0, (s, r) => s + r.rating) / reviews.length;

    final counts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final key = r.rating.round().clamp(1, 5);
      counts[key] = (counts[key] ?? 0) + 1;
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              ShaderMask(
                shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                child: Text(
                  avg == 0 ? '—' : avg.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _starsRow(avg, size: 18),
              const SizedBox(height: 4),
              Text(
                '${reviews.length} review${reviews.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = counts[star] ?? 0;
                final frac = reviews.isEmpty ? 0.0 : count / reviews.length;
                return _distributionBar(star, frac, count);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _distributionBar(int star, double fraction, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text('$star',
                style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(
                      height: 6,
                      color: Colors.white.withValues(alpha: 0.08)),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 20,
            child: Text('$count',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  // ── Write review row ───────────────────────────────────────────────────────

  Widget _buildWriteReviewRow() {
    final uid = context.read<AuthViewModel>().currentUser?.uid;
    if (uid == null) return const SizedBox.shrink();

    if (_userReview != null) {
      return GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppTheme.success, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text("You've reviewed this",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
                onPressed: _showWriteReviewSheet, child: const Text('Edit')),
            TextButton(
              onPressed: _deleteReview,
              child:
                  const Text('Delete', style: TextStyle(color: AppTheme.error)),
            ),
          ],
        ),
      );
    }

    return GlassButton(
      onPressed: _showWriteReviewSheet,
      child: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rate_review_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Write a Review',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── States ─────────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.rate_review_outlined,
                  size: 40, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 20),
            const Text('No reviews yet',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share your experience!',
              style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 15, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            if (!_checkingUserReview && _userReview == null)
              GlassButton(
                onPressed: _showWriteReviewSheet,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Write a Review',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded,
                  size: 36, color: AppTheme.error),
            ),
            const SizedBox(height: 20),
            const Text('Could not load reviews',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Check your internet connection and try again.',
              style:
                  TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GlassButton(
              onPressed: () => setState(() {}),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Retry',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Review card ────────────────────────────────────────────────────────────

  Widget _buildReviewCard(Review review) {
    final isOwn =
        review.userId == context.read<AuthViewModel>().currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _avatar(review),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              review.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isOwn) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('You',
                                  style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(_formatDate(review.createdAt),
                          style: const TextStyle(
                              color: AppTheme.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                _starsRow(review.rating, size: 16),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                review.comment,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
              ),
            ],
            if (isOwn) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _showWriteReviewSheet,
                    icon: const Icon(Icons.edit_rounded, size: 14),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      textStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _deleteReview,
                    icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 14),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      textStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _avatar(Review review) {
    // ⚡ Bolt: Optimize initials generation to prevent O(N) string allocations inside ListView.builder
    var initials = '';
    var isNewWord = true;
    for (var i = 0; i < review.userName.length; i++) {
      final char = review.userName[i];
      if (char == ' ') {
        isNewWord = true;
      } else if (isNewWord) {
        initials += char.toUpperCase();
        isNewWord = false;
        if (initials.length >= 2) break;
      }
    }

    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
      child: review.userPhotoUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: review.userPhotoUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Center(
                  child: Text(initials.isEmpty ? 'U' : initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
              ),
            )
          : Center(
              child: Text(initials.isEmpty ? 'U' : initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
    );
  }

  Widget _starsRow(double rating, {required double size}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating.floor()
              ? Icons.star_rounded
              : i < rating
                  ? Icons.star_half_rounded
                  : Icons.star_border_rounded,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final d = DateTime.now().difference(date);
    if (d.inMinutes < 1) return 'just now';
    if (d.inHours < 1) return '${d.inMinutes}m ago';
    if (d.inDays < 1) return '${d.inHours}h ago';
    if (d.inDays < 7) return '${d.inDays}d ago';
    if (d.inDays < 30) return '${(d.inDays / 7).floor()}w ago';
    if (d.inDays < 365) return '${(d.inDays / 30).floor()}mo ago';
    return '${(d.inDays / 365).floor()}y ago';
  }
}

// ── Write / Edit Sheet ────────────────────────────────────────────────────────

class _WriteReviewSheet extends StatefulWidget {
  final String contentId;
  final String contentCollection;
  final Review? existingReview;
  final String userName;
  final String? userPhotoUrl;
  final String userId;
  final ValueChanged<Review> onSubmitted;

  const _WriteReviewSheet({
    required this.contentId,
    required this.contentCollection,
    this.existingReview,
    required this.userName,
    this.userPhotoUrl,
    required this.userId,
    required this.onSubmitted,
  });

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  late final ReviewService _reviewService =
      ReviewService(contentCollection: widget.contentCollection);
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;

  static const _labels = [
    '',
    'Poor',
    'Fair',
    'Good',
    'Great',
    'Excellent'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _selectedRating = widget.existingReview!.rating.round();
      _commentController.text = widget.existingReview!.comment;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedRating == 0) {
      _showError('Please select a star rating.');
      return;
    }
    if (_commentController.text.trim().isEmpty) {
      _showError('Please write a comment.');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final review = Review(
        id: widget.userId,
        userId: widget.userId,
        userName: widget.userName,
        userPhotoUrl: widget.userPhotoUrl,
        rating: _selectedRating.toDouble(),
        comment: _commentController.text.trim(),
        createdAt: widget.existingReview?.createdAt ?? DateTime.now(),
      );
      await _reviewService.addReview(widget.contentId, review);
      if (mounted) {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
        widget.onSubmitted(review);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingReview == null
                ? 'Review submitted!'
                : 'Review updated!'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showError('Failed to submit. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingReview != null;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Your Review' : 'Rate this Content',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your feedback helps others make better decisions.',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    // Star picker
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (i) {
                              final filled = i < _selectedRating;
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _selectedRating = i + 1);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: AnimatedScale(
                                    scale: filled ? 1.2 : 1.0,
                                    duration: const Duration(
                                        milliseconds: 150),
                                    child: Icon(
                                      filled
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: filled
                                          ? Colors.amber
                                          : AppTheme.textMuted,
                                      size: 48,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 10),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              _selectedRating > 0
                                  ? _labels[_selectedRating]
                                  : 'Tap to rate',
                              key: ValueKey(_selectedRating),
                              style: TextStyle(
                                color: _selectedRating > 0
                                    ? Colors.amber
                                    : AppTheme.textMuted,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _commentController,
                      maxLines: 4,
                      maxLength: 500,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Share your experience with this content...',
                        alignLabelWithHint: true,
                        counterStyle: TextStyle(color: AppTheme.textMuted),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Center(
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                              )
                            : Text(
                                isEditing
                                    ? 'Update Review'
                                    : 'Submit Review',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
