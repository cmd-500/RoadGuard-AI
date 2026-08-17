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
    });
  }

  @override
  void dispose() {
    _homeMapController.dispose();
    _animationController.dispose();
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
          IconButton(
            icon: Icon(AppIcons.bell, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreetingSection(userName),
                      const SizedBox(height: AppSpacing.xxl),
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
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Let\'s make your journey safe today.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.primaryGlow,
          ),
          child: Icon(
            AppIcons.car,
            size: 36,
            color: AppColors.onPrimary,
          ),
        ),
      ],
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

    // Nearby hazard markers (limit to 10 for performance on preview)
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
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.98,
          children: <Widget>[
            AppQuickActionCard(
              title: 'Real-time Alerts',
              subtitle: 'Stay informed',
              icon: AppIcons.alerts,
              iconBackgroundColor: AppColors.infoLight,
              iconColor: AppColors.info,
              onTap: () => _changeTab(AppTab.alerts),
            ),
            AppQuickActionCard(
              title: 'Plan Your Trip',
              subtitle: 'Safe route',
              icon: AppIcons.map,
              iconBackgroundColor: AppColors.successLight,
              iconColor: AppColors.success,
              onTap: () => _changeTab(AppTab.map),
            ),
            AppQuickActionCard(
              title: 'Rewards',
              subtitle: 'Earn & Redeem',
              icon: AppIcons.gift,
              iconBackgroundColor: AppColors.warningLight,
              iconColor: AppColors.warning,
              onTap: () {},
            ),
            AppQuickActionCard(
              title: 'My Reports',
              subtitle: 'View history',
              icon: AppIcons.flag,
              iconBackgroundColor: AppColors.primaryContainer,
              iconColor: AppColors.primary,
              onTap: () => _changeTab(AppTab.profile),
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
            Text('Nearby Alerts', style: AppTypography.headlineSmall),
            AppTertiaryButton(
              label: 'View All',
              onPressed: () => _changeTab(AppTab.map),
              trailingIcon: AppIcons.caretRight,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (reportProvider.isLoading)
          const Center(child: AppCircularProgress())
        else if (reportProvider.nearbyReports.isEmpty)
          _buildEmptyAlerts()
        else
          Column(
            children: reportProvider.nearbyReports
                .take(3)
                .map((report) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppHazardCard(
                        hazardType: report.hazardType.name,
                        title: report.title,
                        distance: '${(report.distanceMeters / 1000).toStringAsFixed(1)} km',
                        location: report.creator?.name ?? 'Unknown location',
                        severity: _getRiskLevel(report.severity.name),
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

  String _getRiskLevel(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return 'HIGH RISK';
      case 'HIGH':
        return 'HIGH RISK';
      case 'MEDIUM':
        return 'MEDIUM RISK';
      case 'LOW':
        return 'LOW RISK';
      default:
        return 'LOW RISK';
    }
  }
}