import 'package:pet_shelter/identity/models/users_record.dart';

import '../../../firebase_auth/base_auth_user_provider.dart';

class LoginAction {
  String email;
  String password;

  LoginAction({required this.email, required this.password});
}

class UpdateUserData {
  BaseAuthUser data;
  UsersRecord? userData;

  UpdateUserData({required this.data, this.userData});
}