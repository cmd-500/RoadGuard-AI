import 'package:flutter/material.dart';
import '../../features/home/home_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/report/report_screen.dart';
import '../../features/alerts/alerts_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/reports/issue_detail_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String map = '/map';
  static const String report = '/report';
  static const String alerts = '/alerts';
  static const String profile = '/profile';
  static const String reports = '/reports';
  static const String issueDetail = '/issue-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomeScreen());
      case map:
        return _buildRoute(const MapScreen());
      case report:
        return _buildRoute(const ReportScreen());
      case alerts:
        return _buildRoute(const AlertsScreen());
      case profile:
        return _buildRoute(const ProfileScreen());
      case reports:
        return _buildRoute(const ReportsScreen());
      case issueDetail:
        final report = settings.arguments as dynamic;
        return _buildRoute(IssueDetailScreen(report: report));
      default:
        return _buildRoute(const HomeScreen());
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(Widget page) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: RouteSettings(name: page.runtimeType.toString()),
    );
  }
}