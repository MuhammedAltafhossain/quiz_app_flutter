import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/data/model/user_data.dart';
import 'package:quiz_app_flutter/ui/getx/quiz_controller.dart';
import 'package:quiz_app_flutter/ui/screen/add_quiz_screen.dart';
import 'package:quiz_app_flutter/ui/utils/utils.dart';
import 'package:quiz_app_flutter/ui/widget/add_text_from_field_widget.dart';
import 'package:quiz_app_flutter/ui/widget/app_elevated_button.dart';
import 'package:quiz_app_flutter/ui/widget/drawer_widget.dart';

class AddQuizTitleScreen extends StatefulWidget {
  const AddQuizTitleScreen({Key? key}) : super(key: key);

  @override
  State<AddQuizTitleScreen> createState() => _AddQuizTitleScreenState();
}

class _AddQuizTitleScreenState extends State<AddQuizTitleScreen> {
  QuizController quizController = Get.put(QuizController());
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final TextEditingController _questionTitle = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();

  void _addQuiz() {
    String questionTitle = _questionTitle.text.trim();
    String imageUrl = _imageUrl.text.trim();
    String userid = UserData.id ?? "";
    quizController
        .storeQuestionTitleData(questionTitle,imageUrl, userid).then((value) {
      if (value != null) {
        customeMessage(
            'Success', 'Question title add Successfully', const Icon(Icons.check));
        _questionTitle.text = '';
        _imageUrl.text = '';
        setState(() {

        });
        Get.to(AddQuizScreen(id: value,));
      }
      else{
        customeMessage(
            'Error', 'Failed', const Icon(Icons.error));
      }
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
      body: SingleChildScrollView(
        child: Stack(
            children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _fromKey,
              child: Column(
                children: [

                  const SizedBox(
                    height: 12,
                  ),

                  AddTextFieldWidget(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Question title is required';
                      }
                    },
                    controller: _questionTitle,
                    obscureText: false,
                    hintText: 'Question title',
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  AddTextFieldWidget(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Question image is required';
                      }
                    },
                    controller: _imageUrl,
                    obscureText: false,
                    hintText: 'Question image Url',
                  ),
                  const SizedBox(
                    height: 12,
                  ),


                  const SizedBox(
                    height: 10,
                  ),
                  AppElevatedButton(
                      text: 'Add',
                      onTap: () {
                        if (_fromKey.currentState!.validate()) {
                          _addQuiz();
                        }
                      })
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

}
