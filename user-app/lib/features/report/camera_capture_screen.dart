import 'dart:async';
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:html' as html show window, Event;
import '../../core/design_system/index.dart';
import '../../shared/components/index.dart';

class CameraCaptureScreen extends StatefulWidget {
  final Function(Uint8List imageBytes, String imageName) onPhotoCaptured;

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
  Uint8List? _capturedImageBytes;
  String? _error;
  Timer? _resizeDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _resizeDebounce?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {

    if (!kIsWeb) return;
    if (!_isInitialized || _controller == null) return;

    _resizeDebounce?.cancel();
    _resizeDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _reacquireCamera();
    });
  }

  Future<void> _reacquireCamera() async {
    final oldController = _controller;
    _controller = null;
    if (mounted) setState(() => _isInitialized = false);
    try {
      await oldController?.dispose();
    } catch (_) {}
    if (!mounted) return;
    await _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      setState(() => _isInitialized = false);
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

      if (kIsWeb) {

        await Future.delayed(const Duration(milliseconds: 100));
        html.window.dispatchEvent(html.Event('resize'));
      }
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
      final bytes = await image.readAsBytes();
      setState(() {
        _capturedImage = image;
        _capturedImageBytes = bytes;
        _isCapturing = false;
      });

      if (mounted) {
        widget.onPhotoCaptured(bytes, image.name);
      }
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _error = 'Failed to capture photo: ${e.toString()}';
      });
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _capturedImageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && !_isInitialized) {
      return _buildErrorState();
    }

    if (!_isInitialized) {
      return _buildLoadingState();
    }

    if (_capturedImageBytes != null) {
      return _buildPreviewState();
    }

    return _buildCameraView();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCircularProgress(size: 48),
          const SizedBox(height: AppSpacing.lg),
          Text('Initializing camera...', style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.camera, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Camera Error',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _error ?? 'Unknown error',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
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
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: (_isInitialized && !_isCapturing) ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      'Tap to capture',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
              _buildCaptureControls(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureControls() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.overlay,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppIconButton(
              icon: AppIcons.refresh,
              onPressed: _switchCamera,
              backgroundColor: AppColors.surface.withValues(alpha: 0.9),
              iconColor: AppColors.textPrimary,
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
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.onPrimary, width: 4),
                  boxShadow: AppShadows.fab,
                ),
                child: _isCapturing
                    ? Center(
                  child: AppCircularProgress(
                    color: AppColors.primary,
                    size: 32,
                  ),
                )
                    : Icon(
                  AppIcons.camera,
                  size: 32,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            AppIconButton(
              icon: AppIcons.flash,
              onPressed: _toggleFlash,
              backgroundColor: AppColors.surface.withValues(alpha: 0.9),
              iconColor: AppColors.textPrimary,
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
        Image.memory(
          _capturedImageBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  alignment: Alignment.topCenter,
                  child: AppInfoCard(
                    title: 'Photo Captured',
                    message: 'Review the photo and continue to submit your report.',
                    icon: AppIcons.checkCircle,
                    backgroundColor: AppColors.successLight,
                    borderColor: AppColors.success,
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
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.overlay,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppSecondaryButton(
                label: 'Retake',
                leadingIcon: AppIcons.refresh,
                onPressed: _retakePhoto,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppPrimaryButton(
                label: 'Use Photo',
                trailingIcon: AppIcons.forward,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}