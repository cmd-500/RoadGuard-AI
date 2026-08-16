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
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Issue Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(AppIcons.more, size: 24),
            onPressed: () => _showMoreMenu(context),
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildStatusTimeline(),
            const SizedBox(height: AppSpacing.xl),
            _buildLocationCard(),
            const SizedBox(height: AppSpacing.xl),
            _buildIssueDetails(),
            const SizedBox(height: AppSpacing.xl),
            _buildPhotos(),
            const SizedBox(height: AppSpacing.xl),
            _buildActions(),
            const SizedBox(height: AppSpacing.xxxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
              child: Image.network(
                report.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: AppColors.surfaceContainerLow,
                  child: Center(
                    child: Icon(AppIcons.image, size: 48, color: AppColors.textTertiary),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.hazardColor(report.hazardType.name).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Icon(
                        _getHazardIcon(report.hazardType),
                        size: 24,
                        color: AppColors.hazardColor(report.hazardType.name),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(report.title, style: AppTypography.titleLarge),
                          Text(
                            report.hazardTypeDisplay,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    AppSeverityBadge(severity: report.severityDisplay, showIcon: true),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Icon(AppIcons.mapPin, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        report.address,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(AppIcons.calendar, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _formatDateTime(report.createdAt),
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(AppIcons.badge, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'ID: ${report.id.substring(0, 8)}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    _buildStatusBadge(report.statusDisplay),
                    const SizedBox(width: AppSpacing.md),
                    _buildCommunityStatusBadge(report.communityStatusDisplay),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    AppStatus appStatus;
    switch (status.toLowerCase()) {
      case 'inprogress':
        appStatus = AppStatus.info;
        break;
      case 'resolved':
        appStatus = AppStatus.success;
        break;
      case 'rejected':
        appStatus = AppStatus.error;
        break;
      case 'pending':
        appStatus = AppStatus.pending;
        break;
      default:
        appStatus = AppStatus.info;
    }
    return AppStatusBadge(label: status, status: appStatus);
  }

  Widget _buildCommunityStatusBadge(String status) {
    return AppOutlineBadge(
      label: status,
      borderColor: AppColors.outlineStrong,
      textColor: AppColors.textSecondary,
    );
  }

  Widget _buildStatusTimeline() {
    final timelineItems = [
      _TimelineItem(
        title: 'Report Submitted',
        description: 'Your report has been submitted for review.',
        timestamp: _formatDateTime(report.createdAt),
        isCompleted: true,
      ),
      _TimelineItem(
        title: 'Under Review',
        description: 'Report is being verified by the team.',
        timestamp: report.status != ReportStatus.pending ? 'Completed' : 'Pending',
        isCompleted: report.status != ReportStatus.pending,
      ),
      _TimelineItem(
        title: 'Work Assigned',
        description: 'Maintenance team has been assigned.',
        timestamp: report.status == ReportStatus.inProgress || report.status == ReportStatus.resolved ? 'Completed' : 'Pending',
        isCompleted: report.status == ReportStatus.inProgress || report.status == ReportStatus.resolved,
      ),
      _TimelineItem(
        title: 'Issue Resolved',
        description: 'The hazard has been fixed and verified.',
        timestamp: report.status == ReportStatus.resolved ? 'Completed' : 'Pending',
        isCompleted: report.status == ReportStatus.resolved,
      ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Timeline', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          ...timelineItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == timelineItems.length - 1;
            return _TimelineItemWidget(item: item, isLast: isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(AppIcons.mapPin, size: 48, color: AppColors.textTertiary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Map Preview\n${report.latitude.toStringAsFixed(6)}, ${report.longitude.toStringAsFixed(6)}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Address', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                    Text(report.address, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coordinates', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                    Text(
                      '${report.latitude.toStringAsFixed(6)}, ${report.longitude.toStringAsFixed(6)}',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: 'View on Map',
            leadingIcon: AppIcons.mapPin,
            isFullWidth: true,
            onPressed: () => _openInMaps(report.latitude, report.longitude),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueDetails() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Issue Details', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPhotos() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Photos', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          if (report.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Image.network(
                report.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: AppColors.surfaceContainerLow,
                  child: Center(
                    child: Icon(AppIcons.image, size: 48, color: AppColors.textTertiary),
                  ),
                ),
              ),
            )
          else
            Center(
              child: Column(
                children: [
                  Icon(AppIcons.image, size: 48, color: AppColors.textTertiary),
                  const SizedBox(height: AppSpacing.md),
                  Text('No photos available', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
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
        AppSecondaryButton(
          label: 'Share Issue',
          leadingIcon: AppIcons.share,
          isFullWidth: true,
          onPressed: _shareIssue,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSecondaryButton(
          label: 'Save',
          leadingIcon: AppIcons.bookmark,
          isFullWidth: true,
          onPressed: () {},
        ),
        const SizedBox(height: AppSpacing.md),
        AppTertiaryButton(
          label: 'Report Incorrect Info',
          leadingIcon: AppIcons.flag,
          textColor: AppColors.error,
          onPressed: () {},
          isFullWidth: true,
        ),
      ],
    );
  }

  IconData _getHazardIcon(HazardType type) {
    switch (type) {
      case HazardType.pothole:
        return AppIcons.pothole;
      case HazardType.accident:
        return AppIcons.carCrash;
      case HazardType.fog:
        return AppIcons.cloudFog;
      case HazardType.speedBreaker:
      case HazardType.unmarkedBreaker:
      case HazardType.illegalBreaker:
        return AppIcons.speedBump;
      case HazardType.waterlogging:
      case HazardType.waterloggedHazard:
        return AppIcons.waves;
      case HazardType.roadDamage:
        return AppIcons.roadHorizon;
      case HazardType.construction:
        return AppIcons.hammer;
      case HazardType.emergency:
        return AppIcons.warningCircle;
      default:
        return AppIcons.warning;
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
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('More Options', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: Icon(AppIcons.share, color: AppColors.textPrimary),
              title: Text('Share', style: AppTypography.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _shareIssue();
              },
            ),
            ListTile(
              leading: Icon(AppIcons.bookmark, color: AppColors.textPrimary),
              title: Text('Save', style: AppTypography.bodyMedium),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(AppIcons.flag, color: AppColors.error),
              title: Text('Report Incorrect', style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
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

class _TimelineItem {
  final String title;
  final String description;
  final String timestamp;
  final bool isCompleted;

  const _TimelineItem({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
  });
}

class _TimelineItemWidget extends StatelessWidget {
  final _TimelineItem item;
  final bool isLast;

  const _TimelineItemWidget({
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: item.isCompleted ? AppColors.primary : AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.isCompleted ? AppColors.primary : AppColors.outline,
                    width: 2,
                  ),
                ),
                child: item.isCompleted
                    ? Icon(AppIcons.check, size: 14, color: AppColors.onPrimary)
                    : const SizedBox.shrink(),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
                    color: item.isCompleted ? AppColors.primary : AppColors.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: AppSpacing.sm),
                    if (item.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(AppRadius.badge),
                        ),
                        child: Text(
                          'Done',
                          style: AppTypography.overline.copyWith(color: AppColors.success),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight,
                          borderRadius: BorderRadius.circular(AppRadius.badge),
                        ),
                        child: Text(
                          'Pending',
                          style: AppTypography.overline.copyWith(color: AppColors.warning),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(item.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.xs),
                Text(item.timestamp, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}