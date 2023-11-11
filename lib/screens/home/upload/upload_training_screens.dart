import 'package:advance_player_academy_trainer/controllers/image_controller.dart';
import 'package:advance_player_academy_trainer/screens/home/upload/widgets/image_uploading_widget.dart';
import 'package:advance_player_academy_trainer/services/training_services.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:advance_player_academy_trainer/utils/lists.dart';
import 'package:advance_player_academy_trainer/utils/text_controllers.dart';
import 'package:advance_player_academy_trainer/widgets/buttons.dart';
import 'package:advance_player_academy_trainer/widgets/custom_text_input.dart';
import 'package:advance_player_academy_trainer/widgets/show_custom_msg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../themes/app_colors.dart';
import '../../../widgets/photo_upload_bottom_sheet.dart';

class UploadTrainingScreen extends StatefulWidget {
  const UploadTrainingScreen({super.key});

  @override
  State<UploadTrainingScreen> createState() => _UploadTrainingScreenState();
}

class _UploadTrainingScreenState extends State<UploadTrainingScreen> {
  String selectedWorkOut = "Strength Training";
  String selectedResourceVideo = "Baseball Drill Video Library";
  String selectedResource = "Baseball Drill Library";
  AppTextControllers appTextControllers = AppTextControllers();
  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final dbController = Provider.of<TrainingServices>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
            imageController.deleteUploadPhoto();
          },
          child: Icon(Icons.arrow_back, color: AppColors.primaryWhite),
        ),
        title: Text(
          "Upload Trainings",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              SizedBox(height: 10),
              Text(
                "Select Resource",
                style: AppTextStyle.H1,
              ),
              DropdownButton(
                  hint: Text(selectedResourceVideo),
                  items: resourceVideoList.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedResource = v!;
                    });
                  }),
              SizedBox(height: 20),
              Text(
                "Select Main Category",
                style: AppTextStyle.H1,
              ),
              DropdownButton(
                  hint: Text(selectedWorkOut),
                  items: mainCategoriesList.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedWorkOut = v!;
                    });
                  }),
              SizedBox(height: 20),
              Text("Insert Main Category Image Below", style: AppTextStyle.H1),
              SizedBox(height: 05),
              ImageUploadingWidget(
                  onCancelBtnPressed: () {
                    imageController.deleteUploadPhoto();
                  },
                  selectedImage: imageController.selectedImage,
                  onPressed: () {
                    photoUploadingBottomSheet(context);
                  }),
              SizedBox(height: 20),
              Text("Description", style: AppTextStyle.H1),
              SizedBox(height: 05),
              CustomTextInput(controller: appTextControllers.descriptionController, hintText: "Description of workout"),
              SizedBox(height: 20),
              Text("Video Url", style: AppTextStyle.H1),
              SizedBox(height: 05),
              CustomTextInput(controller: appTextControllers.videoUrlController, hintText: "https://example.com"),
              SizedBox(height: 30),
              dbController.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : PrimaryButton(
                      onPressed: () async {
                        if (isYouTubeURL(appTextControllers.videoUrlController.text)) {
                          await dbController.uploadTraining(
                            resourceName: selectedResourceVideo,
                            categoryName: selectedWorkOut,
                            description: appTextControllers.descriptionController.text,
                            image: imageController.selectedImage,
                            videoUrl: appTextControllers.videoUrlController.text,
                          );
                          imageController.deleteUploadPhoto();
                          setState(() {});
                        } else {
                          showCustomMsg("Enter Valid Url");
                        }
                      },
                      title: "Upload WorkOut",
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

bool isYouTubeURL(String url) {
  //https://youtube.com/shorts/Ay_g-rgkIsY?si=Qsuv9KI4Aty8BBSW
  RegExp regex = RegExp(
    r'^https?://(?:www\.)?(?:m\.)?youtube\.com/(?:watch\?v=|embed/|v/|shorts/|channel/[\w-]+/|c/[\w-]+\?annotation_id=)|'
    r'^https?://youtu\.be/|'
    r'^https?://youtube\.com/(?:attribution_link\?a=|user/[\w-]+/videos\?|c/[\w-]+/featured/|u/[\w-]+/|'
    r'channel/[\w-]+/|feed/subscriptions/|playlist\?list=|watch\?v=|'
    r'watch\?(?:time_continue=\d+&v=|v=|feature=\w+&v=|'
    r'&list=|index=\d+&list=))([\w-]+)',
  );
  return regex.hasMatch(url);
}
