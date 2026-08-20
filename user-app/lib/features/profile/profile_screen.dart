import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Profile',
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(AppIcons.settings, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: AppSpacing.xl),
                    _buildStats(user),
                    const SizedBox(height: AppSpacing.xl),
                    _buildBadges(user),
                    const SizedBox(height: AppSpacing.xl),
                    _buildMainCTA(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildMenuSections(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildActions(),
                    const SizedBox(height: AppSpacing.xxxxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? user) {
    return AppGlassCard(
      isDark: false,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 56,
                backgroundColor: AppColors.primaryContainer,
                backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                child: user?.avatarUrl == null
                    ? Icon(AppIcons.user, size: 56, color: AppColors.primary)
                    : null,
              ),
              if (user?.isTrusted == true)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 3),
                    ),
                    child: Icon(AppIcons.star, size: 16, color: AppColors.onPrimary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            user?.name ?? 'User',
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: Text(
              user?.roleDisplay ?? 'Citizen',
              style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (user?.location != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AppIcons.mapPin, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  user!.location!,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (user?.isTrusted == true)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(AppRadius.round),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(AppIcons.shieldCheck, size: 14, color: AppColors.success),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Trusted Reporter • ${user!.trustScore} Trust Score',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.success),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats(User? user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;
        final cards = [
          AppStatCard(
            label: 'Reports Submitted',
            value: '${user?.reportsSubmitted ?? 0}',
            icon: AppIcons.flag,
            iconColor: AppColors.primary,
            backgroundColor: AppColors.primaryContainer,
            onTap: () {},
          ),
          AppStatCard(
            label: 'Issues Resolved',
            value: '${user?.reportsConfirmed ?? 0}',
            icon: AppIcons.checkCircle,
            iconColor: AppColors.success,
            backgroundColor: AppColors.successLight,
            onTap: () {},
          ),
          AppStatCard(
            label: 'Trust Score',
            value: '${user?.trustScore ?? 0}',
            icon: AppIcons.star,
            iconColor: AppColors.warning,
            backgroundColor: AppColors.warningLight,
            onTap: () {},
          ),
        ];

        if (isNarrow) {
          return Column(
            children: cards
                .map((card) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: SizedBox(width: double.infinity, child: card),
                    ))
                .toList(),
          );
        }

        return Row(
          children: cards
              .expand((card) => [
                    Expanded(child: card),
                    const SizedBox(width: AppSpacing.md),
                  ])
              .take(5)
              .toList(),
        );
      },
    );
  }

  Widget _buildBadges(User? user) {
    final badges = _computeBadges(user);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Badges', style: AppTypography.headlineSmall),
            AppTertiaryButton(
              label: 'View All',
              onPressed: () {},
              trailingIcon: AppIcons.caretRight,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => _buildBadgeItem(badges[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(_ProfileBadge badge) {
    final color = badge.unlocked ? AppColors.primary : AppColors.textTertiary;
    final background = badge.unlocked ? AppColors.primaryContainer : AppColors.surfaceContainerLow;

    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: badge.unlocked ? null : Border.all(color: AppColors.outline, width: 1.5),
              boxShadow: badge.unlocked ? AppShadows.primaryGlowSubtle : null,
            ),
            child: Icon(badge.icon, size: 32, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: Text(
              badge.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: badge.unlocked ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_ProfileBadge> _computeBadges(User? user) {
    final submitted = user?.reportsSubmitted ?? 0;
    final confirmed = user?.reportsConfirmed ?? 0;
    final isTrusted = user?.isTrusted ?? false;

    return [
      _ProfileBadge(title: 'First Reporter', icon: AppIcons.flag, unlocked: submitted >= 1),
      _ProfileBadge(title: 'Community Helper', icon: AppIcons.users, unlocked: confirmed >= 5),
      _ProfileBadge(title: 'Active Contributor', icon: AppIcons.fire, unlocked: submitted >= 10),
      _ProfileBadge(title: 'Top Reporter', icon: AppIcons.star, unlocked: submitted >= 25),
      _ProfileBadge(title: 'Road Guardian', icon: AppIcons.shieldCheck, unlocked: isTrusted),
    ];
  }

  Widget _buildMainCTA() {
    return AppGlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      borderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(AppIcons.flag, size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Roads Safer',
                      style: AppTypography.headlineSmall,
                    ),
                    Text(
                      'Report issues. Help your community.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: 'Report an Issue',
            isFullWidth: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSections() {
    final sections = [
      _ProfileSection(
        title: 'Account',
        items: [
          _ProfileMenuItem(
            icon: AppIcons.user,
            title: 'My Profile',
            subtitle: 'Manage your account',
            onTap: () {},
            iconBgColor: AppColors.primaryContainer,
            iconColor: AppColors.primary,
          ),
          _ProfileMenuItem(
            icon: AppIcons.flag,
            title: 'My Reports',
            subtitle: 'View submitted reports',
            onTap: () {},
            iconBgColor: AppColors.infoLight,
            iconColor: AppColors.info,
          ),
          _ProfileMenuItem(
            icon: AppIcons.heart,
            title: 'Favorites',
            subtitle: 'Saved locations & routes',
            onTap: () {},
            iconBgColor: AppColors.successLight,
            iconColor: AppColors.success,
          ),
          _ProfileMenuItem(
            icon: AppIcons.bell,
            title: 'Notifications',
            subtitle: 'Alert preferences',
            onTap: () {},
            iconBgColor: AppColors.warningLight,
            iconColor: AppColors.warning,
          ),
        ],
      ),
      _ProfileSection(
        title: 'Safety',
        items: [
          _ProfileMenuItem(
            icon: AppIcons.shield,
            title: 'Safety Tips',
            subtitle: 'Road safety guidelines',
            onTap: () {},
            iconBgColor: AppColors.errorLight,
            iconColor: AppColors.error,
          ),
        ],
      ),
      _ProfileSection(
        title: 'App',
        items: [
          _ProfileMenuItem(
            icon: AppIcons.info,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
            iconBgColor: AppColors.surfaceContainerLow,
            iconColor: AppColors.textSecondary,
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm, top: AppSpacing.xs),
              child: Text(
                section.title,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          ...section.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildMenuItem(item),
          )),
          const SizedBox(height: AppSpacing.md),
        ],
      )).toList(),
    );
  }

  Widget _buildMenuItem(_ProfileMenuItem item) {
    return AppCard(
      onTap: item.onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      isHoverable: true,
      isPressable: true,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBgColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(item.icon, size: 22, color: item.iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTypography.titleMedium),
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          Icon(AppIcons.caretRight, size: 20, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPrimaryButton(
          label: 'Share App',
          leadingIcon: AppIcons.share,
          isFullWidth: true,
          onPressed: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        AppSecondaryButton(
          label: 'Logout',
          leadingIcon: AppIcons.signOut,
          textColor: AppColors.error,
          isFullWidth: true,
          onPressed: () => _showLogoutDialog(),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Logout', style: AppTypography.headlineSmall),
        content: Text('Are you sure you want to logout?', style: AppTypography.bodyMedium),
        actions: [
          AppTertiaryButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          AppPrimaryButton(
            label: 'Logout',
            isFullWidth: false,
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileBadge {
  final String title;
  final IconData icon;
  final bool unlocked;

  const _ProfileBadge({
    required this.title,
    required this.icon,
    required this.unlocked,
  });
}

class _ProfileSection {
  final String title;
  final List<_ProfileMenuItem> items;

  _ProfileSection({required this.title, required this.items});
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color iconBgColor;
  final Color iconColor;

  _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.iconBgColor,
    required this.iconColor,
  });
}