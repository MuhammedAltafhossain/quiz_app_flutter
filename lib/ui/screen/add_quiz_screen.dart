import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app_flutter/data/model/user_data.dart';
import 'package:quiz_app_flutter/ui/getx/quiz_controller.dart';
import 'package:quiz_app_flutter/ui/utils/utils.dart';
import 'package:quiz_app_flutter/ui/widget/add_text_from_field_widget.dart';
import 'package:quiz_app_flutter/ui/widget/app_elevated_button.dart';
import 'package:quiz_app_flutter/ui/widget/drawer_widget.dart';

class AddQuizScreen extends StatefulWidget {
  String id;
  AddQuizScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  QuizController quizController = Get.put(QuizController());
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final TextEditingController _question = TextEditingController();
  final TextEditingController _answerIndex = TextEditingController();
  List<String> options = [];

  void _addQuiz() {
    String question = _question.text.trim();
    int answerIndex = int.parse(_answerIndex.text.trim()) - 1;
    String userid = UserData.id ?? "";
    quizController
        .addQuestionListCollection(widget.id, question, options, answerIndex)
        .then((value) {
      if (value) {
        customeMessage(
            'Success', 'Question add Successfully', const Icon(Icons.check));
        _answerIndex.text = '';
        _question.text = '';
        options.clear();
        setState(() {

        });
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
        child: Stack(children: [
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
                        return 'Question is required';
                      }
                    },
                    controller: _question,
                    obscureText: false,
                    hintText: 'Question',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Options',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _addOption();
                          },
                          child: const Text('Add'))
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  options[index],
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    options.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                  if (options.isNotEmpty)
                    AddTextFieldWidget(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Correct answer index is required';
                        }
                      },
                      controller: _answerIndex,
                      obscureText: false,
                      hintText: 'Correct Answer Index',
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppElevatedButton(
                      text: 'Submit',
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

  void _addOption() {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newOption = '';

        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text('Add Option'),
            content: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'this filed is required';
                }
              },
              onChanged: (value) {
                newOption = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      options.add(newOption);
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}
