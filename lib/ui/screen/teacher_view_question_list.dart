import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/quiz_controller.dart';
import 'package:quiz_app_flutter/ui/widget/app_elevated_button.dart';
import '../../data/model/quiz_question.dart';

class ViewQuestionListScreen extends StatefulWidget {
  String id;

  ViewQuestionListScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewQuestionListScreen> createState() => _ViewQuestionListScreenState();
}

class _ViewQuestionListScreenState extends State<ViewQuestionListScreen> {
  QuizController quizController = Get.put(QuizController());

  List<QuizQuestion> _questionsOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      quizController.fetchQuizQuestions(widget.id);
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
        // drawer: const DrawerWidget(),
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
                padding: const EdgeInsets.all(10),
                child: GetBuilder<QuizController>(builder: (quizController) {
                  _questionsOptions = quizController.fatchQuestionsOption;
                  if (quizController.fetchQuizQuestionsInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _questionsOptions.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${index + 1} .  ${_questionsOptions[index].question ?? ''}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: _questionsOptions[index]
                                        .options!
                                        .map((option) {
                                      return Column(
                                        children: [
                                          AppElevatedButton(
                                              text: option, onTap: () {}),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Correct Answer : ${(_questionsOptions[index].correctAnswerIndex ?? 0) + 1}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ));
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ));
  }
}
