import 'package:pet_shelter/identity/actions/clear_user_data_action.dart';
import 'package:pet_shelter/identity/actions/login_action.dart';
import 'package:pet_shelter/identity/models/identity_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

IdentityState identityReducer(IdentityState state, action) {
  if (action is UpdateUserData) {
    return state.copyWith(currentUser: action.data, currentUserData: action.userData);
  } else if (action is ClearUserDataAction) {
    SharedPreferences.getInstance().then((pref) async {
      await pref.remove("cpmEmail");
      await pref.remove("cpmPassword");
    });
    state.currentUser = null;
    return state.copyWith(currentUser: state.currentUser);
  }
  return state;
}