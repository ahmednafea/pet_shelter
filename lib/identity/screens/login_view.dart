import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shelter/configs/app_assets.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/identity/actions/login_action.dart';
import 'package:pet_shelter/utilities.dart';
import 'package:redux/redux.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailTextFieldController = TextEditingController();

  final passwordTextFieldController = TextEditingController();

  final FocusNode passwordFocusNode = FocusNode();

  final FocusNode emailFocusNode = FocusNode();

  bool validateEmail = true, validatePassword = true, hiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onDispose: (store) {
        emailTextFieldController.dispose();
        passwordTextFieldController.dispose();
        passwordFocusNode.dispose();
        emailFocusNode.dispose();
      },
      builder: (ctx, Store<AppState> store) {
        return Scaffold(
          bottomSheet: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Have no account yet?"),
                TextButton(
                  onPressed: () {
                    context.pushNamed("signup");
                  },
                  child: Text("Signup", style: TextStyle(color: AppColors.primaryDark)),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.logoImg, height: MediaQuery.of(context).size.height * 0.25),
                SizedBox(height: 20),
                TextField(
                  focusNode: emailFocusNode,
                  controller: emailTextFieldController,
                  autofillHints: [AutofillHints.email],
                  onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocusNode),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: AppColors.primary,
                  style: const TextStyle(fontSize: 16.0, color: AppColors.primary),
                  maxLines: 1,
                  enabled: !store.state.homeState.isLoading,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    labelText: "Email",
                    hintStyle: const TextStyle(fontSize: 14.0, color: AppColors.textSecondary),
                    labelStyle: const TextStyle(fontSize: 14.0, color: AppColors.primary),
                    filled: true,
                    prefixIcon: const Icon(CupertinoIcons.mail_solid, color: AppColors.primaryDark),
                    errorText: validateEmail ? null : "Write a correct email address",
                    fillColor: Colors.blueGrey[50],
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primaryDark),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  focusNode: passwordFocusNode,
                  controller: passwordTextFieldController,
                  enabled: !store.state.homeState.isLoading,
                  autofillHints: [AutofillHints.password],
                  onSubmitted: (password) async {
                    setState(() {
                      validateEmail = Utilities.validatingEmail(
                        emailTextFieldController.value.text,
                      );
                      validatePassword = password.length >= 6;
                    });
                    if (validateEmail && validatePassword) {
                      store.dispatch(
                        LoginAction(email: emailTextFieldController.value.text, password: password),
                      );
                    } else {
                      Utilities.showToast(msg: "Please review your data", isError: true);
                    }
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  cursorColor: AppColors.primary,
                  obscureText: hiddenPassword,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  autocorrect: false,
                  style: const TextStyle(color: AppColors.primary),
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    labelText: "Password",
                    hintStyle: const TextStyle(fontSize: 14.0, color: AppColors.textSecondary),
                    labelStyle: const TextStyle(fontSize: 14.0, color: AppColors.primary),
                    prefixIcon: const Icon(CupertinoIcons.lock_fill, color: AppColors.primaryDark),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            hiddenPassword = !hiddenPassword;
                          });
                        },
                        child: Icon(
                          hiddenPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    filled: true,
                    errorText:
                        validatePassword
                            ? null
                            : "password is too short, should be at least 6 characters",
                    fillColor: Colors.blueGrey[50],
                    // contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed:
                      store.state.homeState.isLoading
                          ? null
                          : () async {
                            setState(() {
                              validateEmail = Utilities.validatingEmail(
                                emailTextFieldController.value.text,
                              );
                              validatePassword = passwordTextFieldController.value.text.length >= 6;
                            });
                            if (validateEmail && validatePassword) {
                              store.dispatch(
                                LoginAction(
                                  email: emailTextFieldController.value.text,
                                  password: passwordTextFieldController.value.text,
                                ),
                              );
                            } else {
                              Utilities.showToast(msg: "Please review your data", isError: true);
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}