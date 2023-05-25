import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/auth_controller.dart';
import 'package:quiz_app_flutter/ui/screen/add_quie_title.dart';
import 'package:quiz_app_flutter/ui/screen/login_screen.dart';
import 'package:quiz_app_flutter/ui/screen/quiz_view_screen.dart';
import 'package:quiz_app_flutter/ui/screen/teacher_home_screen.dart';
import '../../data/model/user_data.dart';
import '../screen/student_home_screen.dart';
import '../screen/teacher_view_quiz_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String type = UserData.type ?? '';
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/quiz_logo.png',
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.85,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name : ${UserData.name ?? ''}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'E-mail : ${UserData.email ?? ''}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'Type : ${UserData.type ?? ''}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView(children: [
              ListTile(
                title: const Text("Home"),
                leading: const Icon(Icons.home),
                onTap: () {
                  if (UserData.type == 'Teacher') {
                    Get.to(const TeacherHomeScreen());
                  } else {
                    Get.to(const StudentHomeScreen());
                  }
                },
              ),
              type == 'Teacher'
                  ? ListTile(
                      title: const Text('View Quiz'),
                      leading: const Icon(Icons.quiz_outlined),
                      onTap: () {
                        Get.to(const TeacherViewQuizScreen());
                      },
                    )
                  : Container(),
              ListTile(
                title: UserData.type == 'Teacher'
                    ? const Text('Add Quiz')
                    : const Text('Quiz Test'),
                leading: const Icon(Icons.quiz_outlined),
                onTap: () {
                  if (UserData.type == 'Teacher') {
                    Get.to(const AddQuizTitleScreen());
                  } else {
                    Get.to(const QuizViewScreen());
                  }
                },
              ),
              ListTile(
                title: const Text("Logout"),
                leading: const Icon(Icons.logout),
                onTap: () async {
                  AuthController().logout().then((value) {
                    Get.to(const LoginScreen());
                  });
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}
