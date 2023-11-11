import 'package:advance_player_academy_trainer/models/team_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/text_styles.dart';
import '../team_detail_screen.dart';

class TeamCard extends StatelessWidget {
  final TeamModel teamModel;
  const TeamCard({super.key, required this.teamModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.primaryTransparent,
      highlightColor: AppColors.primaryTransparent,
      onTap: () {
        Get.to(() => TeamDetailScreen(teamModel: teamModel));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        height: MediaQuery.sizeOf(context).height * 0.25,
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(teamModel.teamLogo!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(AppColors.primaryBlack.withOpacity(0.2), BlendMode.srcATop),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              teamModel.teamName!,
              style: AppTextStyle.H1.copyWith(
                fontSize: 18,
                letterSpacing: 2.0,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
