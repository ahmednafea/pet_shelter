
import 'package:pet_shelter/core/models/home_state.dart';
import 'package:pet_shelter/identity/models/identity_state.dart';

class AppState {
  final HomeState homeState;
  final IdentityState identityState;

  AppState({required this.homeState, required this.identityState});
}