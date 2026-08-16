import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/report.dart';
import '../../shared/providers/report_provider.dart';
import '../../shared/providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(28.6139, 77.2090);
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Potholes', 'Accidents', 'Fog', 'Speed Breakers'];
  late AnimationController _bottomSheetController;

  @override
  void initState() {
    super.initState();
    _bottomSheetController = AnimationController(
      duration: AppMotion.slideIn,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final locationProvider = context.read<LocationProvider>();
    await locationProvider.getCurrentLocation();
    if (locationProvider.currentPosition != null) {
      setState(() {
        _center = LatLng(
          locationProvider.currentPosition!.latitude,
          locationProvider.currentPosition!.longitude,
        );
      });
      _mapController.move(_center, 15);
    }
    context.read<ReportProvider>().fetchNearbyReports(
      latitude: _center.latitude,
      longitude: _center.longitude,
      radiusMeters: 5000,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppSearchAppBar(
        hintText: 'Search location...',
        onFilterPressed: _showFilterSheet,
        onLocationPressed: _recenterMap,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 14,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.roadsafes.app',
              ),
              MarkerLayer(
                markers: [
                  if (context.read<LocationProvider>().currentPosition != null)
                    Marker(
                      point: LatLng(
                        context.read<LocationProvider>().currentPosition!.latitude,
                        context.read<LocationProvider>().currentPosition!.longitude,
                      ),
                      width: 48,
                      height: 48,
                      child: const AppCurrentLocationMarker(size: 48, pulsing: true),
                    ),
                  ...reportProvider.nearbyReports
                      .where((report) => _filterMatches(report))
                      .map((report) => _buildHazardMarker(report)),
                ],
              ),
            ],
          ),
          Positioned(
            top: AppSpacing.lg,
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            child: _buildFilterChips(),
          ),
          _buildBottomSheet(reportProvider),
          _buildMapControls(),
        ],
      ),
    );
  }

  bool _filterMatches(NearbyReport report) {
    if (_selectedFilter == 'All') return true;
    switch (_selectedFilter) {
      case 'Potholes':
        return report.hazardType == HazardType.pothole;
      case 'Accidents':
        return report.hazardType == HazardType.accident;
      case 'Fog':
        return report.hazardType == HazardType.fog;
      case 'Speed Breakers':
        return report.hazardType == HazardType.speedBreaker ||
            report.hazardType == HazardType.unmarkedBreaker ||
            report.hazardType == HazardType.illegalBreaker;
      default:
        return true;
    }
  }

  static const Map<String, IconData> _filterIcons = {
    'All': AppIcons.layers,
    'Potholes': AppIcons.pothole,
    'Accidents': AppIcons.carCrash,
    'Fog': AppIcons.cloudFog,
    'Speed Breakers': AppIcons.speedBump,
  };

  Widget _buildFilterChips() {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      shadows: AppShadows.cardElevated,
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;
            return AnimatedContainer(
              duration: AppMotion.fadeIn,
              child: ChoiceChip(
                avatar: Icon(
                  _filterIcons[filter] ?? AppIcons.warning,
                  size: 16,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                label: Text(filter, style: AppTypography.labelMedium),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedFilter = filter),
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
      ),
    );
  }

  Marker _buildHazardMarker(NearbyReport report) {
    final color = AppColors.hazardColor(report.hazardType.name);

    return Marker(
      point: LatLng(report.latitude, report.longitude),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showReportDetail(report),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 2),
            boxShadow: AppShadows.card,
          ),
          child: Icon(
            _getHazardIcon(report.hazardType),
            size: 18,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }

  IconData _getHazardIcon(HazardType type) {
    switch (type) {
      case HazardType.pothole:
        return AppIcons.pothole;
      case HazardType.accident:
        return AppIcons.carCrash;
      case HazardType.fog:
        return AppIcons.cloudFog;
      case HazardType.speedBreaker:
      case HazardType.unmarkedBreaker:
      case HazardType.illegalBreaker:
        return AppIcons.speedBump;
      case HazardType.waterlogging:
      case HazardType.waterloggedHazard:
        return AppIcons.waves;
      case HazardType.roadDamage:
        return AppIcons.roadHorizon;
      case HazardType.construction:
        return AppIcons.hammer;
      case HazardType.emergency:
        return AppIcons.warningCircle;
      default:
        return AppIcons.warning;
    }
  }

  Widget _buildBottomSheet(ReportProvider provider) {
    return DraggableScrollableSheet(
      initialChildSize: 0.22,
      minChildSize: 0.12,
      maxChildSize: 0.65,
      snap: true,
      snapSizes: const [0.12, 0.22, 0.45, 0.65],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
            boxShadow: AppShadows.bottomSheet,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nearby Alerts', style: AppTypography.titleMedium),
                    AppIconButton(
                      icon: AppIcons.close,
                      onPressed: () {},
                      size: 36,
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.nearbyReports.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppIcons.checkCircle, size: 48, color: AppColors.success),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No alerts nearby',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                        itemCount: provider.nearbyReports.where(_filterMatches).length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final filteredReports = provider.nearbyReports.where(_filterMatches).toList();
                          final report = filteredReports[index];
                          return _buildBottomSheetAlert(report);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetAlert(NearbyReport report) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => _showReportDetail(report),
      child: Row(
        children: [
          AppHazardIcon(
            hazardType: report.hazardType.name,
            size: AppHazardIconSize.medium,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.hazardType.name.replaceAll('_', ' ').toUpperCase(),
                  style: AppTypography.titleSmall,
                ),
                Text(
                  '${(report.distanceMeters / 1000).toStringAsFixed(1)} km • ${report.creator?.name ?? 'Unknown'}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          AppSeverityBadge(severity: report.severity.name.toUpperCase(), showIcon: true),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: AppSpacing.xxl,
      right: AppSpacing.screenPadding,
      child: Column(
        children: [
          AppIconButton(
            icon: AppIcons.layers,
            onPressed: () {},
            backgroundColor: AppColors.surface,
            iconColor: AppColors.textPrimary,
            size: 48,
            iconSize: 24,
            tooltip: 'Map Layers',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppIconButton(
            icon: AppIcons.navigation,
            onPressed: () {},
            backgroundColor: AppColors.surface,
            iconColor: AppColors.textPrimary,
            size: 48,
            iconSize: 24,
            tooltip: 'Navigation',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppIconButton(
            icon: AppIcons.myLocation,
            onPressed: _recenterMap,
            backgroundColor: AppColors.primary,
            iconColor: AppColors.onPrimary,
            size: 48,
            iconSize: 24,
            tooltip: 'Current Location',
          ),
        ],
      ),
    );
  }

  void _recenterMap() {
    final position = context.read<LocationProvider>().currentPosition;
    if (position != null) {
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15,
      );
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Hazards', style: AppTypography.headlineSmall),
                AppIconButton(
                  icon: AppIcons.close,
                  onPressed: () => Navigator.pop(context),
                  size: 36,
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter, style: AppTypography.labelMedium),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedFilter = filter);
                    Navigator.pop(context);
                  },
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
                    vertical: AppSpacing.sm,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              label: 'Apply Filters',
              isFullWidth: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDetail(NearbyReport report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppHazardIcon(
                          hazardType: report.hazardType.name,
                          size: AppHazardIconSize.large,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.hazardType.name.replaceAll('_', ' ').toUpperCase(),
                                style: AppTypography.titleMedium,
                              ),
                              Text(
                                '${(report.distanceMeters / 1000).toStringAsFixed(1)} km away',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        AppSeverityBadge(severity: report.severity.name.toUpperCase(), showIcon: true),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (report.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Image.network(
                          report.imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 180,
                            color: AppColors.surfaceContainerLow,
                            child: Icon(AppIcons.image, size: 48, color: AppColors.textTertiary),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: AppSecondaryButton(
                            label: 'Navigate',
                            leadingIcon: AppIcons.navigation,
                            isFullWidth: true,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppPrimaryButton(
                            label: 'Report Issue',
                            leadingIcon: AppIcons.report,
                            isFullWidth: true,
                            onPressed: () {},
                          ),
                        ),
                      ],
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