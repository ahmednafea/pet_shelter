import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/identity/reducer/identity_reducer.dart';

import 'home_reducer.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    identityState: identityReducer(state.identityState, action),
    homeState: homeReducer(state.homeState, action),
  );
}