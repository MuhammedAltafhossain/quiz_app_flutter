import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/screen/student_quiz_test_screen.dart';
import 'package:quiz_app_flutter/ui/screen/teacher_view_question_list.dart';

import '../../data/model/quiz_question.dart';
import '../widget/drawer_widget.dart';

class QuizViewScreen extends StatefulWidget {
  const QuizViewScreen({Key? key}) : super(key: key);

  @override
  State<QuizViewScreen> createState() => _QuizViewScreenState();
}

class _QuizViewScreenState extends State<QuizViewScreen> {
  List<QuizQuestion> _questions = [];

  Future<void> fetchQuizQuestions() async {
    final quizCollection = FirebaseFirestore.instance.collection('questions');
    final snapshot = await quizCollection.get();
    List<QuizQuestion> fetchedQuestions = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();

      final id = doc.id;
      final question = data['questionTitle'];
      final imageUrl = data['imageUrl'];
      final quizQuestion = QuizQuestion(
        id: id,
        questionTitle: question,
        imageUrl: imageUrl,
      );
      fetchedQuestions.add(quizQuestion);
    }

    setState(() {
      _questions = fetchedQuestions;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchQuizQuestions();
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
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
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
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
