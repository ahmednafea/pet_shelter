import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pet_shelter/configs/app_colors.dart';
import 'package:pet_shelter/core/models/app_state.dart';
import 'package:pet_shelter/identity/actions/sign_up_action.dart';
import 'package:pet_shelter/utilities.dart';
import 'package:redux/redux.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime? selectedBirthDate;

  // Validate full name: simple regex to allow letters and spaces, at least 2 words
  bool validateFullName(String name) {
    final regex = RegExp(r"^[a-zA-Z]+ [a-zA-Z ]+$");
    return regex.hasMatch(name.trim());
  }

  // Check if user is 18 or older
  bool isOlderThan18(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year -
        ((now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day))
            ? 1
            : 0);
    return age >= 18;
  }

  void pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(Duration(days: 6555)),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && isOlderThan18(picked)) {
      setState(() {
        selectedBirthDate = picked;
        birthDateController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void registerUser(Store<AppState> store) {
    store.dispatch(
      SignUpAction(
        email: emailController.text.trim(),
        password: passwordController.text,
        phoneNumber: '', // You can remove this from SignUpAction if no longer needed
        displayName: nameController.text.trim(),
        birthdate: selectedBirthDate!,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account created successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (context, store) {
        return Scaffold(
          appBar: AppBar(title: Text('Signup'), centerTitle: true),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: customInputDecoration('Full Name'),
                  autofillHints: [AutofillHints.name],
                  style: TextStyle(color: AppColors.textPrimary),
                  validator: (value) {
                    if (value == null || !validateFullName(value)) {
                      return 'Enter a valid full name (at least 2 words)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: customInputDecoration('Email'),
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  decoration: customInputDecoration('Password'),
                  autofillHints: [AutofillHints.password],
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    hintText: 'YYYY-MM-DD',
                    floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                    suffixIcon: Icon(Icons.calendar_today),
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  readOnly: true,
                  onTap: pickBirthDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your birthdate';
                    }
                    if (selectedBirthDate == null || !isOlderThan18(selectedBirthDate!)) {
                      return 'You must be at least 18 years old';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      registerUser(store);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}