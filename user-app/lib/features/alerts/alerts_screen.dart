import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/alert.dart';
import '../../shared/providers/alert_provider.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> with SingleTickerProviderStateMixin {
  static const _categories = <AlertCategory>[
    AlertCategory.all,
    AlertCategory.road,
    AlertCategory.weather,
    AlertCategory.disaster,
    AlertCategory.visibility,
    AlertCategory.emergency,
  ];

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertProvider>().fetchAlerts();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlertProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Safety Alerts',
        leading: IconButton(
          icon: Icon(AppIcons.menu, size: 24),
          onPressed: () {},
          padding: const EdgeInsets.only(left: AppSpacing.screenPadding),
        ),
        actions: [
          IconButton(
            icon: Icon(AppIcons.bell, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildFilterChips(provider),
            Expanded(child: _buildBody(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AlertProvider provider) {
    if (provider.isLoading && provider.alerts.isEmpty) {
      return const Center(child: AppCircularProgress());
    }

    if (provider.error != null && provider.alerts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.warningCircle, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSecondaryButton(
                label: 'Retry',
                leadingIcon: AppIcons.refresh,
                isFullWidth: false,
                onPressed: () => provider.fetchAlerts(),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.alerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.folderOpen, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.lg),
            Text('No alerts in this category', style: AppTypography.headlineSmall),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        if (provider.emergencyAlerts.isNotEmpty) ...[
          _buildEmergencyAlerts(provider),
          const SizedBox(height: AppSpacing.xl),
        ],
        if (provider.affectedRoads.isNotEmpty) ...[
          _buildAffectedRoads(provider),
          const SizedBox(height: AppSpacing.xl),
        ],
        if (provider.otherAlerts.isNotEmpty) ...[
          _buildOtherAlerts(provider),
          const SizedBox(height: AppSpacing.xl),
        ],
        _buildInfoSection(),
      ],
    );
  }

  Widget _buildFilterChips(AlertProvider provider) {
    return Container(
      color: AppColors.surface,
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = provider.selectedCategory == category;
          return AnimatedContainer(
            duration: AppMotion.fadeIn,
            child: ChoiceChip(
              label: Text(category.categoryDisplay, style: AppTypography.labelMedium),
              selected: isSelected,
              onSelected: (_) => provider.selectCategory(category),
              selectedColor: AppColors.primaryContainer,
              backgroundColor: AppColors.surfaceContainerLow,
              labelStyle: AppTypography.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyAlerts(AlertProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(AppIcons.warningOctagon, size: 20, color: AppColors.error),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('Emergency Alerts', style: AppTypography.headlineSmall),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ...provider.emergencyAlerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: AppSafetyAlertCard(
                title: alert.title,
                description: alert.description,
                location: alert.location,
                distance: _formatDistance(alert.distanceKm),
                severity: alert.severityDisplay,
                imageUrl: alert.imageUrl,
                icon: _getCategoryIcon(alert.category),
                isEmergency: true,
              ),
            )),
      ],
    );
  }

  Widget _buildAffectedRoads(AlertProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(AppIcons.roadHorizon, size: 20, color: AppColors.error),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('Affected Roads', style: AppTypography.headlineSmall),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: provider.affectedRoads.map((road) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  road,
                  style: AppTypography.labelMedium.copyWith(color: AppColors.error),
                ),
              )).toList(),
        ),
      ],
    );
  }

  Widget _buildOtherAlerts(AlertProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Other Active Alerts', style: AppTypography.headlineSmall),
        const SizedBox(height: AppSpacing.lg),
        ...provider.otherAlerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AppSafetyAlertCard(
                title: alert.title,
                description: alert.description,
                location: alert.location,
                distance: _formatDistance(alert.distanceKm),
                severity: alert.severityDisplay,
                imageUrl: alert.imageUrl,
                icon: _getCategoryIcon(alert.category),
                isEmergency: false,
              ),
            )),
      ],
    );
  }

  Widget _buildInfoSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(AppIcons.info, size: 20, color: AppColors.info),
              ),
              const SizedBox(width: AppSpacing.md),
              Text('Alert Sources', style: AppTypography.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Safety alerts are generated from multiple sources including official government agencies, weather departments, satellite data, and AI-based prediction models. Always verify critical alerts with local authorities.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildSourceChip('IMD', AppIcons.cloud),
              _buildSourceChip('Traffic Police', AppIcons.shield),
              _buildSourceChip('Weather Dept', AppIcons.sun),
              _buildSourceChip('Satellite', AppIcons.satellite),
              _buildSourceChip('AI Models', AppIcons.cpu),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m away';
    return '${km.toStringAsFixed(1)} km away';
  }

  IconData _getCategoryIcon(AlertCategory category) {
    switch (category) {
      case AlertCategory.road:
        return AppIcons.roadHorizon;
      case AlertCategory.weather:
        return AppIcons.cloud;
      case AlertCategory.disaster:
        return AppIcons.fire;
      case AlertCategory.visibility:
        return AppIcons.eyeClosed;
      case AlertCategory.emergency:
        return AppIcons.warningCircle;
      default:
        return AppIcons.bell;
    }
  }
}