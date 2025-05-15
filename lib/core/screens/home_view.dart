import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key,required this.feedsNavigation});
final VoidCallback feedsNavigation;
  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'Adoption', 'icon': Icons.pets, 'onTap': () {}},
      {'title': 'Donation', 'icon': Icons.volunteer_activism, 'onTap': () {}},
      {'title': 'Report', 'icon': Icons.camera_outlined, 'onTap': () {}},
    ];

    final dogs = [
      {'image': 'https://placedog.net/400/300?id=1', 'age': '2 years'},
      {'image': 'https://placedog.net/400/300?id=2', 'age': '1 year'},
      {'image': 'https://placedog.net/400/300?id=3', 'age': '3 months'},
    ];

    final posts = [
      {
        'userPic': 'https://randomuser.me/api/portraits/women/65.jpg',
        'name': 'Sarah',
        'content': 'Adopted a lovely pup today! Highly recommend Bayt Aleef ❤️',
      },
      {
        'userPic': 'https://randomuser.me/api/portraits/men/22.jpg',
        'name': 'Ahmed',
        'content': 'Thank you for helping me find the perfect furry friend!',
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 20,
          left: 10,
          right: 10,
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            GridView.builder(
              itemCount: services.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 80,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final service = services[index];
                return GestureDetector(
                  onTap: service['onTap'] as void Function(),
                  child: Card(
                    color: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(service['icon'] as IconData, color: AppColors.surface, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          service['title'] as String,
                          style: const TextStyle(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Row(
              children: [
                Expanded(
                  child: const Text(
                    'Available for Adoption',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {

                  },
                  child: Text("View All", style: TextStyle(color: AppColors.primaryDark)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dogs.length,
                itemBuilder: (context, index) {
                  final dog = dogs[index];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            dog['image']!,
                            height: 100,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dog['age']!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Section: Community Posts
            Row(
              children: [
                Expanded(
                  child: const Text(
                    'Community Posts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),TextButton(
                  onPressed: feedsNavigation,
                  child: Text("View All", style: TextStyle(color: AppColors.primaryDark)),
                ),
              ],
            ),
            ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(post['userPic']!), radius: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post['content']!,
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}