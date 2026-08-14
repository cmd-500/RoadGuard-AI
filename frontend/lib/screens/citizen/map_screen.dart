import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/report_model.dart';
import '../../providers/report_provider.dart';
import '../../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  LatLng _center = const LatLng(GeoDefaults.defaultLat, GeoDefaults.defaultLng);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      context.read<ReportProvider>().fetchReports();
      final pos = await LocationService.getCurrentPosition();
      if (pos != null && mounted) {
        setState(() => _center = LatLng(pos.latitude, pos.longitude));
        _mapController.move(_center, 15);
      }
    });
  }

  void _openDetail(ReportModel report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _HazardDetailSheet(report: report),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _center, initialZoom: 14),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.roadguard.ai',
              ),
              MarkerLayer(
                markers: provider.reports
                    .map((r) => Marker(
                          point: LatLng(r.latitude, r.longitude),
                          width: 36,
                          height: 36,
                          child: GestureDetector(
                            onTap: () => _openDetail(r),
                            child: Icon(Icons.location_on, color: AppColors.severityColor(r.severity), size: 36),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          if (provider.isLoading) const Positioned(top: 12, left: 0, right: 0, child: Center(child: CircularProgressIndicator())),
          Positioned(
            bottom: 90,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'locate',
              backgroundColor: AppColors.surface,
              onPressed: () async {
                final pos = await LocationService.getCurrentPosition();
                if (pos != null) _mapController.move(LatLng(pos.latitude, pos.longitude), 15);
              },
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _HazardDetailSheet extends StatelessWidget {
  final ReportModel report;
  const _HazardDetailSheet({required this.report});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(report.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.severityColor(report.severity), borderRadius: BorderRadius.circular(6)),
                child: Text(report.severity, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Text(HazardType.label(report.hazardType), style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(report.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(report.description, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(report.address, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          if (report.verification.status == 'FLAGGED') ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.medium.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.flag_outlined, size: 16, color: AppColors.medium),
                  const SizedBox(width: 6),
                  Expanded(child: Text('Flagged for review: ${report.verification.reasons.join(', ')}', style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _VoteButton(
                icon: Icons.thumb_up_outlined,
                label: 'Real (${report.upvoteCount})',
                onTap: () => provider.vote(report.id, 'UPVOTE'),
              ),
              const SizedBox(width: 10),
              _VoteButton(
                icon: Icons.thumb_down_outlined,
                label: 'Not there (${report.downvoteCount})',
                onTap: () => provider.vote(report.id, 'DOWNVOTE'),
              ),
              const Spacer(),
              Text(report.communityStatus, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _VoteButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(horizontal: 10)),
    );
  }
}
