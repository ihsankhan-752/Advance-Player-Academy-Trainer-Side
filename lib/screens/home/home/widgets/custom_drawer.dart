import 'package:advance_player_academy_trainer/screens/home/all_players/my_players_screen.dart';
import 'package:advance_player_academy_trainer/screens/home/upload/upload_files_screen.dart';
import 'package:advance_player_academy_trainer/widgets/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/get_trainer_details.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/text_styles.dart';
import '../../../../widgets/custom_list_tile.dart';
import '../../../auth/login_screen.dart';
import '../../chat/user_chat_list.dart';
import '../../teams/team_main_screen.dart';
import '../../upload/upload_main_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserDetails>(context).userData;

    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.3,
            width: double.infinity,
            color: AppColors.mainColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(userController.userImage ?? ""),
                ),
                SizedBox(height: 5),
                Text(
                  userController.username ?? "",
                  style: AppTextStyle.H1.copyWith(
                    color: AppColors.primaryWhite,
                  ),
                ),
                SizedBox(height: 05),
                Text(
                  userController.email ?? "",
                  style: AppTextStyle.H1.copyWith(
                    color: AppColors.primaryWhite,
                  ),
                ),
              ],
            ),
          ),
          CustomListTile(
            onPressed: () {
              Get.back();
            },
            icon: Icons.fitness_center,
            title: "Trainings",
          ),
          CustomListTile(
            onPressed: () {
              Get.to(() => UploadFilesScreen());
            },
            icon: Icons.file_copy,
            title: "Files",
          ),
          CustomListTile(
            onPressed: () {
              Get.to(() => UploadMainScreen());
            },
            icon: Icons.upload,
            title: "Upload",
          ),
          CustomListTile(
            onPressed: () {
              Get.to(() => UserChatList());
            },
            icon: Icons.chat,
            title: "Chat",
          ),
          CustomListTile(
            onPressed: () {
              Get.to(() => TeamMainScreen());
            },
            icon: Icons.groups,
            title: "Teams",
          ),
          CustomListTile(
            onPressed: () {
              Get.to(() => AllPlayersScreen());
            },
            icon: Icons.group_add,
            title: "Players",
          ),
          CustomListTile(
            onPressed: () async {
              customAlertDialog(context, () async {
                await FirebaseAuth.instance.signOut();
                Get.to(() => LoginScreen());
              }, "Are you Sure to LogOut?");
            },
            icon: Icons.logout,
            title: "LogOut",
          ),
        ],
      ),
    );
  }
}
