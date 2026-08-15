import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';

class CameraCaptureScreen extends StatefulWidget {
  final Function(String imagePath) onPhotoCaptured;

  const CameraCaptureScreen({
    super.key,
    required this.onPhotoCaptured,
  });

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;
  bool _isCapturing = false;
  XFile? _capturedImage;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _error = 'No camera available');
        return;
      }

      _controller = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (!mounted) return;
      setState(() => _isInitialized = true);
    } catch (e) {
      setState(() => _error = 'Failed to initialize camera: ${e.toString()}');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeCamera();
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      final image = await controller.takePicture();
      setState(() {
        _capturedImage = image;
        _isCapturing = false;
      });

      if (mounted) {
        widget.onPhotoCaptured(image.path);
      }
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _error = 'Failed to capture photo: ${e.toString()}';
      });
    }
  }

  void _retakePhoto() {
    setState(() => _capturedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && !_isInitialized) {
      return _buildErrorState();
    }

    if (!_isInitialized) {
      return _buildLoadingState();
    }

    if (_capturedImage != null) {
      return _buildPreviewState();
    }

    return _buildCameraView();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoadSafeCircularProgress(size: 48),
          const SizedBox(height: RoadSafeSpacing.lg),
          Text('Initializing camera...', style: RoadSafeTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(RoadSafeSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(RoadSafeIcons.camera, size: 64, color: RoadSafeColors.error),
            const SizedBox(height: RoadSafeSpacing.lg),
            Text(
              'Camera Error',
              style: RoadSafeTypography.headlineSmall,
            ),
            const SizedBox(height: RoadSafeSpacing.md),
            Text(
              _error ?? 'Unknown error',
              style: RoadSafeTypography.bodyMedium.copyWith(color: RoadSafeColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: RoadSafeSpacing.xl),
            RoadSafePrimaryButton(
              label: 'Retry',
              onPressed: _initializeCamera,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        CameraPreview(_controller!),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Tap to capture',
                    style: RoadSafeTypography.titleMedium.copyWith(
                      color: RoadSafeColors.textOnPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
              _buildCameraTips(),
              _buildCaptureControls(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCameraTips() {
    return Container(
      margin: const EdgeInsets.all(RoadSafeSpacing.lg),
      padding: const EdgeInsets.all(RoadSafeSpacing.md),
      decoration: BoxDecoration(
        color: RoadSafeColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(RoadSafeRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Photo Guidelines', style: RoadSafeTypography.titleSmall),
          const SizedBox(height: RoadSafeSpacing.sm),
          ...[
            'Keep the issue in frame',
            'Capture from proper distance',
            'Ensure good lighting',
            'Show surrounding area if possible',
          ].map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: RoadSafeSpacing.xs),
                child: Row(
                  children: [
                    Icon(RoadSafeIcons.check, size: 14, color: RoadSafeColors.success),
                    const SizedBox(width: RoadSafeSpacing.sm),
                    Text(tip, style: RoadSafeTypography.bodySmall),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCaptureControls() {
    return Container(
      padding: const EdgeInsets.all(RoadSafeSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            RoadSafeColors.overlay,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoadSafeIconButton(
              icon: RoadSafeIcons.refresh,
              onPressed: _switchCamera,
              backgroundColor: RoadSafeColors.surface.withValues(alpha: 0.9),
              iconColor: RoadSafeColors.textPrimary,
              size: 56,
              iconSize: 24,
              tooltip: 'Switch Camera',
            ),
            GestureDetector(
              onTap: _isCapturing ? null : _takePicture,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: RoadSafeColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: RoadSafeColors.textOnPrimary, width: 4),
                  boxShadow: RoadSafeShadows.fab,
                ),
                child: _isCapturing
                    ? Center(
                        child: RoadSafeCircularProgress(
                          color: RoadSafeColors.primary,
                          size: 32,
                        ),
                      )
                    : Icon(
                        RoadSafeIcons.camera,
                        size: 32,
                        color: RoadSafeColors.textPrimary,
                      ),
              ),
            ),
            RoadSafeIconButton(
              icon: RoadSafeIcons.flash,
              onPressed: _toggleFlash,
              backgroundColor: RoadSafeColors.surface.withValues(alpha: 0.9),
              iconColor: RoadSafeColors.textPrimary,
              size: 56,
              iconSize: 24,
              tooltip: 'Flash',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null) return;

    try {
      final currentMode = controller.value.flashMode;
      await controller.setFlashMode(
        currentMode == FlashMode.auto ? FlashMode.off : FlashMode.auto,
      );
    } catch (_) {}
  }

  Widget _buildPreviewState() {
    return Stack(
      children: [
        Image.file(
          File(_capturedImage!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(RoadSafeSpacing.xl),
                  alignment: Alignment.topCenter,
                  child: RoadSafeInfoCard(
                    title: 'Photo Captured',
                    message: 'Review the photo and continue to submit your report.',
                    icon: RoadSafeIcons.checkCircle,
                    backgroundColor: RoadSafeColors.successLight,
                    borderColor: RoadSafeColors.success,
                  ),
                ),
              ),
              _buildPreviewControls(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewControls() {
    return Container(
      padding: const EdgeInsets.all(RoadSafeSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            RoadSafeColors.overlay,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: RoadSafeSecondaryButton(
                label: 'Retake',
                leadingIcon: RoadSafeIcons.retake,
                onPressed: _retakePhoto,
              ),
            ),
            const SizedBox(width: RoadSafeSpacing.md),
            Expanded(
              child: RoadSafePrimaryButton(
                label: 'Use Photo',
                trailingIcon: RoadSafeIcons.forward,
                onPressed: () {}, // Navigation handled by parent
              ),
            ),
          ],
        ),
      ),
    );
  }
}