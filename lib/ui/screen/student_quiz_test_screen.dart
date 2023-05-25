import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/quiz_test_controller.dart';
import 'package:quiz_app_flutter/ui/screen/quiz_view_screen.dart';

import '../../data/model/quiz_question.dart';
import '../../data/model/user_data.dart';
import '../widget/drawer_widget.dart';

class StudentQuizTestScreen extends StatefulWidget {
  String id;

  StudentQuizTestScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<StudentQuizTestScreen> createState() => _StudentQuizTestScreenState();
}

class _StudentQuizTestScreenState extends State<StudentQuizTestScreen> {
  QuizTestController quizTestController = Get.put(QuizTestController());

  int _currentQuestionIndex = 0;
  int _score = 0;
  List<QuizQuestion> _questions = [];





  void _submitAnswer(int selectedOptionIndex) {
    if (selectedOptionIndex ==
        _questions[_currentQuestionIndex].correctAnswerIndex) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Quiz is finished
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Quiz Finished'),
            content: Text('Your score: $_score / ${_questions.length}'),
            actions: [

              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  String userId = UserData.id ?? '';
                  quizTestController.storeStudentResult(userId, widget.id, _score);

                  setState(() {
                    _currentQuestionIndex = 0;
                    _score = 0;
                  });
                  Get.to(const QuizViewScreen());
                 },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quizTestController.fetchQuizQuestions(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Quiz App',
          ),
          backgroundColor: Colors.yellow.withOpacity(0.7)),
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
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: GetBuilder<QuizTestController>(
                builder: (quizTextController) {
                  _questions = quizTextController.questions;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}/${_questions.length}:',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _currentQuestionIndex < _questions.length
                            ? _questions[_currentQuestionIndex].question ?? ''
                            : '',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: _currentQuestionIndex < _questions.length &&
                                _questions[_currentQuestionIndex].options != null
                            ? _questions[_currentQuestionIndex]
                                .options!
                                .map((option) {
                                int optionIndex = _questions[_currentQuestionIndex]
                                    .options!
                                    .indexOf(option);
                                return ElevatedButton(
                                  onPressed: () => _submitAnswer(optionIndex),
                                  child: Text(option),
                                );
                              }).toList()
                            : [],
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
