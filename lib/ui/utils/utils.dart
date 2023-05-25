
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors{
   static Color primaryColor = const Color(0xFF026C1C);



}

void customeMessage(String title, String message, Icon icon) {
   Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      borderRadius: 10,
      backgroundColor: AppColors.primaryColor,
      icon: icon,
   );
}

bool isValidEmail(String email) {
   return RegExp(
       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
       .hasMatch(email);
}