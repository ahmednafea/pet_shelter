import 'package:go_router/go_router.dart';
import 'package:pet_shelter/core/actions/update_loading_state.dart';
import 'package:pet_shelter/core/middleware/navigation_key.dart' show navigatorKey;
import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/firebase_auth/auth_util.dart';
import 'package:pet_shelter/identity/actions/login_action.dart';
import 'package:pet_shelter/identity/actions/sign_up_action.dart';
import 'package:pet_shelter/identity/actions/update_profile_action.dart';
import 'package:pet_shelter/identity/models/users_record.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

identityMiddleware(Store<AppState> store, action, NextDispatcher next) {
  if (action is LoginAction) {
    store.dispatch(UpdateLoadingState(isLoading: true));
    authManager
        .signInWithEmail(navigatorKey.currentContext!, action.email, action.password)
        .then((val) async {
          if (val != null) {
            var user = UsersRecord.fromSnapshot(
              await UsersRecord.collection.doc("${val.authUserInfo.uid}").get(),
            );

            store.dispatch(UpdateUserData(data: val, userData: user));
            var pref = await SharedPreferences.getInstance();
            pref.setString("baytAleefEmail", action.email);
            pref.setString("baytAleefPassword", action.password);
            navigatorKey.currentContext!.goNamed("home");
          }
        })
        .whenComplete(() {
          store.dispatch(UpdateLoadingState(isLoading: false));
        });
  } else if (action is SignUpAction) {
    store.dispatch(UpdateLoadingState(isLoading: true));
    authManager
        .createAccountWithEmail(navigatorKey.currentContext!, action.email, action.password)
        .then((value) async {
          if (value != null) {

            var user = UsersRecord.fromSnapshot(
              await UsersRecord.collection.doc("${value.authUserInfo.uid}").get(),
            );
            await user.reference.update(
              createUsersRecordData(
                email: action.email,
                birthdate: action.birthdate,
                displayName: action.displayName,
                isAdmin: false,
                phoneNumber: action.phoneNumber,
              ),
            );
            store.dispatch(UpdateUserData(data: value, userData: user));
            var pref = await SharedPreferences.getInstance();
            pref.setString("baytAleefEmail", action.email);
            pref.setString("baytAleefPassword", action.password);
            navigatorKey.currentContext!.goNamed("home");
          }
        })
        .whenComplete(() {
          store.dispatch(UpdateLoadingState(isLoading: false));
        });
  } else if (action is UpdateProfileAction) {
    store.dispatch(UpdateLoadingState(isLoading: true));
    currentUserReference!
        .update({"birthdate": action.birthDate, "display_name": action.fullName})
        .whenComplete(() => store.dispatch(UpdateLoadingState(isLoading: false)));
  }
  next(action);
}