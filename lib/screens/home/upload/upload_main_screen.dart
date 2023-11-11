import 'package:advance_player_academy_trainer/screens/home/upload/upload_files_screen.dart';
import 'package:advance_player_academy_trainer/screens/home/upload/upload_team_info_screen.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'upload_training_screens.dart';

class UploadMainScreen extends StatelessWidget {
  const UploadMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Get.to(UploadTrainingScreen());
            },
            leading: Icon(Icons.fitness_center),
            title: Text("Upload Training", style: AppTextStyle.H1),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Get.to(UploadTeamInfoScreen());
            },
            leading: Icon(Icons.group),
            title: Text("Upload Team", style: AppTextStyle.H1),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Get.to(() => UploadFilesScreen());
            },
            leading: Icon(Icons.file_copy),
            title: Text("Upload Files", style: AppTextStyle.H1),
          ),
        ],
      ),
    );
  }
}
