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

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: RoadSafeColors.background,
      appBar: RoadSafeAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(RoadSafeIcons.settings, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: RoadSafeSpacing.screenPadding),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildStats(user),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildBadges(user),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildMainCTA(),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildMenuSections(),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildActions(),
            const SizedBox(height: RoadSafeSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? user) {
    return RoadSafeCard(
      padding: const EdgeInsets.all(RoadSafeSpacing.xl),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: RoadSafeColors.primaryContainer,
                backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                child: user?.avatarUrl == null
                    ? Icon(RoadSafeIcons.user, size: 50, color: RoadSafeColors.primary)
                    : null,
              ),
              if (user?.isTrusted == true)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: RoadSafeColors.warning,
                      shape: BoxShape.circle,
                      border: Border.all(color: RoadSafeColors.surface, width: 3),
                    ),
                    child: Icon(RoadSafeIcons.star, size: 14, color: RoadSafeColors.textOnPrimary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: RoadSafeSpacing.lg),
          Text(
            user?.name ?? 'User',
            style: RoadSafeTypography.headlineMedium,
          ),
          const SizedBox(height: RoadSafeSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.md,
              vertical: RoadSafeSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: RoadSafeColors.primaryContainer,
              borderRadius: BorderRadius.circular(RoadSafeRadius.round),
            ),
            child: Text(
              user?.roleDisplay ?? 'Citizen',
              style: RoadSafeTypography.labelSmall.copyWith(color: RoadSafeColors.primary),
            ),
          ),
          const SizedBox(height: RoadSafeSpacing.md),
          if (user?.location != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(RoadSafeIcons.mapPin, size: 16, color: RoadSafeColors.textTertiary),
                const SizedBox(width: RoadSafeSpacing.xs),
                Text(
                  user!.location!,
                  style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: RoadSafeSpacing.md),
          ],
          if (user?.isTrusted == true)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: RoadSafeSpacing.md,
                vertical: RoadSafeSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: RoadSafeColors.successLight,
                borderRadius: BorderRadius.circular(RoadSafeRadius.round),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(RoadSafeIcons.shieldCheck, size: 14, color: RoadSafeColors.success),
                  const SizedBox(width: RoadSafeSpacing.xs),
                  Text(
                    'Trusted Reporter • ${user!.trustScore} Trust Score',
                    style: RoadSafeTypography.labelMedium.copyWith(color: RoadSafeColors.success),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats(User? user) {
    return Row(
      children: [
        Expanded(
          child: RoadSafeCard(
            padding: const EdgeInsets.all(RoadSafeSpacing.lg),
            child: Column(
              children: [
                Icon(RoadSafeIcons.flag, size: 32, color: RoadSafeColors.primary),
                const SizedBox(height: RoadSafeSpacing.sm),
                Text(
                  '${user?.reportsSubmitted ?? 0}',
                  style: RoadSafeTypography.headlineMedium.copyWith(color: RoadSafeColors.primary),
                ),
                Text(
                  'Reports Submitted',
                  style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: RoadSafeSpacing.md),
        Expanded(
          child: RoadSafeCard(
            padding: const EdgeInsets.all(RoadSafeSpacing.lg),
            child: Column(
              children: [
                Icon(RoadSafeIcons.checkCircle, size: 32, color: RoadSafeColors.success),
                const SizedBox(height: RoadSafeSpacing.sm),
                Text(
                  '${user?.reportsConfirmed ?? 0}',
                  style: RoadSafeTypography.headlineMedium.copyWith(color: RoadSafeColors.success),
                ),
                Text(
                  'Issues Resolved',
                  style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
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
            Text('My Badges', style: RoadSafeTypography.headlineSmall),
            RoadSafeTextButton(
              label: 'View All',
              onPressed: () {},
              trailingIcon: RoadSafeIcons.caretRight,
            ),
          ],
        ),
        const SizedBox(height: RoadSafeSpacing.md),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            separatorBuilder: (_, __) => const SizedBox(width: RoadSafeSpacing.lg),
            itemBuilder: (context, index) => _buildBadgeItem(badges[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeItem(_ProfileBadge badge) {
    final color = badge.unlocked ? RoadSafeColors.primary : RoadSafeColors.textTertiary;
    final background = badge.unlocked ? RoadSafeColors.primaryContainer : RoadSafeColors.backgroundAlt;

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: badge.unlocked ? null : Border.all(color: RoadSafeColors.border),
            ),
            child: Icon(badge.icon, size: 26, color: color),
          ),
          const SizedBox(height: RoadSafeSpacing.xs),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: RoadSafeTypography.labelSmall.copyWith(
              color: badge.unlocked ? RoadSafeColors.textPrimary : RoadSafeColors.textTertiary,
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
      _ProfileBadge(title: 'First Reporter', icon: RoadSafeIcons.flag, unlocked: submitted >= 1),
      _ProfileBadge(title: 'Community Helper', icon: RoadSafeIcons.users, unlocked: confirmed >= 5),
      _ProfileBadge(title: 'Active Contributor', icon: RoadSafeIcons.fire, unlocked: submitted >= 10),
      _ProfileBadge(title: 'Top Reporter', icon: RoadSafeIcons.star, unlocked: submitted >= 25),
      _ProfileBadge(title: 'Road Guardian', icon: RoadSafeIcons.shieldCheck, unlocked: isTrusted),
    ];
  }

  Widget _buildMainCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(RoadSafeSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [RoadSafeColors.primary, RoadSafeColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
        boxShadow: RoadSafeShadows.cardElevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(RoadSafeSpacing.md),
                decoration: BoxDecoration(
                  color: RoadSafeColors.textOnPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
                ),
                child: Icon(RoadSafeIcons.flag, size: 28, color: RoadSafeColors.textOnPrimary),
              ),
              const SizedBox(width: RoadSafeSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Roads Safer',
                      style: RoadSafeTypography.headlineSmall.copyWith(color: RoadSafeColors.textOnPrimary),
                    ),
                    Text(
                      'Report issues. Help your community.',
                      style: RoadSafeTypography.bodyMedium.copyWith(
                        color: RoadSafeColors.textOnPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RoadSafeSpacing.lg),
          RoadSafeSecondaryButton(
            label: 'Report an Issue',
            isFullWidth: true,
            borderColor: RoadSafeColors.textOnPrimary,
            textColor: RoadSafeColors.textOnPrimary,
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
            icon: RoadSafeIcons.user,
            title: 'My Profile',
            subtitle: 'Manage your account',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: RoadSafeIcons.flag,
            title: 'My Reports',
            subtitle: 'View submitted reports',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: RoadSafeIcons.heart,
            title: 'Favorites',
            subtitle: 'Saved locations & routes',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: RoadSafeIcons.bell,
            title: 'Notifications',
            subtitle: 'Alert preferences',
            onTap: () {},
          ),
        ],
      ),
      _ProfileSection(
        title: 'Safety',
        items: [
          _ProfileMenuItem(
            icon: RoadSafeIcons.shield,
            title: 'Safety Tips',
            subtitle: 'Road safety guidelines',
            onTap: () {},
          ),
        ],
      ),
      _ProfileSection(
        title: 'App',
        items: [
          _ProfileMenuItem(
            icon: RoadSafeIcons.info,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    ];

    return Column(
      children: sections.map((section) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: RoadSafeSpacing.sm, bottom: RoadSafeSpacing.sm),
              child: Text(
                section.title,
                style: RoadSafeTypography.labelSmall.copyWith(
                  color: RoadSafeColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          ...section.items.map((item) => _buildMenuItem(item)),
        ],
      )).toList(),
    );
  }

  Widget _buildMenuItem(_ProfileMenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RoadSafeSpacing.sm),
      child: RoadSafeCard(
        padding: const EdgeInsets.all(RoadSafeSpacing.md),
        onTap: item.onTap,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: RoadSafeColors.primaryContainer,
                borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              ),
              child: Icon(item.icon, size: 22, color: RoadSafeColors.primary),
            ),
            const SizedBox(width: RoadSafeSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: RoadSafeTypography.titleMedium),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                    ),
                ],
              ),
            ),
            Icon(RoadSafeIcons.caretRight, size: 20, color: RoadSafeColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        RoadSafeSecondaryButton(
          label: 'Share App',
          leadingIcon: RoadSafeIcons.share,
          isFullWidth: true,
          onPressed: () {},
        ),
        const SizedBox(height: RoadSafeSpacing.md),
        RoadSafeTextButton(
          label: 'Logout',
          leadingIcon: RoadSafeIcons.signOut,
          textColor: RoadSafeColors.error,
          onPressed: () => _showLogoutDialog(),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RoadSafeRadius.xl)),
        title: Text('Logout', style: RoadSafeTypography.headlineSmall),
        content: Text('Are you sure you want to logout?', style: RoadSafeTypography.bodyMedium),
        actions: [
          RoadSafeTextButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          RoadSafePrimaryButton(
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

  _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}