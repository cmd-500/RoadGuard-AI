import 'package:flutter/material.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'My Reports',
        actions: [
          IconButton(
            icon: Icon(AppIcons.search, size: 24),
            onPressed: () {},
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          _buildStatusFilters(),
          Expanded(
            child: reportProvider.isLoading && reportProvider.reports.isEmpty
                ? const Center(child: AppCircularProgress())
                : _buildReportsList(reportProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.md),
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = _selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: AppTypography.titleMedium.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
      color: AppColors.surface,
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
        itemCount: _statusFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final status = _statusFilters[index];
          final isSelected = _selectedStatus == status;
          return ChoiceChip(
            label: Text(status, style: AppTypography.labelMedium),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedStatus = status),
            selectedColor: AppColors.primaryContainer,
            backgroundColor: AppColors.background,
            labelStyle: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.outline,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
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
            Icon(AppIcons.folderOpen, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No reports yet',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Start reporting hazards to see them here',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              label: 'Report Issue',
              leadingIcon: AppIcons.plus,
              isFullWidth: false,
              onPressed: () {},
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: provider.reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final report = provider.reports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(dynamic report) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => IssueDetailScreen(report: report)),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppHazardIcon(
                hazardType: report.hazardTypeDisplay,
                size: AppHazardIconSize.medium,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      report.address,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppStatusBadge(
                label: report.statusDisplay,
                status: _getStatusEnum(report.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (report.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  report.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceContainerLow,
                    child: Icon(AppIcons.image, color: AppColors.textTertiary, size: 32),
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(AppIcons.clock, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatDateTime(report.createdAt),
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppStatus _getStatusEnum(dynamic status) {
    switch (status.toString().toLowerCase()) {
      case 'inprogress':
        return AppStatus.info;
      case 'resolved':
        return AppStatus.success;
      case 'rejected':
        return AppStatus.error;
      case 'pending':
        return AppStatus.pending;
      default:
        return AppStatus.info;
    }
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
}