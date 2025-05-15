import 'package:pet_shelter/identity/models/users_record.dart';

import '../../../firebase_auth/base_auth_user_provider.dart';

class IdentityState {
  BaseAuthUser? currentUser;
  UsersRecord? currentUserData;

  IdentityState({this.currentUser, this.currentUserData});

  IdentityState copyWith({BaseAuthUser? currentUser, UsersRecord? currentUserData}) {
    return IdentityState(
        currentUser: currentUser ?? this.currentUser,
        currentUserData: currentUserData ?? this.currentUserData);
  }
}