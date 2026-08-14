import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/report.dart';
import '../../shared/providers/report_provider.dart';
import '../../shared/providers/auth_provider.dart';
import 'issue_detail_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedTab = 'My Reports';
  String _selectedStatus = 'All';
  final List<String> _tabs = ['My Reports', 'Watched'];
  final List<String> _statusFilters = ['All', 'Open', 'In Progress', 'Resolved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: RoadSafeColors.background,
      appBar: RoadSafeAppBar(
        title: 'My Reports',
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.magnifyingGlass, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: RoadSafeSpacing.screenPadding),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          _buildStatusFilters(),
          Expanded(
            child: reportProvider.isLoading && reportProvider.reports.isEmpty
                ? const Center(child: RoadSafeCircularProgress())
                : _buildReportsList(reportProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: RoadSafeColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.screenPadding, vertical: RoadSafeSpacing.md),
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = _selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: RoadSafeSpacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? RoadSafeColors.primary : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: RoadSafeTypography.titleMedium.copyWith(
                    color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Container(
      color: RoadSafeColors.surface,
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: RoadSafeSpacing.screenPadding, vertical: RoadSafeSpacing.sm),
        itemCount: _statusFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: RoadSafeSpacing.sm),
        itemBuilder: (context, index) {
          final status = _statusFilters[index];
          final isSelected = _selectedStatus == status;
          return ChoiceChip(
            label: Text(status, style: RoadSafeTypography.labelMedium),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedStatus = status),
            selectedColor: RoadSafeColors.primaryContainer,
            backgroundColor: RoadSafeColors.background,
            labelStyle: RoadSafeTypography.labelMedium.copyWith(
              color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textSecondary,
            ),
            side: BorderSide(
              color: isSelected ? RoadSafeColors.primary : RoadSafeColors.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RoadSafeRadius.round),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: RoadSafeSpacing.md,
              vertical: RoadSafeSpacing.xs,
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportsList(ReportProvider provider) {
    if (provider.reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIconsRegular.folderOpen, size: 64, color: RoadSafeColors.textTertiary),
            const SizedBox(height: RoadSafeSpacing.lg),
            Text(
              'No reports yet',
              style: RoadSafeTypography.headlineSmall,
            ),
            const SizedBox(height: RoadSafeSpacing.md),
            Text(
              'Start reporting hazards to see them here',
              style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
            ),
            const SizedBox(height: RoadSafeSpacing.xl),
            RoadSafePrimaryButton(
              label: 'Report Issue',
              leadingIcon: PhosphorIconsRegular.plus,
              isFullWidth: false,
              onPressed: () {},
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
      itemCount: provider.reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: RoadSafeSpacing.md),
      itemBuilder: (context, index) {
        final report = provider.reports[index];
        return RoadSafeReportCard(
          title: report.title,
          hazardType: report.hazardTypeDisplay,
          location: report.address,
          dateTime: _formatDateTime(report.createdAt),
          status: report.statusDisplay,
          statusMessage: _getStatusMessage(report.status, report.updatedAt),
          imageUrl: report.imageUrl,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => IssueDetailScreen(report: report)),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    }
    return 'Just now';
  }

  String _getStatusMessage(ReportStatus status, DateTime updatedAt) {
    switch (status) {
      case ReportStatus.inProgress:
        return 'Work has been assigned to the maintenance team.';
      case ReportStatus.resolved:
        return 'Issue resolved.';
      case ReportStatus.rejected:
        return 'Report rejected.';
      case ReportStatus.pending:
        return 'Awaiting review.';
      default:
        return 'Status updated ${_formatDateTime(updatedAt)}';
    }
  }
}