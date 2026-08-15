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

class _AlertsScreenState extends State<AlertsScreen> {
  static const _categories = <AlertCategory>[
    AlertCategory.all,
    AlertCategory.road,
    AlertCategory.weather,
    AlertCategory.disaster,
    AlertCategory.visibility,
    AlertCategory.emergency,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertProvider>().fetchAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlertProvider>();

    return Scaffold(
      backgroundColor: RoadSafeColors.background,
      appBar: RoadSafeAppBar(
        title: 'Safety Alerts',
        leading: IconButton(
          icon: Icon(RoadSafeIcons.menu, size: 24),
          onPressed: () {},
          padding: const EdgeInsets.only(left: RoadSafeSpacing.screenPadding),
        ),
        actions: [
          IconButton(
            icon: Icon(RoadSafeIcons.bell, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: RoadSafeSpacing.screenPadding),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(provider),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(AlertProvider provider) {
    if (provider.isLoading && provider.alerts.isEmpty) {
      return const Center(child: RoadSafeCircularProgress());
    }

    if (provider.error != null && provider.alerts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(RoadSafeSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(RoadSafeIcons.warningCircle, size: 48, color: RoadSafeColors.error),
              const SizedBox(height: RoadSafeSpacing.md),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.error),
              ),
              const SizedBox(height: RoadSafeSpacing.lg),
              RoadSafeSecondaryButton(
                label: 'Retry',
                leadingIcon: RoadSafeIcons.refresh,
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
            Icon(RoadSafeIcons.folderOpen, size: 64, color: RoadSafeColors.textTertiary),
            const SizedBox(height: RoadSafeSpacing.lg),
            Text('No alerts in this category', style: RoadSafeTypography.headlineSmall),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
      children: [
        if (provider.emergencyAlerts.isNotEmpty) ...[
          _buildEmergencyAlerts(provider),
          const SizedBox(height: RoadSafeSpacing.xl),
        ],
        if (provider.affectedRoads.isNotEmpty) ...[
          _buildAffectedRoads(provider),
          const SizedBox(height: RoadSafeSpacing.xl),
        ],
        if (provider.otherAlerts.isNotEmpty) ...[
          _buildOtherAlerts(provider),
          const SizedBox(height: RoadSafeSpacing.xl),
        ],
        _buildInfoSection(),
      ],
    );
  }

  Widget _buildFilterChips(AlertProvider provider) {
    return Container(
      color: RoadSafeColors.surface,
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.screenPadding, vertical: RoadSafeSpacing.sm),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: RoadSafeSpacing.sm),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = provider.selectedCategory == category;
          return ChoiceChip(
            label: Text(category.categoryDisplay, style: RoadSafeTypography.labelMedium),
            selected: isSelected,
            onSelected: (_) => provider.selectCategory(category),
            selectedColor: RoadSafeColors.primaryContainer,
            backgroundColor: RoadSafeColors.background,
            labelStyle: RoadSafeTypography.labelMedium.copyWith(
              color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textSecondary,
            ),
            side: BorderSide(
              color: isSelected ? RoadSafeColors.primary : RoadSafeColors.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.round),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.md,
              vertical: RoadSafeSpacing.xs,
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
        Text('Emergency Alerts', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        ...provider.emergencyAlerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: RoadSafeSpacing.lg),
              child: RoadSafeSafetyAlertCard(
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
        Text('Affected Roads', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        Wrap(
          spacing: RoadSafeSpacing.sm,
          runSpacing: RoadSafeSpacing.sm,
          children: provider.affectedRoads.map((road) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RoadSafeSpacing.md,
                  vertical: RoadSafeSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: RoadSafeColors.errorLight,
                  borderRadius: BorderRadius.circular(RoadSafeRadius.round),
                  border: Border.all(color: RoadSafeColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  road,
                  style: RoadSafeTypography.labelMedium.copyWith(color: RoadSafeColors.error),
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
        Text('Other Active Alerts', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        ...provider.otherAlerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: RoadSafeSpacing.md),
              child: RoadSafeSafetyAlertCard(
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
    return RoadSafeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(RoadSafeIcons.info, size: 20, color: RoadSafeColors.informational),
              const SizedBox(width: RoadSafeSpacing.sm),
              Text('Alert Sources', style: RoadSafeTypography.titleMedium),
            ],
          ),
          const SizedBox(height: RoadSafeSpacing.md),
          Text(
            'Safety alerts are generated from multiple sources including official government agencies, weather departments, satellite data, and AI-based prediction models. Always verify critical alerts with local authorities.',
            style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
          ),
          const SizedBox(height: RoadSafeSpacing.lg),
          Wrap(
            spacing: RoadSafeSpacing.sm,
            runSpacing: RoadSafeSpacing.sm,
            children: [
              _buildSourceChip('IMD', RoadSafeIcons.cloud),
              _buildSourceChip('Traffic Police', RoadSafeIcons.shield),
              _buildSourceChip('Weather Dept', RoadSafeIcons.sun),
              _buildSourceChip('Satellite', RoadSafeIcons.satellite),
              _buildSourceChip('AI Models', RoadSafeIcons.cpu),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RoadSafeSpacing.md,
        vertical: RoadSafeSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: RoadSafeColors.background,
        borderRadius: BorderRadius.circular(RoadSafeRadius.round),
        border: Border.all(color: RoadSafeColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: RoadSafeColors.textSecondary),
          const SizedBox(width: RoadSafeSpacing.xs),
          Text(label, style: RoadSafeTypography.labelSmall),
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
        return RoadSafeIcons.roadHorizon;
      case AlertCategory.weather:
        return RoadSafeIcons.cloud;
      case AlertCategory.disaster:
        return RoadSafeIcons.fire;
      case AlertCategory.visibility:
        return RoadSafeIcons.eyeClosed;
      case AlertCategory.emergency:
        return RoadSafeIcons.warningCircle;
      default:
        return RoadSafeIcons.bell;
    }
  }
}
