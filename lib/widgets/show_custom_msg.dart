import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showCustomMsg(String msg) {
  Get.snackbar(
    msg,
    "",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.primaryBlack,
    colorText: AppColors.primaryWhite,
    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}

showErrorMsg(String msg) {
  Get.snackbar(
    msg,
    "",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: AppColors.primaryWhite,
    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
  );
}
