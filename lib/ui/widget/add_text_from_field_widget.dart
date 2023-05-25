import 'package:flutter/material.dart';

import '../utils/utils.dart';

typedef StringValue = String Function(String);

class AddTextFieldWidget extends StatelessWidget {
  const AddTextFieldWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines,
    this.validator, required this.obscureText, this.textInputType,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final bool? textInputType;

  final int? maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType == true ? TextInputType.number : null,
      validator: validator,
      maxLines: maxLines ?? 1,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
