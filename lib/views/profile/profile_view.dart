import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/app_theme.dart';
import '../../core/glass_widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return GradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildAvatar(auth),
              const SizedBox(height: 16),
              Text(
                auth.displayName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                auth.email,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),
              _buildStatsRow(),
              const SizedBox(height: 28),
              _buildSection('Account', [
                _SettingItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.download_rounded,
                  label: 'Downloads',
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 20),
              _buildSection('Preferences', [
                _SettingItem(
                  icon: Icons.dark_mode_rounded,
                  label: 'Appearance',
                  trailing: const Text(
                    'Dark',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  trailing: const Text(
                    'English',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 20),
              _buildSection('Support', [
                _SettingItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help Center',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About',
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context, auth),
                  icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(color: AppTheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: AppTheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hackston LMS v1.0.0',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AuthViewModel auth) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: auth.photoUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: auth.photoUrl!,
                fit: BoxFit.cover,
                width: 88,
                height: 88,
                errorWidget: (_, __, ___) => Center(
                  child: Text(
                    auth.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                auth.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
    );
  }

  Widget _buildStatsRow() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('0', 'Courses'),
          Container(
            width: 1,
            height: 36,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          _buildStatItem('0h', 'Learning'),
          Container(
            width: 1,
            height: 36,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          _buildStatItem('0', 'Certificates'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<_SettingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        GlassCard(
          borderRadius: 16,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: index == 0 && items.length == 1
                          ? BorderRadius.circular(16)
                          : index == 0
                          ? const BorderRadius.vertical(
                              top: Radius.circular(16),
                            )
                          : index == items.length - 1
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            )
                          : BorderRadius.zero,
                      onTap: item.onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: AppTheme.textSecondary,
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                item.label,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            if (item.trailing != null) item.trailing!,
                            if (item.trailing == null)
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppTheme.textMuted,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 54,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthViewModel auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });
}
