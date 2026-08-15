import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/report.dart';

class IssueDetailScreen extends StatelessWidget {
  final Report report;

  const IssueDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoadSafeColors.background,
      appBar: RoadSafeAppBar(
        title: 'Issue Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(RoadSafeIcons.more, size: 24),
            onPressed: () => _showMoreMenu(context),
            padding: const EdgeInsets.only(right: RoadSafeSpacing.screenPadding),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopCard(),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildStatusTimeline(),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildLocationCard(),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildIssueDetails(),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildPhotos(),
            const SizedBox(height: RoadSafeSpacing.xl),
            _buildActions(),
            const SizedBox(height: RoadSafeSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return RoadSafeCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(RoadSafeRadius.xl)),
              child: Image.network(
                report.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: RoadSafeColors.backgroundAlt,
                  child: Center(
                    child: Icon(RoadSafeIcons.image, size: 48, color: RoadSafeColors.textTertiary),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(RoadSafeSpacing.lg),
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
                          Text(report.title, style: RoadSafeTypography.titleLarge),
                          Text(
                            report.hazardTypeDisplay,
                            style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    RoadSafeSeverityBadge(severity: report.severityDisplay),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.lg),
                Row(
                  children: [
                    Icon(RoadSafeIcons.mapPin, size: 16, color: RoadSafeColors.textTertiary),
                    const SizedBox(width: RoadSafeSpacing.xs),
                    Expanded(
                      child: Text(
                        report.address,
                        style: RoadSafeTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.sm),
                Row(
                  children: [
                    Icon(RoadSafeIcons.calendar, size: 16, color: RoadSafeColors.textTertiary),
                    const SizedBox(width: RoadSafeSpacing.xs),
                    Text(
                      _formatDateTime(report.createdAt),
                      style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                    ),
                    const SizedBox(width: RoadSafeSpacing.md),
                    Icon(RoadSafeIcons.idCard, size: 16, color: RoadSafeColors.textTertiary),
                    const SizedBox(width: RoadSafeSpacing.xs),
                    Text(
                      'ID: ${report.id.substring(0, 8)}',
                      style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: RoadSafeSpacing.lg),
                Row(
                  children: [
                    RoadSafeStatusBadge(status: report.statusDisplay),
                    const SizedBox(width: RoadSafeSpacing.md),
                    RoadSafeCommunityStatusBadge(status: report.communityStatusDisplay),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    final timelineItems = [
      RoadSafeTimelineItem(
        title: 'Report Submitted',
        description: 'Your report has been submitted for review.',
        timestamp: _formatDateTime(report.createdAt),
      ),
      RoadSafeTimelineItem(
        title: 'Work Assigned',
        description: 'Maintenance team has been assigned.',
        timestamp: 'Pending',
      ),
      RoadSafeTimelineItem(
        title: 'Work In Progress',
        description: 'Repairs are currently underway.',
        timestamp: 'Pending',
      ),
      RoadSafeTimelineItem(
        title: 'Issue Resolved',
        description: 'The hazard has been fixed and verified.',
        timestamp: 'Pending',
      ),
    ];

    int currentIndex = 0;
    switch (report.status) {
      case ReportStatus.pending:
        currentIndex = 0;
        break;
      case ReportStatus.inProgress:
        currentIndex = 2;
        break;
      case ReportStatus.resolved:
        currentIndex = 3;
        break;
      case ReportStatus.rejected:
        currentIndex = 0;
        break;
    }

    return RoadSafeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Timeline', style: RoadSafeTypography.headlineSmall),
          const SizedBox(height: RoadSafeSpacing.lg),
          RoadSafeStatusTimeline(
            items: timelineItems,
            currentIndex: currentIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return RoadSafeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: RoadSafeTypography.headlineSmall),
          const SizedBox(height: RoadSafeSpacing.lg),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: RoadSafeColors.backgroundAlt,
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(RoadSafeIcons.mapPin, size: 48, color: RoadSafeColors.textTertiary),
                  const SizedBox(height: RoadSafeSpacing.sm),
                  Text(
                    'Map Preview\n${report.latitude.toStringAsFixed(6)}, ${report.longitude.toStringAsFixed(6)}',
                    style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: RoadSafeSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Address', style: RoadSafeTypography.labelSmall.copyWith(color: RoadSafeColors.textTertiary)),
                    Text(report.address, style: RoadSafeTypography.bodyMedium),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coordinates', style: RoadSafeTypography.labelSmall.copyWith(color: RoadSafeColors.textTertiary)),
                    Text(
                      '${report.latitude.toStringAsFixed(6)}, ${report.longitude.toStringAsFixed(6)}',
                      style: RoadSafeTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RoadSafeSpacing.lg),
          RoadSafePrimaryButton(
            label: 'View on Map',
            leadingIcon: RoadSafeIcons.mapPin,
            isFullWidth: true,
            onPressed: () => _openInMaps(report.latitude, report.longitude),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueDetails() {
    return RoadSafeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Issue Details', style: RoadSafeTypography.headlineSmall),
          const SizedBox(height: RoadSafeSpacing.lg),
          _buildDetailRow('Category', report.hazardTypeDisplay),
          _buildDetailRow('Description', report.description.isNotEmpty ? report.description : 'No description provided'),
          _buildDetailRow('Reported By', report.creator?.name ?? 'Anonymous'),
          _buildDetailRow('Device', 'Mobile App'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: RoadSafeSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: RoadSafeTypography.labelSmall.copyWith(color: RoadSafeColors.textTertiary)),
          const SizedBox(height: RoadSafeSpacing.xs),
          Text(value, style: RoadSafeTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPhotos() {
    return RoadSafeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Photos', style: RoadSafeTypography.headlineSmall),
          const SizedBox(height: RoadSafeSpacing.lg),
          if (report.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              child: Image.network(
                report.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: RoadSafeColors.backgroundAlt,
                  child: Center(
                    child: Icon(RoadSafeIcons.image, size: 48, color: RoadSafeColors.textTertiary),
                  ),
                ),
              ),
            )
          else
            Center(
              child: Column(
                children: [
                  Icon(RoadSafeIcons.image, size: 48, color: RoadSafeColors.textTertiary),
                  const SizedBox(height: RoadSafeSpacing.md),
                  Text('No photos available', style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        RoadSafeSecondaryButton(
          label: 'Share Issue',
          leadingIcon: RoadSafeIcons.share,
          isFullWidth: true,
          onPressed: _shareIssue,
        ),
        const SizedBox(height: RoadSafeSpacing.md),
        RoadSafeSecondaryButton(
          label: 'Save',
          leadingIcon: RoadSafeIcons.bookmark,
          isFullWidth: true,
          onPressed: () {},
        ),
        const SizedBox(height: RoadSafeSpacing.md),
        RoadSafeTextButton(
          label: 'Report Incorrect Info',
          leadingIcon: RoadSafeIcons.flag,
          textColor: RoadSafeColors.error,
          onPressed: () {},
        ),
      ],
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showMoreMenu(BuildContext context) {
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
          children: [
            Text('More Options', style: RoadSafeTypography.headlineSmall),
            const SizedBox(height: RoadSafeSpacing.lg),
            ListTile(
              leading: Icon(RoadSafeIcons.share, color: RoadSafeColors.textPrimary),
              title: Text('Share', style: RoadSafeTypography.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _shareIssue();
              },
            ),
            ListTile(
              leading: Icon(RoadSafeIcons.bookmark, color: RoadSafeColors.textPrimary),
              title: Text('Save', style: RoadSafeTypography.bodyMedium),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(RoadSafeIcons.flag, color: RoadSafeColors.error),
              title: Text('Report Incorrect', style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _shareIssue() {
    // Implement share functionality
  }

  Future<void> _openInMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}