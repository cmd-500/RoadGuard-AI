import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/alert.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'All Alerts';
  final List<String> _filters = ['All Alerts', 'Road', 'Weather', 'Disaster', 'Visibility', 'Emergency'];

  // Mock alerts data
  final List<SafetyAlert> _alerts = [
    SafetyAlert(
      id: '1',
      title: 'Flood Warning',
      description: 'Heavy rainfall expected. Low-lying areas may experience flooding. Avoid travel if possible.',
      location: 'Noida, Uttar Pradesh',
      distanceKm: 5.2,
      severity: AlertSeverity.critical,
      category: AlertCategory.emergency,
      source: 'IMD',
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      imageUrl: '',
      affectedRoads: ['Noida–Greater Noida Expressway', 'Sector 18 Main Road', 'Dadri Road'],
      isEmergency: true,
    ),
    SafetyAlert(
      id: '2',
      title: 'Heavy Rainfall',
      description: 'Continuous heavy rain expected for next 6 hours. Reduced visibility on highways.',
      location: 'Delhi NCR',
      distanceKm: 12.5,
      severity: AlertSeverity.high,
      category: AlertCategory.weather,
      source: 'Weather Dept',
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
    SafetyAlert(
      id: '3',
      title: 'Dense Fog',
      description: 'Visibility reduced to less than 50 meters on expressways. Drive with caution.',
      location: 'Delhi–Meerut Expressway',
      distanceKm: 8.0,
      severity: AlertSeverity.medium,
      category: AlertCategory.visibility,
      source: 'Traffic Police',
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
    SafetyAlert(
      id: '4',
      title: 'Landslide Warning',
      description: 'Potential landslide risk on hilly routes. Alternative routes advised.',
      location: 'Mussoorie Road',
      distanceKm: 45.0,
      severity: AlertSeverity.high,
      category: AlertCategory.disaster,
      source: 'Geological Survey',
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: false,
    ),
    SafetyAlert(
      id: '5',
      title: 'Wildfire Alert',
      description: 'Forest fire reported near highway. Smoke may reduce visibility.',
      location: 'Rajaji National Park',
      distanceKm: 30.0,
      severity: AlertSeverity.critical,
      category: AlertCategory.emergency,
      source: 'Forest Dept',
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      imageUrl: '',
      affectedRoads: [],
      isEmergency: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadSafeColors.background,
      appBar: RoadSafeAppBar(
        title: 'Safety Alerts',
        leading: IconButton(
          icon: Icon(PhosphorIconsRegular.list, size: 24),
          onPressed: () {},
          padding: const EdgeInsets.only(left: RoadSafeSpacing.screenPadding),
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.bell, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: RoadSafeSpacing.screenPadding),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
              children: [
                _buildEmergencyAlerts(),
                const SizedBox(height: RoadSafeSpacing.xl),
                _buildAffectedRoads(),
                const SizedBox(height: RoadSafeSpacing.xl),
                _buildOtherAlerts(),
                const SizedBox(height: RoadSafeSpacing.xl),
                _buildInfoSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: RoadSafeColors.surface,
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.screenPadding, vertical: RoadSafeSpacing.sm),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: RoadSafeSpacing.sm),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter, style: RoadSafeTypography.labelMedium),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedFilter = filter),
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

  Widget _buildEmergencyAlerts() {
    final emergencyAlerts = _alerts.where((a) => a.isEmergency).toList();

    if (emergencyAlerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Emergency Alerts', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        ...emergencyAlerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: RoadSafeSpacing.lg),
              child: RoadSafeSafetyAlertCard(
                title: alert.title,
                description: alert.description,
                location: alert.location,
                distance: '${alert.distanceKm.toStringAsFixed(1)} km',
                severity: alert.severityDisplay,
                imageUrl: alert.imageUrl,
                icon: _getCategoryIcon(alert.category),
                isEmergency: true,
              ),
            )),
      ],
    );
  }

  Widget _buildAffectedRoads() {
    final emergencyAlerts = _alerts.where((a) => a.isEmergency && a.affectedRoads.isNotEmpty).toList();

    if (emergencyAlerts.isEmpty) return const SizedBox.shrink();

    final allAffectedRoads = emergencyAlerts
        .expand((a) => a.affectedRoads)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Affected Roads', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        Wrap(
          spacing: RoadSafeSpacing.sm,
          runSpacing: RoadSafeSpacing.sm,
          children: allAffectedRoads.map((road) => Container(
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

  Widget _buildOtherAlerts() {
    final otherAlerts = _alerts.where((a) => !a.isEmergency).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Other Active Alerts', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        ...otherAlerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: RoadSafeSpacing.md),
              child: RoadSafeSafetyAlertCard(
                title: alert.title,
                description: alert.description,
                location: alert.location,
                distance: '${alert.distanceKm.toStringAsFixed(1)} km',
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
              Icon(PhosphorIconsRegular.info, size: 20, color: RoadSafeColors.informational),
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
              _buildSourceChip('IMD', PhosphorIconsRegular.cloud),
              _buildSourceChip('Traffic Police', PhosphorIconsRegular.shield),
              _buildSourceChip('Weather Dept', PhosphorIconsRegular.sun),
              _buildSourceChip('Satellite', PhosphorIconsRegular.satellite),
              _buildSourceChip('AI Models', PhosphorIconsRegular.cpu),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceChip(String label, PhosphorIconsRegular icon) {
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

  PhosphorIconsRegular _getCategoryIcon(AlertCategory category) {
    switch (category) {
      case AlertCategory.road:
        return PhosphorIconsRegular.roadHorizon;
      case AlertCategory.weather:
        return PhosphorIconsRegular.cloud;
      case AlertCategory.disaster:
        return PhosphorIconsRegular.fire;
      case AlertCategory.visibility:
        return PhosphorIconsRegular.eyeClosed;
      case AlertCategory.emergency:
        return PhosphorIconsRegular.warningCircle;
      default:
        return PhosphorIconsRegular.bell;
    }
  }
}