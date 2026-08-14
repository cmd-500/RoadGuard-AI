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

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(28.6139, 77.2090);
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Potholes', 'Accidents', 'Fog', 'Speed Breakers'];
  bool _showBottomSheet = true;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: RoadSafeColors.background,
      appBar: RoadSafeSearchAppBar(
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: RoadSafeColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: RoadSafeColors.surface, width: 3),
                              boxShadow: RoadSafeShadows.fab,
                            ),
                            child: Icon(
                              RoadSafeIcons.mapPin,
                              size: 24,
                              color: RoadSafeColors.textOnPrimary,
                            ),
                          ),
                    ),
                  ...reportProvider.nearbyReports.map((report) => _buildHazardMarker(report)),
                ],
              ),
            ],
          ),
          Positioned(
            top: RoadSafeSpacing.lg,
            left: RoadSafeSpacing.screenPadding,
            right: RoadSafeSpacing.screenPadding,
            child: _buildFilterChips(),
          ),
          if (_showBottomSheet)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomSheet(reportProvider),
            ),
          Positioned(
            bottom: _showBottomSheet ? 220 : RoadSafeSpacing.xxl,
            right: RoadSafeSpacing.screenPadding,
            child: _buildMapControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
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
            backgroundColor: RoadSafeColors.surface,
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

  Widget _buildHazardMarker(NearbyReport report) {
    final color = RoadSafeColors.hazardColor(report.hazardType.name);

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
            border: Border.all(color: RoadSafeColors.surface, width: 2),
            boxShadow: RoadSafeShadows.card,
          ),
          child: Icon(
            _getHazardIcon(report.hazardType),
            size: 18,
            color: RoadSafeColors.textOnPrimary,
          ),
        ),
      ),
    );
  }

  IconData _getHazardIcon(HazardType type) {
    switch (type) {
      case HazardType.pothole:
        return RoadSafeIcons.pothole;
      case HazardType.accident:
        return RoadSafeIcons.carCrash;
      case HazardType.fog:
        return RoadSafeIcons.cloudFog;
      case HazardType.speedBreaker:
      case HazardType.unmarkedBreaker:
      case HazardType.illegalBreaker:
        return RoadSafeIcons.speedBump;
      case HazardType.waterlogging:
      case HazardType.waterloggedHazard:
        return RoadSafeIcons.waves;
      case HazardType.roadDamage:
        return RoadSafeIcons.roadHorizon;
      case HazardType.construction:
        return RoadSafeIcons.hammer;
      case HazardType.emergency:
        return RoadSafeIcons.warningCircle;
      default:
        return RoadSafeIcons.warning;
    }
  }

  Widget _buildBottomSheet(ReportProvider provider) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: RoadSafeColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(RoadSafeRadius.xxl)),
        boxShadow: RoadSafeShadows.bottomSheet,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: RoadSafeSpacing.md),
            decoration: BoxDecoration(
              color: RoadSafeColors.border,
              borderRadius: BorderRadius.circular(RoadSafeRadius.round),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(RoadSafeSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nearby Alerts', style: RoadSafeTypography.titleMedium),
                IconButton(
                  icon: Icon(RoadSafeIcons.close, size: 20),
                  onPressed: () => setState(() => _showBottomSheet = false),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.nearbyReports.isEmpty
                ? Center(
                    child: Text(
                      'No alerts nearby',
                      style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.screenPadding),
                    itemCount: provider.nearbyReports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: RoadSafeSpacing.sm),
                    itemBuilder: (context, index) {
                      final report = provider.nearbyReports[index];
                      return _buildBottomSheetAlert(report);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetAlert(NearbyReport report) {
    return Container(
      padding: const EdgeInsets.all(RoadSafeSpacing.md),
      decoration: BoxDecoration(
        color: RoadSafeColors.background,
        borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
        border: Border.all(color: RoadSafeColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: RoadSafeColors.hazardColor(report.hazardType.name).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(RoadSafeRadius.md),
            ),
            child: Icon(
              _getHazardIcon(report.hazardType),
              size: 20,
              color: RoadSafeColors.hazardColor(report.hazardType.name),
            ),
          ),
          const SizedBox(width: RoadSafeSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.hazardType.name.replaceAll('_', ' ').toUpperCase(),
                  style: RoadSafeTypography.titleSmall,
                ),
                Text(
                  '${(report.distanceMeters / 1000).toStringAsFixed(1)} km • ${report.creator?.name ?? 'Unknown'}',
                  style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                ),
              ],
            ),
          ),
          RoadSafeSeverityBadge(severity: report.severity.name.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        RoadSafeIconButton(
          icon: RoadSafeIcons.layers,
          onPressed: () {},
          backgroundColor: RoadSafeColors.surface,
          iconColor: RoadSafeColors.textPrimary,
          size: 48,
          iconSize: 24,
          tooltip: 'Map Layers',
        ),
        const SizedBox(height: RoadSafeSpacing.sm),
        RoadSafeIconButton(
          icon: RoadSafeIcons.navigation,
          onPressed: () {},
          backgroundColor: RoadSafeColors.surface,
          iconColor: RoadSafeColors.textPrimary,
          size: 48,
          iconSize: 24,
          tooltip: 'Navigation',
        ),
        const SizedBox(height: RoadSafeSpacing.sm),
        RoadSafeIconButton(
          icon: RoadSafeIcons.location,
          onPressed: _recenterMap,
          backgroundColor: RoadSafeColors.primary,
          iconColor: RoadSafeColors.textOnPrimary,
          size: 48,
          iconSize: 24,
          tooltip: 'Current Location',
        ),
      ],
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
      builder: (context) => Container(
        padding: const EdgeInsets.all(RoadSafeSpacing.xl),
        decoration: BoxDecoration(
          color: RoadSafeColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(RoadSafeRadius.xxl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Hazards', style: RoadSafeTypography.headlineSmall),
            const SizedBox(height: RoadSafeSpacing.lg),
            Wrap(
              spacing: RoadSafeSpacing.sm,
              runSpacing: RoadSafeSpacing.sm,
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter, style: RoadSafeTypography.labelMedium),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedFilter = filter);
                    Navigator.pop(context);
                  },
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
                );
              }).toList(),
            ),
            const SizedBox(height: RoadSafeSpacing.xl),
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
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: RoadSafeColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(RoadSafeRadius.xxl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: RoadSafeSpacing.md),
              decoration: BoxDecoration(
                color: RoadSafeColors.border,
                borderRadius: BorderRadius.circular(RoadSafeRadius.round),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(RoadSafeSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: RoadSafeColors.hazardColor(report.hazardType.name).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
                          ),
                          child: Icon(
                            _getHazardIcon(report.hazardType),
                            size: 24,
                            color: RoadSafeColors.hazardColor(report.hazardType.name),
                          ),
                        ),
                        const SizedBox(width: RoadSafeSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.hazardType.name.replaceAll('_', ' ').toUpperCase(),
                                style: RoadSafeTypography.titleMedium,
                              ),
                              Text(
                                '${(report.distanceMeters / 1000).toStringAsFixed(1)} km away',
                                style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        RoadSafeSeverityBadge(severity: report.severity.name.toUpperCase()),
                      ],
                    ),
                    const SizedBox(height: RoadSafeSpacing.lg),
                    if (report.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
                        child: Image.network(
                          report.imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: RoadSafeSpacing.lg),
                    RoadSafePrimaryButton(
                      label: 'Navigate',
                      leadingIcon: RoadSafeIcons.navigation,
                      onPressed: () {},
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