import 'package:firebase_auth/firebase_auth.dart';

class SignUpAction {
  String email;
  String password;
  String phoneNumber;
  String displayName;
  DateTime birthdate;

  SignUpAction({
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.displayName,
    required this.birthdate,
  });
}