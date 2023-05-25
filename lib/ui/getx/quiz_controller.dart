import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/data/model/user_data.dart';

import '../../data/model/quiz_question.dart';

class QuizController extends GetxController {
  List<QuizQuestion> fatchQuestions = [];
  List<QuizQuestion> fatchQuestionsOption = [];
  List<QuizQuestion> fatchStudentQuiz = [];
  bool fatchStudentQuizInProgress = true;
  bool fetchQuizQuestionsInProgress = true;
  bool quizFatchInProgress = true;

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> storeQuestionTitleData(
      String title, String imageUrl, String userId) async {
    final CollectionReference questionsCollection =
        firestore.collection('questions');
    var result = await questionsCollection.add({
      'userId': userId,
      'questionTitle': title,
      'imageUrl': imageUrl,
    });

    try {
      print('Question data stored successfully!');
      return result.id;
    } catch (e) {
      print('Error storing question data: $e');
      return null;
    }
  }

  Future<bool> addQuestionListCollection(String? id, String question,
      List<String> options, int correctAnswerIndex) async {
    CollectionReference questions = firestore.collection('questions');
    questions.doc(id).collection('questions_list').add({
      'question': question,
      'options': options.toList(),
      'correctAnswerIndex': correctAnswerIndex,
    });
    try {
      log('Question data stored successfully!');
      return true;
    } catch (e) {
      log('Error storing question data: $e');
      return false;
    }
  }

  Future<void> fetchQuizQuestionsByTeacher() async {
    quizFatchInProgress = true;
    update();
    final quizCollection = FirebaseFirestore.instance.collection('questions');
    final snapshot = await quizCollection.get();
    List<QuizQuestion> fetchedQuestions = [];
    quizFatchInProgress = false;
    update();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      final id = doc.id;
      final question = data['questionTitle'];
      final imageUrl = data['imageUrl'];
      final userId = data['userId'];
      final quizQuestion = QuizQuestion(
        id: id,
        questionTitle: question,
        imageUrl: imageUrl,
        userId: userId,
      );
      if (userId == UserData.id) {
        fetchedQuestions.add(quizQuestion);
      }
    }

    fatchQuestions = fetchedQuestions;
    update();
  }

  Future<void> fetchQuizQuestions(String quizId) async {
    fetchQuizQuestionsInProgress = true;
    update();
    final quizCollection = FirebaseFirestore.instance.collection('questions');
    final snapshot =
        await quizCollection.doc(quizId).collection('questions_list').get();

    List<QuizQuestion> fetchedQuestions = [];
    fetchQuizQuestionsInProgress = false;
    update();
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

    fatchQuestionsOption = fetchedQuestions;
    update();
  }

  Future<void> fetchStudentQuizQuestions() async {
    fatchStudentQuizInProgress = true;
    update();
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

      var quizDataFatch;
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await fetchQuizData(id, UserData.id ?? '');
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        var quizData = doc.data();
        quizDataFatch = quizData['quizId'];
      }
      fatchStudentQuizInProgress = false;
      update();
      if (quizDataFatch == null) {
        fetchedQuestions.add(quizQuestion);
      }
    }
    print(fetchedQuestions);
    fatchStudentQuiz = fetchedQuestions;
    update();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchQuizData(
      String quizId, String userId) {
    return FirebaseFirestore.instance
        .collection('result')
        .where('quizId', isEqualTo: quizId)
        .where('userId', isEqualTo: userId)
        .get();
  }
}
