import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart';
import 'package:pet_shelter/core/models/adoption_request_record.dart';
import 'package:pet_shelter/core/models/dog_model.dart';
import 'package:pet_shelter/core/models/report_record.dart';
import 'package:pet_shelter/core/screens/create_dog_screen.dart';
import 'package:pet_shelter/identity/models/users_record.dart';
import 'package:pet_shelter/utilities.dart';

class ReportsManagementScreen extends StatefulWidget {
  const ReportsManagementScreen({super.key});

  @override
  State<ReportsManagementScreen> createState() => _ReportsManagementScreenState();
}

class _ReportsManagementScreenState extends State<ReportsManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reports Management"), centerTitle: true),
      body: StreamBuilder(
        stream: ReportRecord.collection.snapshots(),
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
          var data = snap.data!.docs.map((val) => ReportRecord.fromSnapshot(val)).toList();

          return data.isNotEmpty
              ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final request = data[index];
                  return FutureBuilder<UsersRecord>(
                    future: UsersRecord.getDocumentOnce(
                      UsersRecord.collection.doc("/${request.userId}"),
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
                                    Text(
                                      "Please i wanna report about this dog?\nLocation: ${request.location}",
                                      style: const TextStyle(color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 8),
                                    request.picture.isNotEmpty
                                        ? Image.network(
                                          request.picture,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.asset(
                                          AppAssets.logoImg,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Description: ${request.description}",
                                            style: const TextStyle(color: AppColors.textSecondary),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            navigatorKey.currentState!.push(
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => CreateDogScreen(
                                                      imageUrl: request.picture,
                                                      reportedDescription: request.description,
                                                    ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: AppColors.primaryDark,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            "Accept",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                        ), ElevatedButton(
                                          onPressed: () {
                                            request.reference.delete();
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
              : Center(child: Text("No adoptions yet."));
        },
      ),
    );
  }
}