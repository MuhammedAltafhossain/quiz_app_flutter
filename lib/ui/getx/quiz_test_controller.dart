import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/model/quiz_question.dart';

class QuizTestController extends GetxController {
  List<QuizQuestion> questions = [];
  bool quizTestInProgress = true;

  Future<void> fetchQuizQuestions(String quizId) async {
    final quizCollection = FirebaseFirestore.instance.collection('questions');
    final snapshot =
        await quizCollection.doc(quizId).collection('questions_list').get();

    List<QuizQuestion> fetchedQuestions = [];
    quizTestInProgress = false;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final question = data['question'];
      final options = List<String>.from(data['options']);
      final correctAnswerIndex = data['correctAnswerIndex'];

      final quizQuestion = QuizQuestion(
        question: question,
        options: options,
        correctAnswerIndex: correctAnswerIndex,
      );
      fetchedQuestions.add(quizQuestion);
    }

    questions = fetchedQuestions;
    update();
  }

  Future<String?> storeStudentResult(
      String userId, String quizId, int score) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference questionsCollection =
        firestore.collection('result');
    var result = await questionsCollection.add({
      'userId': userId,
      'quizId': quizId,
      'score': score,
    });

    try {
      print('Question data stored successfully!');
      return result.id;
    } catch (e) {
      print('Error storing question data: $e');
      return null;
    }
  }
}
