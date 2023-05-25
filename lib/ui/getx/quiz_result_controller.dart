import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/data/model/user_data.dart';

import '../../data/model/quiz_result_model.dart';

class QuizResultController extends GetxController {
  List<QuizResultModel> quizResultModelList = [];
  bool quizResultInProgress = true;

  Future<void> fetchQuizResult() async {
    try {
      final quizCollection = FirebaseFirestore.instance.collection('result');
      final snapshot = await quizCollection.get();
      List<QuizResultModel> questionsResult = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final id = doc.id;
        final quizId = data['quizId'];
        final score = data['score'];
        final userId = data['userId'];

        final quizCollection =
            FirebaseFirestore.instance.collection('questions');
        final snapshotQuiz = await quizCollection.doc(quizId).get();

        final image = snapshotQuiz['imageUrl'];
        final title = snapshotQuiz['questionTitle'];
        quizResultInProgress = false;
        final quizResult = QuizResultModel(
          id: id,
          quizId: quizId,
          score: score,
          userId: userId,
          imageUrl: image,
          title: title,
        );
        if (UserData.id == userId) {
          questionsResult.add(quizResult);
        }
      }
      quizResultModelList = questionsResult;
      update();
    } catch (e) {
      quizResultInProgress = true;
      log('error ${e}');
    }
  }

  Future<void> fetchQuizResultViewTeacher() async {
    try {
      final quizCollection = FirebaseFirestore.instance.collection('result');
      final snapshot = await quizCollection.get();
      List<QuizResultModel> questionsResult = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final id = doc.id;
        final quizId = data['quizId'];
        final score = data['score'];
        final userId = data['userId'];

        final quizCollection =
            FirebaseFirestore.instance.collection('questions');
        final snapshotQuiz = await quizCollection.doc(quizId).get();

        final image = snapshotQuiz['imageUrl'];
        final title = snapshotQuiz['questionTitle'];
        final qUserId = snapshotQuiz['userId'];

        final getUserCollection =
            FirebaseFirestore.instance.collection('users');
        final snapshotUser = await getUserCollection.doc(userId).get();
        final name = snapshotUser['name'];
        final email = snapshotUser['email'];
        quizResultInProgress = false;
        update();
        final quizResult = QuizResultModel(
          id: id,
          quizId: quizId,
          score: score,
          userId: userId,
          imageUrl: image,
          title: title,
          name: name,
          email: email,
        );
        if (qUserId == UserData.id) {
          questionsResult.add(quizResult);
        }
      }
      quizResultModelList = questionsResult;

    } catch (e) {
      quizResultInProgress = true;
      log('error ${e}');
    }
  }
}
