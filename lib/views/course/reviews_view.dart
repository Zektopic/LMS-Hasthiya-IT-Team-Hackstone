import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_theme.dart';
import '../../core/glass_widgets.dart';
import '../../models/review.dart';
import '../../services/review_service.dart';
import '../../viewmodels/auth_viewmodel.dart';

class ReviewsView extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const ReviewsView({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  final ReviewService _reviewService = ReviewService();
  Review? _userReview;
  bool _checkingUserReview = true;

  @override
  void initState() {
    super.initState();
    _checkUserReview();
  }

  Future<void> _checkUserReview() async {
    final auth = context.read<AuthViewModel>();
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      setState(() => _checkingUserReview = false);
      return;
    }
    final review = await _reviewService.getUserReview(widget.courseId, uid);
    if (mounted) {
      setState(() {
        _userReview = review;
        _checkingUserReview = false;
      });
    }
  }

  void _showWriteReviewSheet() {
    final auth = context.read<AuthViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WriteReviewSheet(
        courseId: widget.courseId,
        existingReview: _userReview,
        userName: auth.displayName,
        userPhotoUrl: auth.photoUrl,
        userId: auth.currentUser!.uid,
        onSubmitted: (review) {
          setState(() => _userReview = review);
        },
      ),
    );
  }

  Future<void> _deleteReview() async {
    final auth = context.read<AuthViewModel>();
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _reviewService.deleteReview(widget.courseId, uid);
      if (mounted) setState(() => _userReview = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    GlassCard(
                      borderRadius: 12,
                      padding: EdgeInsets.zero,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Reviews',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Review>>(
                  stream: _reviewService.getReviews(widget.courseId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.primaryColor),
                      );
                    }

                    final reviews = snapshot.data ?? [];
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      children: [
                        _buildRatingSummary(reviews),
                        const SizedBox(height: 20),
                        if (!_checkingUserReview)
                          _buildWriteReviewButton(reviews),
                        const SizedBox(height: 20),
                        if (reviews.isEmpty)
                          _buildEmptyState()
                        else ...[
                          Text(
                            '${reviews.length} Review${reviews.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...reviews.map((r) => _buildReviewCard(r)),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary(List<Review> reviews) {
    final avg = reviews.isEmpty
        ? 0.0
        : reviews.fold(0.0, (sum, r) => sum + r.rating) / reviews.length;

    Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final key = r.rating.round().clamp(1, 5);
      counts[key] = (counts[key] ?? 0) + 1;
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Big average number
          Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
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
              _buildStarsRow(avg, size: 18),
              const SizedBox(height: 4),
              Text(
                '${reviews.length} review${reviews.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Distribution bars
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = counts[star] ?? 0;
                final fraction =
                    reviews.isEmpty ? 0.0 : count / reviews.length;
                return _buildDistributionBar(star, fraction, count);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionBar(int star, double fraction, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$star',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
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
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
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
            child: Text(
              '$count',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteReviewButton(List<Review> allReviews) {
    final auth = context.read<AuthViewModel>();
    final uid = auth.currentUser?.uid;
    if (uid == null) return const SizedBox.shrink();

    if (_userReview != null) {
      return GlassCard(
        padding: const EdgeInsets.all(16),
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
              child: Text(
                'You\'ve reviewed this course',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: _showWriteReviewSheet,
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: _deleteReview,
              child: const Text('Delete',
                  style: TextStyle(color: AppTheme.error)),
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
            Text(
              'Write a Review',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 56,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'No reviews yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share your experience!',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    final isOwnReview =
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
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: review.userPhotoUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: review.userPhotoUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                _buildInitialsAvatar(review.userName),
                          ),
                        )
                      : _buildInitialsAvatar(review.userName),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (isOwnReview) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'You',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _formatDate(review.createdAt),
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStarsRow(review.rating, size: 16),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                review.comment,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String name) {
    final initials = name
        .split(' ')
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((s) => s[0])
        .join()
        .toUpperCase();
    return Center(
      child: Text(
        initials.isEmpty ? 'U' : initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildStarsRow(double rating, {required double size}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final half = !filled && index < rating;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_border_rounded,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}

// ─── Write Review Bottom Sheet ───────────────────────────────────────────────

class _WriteReviewSheet extends StatefulWidget {
  final String courseId;
  final Review? existingReview;
  final String userName;
  final String? userPhotoUrl;
  final String userId;
  final ValueChanged<Review> onSubmitted;

  const _WriteReviewSheet({
    required this.courseId,
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
  final ReviewService _reviewService = ReviewService();
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;

  static const _ratingLabels = ['', 'Poor', 'Fair', 'Good', 'Great', 'Excellent'];

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
        createdAt: DateTime.now(),
      );

      await _reviewService.addReview(widget.courseId, review);

      if (mounted) {
        Navigator.pop(context);
        widget.onSubmitted(review);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingReview == null
                ? 'Review submitted!'
                : 'Review updated!'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showError('Failed to submit review. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingReview != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
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
                      isEditing ? 'Edit Your Review' : 'Rate this Course',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your feedback helps others make better decisions.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Star picker
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final filled = index < _selectedRating;
                              return GestureDetector(
                                onTap: () => setState(
                                    () => _selectedRating = index + 1),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  child: AnimatedScale(
                                    scale: filled ? 1.15 : 1.0,
                                    duration: const Duration(milliseconds: 150),
                                    child: Icon(
                                      filled
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: filled
                                          ? Colors.amber
                                          : AppTheme.textMuted,
                                      size: 44,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              _selectedRating > 0
                                  ? _ratingLabels[_selectedRating]
                                  : 'Tap to rate',
                              key: ValueKey(_selectedRating),
                              style: TextStyle(
                                color: _selectedRating > 0
                                    ? Colors.amber
                                    : AppTheme.textMuted,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Comment field
                    TextField(
                      controller: _commentController,
                      maxLines: 4,
                      maxLength: 500,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Share your experience with this course...',
                        alignLabelWithHint: true,
                        counterStyle: TextStyle(color: AppTheme.textMuted),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    GlassButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Center(
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditing
                                    ? 'Update Review'
                                    : 'Submit Review',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
