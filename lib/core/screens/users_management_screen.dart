import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart';
import 'package:pet_shelter/core/models/post_model.dart';
import 'package:pet_shelter/core/screens/add_post_screen.dart';
import 'package:pet_shelter/identity/models/users_record.dart';
import 'package:pet_shelter/shared.dart';

class UsersManagementScreen extends StatelessWidget {
  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Users Management")),
      body: StreamBuilder(
        stream: UsersRecord.collection.snapshots(),
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
          var data =
              snap.data!.docs
                  .where(
                    (val) =>
                        val.reference !=
                        Shared.store!.state.identityState.currentUserData!.reference,
                  )
                  .map((val) => UsersRecord.fromSnapshot(val))
                  .toList();
          return data.isNotEmpty
              ? ListView.builder(
                itemCount: data.length,
                padding: EdgeInsets.only(bottom: 20, right: 16, left: 16, top: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = data[index];

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
                            radius: 24,
                            backgroundColor: AppColors.accent,
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
                                Row(
                                  children: [
                                    Text("Role:"),
                                    SizedBox(width: 10),
                                    Expanded(child: Text(user.isAdmin ? "Admin" : "User")),
                                    TextButton(
                                      onPressed: () {
                                        user.reference.update({"is_admin": !user.isAdmin});
                                      },
                                      child: Text(
                                        "Make ${user.isAdmin ? "User" : "Admin"}",
                                        style: TextStyle(color: AppColors.primaryDark),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    user.reference.delete();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.error,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              )
              : Center(child: Text("No users in the system."));
        },
      ),
    );
  }
}