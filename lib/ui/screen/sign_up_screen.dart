import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/auth_controller.dart';
import 'package:quiz_app_flutter/ui/screen/login_screen.dart';
import '../utils/utils.dart';
import '../widget/add_text_from_field_widget.dart';
import '../widget/app_elevated_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AuthController authController = Get.put(AuthController());

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  List<String> items = ['Teacher', 'Student'];
  String currentItem = 'Teacher';
  bool checkDropdownValue = false;

  void _register() {
    String userType = currentItem.trim();
    String name = _userNameTextEditingController.text.trim();
    String email = _emailTextEditingController.text.trim();
    String password = _passwordTextEditingController.text.trim();
    authController.register(userType, name, email, password).then((value) {
      if (value) {
        Get.to(const LoginScreen());
      } else {
        customeMessage(
          'Error',
          'Please try again..!',
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Form(
          key: _fromKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/quiz_logo.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Let\'s Get Started',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  letterSpacing: 2.3,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                'Create an Account',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 2.3,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: const Text('Choose Option'),
                    elevation: 16,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                    onChanged: (String? newValue) {
                      if (newValue != null) currentItem = newValue;
                      setState(() {});
                    },
                    value: currentItem,
                    items: items
                        .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              AddTextFieldWidget(
                controller: _userNameTextEditingController,
                hintText: 'Please enter your name',
                obscureText: false,
                validator: (value) =>
                    value!.isEmpty ? 'Name cannot be blank' : null,
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
              authController.registerInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : AppElevatedButton(
                      text: 'SIGN UP',
                      onTap: () {
                        if (_fromKey.currentState!.validate()) {
                          _register();
                        }
                      }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an accounts?',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1.3,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(const LoginScreen());
                      },
                      child: Text(
                        'Sing in',
                        style: TextStyle(color: AppColors.primaryColor),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
