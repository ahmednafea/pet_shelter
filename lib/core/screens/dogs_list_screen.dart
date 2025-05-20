import 'package:flutter/material.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/dog_model.dart';
import 'package:pet_shelter/core/screens/add_adoption_request_screen.dart';

class AvailableDogsScreen extends StatelessWidget {
  const AvailableDogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Dogs for Adoption')),
      body: StreamBuilder(
        stream: DogRecord.collection.snapshots(),
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
                  .where((val) => (val.data() as Map<String, dynamic>)["adoption_user_id"] == null)
                  .map((val) => DogRecord.fromSnapshot(val))
                  .take(4)
                  .toList();
          return data.isNotEmpty
              ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final dog = data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AdoptionRequestScreen(dog: dog)),
                      );
                    },

                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                dog.image != null
                                    ? Image.network(dog.image!, width: 120, fit: BoxFit.cover)
                                    : Image.asset(AppAssets.logoImg, width: 120, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${dog.age} years",
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${dog.description}",
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
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
              : Center(child: Text("We have no dogs now."));
        },
      ),
    );
  }
}