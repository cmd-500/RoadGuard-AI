// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:roadguard_ai/main.dart';
import 'package:roadguard_ai/shared/providers/auth_provider.dart';
import 'package:roadguard_ai/shared/providers/report_provider.dart';
import 'package:roadguard_ai/shared/providers/vote_provider.dart';
import 'package:roadguard_ai/shared/providers/location_provider.dart';
import 'package:roadguard_ai/shared/repositories/auth_repository.dart';
import 'package:roadguard_ai/shared/repositories/report_repository.dart';
import 'package:roadguard_ai/shared/repositories/vote_repository.dart';
import 'package:roadguard_ai/shared/services/api_client.dart';

void main() {
  testWidgets('RoadSafe app loads home screen', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authRepo = AuthRepositoryImpl(apiClient: apiClient);
    final reportRepo = ReportRepositoryImpl(apiClient: apiClient);
    final voteRepo = VoteRepositoryImpl(apiClient: apiClient);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          Provider<AuthRepository>.value(value: authRepo),
          Provider<ReportRepository>.value(value: reportRepo),
          Provider<VoteRepository>.value(value: voteRepo),
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(repository: authRepo),
          ),
          ChangeNotifierProvider<ReportProvider>(
            create: (_) => ReportProvider(repository: reportRepo),
          ),
          ChangeNotifierProvider<VoteProvider>(
            create: (_) => VoteProvider(repository: voteRepo),
          ),
          ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider(),
          ),
        ],
        child: const RoadSafeApp(),
      ),
    );

    // Wait for initialization
    await tester.pumpAndSettle();

    // Verify home screen loads - check for greeting text
    expect(find.textContaining('Good'), findsOneWidget);
    expect(find.text('Let\'s make your journey safe today.'), findsOneWidget);
  });

  testWidgets('Bottom navigation has 5 tabs', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authRepo = AuthRepositoryImpl(apiClient: apiClient);
    final reportRepo = ReportRepositoryImpl(apiClient: apiClient);
    final voteRepo = VoteRepositoryImpl(apiClient: apiClient);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          Provider<AuthRepository>.value(value: authRepo),
          Provider<ReportRepository>.value(value: reportRepo),
          Provider<VoteRepository>.value(value: voteRepo),
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(repository: authRepo),
          ),
          ChangeNotifierProvider<ReportProvider>(
            create: (_) => ReportProvider(repository: reportRepo),
          ),
          ChangeNotifierProvider<VoteProvider>(
            create: (_) => VoteProvider(repository: voteRepo),
          ),
          ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider(),
          ),
        ],
        child: const RoadSafeApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Check all 5 navigation tabs exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    // Report is the center FAB
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}