import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/donation_request_record.dart';
import 'package:pet_shelter/shared.dart';
import 'package:pet_shelter/utilities.dart';

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({super.key});

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate()) {
      final amount = _amountController.text;
      await DonationRequestRecord.collection.add(
        createDonationRequestRecordData(
          userId: Shared.store?.state.identityState.currentUserData?.reference.id,
          amount: amount,
        ),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Donation of EGP $amount submitted!')));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Donation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Enter the donation amount in Egyptian Pounds (EGP)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration('Donation Amount').copyWith(prefixText: 'EGP '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final numValue = num.tryParse(value);
                  if (numValue == null || numValue <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  'Submit Donation',
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