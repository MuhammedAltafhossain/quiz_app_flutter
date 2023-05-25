import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/auth_controller.dart';
import 'package:quiz_app_flutter/ui/screen/sign_up_screen.dart';
import 'package:quiz_app_flutter/ui/screen/student_home_screen.dart';
import 'package:quiz_app_flutter/ui/screen/teacher_home_screen.dart';
import 'package:quiz_app_flutter/ui/utils/utils.dart';

import '../../data/model/user_data.dart';
import '../widget/add_text_from_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  void _login() {
    if (authController.loginInProgress) {
      const Center(child: CircularProgressIndicator());
    } else {
      String email = _emailTextEditingController.text.trim();
      String password = _passwordTextEditingController.text.trim();
      authController.login(email, password).then((value) {
        if (value != null) {
          if (value == "Wrong password") {
            return customeMessage(
                'error',
                'wrong password',
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ));
          } else if (value == 'User not found') {
            return customeMessage(
                "Error",
                "User not found..",
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ));
          }

          authController.fetchUserData(value).then((value) {
            if (value != null) {
              UserData.id = value['id'];
              UserData.type = value['userType'];
              UserData.name = value['name'];
              UserData.email = value['email'];
              if (value['userType'] == 'Teacher') {
                Get.to(const TeacherHomeScreen());
              } else {
                Get.to(const StudentHomeScreen());
              }
            }
          });
        } else {
          customeMessage(
              'Error',
              "Please try again...!",
              const Icon(
                Icons.error,
                color: Colors.red,
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Center(
              child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          letterSpacing: 2.2),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    AddTextFieldWidget(
                      controller: _emailTextEditingController,
                      hintText: 'Email Address',
                      obscureText: false,
                      validator: (value) {
                        if (!isValidEmail(value.toString())) {
                          return 'Invalid Email';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    AddTextFieldWidget(
                      controller: _passwordTextEditingController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Password cannot be blank' : null,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.2),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an accounts?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: 1.3,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(const SignUpScreen());
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w800),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
