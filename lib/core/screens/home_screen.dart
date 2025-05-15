import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/screens/feed_screen.dart';
import 'package:pet_shelter/core/screens/home_view.dart';
import 'package:pet_shelter/identity/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomeView(feedsNavigation: (){
            controller.jumpToTab(1);
          },),
          item: ItemConfig(
            icon: Icon(Icons.home),
            title: "Home",
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: FeedView(),
          item: ItemConfig(
            icon: Icon(CupertinoIcons.doc_plaintext),
            title: "Feed",
            activeForegroundColor: AppColors.primary,
          ),
        ),
        PersistentTabConfig(
          screen: ProfileScreen(),
          item: ItemConfig(
            icon: Icon(Icons.person_rounded),
            title: "Profile",
            activeForegroundColor: AppColors.primary,
          ),
        ),
      ],controller: controller,
      navBarBuilder:
          (navBarConfig) => Style4BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(color: Colors.white),
          ),
    );
  }
}