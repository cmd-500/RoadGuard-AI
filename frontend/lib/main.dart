import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/design_system/index.dart';
import 'core/routing/app_router.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/report_provider.dart';
import 'shared/providers/vote_provider.dart';
import 'shared/providers/location_provider.dart';
import 'shared/providers/alert_provider.dart';
import 'shared/repositories/auth_repository.dart';
import 'shared/repositories/report_repository.dart';
import 'shared/repositories/vote_repository.dart';
import 'shared/repositories/alert_repository.dart';
import 'shared/services/api_client.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const RoadSafeApp());
}

class RoadSafeApp extends StatelessWidget {
  const RoadSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();

    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(apiClient: apiClient),
        ),
        Provider<ReportRepository>(
          create: (_) => ReportRepositoryImpl(apiClient: apiClient),
        ),
        Provider<VoteRepository>(
          create: (_) => VoteRepositoryImpl(apiClient: apiClient),
        ),
        Provider<AlertRepository>(
          create: (_) => MockAlertRepositoryImpl(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            repository: context.read<AuthRepository>(),
          )..initialize(),
        ),
        ChangeNotifierProvider<ReportProvider>(
          create: (context) => ReportProvider(
            repository: context.read<ReportRepository>(),
          ),
        ),
        ChangeNotifierProvider<VoteProvider>(
          create: (context) => VoteProvider(
            repository: context.read<VoteRepository>(),
          ),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider()..requestPermission(),
        ),
        ChangeNotifierProvider<AlertProvider>(
          create: (context) => AlertProvider(
            repository: context.read<AlertRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'RoadSafe',
        debugShowCheckedModeBanner: false,
        theme: RoadSafeTheme.light,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.home,
      ),
    );
  }
}