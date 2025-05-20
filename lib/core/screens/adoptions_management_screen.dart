import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/adoption_request_record.dart';
import 'package:pet_shelter/core/models/dog_model.dart';
import 'package:pet_shelter/identity/models/users_record.dart';
import 'package:pet_shelter/utilities.dart';

class AdoptionsManagementScreen extends StatefulWidget {
  const AdoptionsManagementScreen({super.key});

  @override
  State<AdoptionsManagementScreen> createState() => _AdoptionsManagementScreenState();
}

class _AdoptionsManagementScreenState extends State<AdoptionsManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adoptions Management"), centerTitle: true),
      body: StreamBuilder(
        stream: AdoptionRequestRecord.collection.snapshots(),
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
          var data = snap.data!.docs.map((val) => AdoptionRequestRecord.fromSnapshot(val)).toList();

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
                                      "Please i wanna adopt this dog?\nMy Address: ${request.address}",
                                      style: const TextStyle(color: AppColors.textSecondary),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        request.dog?["image"] != null
                                            ? Image.network(
                                              request.dog!["image"],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              AppAssets.logoImg,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                        Expanded(
                                          child: Text(
                                            "Dog Age: ${request.dog?["age"]} years",
                                            style: const TextStyle(color: AppColors.textSecondary),
                                          ),
                                        ),
                                      ],
                                    ),
                                    request.status == "Pending"
                                        ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                request.reference.update({"status": "Accepted"});
                                                DogRecord.collection
                                                    .doc("${request.dog?["dogId"]}")
                                                    .update({
                                                      "adoption_user_id": request.userId,
                                                    });
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
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                request.reference.update({"status": "Rejected"});
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
                                                "Reject",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                        : statusWidget(request.status),
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