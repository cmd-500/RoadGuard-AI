import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/report.dart' as shared_models;
import '../../shared/models/report.dart' show Severity;
import '../../shared/providers/report_provider.dart';
import '../../shared/providers/location_provider.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/alert_provider.dart';
import '../../shared/models/alert.dart';
import '../map/map_screen.dart';
import '../report/report_screen.dart';
import '../alerts/alerts_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  AppTab _currentTab = AppTab.home;
  final MapController _homeMapController = MapController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Timer? _alertPollTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().getCurrentLocation();
      context.read<ReportProvider>().fetchReports();
      context.read<AlertProvider>().fetchAlerts();
    });

    _alertPollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) context.read<AlertProvider>().fetchAlerts();
    });
  }

  @override
  void dispose() {
    _homeMapController.dispose();
    _animationController.dispose();
    _alertPollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?.name.split(' ').first ?? 'User';

    final screens = [
      _buildHomeContent(userName, locationProvider),
      const MapScreen(),
      const ReportScreen(),
      const AlertsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentTab.index],
      bottomNavigationBar: AppBottomNavigation(
        currentTab: _currentTab,
        onTabChanged: (tab) => setState(() => _currentTab = tab),
      ),
    );
  }

  Widget _buildHomeContent(String userName, LocationProvider locationProvider) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        leading: IconButton(
          icon: Icon(AppIcons.menu, size: 24),
          onPressed: () {},
          padding: const EdgeInsets.only(left: AppSpacing.screenPadding),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(AppIcons.bell, size: 24),
                  onPressed: () {},
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: () => context.read<AlertProvider>().fetchAlerts(),
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchField(),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildMapPreview(locationProvider),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildQuickActions(),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildNearbyAlerts(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return AppSearchField(
      hint: 'Where do you want to go?',
      onFilterPressed: () {},
      onLocationPressed: () {},
    );
  }

  Widget _buildMapPreview(LocationProvider locationProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Live Map', style: AppTypography.headlineSmall),
            AppTertiaryButton(
              label: 'Fullscreen',
              leadingIcon: AppIcons.openInFull,
              onPressed: () => _changeTab(AppTab.map),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.outline),
            boxShadow: AppShadows.card,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Stack(
              children: <Widget>[
                FlutterMap(
                  mapController: _homeMapController,
                  options: MapOptions(
                    initialCenter: _getHomeMapCenter(locationProvider),
                    initialZoom: 13,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.roadsafes.app',
                    ),
                    MarkerLayer(
                      markers: _buildHomeMapMarkers(),
                    ),
                  ],
                ),
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: AppIconButton(
                    icon: AppIcons.openInFull,
                    onPressed: () => _changeTab(AppTab.map),
                    backgroundColor: AppColors.surface,
                    iconColor: AppColors.textPrimary,
                    size: 40,
                    iconSize: 20,
                    tooltip: 'Open fullscreen map',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LatLng _getHomeMapCenter(LocationProvider locationProvider) {
    if (locationProvider.currentPosition != null) {
      return LatLng(
        locationProvider.currentPosition!.latitude,
        locationProvider.currentPosition!.longitude,
      );
    }
    return const LatLng(28.6139, 77.2090);
  }

  List<Marker> _buildHomeMapMarkers() {
    final reportProvider = context.read<ReportProvider>();
    final markers = <Marker>[];

    final locProvider = context.read<LocationProvider>();
    if (locProvider.currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(
            locProvider.currentPosition!.latitude,
            locProvider.currentPosition!.longitude,
          ),
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 3),
              boxShadow: AppShadows.fab,
            ),
            child: Icon(
              AppIcons.mapPin,
              size: 20,
              color: AppColors.onPrimary,
            ),
          ),
        ),
      );
    }

    final reports = reportProvider.nearbyReports.take(10).toList();
    for (final report in reports) {
      final color = AppColors.hazardColor(report.hazardType.name);
      markers.add(
        Marker(
          point: LatLng(report.latitude, report.longitude),
          width: 32,
          height: 32,
          child: GestureDetector(
            onTap: () => _showQuickHazardInfo(report),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
                boxShadow: AppShadows.card,
              ),
              child: Icon(
                _getHazardIcon(report.hazardType.name),
                size: 14,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  IconData _getHazardIcon(String hazardType) {
    switch (hazardType) {
      case 'POTHOLE':
        return AppIcons.pothole;
      case 'ACCIDENT':
        return AppIcons.carCrash;
      case 'FOG':
        return AppIcons.cloudFog;
      case 'SPEED_BREAKER':
      case 'UNMARKED_BREAKER':
      case 'ILLEGAL_BREAKER':
        return AppIcons.speedBump;
      case 'WATERLOGGING':
      case 'WATERLOGGED_HAZARD':
        return AppIcons.waves;
      case 'ROAD_DAMAGE':
        return AppIcons.roadHorizon;
      case 'CONSTRUCTION':
        return AppIcons.hammer;
      case 'EMERGENCY':
        return AppIcons.warningCircle;
      default:
        return AppIcons.warning;
    }
  }

  void _showQuickHazardInfo(shared_models.NearbyReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${report.hazardType.name.toUpperCase()} - ${(report.distanceMeters / 1000).toStringAsFixed(1)} km',
          style: AppTypography.bodyMedium,
        ),
        backgroundColor: AppColors.hazardColor(report.hazardType.name),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _changeTab(AppTab tab) {
    setState(() => _currentTab = tab);
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Quick Actions', style: AppTypography.headlineSmall),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final cardWidth = (maxWidth - (3 * AppSpacing.sm)) / 4;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: cardWidth,
                  child: AppQuickActionCard(
                    title: 'Live Alerts',
                    subtitle: 'Stay informed',
                    icon: AppIcons.alerts,
                    iconBackgroundColor: AppColors.infoLight,
                    iconColor: AppColors.info,
                    onTap: () => _changeTab(AppTab.alerts),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: cardWidth,
                  child: AppQuickActionCard(
                    title: 'Report Issue',
                    subtitle: 'Help others',
                    icon: AppIcons.camera,
                    iconBackgroundColor: AppColors.successLight,
                    iconColor: AppColors.success,
                    onTap: () => _changeTab(AppTab.report),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: cardWidth,
                  child: AppQuickActionCard(
                    title: 'Plan Trip',
                    subtitle: 'Safe route',
                    icon: AppIcons.map,
                    iconBackgroundColor: AppColors.primaryContainer,
                    iconColor: AppColors.primary,
                    onTap: () => _changeTab(AppTab.map),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: cardWidth,
                  child: AppQuickActionCard(
                    title: 'Rewards',
                    subtitle: 'Earn & Redeem',
                    icon: AppIcons.gift,
                    iconBackgroundColor: AppColors.warningLight,
                    iconColor: AppColors.warning,
                    onTap: () {},
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildNearbyAlerts() {
    final alertProvider = context.watch<AlertProvider>();
    final alerts = alertProvider.alerts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Nearby Alerts', style: AppTypography.headlineSmall),
            AppTertiaryButton(
              label: 'View All',
              onPressed: () => _changeTab(AppTab.alerts),
              trailingIcon: AppIcons.caretRight,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (alertProvider.isLoading)
          const Center(child: AppCircularProgress())
        else if (alertProvider.error != null)
          _buildAlertsErrorState(alertProvider.error!)
        else if (alerts.isEmpty)
            _buildEmptyAlerts()
          else
            Column(
              children: alerts
                  .take(3)
                  .map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppAlertListItem(
                  hazardType: alert.category.name,
                  title: alert.title,
                  subtitle: alert.affectedRoads.isNotEmpty
                      ? alert.affectedRoads.first
                      : alert.location,
                  distance: alert.distanceKm > 0
                      ? (alert.distanceKm < 1
                      ? '${(alert.distanceKm * 1000).round()} m'
                      : '${alert.distanceKm.toStringAsFixed(1)} km')
                      : '',
                  severity: alert.severityDisplay,
                  onTap: () => _changeTab(AppTab.alerts),
                ),
              ))
                  .toList(),
            ),
      ],
    );
  }

  Widget _buildAlertsErrorState(String error) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(AppIcons.warningCircle, size: 20, color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Couldn\'t load live alerts',
                  style: AppTypography.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            error,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTertiaryButton(
            label: 'Retry',
            onPressed: () => context.read<AlertProvider>().fetchAlerts(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAlerts() {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        children: <Widget>[
          Icon(AppIcons.checkCircle, size: 48, color: AppColors.success),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No nearby alerts',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your route looks clear!',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}