import 'package:flutter/material.dart';
import 'package:pet_shelter/core/models/adoption_request_record.dart';
import 'package:pet_shelter/core/models/dog_model.dart';
import 'package:pet_shelter/shared.dart';
import 'package:pet_shelter/utilities.dart';

import '../../configs/app_colors.dart';

class AdoptionRequestScreen extends StatefulWidget {
  final DogRecord dog;

  const AdoptionRequestScreen({super.key, required this.dog});

  @override
  State<AdoptionRequestScreen> createState() => _AdoptionRequestScreenState();
}

class _AdoptionRequestScreenState extends State<AdoptionRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final address = _addressController.text;
      await AdoptionRequestRecord.collection.add(
        createAdoptionRequestRecordData(
          userId: Shared.store!.state.identityState.currentUserData!.reference.id,
          address: address,
          dog: widget.dog,
        ),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Adoption request submitted!')));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.dog.image ?? "",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text('Dog Age: ${widget.dog.age}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _addressController,
                decoration: customInputDecoration(
                  'Your Address',
                ).copyWith(hintText: 'Enter your full address'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Submit Request',
                  style: TextStyle(fontSize: 16, color: AppColors.textOnPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}