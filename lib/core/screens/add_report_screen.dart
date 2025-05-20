import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/report_record.dart';
import 'package:pet_shelter/shared.dart';
import 'package:pet_shelter/utilities.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _selectedImage;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      setState(() {
        isLoading = true;
      });
      try {
        final description = _descriptionController.text;
        final address = _addressController.text;

        // 1. Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child(
          'report_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final uploadTask = await storageRef.putFile(_selectedImage!);

        // 2. Get download URL
        final imageUrl = await uploadTask.ref.getDownloadURL();

        // 3. Submit report to Firestore
        await ReportRecord.collection.add(
          createReportRecordData(
            userId: Shared.store?.state.identityState.currentUserData?.reference.id,
            description: description,
            location: address,
            picture: imageUrl, // 🔥 Use download URL here
          ),
        );

        // 4. Feedback to user
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Report submitted successfully!')));
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Upload failed: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to submit report')));
      }
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a picture')));
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child:
              isLoading
                  ? const SizedBox(height: 70, child: Center(child: CircularProgressIndicator()))
                  : Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child:
                            _selectedImage == null
                                ? Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                                  ),
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: customInputDecoration('Description'),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Please enter a description'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _addressController,
                        decoration: customInputDecoration("Address"),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Please enter an address'
                                    : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(
                            'Submit Report',
                            style: TextStyle(fontSize: 16, color: AppColors.textOnPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}