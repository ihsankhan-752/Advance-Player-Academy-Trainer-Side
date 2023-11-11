import 'package:advance_player_academy_trainer/models/training_model.dart';
import 'package:advance_player_academy_trainer/screens/home/home/training_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/text_styles.dart';

class CustomTrainingCard extends StatelessWidget {
  final TrainingModel trainingModel;
  const CustomTrainingCard({super.key, required this.trainingModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TrainingDetailScreen(trainingModel: trainingModel));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(08),
          image: DecorationImage(
            image: NetworkImage(trainingModel.image!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(AppColors.primaryBlack.withOpacity(0.4), BlendMode.srcATop),
          ),
        ),
        child: Center(
          child: Text(
            trainingModel.categoryName!,
            style: AppTextStyle.H1.copyWith(
              color: AppColors.primaryWhite,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
