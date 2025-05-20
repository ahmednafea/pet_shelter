import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/post_model.dart';
import 'package:pet_shelter/shared.dart';
import 'package:pet_shelter/utilities.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final content = _postController.text;
      await PostRecord.collection.add(
        createPostRecordData(
          userId: Shared.store?.state.identityState.currentUserData?.reference.id,
          description: content,
        ),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post submitted successfully!')));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('What\'s on your mind?', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _postController,
                decoration: customInputDecoration(
                  "Post",
                ).copyWith(hintText: 'Write your post here...'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Post content is required';
                  }
                  return null;
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text('Post', style: TextStyle(fontSize: 16, color: AppColors.textOnPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}