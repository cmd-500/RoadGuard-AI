import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/report_provider.dart';
import '../../services/location_service.dart';

class ReportHazardScreen extends StatefulWidget {
  const ReportHazardScreen({super.key});

  @override
  State<ReportHazardScreen> createState() => _ReportHazardScreenState();
}

class _ReportHazardScreenState extends State<ReportHazardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _address = TextEditingController();
  String _hazardType = HazardType.pothole;
  String _severity = Severity.medium;

  File? _image;
  Position? _position;
  bool _capturing = false;
  String? _captureError;

  Future<void> _captureAndLocate() async {
    setState(() {
      _capturing = true;
      _captureError = null;
    });

    try {
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        setState(() => _captureError = 'Location permission is required to submit a report');
        return;
      }

      // camera only, deliberately no ImageSource.gallery, so a report photo is proof it was taken here, now
      final picked = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1600, imageQuality: 85);
      if (picked == null) return;

      setState(() {
        _image = File(picked.path);
        _position = position;
      });
    } finally {
      setState(() => _capturing = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _image == null || _position == null) return;

    final provider = context.read<ReportProvider>();
    final success = await provider.createReport(
      title: _title.text.trim(),
      description: _description.text.trim(),
      address: _address.text.trim(),
      hazardType: _hazardType,
      severity: _severity,
      latitude: _position!.latitude,
      longitude: _position!.longitude,
      imageFile: _image!,
    );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Report Hazard')),
      body: SafeArea(
        child: _image == null ? _buildCaptureStep() : _buildFormStep(provider),
      ),
    );
  }

  Widget _buildCaptureStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_outlined, size: 56, color: AppColors.primary),
            const SizedBox(height: 14),
            Text('Take a photo of the hazard', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            const Text(
              'Photos must be taken live from the camera, not chosen from your gallery, so location and timing can be verified.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_captureError != null) ...[
              Text(_captureError!, style: const TextStyle(color: AppColors.critical, fontSize: 13)),
              const SizedBox(height: 12),
            ],
            ElevatedButton.icon(
              onPressed: _capturing ? null : _captureAndLocate,
              icon: _capturing
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormStep(ReportProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(_image!, height: 180, fit: BoxFit.cover),
            ),
            TextButton.icon(
              onPressed: () => setState(() => _image = null),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retake photo'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title (e.g. Deep pothole near junction)'),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Enter a short title' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (v) => (v == null || v.trim().length < 5) ? 'Add a short description' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Landmark / address'),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Add a nearby landmark' : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _hazardType,
              decoration: const InputDecoration(labelText: 'Hazard type'),
              items: HazardType.all.map((t) => DropdownMenuItem(value: t, child: Text(HazardType.label(t)))).toList(),
              onChanged: (v) => setState(() => _hazardType = v!),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _severity,
              decoration: const InputDecoration(labelText: 'Severity'),
              items: Severity.all.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _severity = v!),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: provider.isLoading ? null : _submit,
              child: provider.isLoading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
