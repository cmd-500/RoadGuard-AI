import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'citizen/map_screen.dart';
import 'citizen/report_hazard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoadGuard AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      // driver mode and admin/authority tools slot in here in later batches,
      // routed by user.role
      body: const MapScreen(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportHazardScreen())),
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Report Hazard'),
      ),
    );
  }
}

