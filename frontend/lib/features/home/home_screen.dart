import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/report.dart';
import '../../shared/providers/report_provider.dart';
import '../../shared/providers/location_provider.dart';
import '../../shared/providers/auth_provider.dart';
import '../map/map_screen.dart';
import '../report/report_screen.dart';
import '../alerts/alerts_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RoadSafeTab _currentTab = RoadSafeTab.home;
  final MapController _homeMapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().getCurrentLocation();
      context.read<ReportProvider>().fetchReports();
    });
  }

  @override
  void dispose() {
    _homeMapController.dispose();
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
      bottomNavigationBar: RoadSafeBottomNavigation(
        currentTab: _currentTab,
        onTabChanged: (tab) => setState(() => _currentTab = tab),
      ),
    );
  }

  Widget _buildHomeContent(String userName, LocationProvider locationProvider) {
    return Scaffold(
      backgroundColor: RoadSafeColors.background,
      appBar: RoadSafeAppBar(
        title: null,
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(RoadSafeSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingSection(userName),
                    const SizedBox(height: RoadSafeSpacing.xxl),
                    _buildSearchField(),
                    const SizedBox(height: RoadSafeSpacing.xxl),
                    _buildMapPreview(locationProvider),
                    const SizedBox(height: RoadSafeSpacing.xxl),
                    _buildQuickActions(),
                    const SizedBox(height: RoadSafeSpacing.xxl),
                    _buildNearbyAlerts(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection(String userName) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $userName',
                style: RoadSafeTypography.headlineMedium,
              ),
              const SizedBox(height: RoadSafeSpacing.xs),
              Text(
                'Let\'s make your journey safe today.',
                style: RoadSafeTypography.bodyMedium.copyWith(
                  color: RoadSafeColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: RoadSafeColors.primaryContainer,
            borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
          ),
          child: Icon(
            RoadSafeIcons.car,
            size: 40,
            color: RoadSafeColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return RoadSafeSearchField(
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
            Text('Live Map', style: RoadSafeTypography.headlineSmall),
            RoadSafeTextButton(
              label: 'Fullscreen',
              leadingIcon: Icons.open_in_full,
              onPressed: () => _changeTab(RoadSafeTab.map),
            ),
          ],
        ),
        const SizedBox(height: RoadSafeSpacing.md),
        Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
            border: Border.all(color: RoadSafeColors.border),
            boxShadow: RoadSafeShadows.card,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
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
                  top: RoadSafeSpacing.md,
                  right: RoadSafeSpacing.md,
                  child: RoadSafeIconButton(
                    icon: Icons.open_in_full,
                    onPressed: () => _changeTab(RoadSafeTab.map),
                    backgroundColor: RoadSafeColors.surface,
                    iconColor: RoadSafeColors.textPrimary,
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

    // Current location marker
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
              color: RoadSafeColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: RoadSafeColors.surface, width: 3),
              boxShadow: RoadSafeShadows.fab,
            ),
            child: Icon(
              RoadSafeIcons.mapPin,
              size: 20,
              color: RoadSafeColors.textOnPrimary,
            ),
          ),
        ),
      );
    }

    // Nearby hazard markers (limit to 10 for performance on preview)
    final reports = reportProvider.nearbyReports.take(10).toList();
    for (final report in reports) {
      final color = RoadSafeColors.hazardColor(report.hazardType.name);
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
                border: Border.all(color: RoadSafeColors.surface, width: 2),
                boxShadow: RoadSafeShadows.card,
              ),
              child: Icon(
                _getHazardIcon(report.hazardType),
                size: 14,
                color: RoadSafeColors.textOnPrimary,
              ),
            ),
          ),
        ),
      );
    }

    return markers;
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

  void _showQuickHazardInfo(NearbyReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${report.hazardType.name.replaceAll('_', ' ').toUpperCase()} - ${(report.distanceMeters / 1000).toStringAsFixed(1)} km',
          style: RoadSafeTypography.bodyMedium,
        ),
        backgroundColor: RoadSafeColors.hazardColor(report.hazardType.name),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _changeTab(RoadSafeTab tab) {
    setState(() => _currentTab = tab);
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Quick Actions', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: RoadSafeSpacing.md,
          mainAxisSpacing: RoadSafeSpacing.md,
          // Fixed design ratio (not a pixel height) — card height scales
          // automatically with whatever width the grid column gets.
          childAspectRatio: 0.98,
          children: <Widget>[
            RoadSafeQuickActionCard(
              title: 'Real-time Alerts',
              subtitle: 'Stay informed',
              icon: RoadSafeIcons.alerts,
              iconBackgroundColor: RoadSafeColors.informationalLight,
              iconColor: RoadSafeColors.informational,
              onTap: () => _changeTab(RoadSafeTab.alerts),
            ),
            RoadSafeQuickActionCard(
              title: 'Report Issue',
              subtitle: 'Help others',
              icon: RoadSafeIcons.report,
              iconBackgroundColor: RoadSafeColors.primaryContainer,
              iconColor: RoadSafeColors.primary,
              onTap: () => _changeTab(RoadSafeTab.report),
            ),
            RoadSafeQuickActionCard(
              title: 'Plan Your Trip',
              subtitle: 'Safe route',
              icon: RoadSafeIcons.map,
              iconBackgroundColor: RoadSafeColors.successLight,
              iconColor: RoadSafeColors.success,
              onTap: () => _changeTab(RoadSafeTab.map),
            ),
            RoadSafeQuickActionCard(
              title: 'Rewards',
              subtitle: 'Earn & Redeem',
              icon: RoadSafeIcons.gift,
              iconBackgroundColor: RoadSafeColors.warningLight,
              iconColor: RoadSafeColors.warning,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbyAlerts() {
    final reportProvider = context.watch<ReportProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Nearby Alerts', style: RoadSafeTypography.headlineSmall),
            RoadSafeTextButton(
              label: 'View All',
              onPressed: () => _changeTab(RoadSafeTab.map),
              trailingIcon: RoadSafeIcons.caretRight,
            ),
          ],
        ),
        const SizedBox(height: RoadSafeSpacing.lg),
        if (reportProvider.isLoading)
          const Center(child: RoadSafeCircularProgress())
        else if (reportProvider.nearbyReports.isEmpty)
          _buildEmptyAlerts()
        else
          Column(
            children: reportProvider.nearbyReports
                .take(3)
                .map((report) => Padding(
                      padding: const EdgeInsets.only(bottom: RoadSafeSpacing.md),
                      child: RoadSafeHazardCard(
                        hazardType: report.hazardType.name,
                        title: report.title,
                        distance: '${(report.distanceMeters / 1000).toStringAsFixed(1)} km',
                        location: report.creator?.name ?? 'Unknown location',
                        severity: _getRiskLevel(report.severity),
                        imageUrl: report.imageUrl,
                        onTap: () {},
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildEmptyAlerts() {
    return RoadSafeCard(
      padding: const EdgeInsets.all(RoadSafeSpacing.xxl),
      child: Column(
        children: <Widget>[
          Icon(RoadSafeIcons.checkCircle, size: 48, color: RoadSafeColors.success),
          const SizedBox(height: RoadSafeSpacing.md),
          Text(
            'No nearby alerts',
            style: RoadSafeTypography.titleMedium,
          ),
          const SizedBox(height: RoadSafeSpacing.xs),
          Text(
            'Your route looks clear!',
            style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _getRiskLevel(Severity severity) {
    switch (severity) {
      case Severity.critical:
        return 'HIGH RISK';
      case Severity.high:
        return 'HIGH RISK';
      case Severity.medium:
        return 'MEDIUM RISK';
      case Severity.low:
        return 'LOW RISK';
    }
  }
}