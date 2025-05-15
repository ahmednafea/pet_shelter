import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/middleware/home_middleware.dart';
import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/core/models/home_state.dart';
import 'package:pet_shelter/core/reducer/app_state_reducer.dart';
import 'package:pet_shelter/identity/middleware/identity_middleware.dart';
import 'package:pet_shelter/identity/models/identity_state.dart';
import 'package:redux/redux.dart';

import 'configs/router.dart' as AppRouter;
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

AppState init() => AppState(homeState: HomeState(isLoading: false), identityState: IdentityState());

loggingMiddleware(Store<AppState> store, action, NextDispatcher next) {
  debugPrint('${DateTime.now()} $action ');
  next(action);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final store = Store<AppState>(
    appStateReducer,
    initialState: init(),
    middleware: [loggingMiddleware, homeMiddleware, identityMiddleware],
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Bayt Aleef',
        theme: AppColors.getThemeData(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}