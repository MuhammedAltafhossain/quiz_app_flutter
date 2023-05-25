import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/ui/getx/quiz_result_controller.dart';
import '../widget/drawer_widget.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  QuizResultController quizResultController = Get.put(QuizResultController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quizResultController.fetchQuizResult();
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
              padding: const EdgeInsets.all(10),
              child: GetBuilder<QuizResultController>(
                builder: (controllerResult) {
                  final result = controllerResult.quizResultModelList;
                  if (controllerResult.quizResultInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Image.network(
                                result[index].imageUrl ?? '',
                              ),
                              title: Text(
                                'Title: ${result[index].title ?? 0}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Score: ${result[index].score ?? 0}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
