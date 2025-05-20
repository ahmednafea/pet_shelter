import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart';
import 'package:pet_shelter/core/models/adoption_request_record.dart';
import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/core/models/donation_request_record.dart';
import 'package:pet_shelter/core/models/report_record.dart';
import 'package:pet_shelter/core/screens/adoptions_management_screen.dart';
import 'package:pet_shelter/core/screens/donations_management_screen.dart';
import 'package:pet_shelter/core/screens/feed_management_screen.dart';
import 'package:pet_shelter/core/screens/reports_management_screen.dart';
import 'package:pet_shelter/core/screens/users_management_screen.dart';
import 'package:pet_shelter/firebase_auth/auth_util.dart';
import 'package:pet_shelter/identity/actions/clear_user_data_action.dart';
import 'package:pet_shelter/utilities.dart';
import 'package:redux/redux.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (context, Store<AppState> store) {
        return DefaultTabController(
          length: store.state.identityState.currentUserData!.isAdmin ? 4 : 3,
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
                      if (store.state.identityState.currentUserData!.isAdmin)
                        Tab(icon: Icon(Icons.admin_panel_settings_rounded), text: 'Admin'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            store.state.identityState.currentUserData!.photoUrl.isNotEmpty
                                ? NetworkImage(store.state.identityState.currentUserData!.photoUrl)
                                : AssetImage(AppAssets.logoImg),
                        radius: 50,
                        backgroundColor: Colors.black12,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        store.state.identityState.currentUserData!.displayName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        store.state.identityState.currentUserData!.email,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildAdoptionHistory(
                          store.state.identityState.currentUserData!.reference.id,
                        ),
                        _buildDonationHistory(
                          store.state.identityState.currentUserData!.reference.id,
                        ),
                        _buildReportHistory(
                          store.state.identityState.currentUserData!.reference.id,
                        ),
                        if (store.state.identityState.currentUserData!.isAdmin)
                          _buildAdminSection(),
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
                      onPressed: () async {
                        store.dispatch(ClearUserDataAction());
                        await authManager.signOut();
                        context.goNamed("login");
                      },
                      icon: Icon(Icons.logout, color: AppColors.textOnPrimary),
                      label: Text('Logout', style: TextStyle(color: AppColors.textOnPrimary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdoptionHistory(String uid) {
    return StreamBuilder(
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
        var data =
            snap.data!.docs
                .where((val) => (val.data() as Map<String, dynamic>)["user_id"] == uid)
                .map((val) => AdoptionRequestRecord.fromSnapshot(val))
                .toList();

        return data.isNotEmpty
            ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final request = data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
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
                    ),
                    title: Text('Age: ${request.dog!['age']}'),
                    subtitle: Text(request.address),
                    trailing: statusWidget(request.status),
                    isThreeLine: true,
                  ),
                );
              },
            )
            : Center(child: Text("No Adoptions Requests Yet."));
      },
    );
  }

  Widget _buildAdminSection() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: Icon(Icons.pets, color: AppColors.primaryDark),
          onTap: () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => AdoptionsManagementScreen()),
            );
          },
          title: Text(
            "Adoption Requests",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            "Manage Adoption Requests",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryDark),
        ),
        ListTile(
          leading: Icon(Icons.volunteer_activism, color: AppColors.primaryDark),
          onTap: () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => DonationsManagementScreen()),
            );
          },
          title: Text(
            "Donations",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            "Manage Donations",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryDark),
        ),
        ListTile(
          leading: Icon(Icons.camera_outlined, color: AppColors.primaryDark),
          onTap: () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => ReportsManagementScreen()),
            );
          },
          title: Text(
            "Reports",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            "Manage Reports",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryDark),
        ),
        ListTile(
          leading: Icon(CupertinoIcons.doc_plaintext, color: AppColors.primaryDark),
          onTap: () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => FeedManagementScreen()),
            );
          },
          title: Text(
            "Posts",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            "Manage Posts",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryDark),
        ),
        ListTile(
          leading: Icon(CupertinoIcons.person_3_fill, color: AppColors.primaryDark),
          onTap: () {
            navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => UsersManagementScreen()),
            );
          },
          title: Text(
            "Users",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            "Manage Users",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryDark),
        ),
      ],
    );
  }

  Widget _buildDonationHistory(String uid) {
    return StreamBuilder(
      stream: DonationRequestRecord.collection.snapshots(),
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
                .where((val) => (val.data() as Map<String, dynamic>)["user_id"] == uid)
                .map((val) => DonationRequestRecord.fromSnapshot(val))
                .toList();

        return data.isNotEmpty
            ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final request = data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.monetization_on),
                    title: Text('Donated: ${request.amount} EGP'),
                  ),
                );
              },
            )
            : Center(child: Text("No donations yet."));
      },
    );
  }

  Widget _buildReportHistory(String uid) {
    return StreamBuilder(
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
        var data =
            snap.data!.docs
                .where((val) => (val.data() as Map<String, dynamic>)["user_id"] == uid)
                .map((val) => ReportRecord.fromSnapshot(val))
                .toList();

        return data.isNotEmpty
            ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final request = data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          request.picture.isNotEmpty
                              ? Image.network(
                                request.picture,
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
                    ),
                    title: Text(request.location),
                    subtitle: Text(request.description),
                  ),
                );
              },
            )
            : Center(child: Text("No reports yet."));
      },
    );
  }
}