import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().getCurrentLocation();
      context.read<ReportProvider>().fetchReports();
    });
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(userName),
              const SizedBox(height: RoadSafeSpacing.xxl),
              _buildSearchField(),
              const SizedBox(height: RoadSafeSpacing.xxl),
              _buildQuickActions(),
              const SizedBox(height: RoadSafeSpacing.xxl),
              _buildNearbyAlerts(),
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.lg),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: RoadSafeSpacing.md,
          mainAxisSpacing: RoadSafeSpacing.md,
          childAspectRatio: 1.1,
          children: [
            RoadSafeQuickActionCard(
              title: 'Real-time Alerts',
              subtitle: 'Nearby hazards & warnings',
              icon: RoadSafeIcons.alerts,
              iconBackgroundColor: RoadSafeColors.informationalLight,
              iconColor: RoadSafeColors.informational,
              onTap: () => setState(() => _currentTab = RoadSafeTab.alerts),
            ),
            RoadSafeQuickActionCard(
              title: 'Report Issue',
              subtitle: 'Report road hazards',
              icon: RoadSafeIcons.report,
              iconBackgroundColor: RoadSafeColors.primaryContainer,
              iconColor: RoadSafeColors.primary,
              onTap: () => setState(() => _currentTab = RoadSafeTab.report),
            ),
            RoadSafeQuickActionCard(
              title: 'Plan Your Trip',
              subtitle: 'Safe route navigation',
              icon: RoadSafeIcons.map,
              iconBackgroundColor: RoadSafeColors.successLight,
              iconColor: RoadSafeColors.success,
              onTap: () => setState(() => _currentTab = RoadSafeTab.map),
            ),
            RoadSafeQuickActionCard(
              title: 'Rewards',
              subtitle: 'Earn points for reports',
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nearby Alerts', style: RoadSafeTypography.headlineSmall),
            RoadSafeTextButton(
              label: 'View All',
              onPressed: () => setState(() => _currentTab = RoadSafeTab.map),
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
        children: [
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