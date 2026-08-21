import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/report.dart';
import '../../shared/providers/report_provider.dart';
import '../../shared/providers/location_provider.dart';
import '../../services/report_service.dart';
import 'camera_capture_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final List<String> _steps = ['Issue Details', 'Add Photo', 'Review'];

  HazardType? _selectedHazardType;
  Severity? _selectedSeverity;
  String _selectedWhen = 'Just now';
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Position? _selectedLocation;
  Uint8List? _capturedImageBytes;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final locationProvider = context.read<LocationProvider>();
    if (locationProvider.currentPosition != null) {
      setState(() {
        _selectedLocation = locationProvider.currentPosition!;
        _locationController.text = locationProvider.currentAddress ?? '';
      });
    } else {
      await locationProvider.getCurrentLocation();
      if (locationProvider.currentPosition != null) {
        setState(() {
          _selectedLocation = locationProvider.currentPosition!;
          _locationController.text = locationProvider.currentAddress ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _detailsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Report Issue',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(AppIcons.info, size: 24),
            onPressed: _showInfoDialog,
            padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildIssueDetailsStep(),
                _buildAddPhotoStep(),
                _buildReviewStep(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.lg,
      ),
      child: AppCombinedProgress(
        steps: _steps,
        currentStep: _currentStep,
      ),
    );
  }

  Widget _buildIssueDetailsStep() {
    final locationProvider = context.watch<LocationProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Issue Type', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          _buildHazardTypeSelector(),
          const SizedBox(height: AppSpacing.xl),
          Text('Severity', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          _buildSeveritySelector(),
          const SizedBox(height: AppSpacing.xl),
          _buildLocationField(locationProvider),
          const SizedBox(height: AppSpacing.xl),
          _buildDetailsField(),
          const SizedBox(height: AppSpacing.xl),
          _buildWhenSelector(),
          const SizedBox(height: AppSpacing.xl),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHazardTypeSelector() {
    final hazardTypes = [
      ('Pothole', HazardType.pothole, AppIcons.pothole, AppColors.hazardColor('POTHOLE')),
      ('Accident', HazardType.accident, AppIcons.carCrash, AppColors.hazardColor('ACCIDENT')),
      ('Fog', HazardType.fog, AppIcons.cloudFog, AppColors.hazardColor('FOG')),
      ('Speed Breaker', HazardType.speedBreaker, AppIcons.speedBump, AppColors.hazardColor('SPEED_BREAKER')),
      ('Waterlogging', HazardType.waterlogging, AppIcons.waves, AppColors.hazardColor('WATERLOGGING')),
      ('Road Damage', HazardType.roadDamage, AppIcons.roadHorizon, AppColors.hazardColor('ROAD_DAMAGE')),
      ('Construction', HazardType.construction, AppIcons.hammer, AppColors.hazardColor('CONSTRUCTION')),
      ('Other', HazardType.other, AppIcons.warning, AppColors.hazardColor('OTHER')),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final crossAxisCount = availableWidth > 600 ? 4 : (availableWidth > 400 ? 3 : 2);
        final itemWidth = (availableWidth - (AppSpacing.md * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: hazardTypes.map((type) {
            final isSelected = _selectedHazardType == type.$2;
            final color = type.$4;
            final lightColor = AppColors.hazardLightColor(type.$2.name);
            return SizedBox(
              width: itemWidth,
              child: GestureDetector(
                onTap: () => setState(() => _selectedHazardType = type.$2),
                child: AnimatedContainer(
                  duration: AppMotion.fadeIn,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected ? lightColor : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: isSelected ? color : AppColors.outline,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ] : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? color : lightColor,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Icon(
                          type.$3,
                          size: 24,
                          color: isSelected ? AppColors.onPrimary : color,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          type.$1,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected ? color : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSeveritySelector() {

    final severities = [
      (Severity.low, 'Low', 'Minor issue', AppIcons.circle, 'LOW'),
      (Severity.medium, 'Medium', 'Noticeable hazard', AppIcons.warning, 'MEDIUM'),
      (Severity.high, 'High', 'Dangerous condition', AppIcons.warningCircle, 'HIGH'),
    ];

    return Column(
      children: severities.map((severity) {
        final isSelected = _selectedSeverity == severity.$1;
        final color = AppColors.severityColor(severity.$5);
        final lightColor = AppColors.severityLightColor(severity.$5);

        return AnimatedContainer(
          duration: AppMotion.fadeIn,
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedSeverity = severity.$1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isSelected ? color : AppColors.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        severity.$4,
                        size: 22,
                        color: isSelected ? AppColors.onPrimary : color,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            severity.$2,
                            style: AppTypography.titleMedium.copyWith(
                              color: isSelected ? color : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          Text(
                            severity.$3,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(AppIcons.checkCircle, size: 24, color: color),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationField(LocationProvider locationProvider) {
    final showError = !locationProvider.isLoading &&
        locationProvider.error != null &&
        _selectedLocation == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: AppTypography.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Current Location',
          hint: locationProvider.isLoading ? 'Detecting your location…' : 'Auto-detected from GPS',
          controller: _locationController,
          readOnly: true,
          prefixIcon: AppIcons.location,
          suffixIcon: locationProvider.isLoading ? null : AppIcons.gps,
          onSuffixPressed: locationProvider.isLoading ? null : _loadCurrentLocation,
        ),
        if (locationProvider.isLoading) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const AppCircularProgress(size: 14),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Fetching current location…',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ] else if (showError) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AppIcons.warningCircle, size: 16, color: AppColors.error),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  locationProvider.error!,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                ),
              ),
              AppTertiaryButton(label: 'Retry', onPressed: _loadCurrentLocation, isFullWidth: false),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDetailsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details (Optional)', style: AppTypography.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        AppTextArea(
          hint: 'Add any additional details...',
          controller: _detailsController,
          maxLines: 4,
          maxLength: 200,
        ),
      ],
    );
  }

  Widget _buildWhenSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('When did you see this?', style: AppTypography.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = (constraints.maxWidth - AppSpacing.md) / 2;
            return Row(
              children: [
                SizedBox(
                  width: buttonWidth,
                  child: _buildWhenOption('Just now', 'Just now'),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: buttonWidth,
                  child: _buildWhenOption('Earlier', 'Earlier'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildWhenOption(String label, String value) {
    final isSelected = _selectedWhen == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedWhen = value),
      child: AnimatedContainer(
        duration: AppMotion.fadeIn,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.titleMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return AppInfoCard(
      title: 'Help keep roads safe for everyone',
      message: 'Your report will be verified by AI and the community.',
      icon: AppIcons.shieldCheck,
      backgroundColor: AppColors.successLight,
      borderColor: AppColors.success,
    );
  }

  Widget _buildAddPhotoStep() {
    return CameraCaptureScreen(
      onPhotoCaptured: (imageBytes, imageName) {
        setState(() => _capturedImageBytes = imageBytes);

        setState(() => _currentStep = 2);
        _pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Your Report', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Please review the details before submitting',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildReviewSection('Issue Type', _selectedHazardType?.name.replaceAll('_', ' ').toUpperCase() ?? 'Not selected'),
          _buildReviewSection('Severity', _selectedSeverity?.name.toUpperCase() ?? 'Not selected'),
          _buildReviewSection('Location', _locationController.text.isNotEmpty ? _locationController.text : 'Not set'),
          _buildReviewSection('Reported On', _selectedWhen),
          _buildReviewSection('Details', _detailsController.text.isNotEmpty ? _detailsController.text : 'No details provided'),
          const SizedBox(height: AppSpacing.xl),
          if (_selectedLocation != null)
            _buildLocationPreview(),
          const SizedBox(height: AppSpacing.xl),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String label, String value) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTertiaryButton(
            label: 'Edit',
            leadingIcon: AppIcons.edit,
            onPressed: () {
              if (label == 'Location') {
                setState(() => _currentStep = 0);
                _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPreview() {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location Preview', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox(
              height: 150,
              child: IgnorePointer(

                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      _selectedLocation!.latitude,
                      _selectedLocation!.longitude,
                    ),
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.roadsafes.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            _selectedLocation!.latitude,
                            _selectedLocation!.longitude,
                          ),
                          width: 40,
                          height: 40,
                          child: Icon(
                            AppIcons.mapPin,
                            size: 36,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Report Issue', style: AppTypography.headlineSmall),
        content: Text(
          'Help keep roads safe by reporting hazards. Your report will be verified by AI and community members.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          AppTertiaryButton(
            label: 'Got it',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_selectedHazardType == null || _selectedLocation == null || _selectedSeverity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select issue type and ensure location is set', style: AppTypography.bodyMedium),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final imageBytes = _capturedImageBytes;
    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please capture a photo', style: AppTypography.bodyMedium),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      final created = await ReportService.createReport(
        title: _selectedHazardType!.name.replaceAll('_', ' ').toUpperCase(),
        description: _detailsController.text,
        address: _locationController.text,
        hazardType: _selectedHazardType!.toBackendName(),
        severity: _selectedSeverity!.toBackendName(),
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        imageFile: imageBytes,
        imageName: 'report_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report submitted successfully!', style: AppTypography.bodyMedium),
            backgroundColor: AppColors.success,
          ),
        );
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e', style: AppTypography.bodyMedium),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Uint8List? _getCapturedImage() {
    return _capturedImageBytes;
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _selectedHazardType = null;
      _selectedSeverity = null;
      _selectedWhen = 'Just now';
      _detailsController.clear();
      _selectedLocation = null;
      _capturedImageBytes = null;
    });
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: AppSecondaryButton(
                  label: 'Back',
                  leadingIcon: AppIcons.back,
                  onPressed: () {
                    setState(() => _currentStep--);
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppPrimaryButton(
                label: _currentStep == 2 ? 'Submit Report' : 'Next',
                trailingIcon: _currentStep == 2 ? null : AppIcons.forward,
                onPressed: _currentStep == 0
                    ? (_selectedHazardType != null && _selectedLocation != null && _selectedSeverity != null
                    ? () {
                  setState(() => _currentStep++);
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
                    : null)
                    : _currentStep == 1
                    ? null
                    : _submitReport,
                isLoading: _currentStep == 2 && context.watch<ReportProvider>().isSubmitting,
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}