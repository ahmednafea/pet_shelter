import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart';
import 'package:pet_shelter/core/models/post_model.dart';
import 'package:pet_shelter/core/screens/add_post_screen.dart';
import 'package:pet_shelter/identity/models/users_record.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: PostRecord.collection.snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text("Error"));
          } else if (!snap.hasData) {
            return Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(color: AppColors.primaryDark),
              ),
            );
          }
          var data = snap.data!.docs.map((val) => PostRecord.fromSnapshot(val)).toList();
          return data.isNotEmpty
              ? ListView.builder(
                itemCount: data.length,
                padding: EdgeInsets.only(
                  bottom: 12,
                  right: 16,
                  left: 16,
                  top: MediaQuery.of(context).padding.top,
                ),
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
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final user = userSnap.data!;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    user.photoUrl.isNotEmpty
                                        ? NetworkImage(user.photoUrl)
                                        : AssetImage(AppAssets.logoImg),
                                radius: 24,backgroundColor: AppColors.accent,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  );
                },
              )
              : Center(child: Text("No Available Posts."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}