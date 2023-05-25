import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/quiz_controller.dart';
import 'package:quiz_app_flutter/ui/screen/teacher_view_question_list.dart';
import '../../data/model/quiz_question.dart';
import '../widget/drawer_widget.dart';

class TeacherViewQuizScreen extends StatefulWidget {
  const TeacherViewQuizScreen({Key? key}) : super(key: key);

  @override
  State<TeacherViewQuizScreen> createState() => _TeacherViewQuizScreenState();
}

class _TeacherViewQuizScreenState extends State<TeacherViewQuizScreen> {
  QuizController quizController = Get.put(QuizController());
  List<QuizQuestion> _questions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      quizController.fetchQuizQuestionsByTeacher();
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: GetBuilder<QuizController>(builder: (quizController) {
                _questions = quizController.fatchQuestions;
                if (quizController.quizFatchInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Get.to(ViewQuestionListScreen(
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
              }),
            ),
          ),
        ],
      ),
    );
  }
}
