
import 'package:pet_shelter/core/actions/update_loading_state.dart';
import 'package:pet_shelter/core/models/home_state.dart';

HomeState homeReducer(HomeState state, action) {
  if (action is UpdateLoadingState) {
    return state.copyWith(isLoading: action.isLoading);
  }
  return state;
}