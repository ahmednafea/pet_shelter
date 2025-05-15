import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = {
      'name': 'Ahmed Nafea',
      'email': 'ahmed@example.com',
      'phone': '+20 123 456 7890',
      'image': 'https://randomuser.me/api/portraits/men/75.jpg',
    };

    final adoptionHistory = [
      {
        'dogName': 'Bella',
        'age': '2 years',
        'image': 'https://placedog.net/400/300?id=1',
      },
      {
        'dogName': 'Max',
        'age': '3 months',
        'image': 'https://placedog.net/400/300?id=2',
      },
    ];

    final donationHistory = [
      {'amount': 100},
      {'amount': 50},
    ];

    final reportHistory = [
      {
        'image': 'https://placedog.net/400/300?id=3',
        'address': 'Downtown, Cairo',
        'description': 'Stray dog injured on street',
      },
      {
        'image': 'https://placedog.net/400/300?id=4',
        'address': 'Nasr City, Cairo',
        'description': 'Reported animal abuse in alley',
      },
    ];
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              TabBar(
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                tabs: [
                  Tab(icon: Icon(Icons.pets), text: 'Adoption'),
                  Tab(icon: Icon(Icons.volunteer_activism), text: 'Donations'),
                  Tab(icon: Icon(Icons.camera_outlined), text: 'Reports'),
                ],
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                backgroundImage: NetworkImage(user['image']!),
                radius: 50,
              ),
              const SizedBox(height: 10),
              Text(
                user['name']!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(user['email']!, style: const TextStyle(color: AppColors.textSecondary)),
              Text(user['phone']!, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),

              Expanded(
                child: TabBarView(
                  children: [
                    _buildAdoptionHistory(adoptionHistory),
                    _buildDonationHistory(donationHistory),
                    _buildReportHistory(reportHistory),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    // TODO: Add logout logic
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdoptionHistory(List<Map<String, String>> adoptions) {
    if (adoptions.isEmpty) return const Center(child: Text("No adoptions yet."));
    return ListView.builder(
      itemCount: adoptions.length,
      itemBuilder: (context, index) {
        final dog = adoptions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(dog['image']!, width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(dog['dogName']!),
            subtitle: Text('Age: ${dog['age']}'),
          ),
        );
      },
    );
  }

  Widget _buildDonationHistory(List<Map<String, int>> donations) {
    if (donations.isEmpty) return const Center(child: Text("No donations yet."));
    return ListView.builder(
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        return ListTile(
          leading: const Icon(Icons.monetization_on),
          title: Text('Donated: ${donation['amount']} EGP'),
        );
      },
    );
  }

  Widget _buildReportHistory(List<Map<String, String>> reports) {
    if (reports.isEmpty) return const Center(child: Text("No reports yet."));
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(report['image']!, width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(report['address']!),
            subtitle: Text(report['description']!),
          ),
        );
      },
    );
  }
}