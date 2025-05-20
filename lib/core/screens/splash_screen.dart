import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart';
import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/identity/actions/login_action.dart';
import 'package:pet_shelter/identity/screens/login_view.dart';
import 'package:pet_shelter/shared.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      onInit: (Store<AppState> store) async {
        Shared.store = store;

        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (preferences.containsKey("baytAleefEmail")) {
          var email = preferences.getString("baytAleefEmail") ?? "";
          var password = preferences.getString("baytAleefPassword") ?? "";
          store.dispatch(LoginAction(email: email, password: password));
        } else {
          Future.delayed(const Duration(seconds: 4), () {
            context.replaceNamed("login");
          });
        }
        initializeDateFormatting("en");
      },

      builder: (BuildContext ctx, Store<AppState> store) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                AppAssets.logoImg,
                height: MediaQuery.of(context).size.height * 0.33,
              ),
            ),
          ),
        );
      },
    );
  }
}