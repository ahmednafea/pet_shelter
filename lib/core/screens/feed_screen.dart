import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_colors.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> posts = [
      {
        'userName': 'Sarah Ali',
        'userImage': 'https://randomuser.me/api/portraits/women/12.jpg',
        'content': 'Just adopted a sweet pup named Lulu! ❤️🐶',
      },
      {
        'userName': 'Mohamed Samir',
        'userImage': 'https://randomuser.me/api/portraits/men/14.jpg',
        'content': 'Saw a stray dog in Heliopolis. Anyone can help?',
      },
      {
        'userName': 'Layla Hassan',
        'userImage': 'https://randomuser.me/api/portraits/women/18.jpg',
        'content': 'Donated to Bayt Aleef today 🙌. Let’s support the cause!',
      },
    ];

    return Scaffold(

      body: ListView.builder(
        padding:  EdgeInsets.only(bottom: 12, right: 16,left: 16,top: MediaQuery.of(context).padding.top ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(post['userImage']!),
              ),
              title: Text(post['userName']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(post['content']!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          // TODO: Navigate to AddPostScreen
        },
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}