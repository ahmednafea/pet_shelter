import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/dog_model.dart';
import 'package:pet_shelter/utilities.dart';

class CreateDogScreen extends StatefulWidget {
  final String imageUrl;
  final String reportedDescription;

  const CreateDogScreen({super.key, required this.imageUrl, required this.reportedDescription});

  @override
  State<CreateDogScreen> createState() => _CreateDogScreenState();
}

class _CreateDogScreenState extends State<CreateDogScreen> {
  late TextEditingController _descriptionController;
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.reportedDescription);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final description = _descriptionController.text.trim();
    final ageText = _ageController.text.trim();
    if (description.isEmpty) {
      _showSnackBar('Description cannot be empty');
      return;
    }
    if (ageText.isEmpty) {
      _showSnackBar('Please enter the dog\'s age');
      return;
    }
    final age = int.tryParse(ageText);
    if (age == null || age <= 0) {
      _showSnackBar('Please enter a valid positive age');
      return;
    }

    // You can now use description and age for your submission logic
    print('Submitted: Description: $description, Age: $age');

    await DogRecord.collection.add(
      createDogRecordData(description: description, image: widget.imageUrl, age: age),
    );

    // 4. Feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dog was added to the adoption list successfully')),
    );
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Dog Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.imageUrl.isNotEmpty)
                Image.network(
                  widget.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Icon(Icons.broken_image, size: 50)),
                      ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: customInputDecoration('Description'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration('Age (years)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text('Submit', style: TextStyle(fontSize: 16, color: AppColors.textOnPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}