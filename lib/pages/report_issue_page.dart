// lib/pages/report_issue_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import 'submitted_page.dart'; // adjust import path if needed

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _confirmLocationController =
      TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();

  final List<String> _categories = ['Roads', 'Electricity', 'Water', 'Garbage'];
  String _selectedCategory = 'Roads';

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _galleryImages = [];
  XFile? _cameraImage;

  double? _lat;
  double? _lng;
  bool _loadingLocation = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _confirmLocationController.dispose();
    _moreInfoController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() => _loadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        setState(() => _loadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        setState(() => _loadingLocation = false);
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _confirmLocationController.text =
            'Lat: ${_lat!.toStringAsFixed(6)}, Lng: ${_lng!.toStringAsFixed(6)}';
        _loadingLocation = false;
      });
    } catch (e) {
      setState(() => _loadingLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> picked = await _picker.pickMultiImage(imageQuality: 80);
      if (picked != null && picked.isNotEmpty) {
        setState(() {
          _galleryImages.addAll(picked);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gallery pick failed: $e')),
      );
    }
  }

  Future<void> _captureFromCamera() async {
    try {
      final XFile? captured = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (captured != null) {
        setState(() {
          _cameraImage = captured;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo captured')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera failed: $e')),
      );
    }
  }

  void _removeGalleryImage(int index) {
    setState(() {
      _galleryImages.removeAt(index);
    });
  }

  void _removeCameraImage() {
    setState(() {
      _cameraImage = null;
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill title and description')),
      );
      return;
    }
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate API call

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SubmittedPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submit failed: $e')),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  Widget _buildGalleryGrid() {
    final List<Widget> tiles = [];
    tiles.add(GestureDetector(
      onTap: _pickFromGallery,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: const Center(
            child: Icon(Icons.add, size: 28, color: Colors.black54)),
      ),
    ));
    for (int i = 0; i < _galleryImages.length; i++) {
      final XFile f = _galleryImages[i];
      tiles.add(Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(f.path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeGalleryImage(i),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          )
        ],
      ));
    }
    return Wrap(spacing: 8, runSpacing: 8, children: tiles);
  }

  Widget _buildCameraCard() {
    return GestureDetector(
      onTap: _captureFromCamera,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: _cameraImage == null ? Colors.grey.shade50 : null,
        ),
        child: _cameraImage == null
            ? Row(
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12)),
                      color: Colors.grey.shade100,
                    ),
                    child: const Center(
                        child: Icon(Icons.camera_alt,
                            size: 40, color: Colors.black54)),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text('Click to Capture from Camera',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_cameraImage!.path),
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _removeCameraImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Report Complain'),
          backgroundColor: theme.primaryColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Title Section
            const Text('Issue Title',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Enter issue title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Description Section
            const Text('Description',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _descController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Enter description',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            const Text('Choose Category',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedCategory = v ?? 'Roads'),
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 18),

            const Text('Add Image (Gallery)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildGalleryGrid(),
            const SizedBox(height: 18),

            const Text('Add Photo (Camera)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildCameraCard(),
            const SizedBox(height: 18),

            const Text('Set Location',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _loadingLocation
                ? const Center(child: CircularProgressIndicator())
                : TextField(
                    controller: _confirmLocationController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Location',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
            const SizedBox(height: 16),

            const Text('Additional Information',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _moreInfoController,
              decoration: InputDecoration(
                labelText: 'Add more details (optional)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
