import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/quiz_controller.dart';
import 'package:quiz_app_flutter/ui/screen/student_quiz_test_screen.dart';
import 'package:quiz_app_flutter/ui/screen/teacher_view_question_list.dart';

import '../../data/model/quiz_question.dart';
import '../../data/model/user_data.dart';
import '../widget/drawer_widget.dart';

class QuizViewScreen extends StatefulWidget {
  const QuizViewScreen({Key? key}) : super(key: key);

  @override
  State<QuizViewScreen> createState() => _QuizViewScreenState();
}

class _QuizViewScreenState extends State<QuizViewScreen> {
  List<QuizQuestion> _questions = [];
  QuizController quizController = Get.put(QuizController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      quizController.fetchStudentQuizQuestions();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Quiz App',
          ),
          backgroundColor: Colors.yellow.withOpacity(0.7)),
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.fill,
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GetBuilder<QuizController>(
                 builder: (quizController) {
                   _questions = quizController.fatchStudentQuiz;
                  return ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        print(_questions.length);
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Get.to(StudentQuizTestScreen(
                                      id: _questions[index].id ?? ''));
                                },
                                child: ListTile(
                                  leading: Image.network(
                                    _questions[index].imageUrl ?? '',
                                  ),
                                  title:
                                  Text(_questions[index].questionTitle ?? ''),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
