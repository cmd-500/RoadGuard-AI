import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';
import '../../shared/models/report.dart';
import '../../shared/providers/report_provider.dart';
import '../../shared/providers/location_provider.dart';
import 'issue_details_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final List<String> _steps = ['Issue Details', 'Add Photo', 'Review'];

  HazardType? _selectedHazardType;
  Severity _selectedSeverity = Severity.medium;
  String _selectedWhen = 'Just now';
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Position? _selectedLocation;

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
      backgroundColor: RoadSafeColors.background,
       appBar: RoadSafeAppBar(
        title: 'Report Issue',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(RoadSafeIcons.info, size: 24),
            onPressed: _showInfoDialog,
            padding: const EdgeInsets.only(right: RoadSafeSpacing.screenPadding),
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
      color: RoadSafeColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: RoadSafeSpacing.screenPadding,
        vertical: RoadSafeSpacing.lg,
      ),
      child: RoadSafeCombinedProgress(
        steps: _steps,
        currentStep: _currentStep,
      ),
    );
  }

  Widget _buildIssueDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Issue Type', style: RoadSafeTypography.headlineSmall),
          const SizedBox(height: RoadSafeSpacing.md),
          _buildHazardTypeSelector(),
          const SizedBox(height: RoadSafeSpacing.xl),
          Text('Severity', style: RoadSafeTypography.headlineSmall),
          const SizedBox(height: RoadSafeSpacing.md),
          _buildSeveritySelector(),
          const SizedBox(height: RoadSafeSpacing.xl),
          _buildLocationField(),
          const SizedBox(height: RoadSafeSpacing.xl),
          _buildDetailsField(),
          const SizedBox(height: RoadSafeSpacing.xl),
          _buildWhenSelector(),
          const SizedBox(height: RoadSafeSpacing.xl),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHazardTypeSelector() {
    final hazardTypes = [
      ('Pothole', HazardType.pothole, RoadSafeIcons.pothole),
      ('Accident', HazardType.accident, RoadSafeIcons.carCrash),
      ('Fog', HazardType.fog, RoadSafeIcons.cloudFog),
      ('Speed Breaker', HazardType.speedBreaker, RoadSafeIcons.speedBump),
      ('Waterlogging', HazardType.waterlogging, RoadSafeIcons.waves),
      ('Road Damage', HazardType.roadDamage, RoadSafeIcons.roadHorizon),
      ('Construction', HazardType.construction, RoadSafeIcons.hammer),
      ('Other', HazardType.other, RoadSafeIcons.warning),
    ];

    return Wrap(
      spacing: RoadSafeSpacing.md,
      runSpacing: RoadSafeSpacing.md,
      children: hazardTypes.map((type) {
        final isSelected = _selectedHazardType == type.$2;
        return GestureDetector(
          onTap: () => setState(() => _selectedHazardType = type.$2),
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(RoadSafeSpacing.md),
            decoration: BoxDecoration(
              color: isSelected ? RoadSafeColors.primaryContainer : RoadSafeColors.surface,
              borderRadius: BorderRadius.circular(RoadSafeRadius.xl),
              border: Border.all(
                color: isSelected ? RoadSafeColors.primary : RoadSafeColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  type.$3,
                  size: 32,
                  color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textSecondary,
                ),
                const SizedBox(height: RoadSafeSpacing.sm),
                Text(
                  type.$1,
                  style: RoadSafeTypography.labelMedium.copyWith(
                    color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeveritySelector() {
    final severities = [
      (Severity.low, 'Low', 'Minor issue', RoadSafeIcons.circle, RoadSafeColors.low),
      (Severity.medium, 'Medium', 'Noticeable hazard', RoadSafeIcons.warning, RoadSafeColors.medium),
      (Severity.high, 'High', 'Dangerous condition', RoadSafeIcons.warningCircle, RoadSafeColors.high),
      (Severity.critical, 'Critical', 'Immediate danger', RoadSafeIcons.warningOctagon, RoadSafeColors.critical),
    ];

    return Column(
      children: severities.map((severity) {
        final isSelected = _selectedSeverity == severity.$1;
        return Container(
          margin: const EdgeInsets.only(bottom: RoadSafeSpacing.sm),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedSeverity = severity.$1),
              borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
              child: Container(
                padding: const EdgeInsets.all(RoadSafeSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? severity.$5.withValues(alpha: 0.1) : RoadSafeColors.surface,
                  borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
                  border: Border.all(
                    color: isSelected ? severity.$5 : RoadSafeColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? severity.$5 : severity.$5.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(RoadSafeRadius.md),
                      ),
                      child: Icon(
                        severity.$4,
                        size: 20,
                        color: isSelected ? RoadSafeColors.textOnPrimary : severity.$5,
                      ),
                    ),
                    const SizedBox(width: RoadSafeSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            severity.$2,
                            style: RoadSafeTypography.titleMedium.copyWith(
                              color: isSelected ? severity.$5 : RoadSafeColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          Text(
                            severity.$3,
                            style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(RoadSafeIcons.checkCircle, size: 24, color: severity.$5),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.md),
        RoadSafeTextField(
          label: 'Current Location',
          hint: 'Auto-detected from GPS',
          controller: _locationController,
          readOnly: true,
          prefixIcon: RoadSafeIcons.location,
          suffixIcon: RoadSafeIcons.gps,
          onSuffixPressed: _loadCurrentLocation,
        ),
      ],
    );
  }

  Widget _buildDetailsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details (Optional)', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.md),
        RoadSafeTextField(
          hint: 'Add any additional details...',
          controller: _detailsController,
          maxLines: 4,
          maxLength: 200,
          prefixIcon: RoadSafeIcons.note,
        ),
      ],
    );
  }

  Widget _buildWhenSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('When did you see this?', style: RoadSafeTypography.headlineSmall),
        const SizedBox(height: RoadSafeSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildWhenOption('Just now', 'Just now'),
            ),
            const SizedBox(width: RoadSafeSpacing.md),
            Expanded(
              child: _buildWhenOption('Earlier', 'Earlier'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWhenOption(String label, String value) {
    final isSelected = _selectedWhen == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedWhen = value),
      child: Container(
        padding: const EdgeInsets.all(RoadSafeSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? RoadSafeColors.primaryContainer : RoadSafeColors.surface,
          borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
          border: Border.all(
            color: isSelected ? RoadSafeColors.primary : RoadSafeColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: RoadSafeTypography.titleMedium.copyWith(
            color: isSelected ? RoadSafeColors.primary : RoadSafeColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return RoadSafeInfoCard(
      title: 'Help keep roads safe for everyone',
      message: 'Your report will be verified by AI and the community.',
      icon: PhosphorIconsRegular.shieldCheck,
      backgroundColor: RoadSafeColors.successLight,
      borderColor: RoadSafeColors.success,
    );
  }

  Widget _buildAddPhotoStep() {
    return CameraCaptureScreen(
      onPhotoCaptured: (imagePath) {
        // Navigate to review step
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
      padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Your Report', style: RoadSafeTypography.headlineMedium),
          const SizedBox(height: RoadSafeSpacing.xs),
          Text(
            'Please review the details before submitting',
            style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
          ),
          const SizedBox(height: RoadSafeSpacing.xl),
          _buildReviewSection('Issue Type', _selectedHazardType?.name.replaceAll('_', ' ').toUpperCase() ?? 'Not selected'),
          _buildReviewSection('Severity', _selectedSeverity.name.toUpperCase()),
          _buildReviewSection('Location', _locationController.text.isNotEmpty ? _locationController.text : 'Not set'),
          _buildReviewSection('Reported On', _selectedWhen),
          _buildReviewSection('Details', _detailsController.text.isNotEmpty ? _detailsController.text : 'No details provided'),
          const SizedBox(height: RoadSafeSpacing.xl),
          if (_selectedLocation != null)
            _buildLocationPreview(),
          const SizedBox(height: RoadSafeSpacing.xl),
          _buildInfoCard(),
          const SizedBox(height: RoadSafeSpacing.xl),
          RoadSafePrimaryButton(
            label: 'Submit Report',
            leadingIcon: PhosphorIconsRegular.paperPlane,
            onPressed: _submitReport,
            isLoading: context.watch<ReportProvider>().isSubmitting,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: RoadSafeSpacing.md),
      padding: const EdgeInsets.all(RoadSafeSpacing.lg),
      decoration: BoxDecoration(
        color: RoadSafeColors.surface,
        borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
        border: Border.all(color: RoadSafeColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: RoadSafeTypography.labelSmall.copyWith(color: RoadSafeColors.textTertiary),
          ),
          const SizedBox(height: RoadSafeSpacing.xs),
          Text(
            value,
            style: RoadSafeTypography.titleMedium,
          ),
          const SizedBox(height: RoadSafeSpacing.sm),
          RoadSafeTextButton(
            label: 'Edit',
            leadingIcon: PhosphorIconsRegular.pencil,
            onPressed: () {
              // Navigate back to appropriate step
              if (label == 'Location') {
                setState(() => _currentStep = 0);
                _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPreview() {
    return Container(
      padding: const EdgeInsets.all(RoadSafeSpacing.lg),
      decoration: BoxDecoration(
        color: RoadSafeColors.surface,
        borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
        border: Border.all(color: RoadSafeColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location Preview', style: RoadSafeTypography.titleMedium),
          const SizedBox(height: RoadSafeSpacing.md),
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
                  Icon(PhosphorIconsRegular.map, size: 48, color: RoadSafeColors.textTertiary),
                  const SizedBox(height: RoadSafeSpacing.sm),
                  Text(
                    'Map Preview\n${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                    style: RoadSafeTypography.bodySmall.copyWith(color: RoadSafeColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RoadSafeRadius.xl)),
        title: Text('Report Issue', style: RoadSafeTypography.headlineSmall),
        content: Text(
          'Help keep roads safe by reporting hazards. Your report will be verified by AI and community members.',
          style: RoadSafeTypography.bodyMedium,
        ),
        actions: [
          RoadSafeTextButton(
            label: 'Got it',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_selectedHazardType == null || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select issue type and ensure location is set', style: RoadSafeTypography.bodyMedium),
          backgroundColor: RoadSafeColors.error,
        ),
      );
      return;
    }

    final success = await context.read<ReportProvider>().createReport(
      title: _selectedHazardType!.name.replaceAll('_', ' ').toUpperCase(),
      description: _detailsController.text,
      address: _locationController.text,
      hazardType: _selectedHazardType!,
      severity: _selectedSeverity,
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      imagePath: '', // Will be handled by camera screen
    );

    if (success != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report submitted successfully!', style: RoadSafeTypography.bodyMedium),
          backgroundColor: RoadSafeColors.success,
        ),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _selectedHazardType = null;
      _selectedSeverity = Severity.medium;
      _selectedWhen = 'Just now';
      _detailsController.clear();
      _selectedLocation = null;
    });
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(RoadSafeSpacing.screenPadding),
      decoration: BoxDecoration(
        color: RoadSafeColors.surface,
        boxShadow: [
          BoxShadow(
            color: RoadSafeColors.shadow,
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
                child: RoadSafeSecondaryButton(
                  label: 'Back',
                  leadingIcon: PhosphorIconsRegular.arrowLeft,
                  onPressed: () {
                    setState(() => _currentStep--);
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: RoadSafeSpacing.md),
            Expanded(
              child: RoadSafePrimaryButton(
                label: _currentStep == 2 ? 'Submit Report' : 'Next',
                trailingIcon: _currentStep == 2 ? null : PhosphorIconsRegular.arrowRight,
                onPressed: _currentStep == 0
                    ? (_selectedHazardType != null && _selectedLocation != null
                        ? () {
                            setState(() => _currentStep++);
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null)
                    : _currentStep == 1
                        ? null // Handled by camera screen
                        : _submitReport,
                isLoading: _currentStep == 2 && context.watch<ReportProvider>().isSubmitting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}