import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart';
import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/core/models/dog_model.dart';
import 'package:pet_shelter/core/models/post_model.dart';
import 'package:pet_shelter/core/screens/add_adoption_request_screen.dart';
import 'package:pet_shelter/core/screens/add_donation_request_screen.dart';
import 'package:pet_shelter/core/screens/add_report_screen.dart';
import 'package:pet_shelter/core/screens/dogs_list_screen.dart';
import 'package:pet_shelter/identity/models/users_record.dart';
import 'package:redux/redux.dart' show Store;

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.feedsNavigation});

  final VoidCallback feedsNavigation;

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Adoption',
        'icon': Icons.pets,
        'onTap': () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => AvailableDogsScreen()),
          );
        },
      },
      {
        'title': 'Donation',
        'icon': Icons.volunteer_activism,
        'onTap': () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => AddDonationScreen()),
          );
        },
      },
      {
        'title': 'Report',
        'icon': Icons.camera_outlined,
        'onTap': () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => AddReportScreen()),
          );
        },
      },
      {
        'title': 'About Us',
        'icon': Icons.info_outlined,
        'onTap': () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => AddReportScreen()),
          );
        },
      },
      {
        'title': 'Contact Us',
        'icon': Icons.message_outlined,
        'onTap': () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => AddReportScreen()),
          );
        },
      },
      {
        'title': 'Tips & Tricks',
        'icon': Icons.tips_and_updates_outlined,
        'onTap': () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => AddReportScreen()),
          );
        },
      },
      {
        'title': 'Service Dogs',
        'icon': Icons.wheelchair_pickup_rounded,
        'onTap': () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => AddReportScreen()),
          );
        },
      },
    ];

    return StoreBuilder(
      builder: (context, Store<AppState> store) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: 20,
              left: 10,
              right: 10,
              top: MediaQuery.of(context).padding.top + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome ${store.state.identityState.currentUserData?.displayName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  'Our Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    itemCount: services.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (context, index) {
                      final service = services[index];
                      return GestureDetector(
                        onTap: service['onTap'] as void Function(),
                        child: Card(
                          color: AppColors.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  service['icon'] as IconData,
                                  color: AppColors.surface,
                                  size: 32,
                                ),
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
                        ),
                      );
                    },
                  ),
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
                        navigatorKey.currentState!.push(
                          MaterialPageRoute(
                            builder: (context) => AvailableDogsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  child: StreamBuilder(
                    stream: DogRecord.collection.snapshots(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return Center(child: Text("Error"));
                      } else if (!snap.hasData) {
                        return Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        );
                      }
                      var data =
                          snap.data!.docs
                              .where(
                                (val) =>
                                    (val.data()
                                        as Map<
                                          String,
                                          dynamic
                                        >)["adoption_user_id"] ==
                                    null,
                              )
                              .map((val) => DogRecord.fromSnapshot(val))
                              .take(4)
                              .toList();
                      return data.isNotEmpty
                          ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final dog = data[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              AdoptionRequestScreen(dog: dog),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child:
                                            dog.image != null
                                                ? Image.network(
                                                  dog.image!,
                                                  height: 100,
                                                  width: 140,
                                                  fit: BoxFit.cover,
                                                )
                                                : Image.asset(
                                                  AppAssets.logoImg,
                                                  height: 100,
                                                  width: 140,
                                                  fit: BoxFit.cover,
                                                ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${dog.age} years",
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                          : Center(
                            child: Text("No Available Dogs Now, Check Later."),
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
                    ),
                    TextButton(
                      onPressed: feedsNavigation,
                      child: Text(
                        "View All",
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: PostRecord.collection.snapshots(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Center(child: Text("Error"));
                    } else if (!snap.hasData) {
                      return Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryDark,
                          ),
                        ),
                      );
                    }
                    var data =
                        snap.data!.docs
                            .map((val) => PostRecord.fromSnapshot(val))
                            .take(4)
                            .toList();
                    return data.isNotEmpty
                        ? ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final post = data[index];

                            return FutureBuilder<UsersRecord>(
                              future: UsersRecord.getDocumentOnce(
                                UsersRecord.collection.doc("/${post.userId!}"),
                              ),
                              builder: (context, userSnap) {
                                if (userSnap.hasError) {
                                  return Center(child: Text("user data error"));
                                } else if (!userSnap.hasData) {
                                  return const SizedBox(
                                    height: 70,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final user = userSnap.data!;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              user.photoUrl.isNotEmpty
                                                  ? NetworkImage(user.photoUrl)
                                                  : AssetImage(
                                                    AppAssets.logoImg,
                                                  ),
                                          radius: 24,
                                          backgroundColor: AppColors.accent,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.displayName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                post.description ?? "",
                                                style: const TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                        : Center(child: Text("No Available Posts."));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
