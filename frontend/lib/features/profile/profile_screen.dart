import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
            icon: Icon(PhosphorIconsRegular.gear, size: 24),
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
                    ? Icon(PhosphorIconsRegular.user, size: 50, color: RoadSafeColors.primary)
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
                    child: Icon(PhosphorIconsRegular.star, size: 14, color: RoadSafeColors.textOnPrimary),
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
                Icon(PhosphorIconsRegular.mapPin, size: 16, color: RoadSafeColors.textTertiary),
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
                  Icon(PhosphorIconsRegular.shieldCheck, size: 14, color: RoadSafeColors.success),
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
                Icon(PhosphorIconsRegular.flag, size: 32, color: RoadSafeColors.primary),
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
                Icon(PhosphorIconsRegular.checkCircle, size: 32, color: RoadSafeColors.success),
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
                child: Icon(PhosphorIconsRegular.flag, size: 28, color: RoadSafeColors.textOnPrimary),
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
            icon: PhosphorIconsRegular.user,
            title: 'My Profile',
            subtitle: 'Manage your account',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: PhosphorIconsRegular.flag,
            title: 'My Reports',
            subtitle: 'View submitted reports',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: PhosphorIconsRegular.heart,
            title: 'Favorites',
            subtitle: 'Saved locations & routes',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: PhosphorIconsRegular.bell,
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
            icon: PhosphorIconsRegular.shield,
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
            icon: PhosphorIconsRegular.info,
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
    return RoadSafeCard(
      margin: const EdgeInsets.only(bottom: RoadSafeSpacing.sm),
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
          Icon(PhosphorIconsRegular.caretRight, size: 20, color: RoadSafeColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        RoadSafeSecondaryButton(
          label: 'Share App',
          leadingIcon: PhosphorIconsRegular.share,
          isFullWidth: true,
          onPressed: () {},
        ),
        const SizedBox(height: RoadSafeSpacing.md),
        RoadSafeTextButton(
          label: 'Logout',
          leadingIcon: PhosphorIconsRegular.signOut,
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

class _ProfileSection {
  final String title;
  final List<_ProfileMenuItem> items;

  _ProfileSection({required this.title, required this.items});
}

class _ProfileMenuItem {
  final PhosphorIconsRegular icon;
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