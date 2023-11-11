import 'dart:io';

import 'package:advance_player_academy_trainer/controllers/image_controller.dart';
import 'package:advance_player_academy_trainer/controllers/loading_controller.dart';
import 'package:advance_player_academy_trainer/services/team_services.dart';
import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:advance_player_academy_trainer/utils/text_controllers.dart';
import 'package:advance_player_academy_trainer/widgets/buttons.dart';
import 'package:advance_player_academy_trainer/widgets/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/photo_upload_bottom_sheet.dart';

class UploadTeamInfoScreen extends StatelessWidget {
  const UploadTeamInfoScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    AppTextControllers appTextControllers = AppTextControllers();
    var imageController = Provider.of<ImageController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Team Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text("Team Logo (*)", style: AppTextStyle.H1),
              SizedBox(height: 10),
              if (imageController.selectedImage == null)
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      photoUploadingBottomSheet(context);
                    },
                    child: Center(
                      child: Icon(Icons.photo, size: 30),
                    ),
                  ),
                )
              else
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(
                        File(imageController.selectedImage!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: AppColors.primaryBlack,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text("Team Name (*)", style: AppTextStyle.H1),
              SizedBox(height: 10),
              CustomTextInput(controller: appTextControllers.teamNameController, hintText: "Example Team"),
              SizedBox(height: 20),
              Text("Team Owner (*)", style: AppTextStyle.H1),
              SizedBox(height: 10),
              CustomTextInput(controller: appTextControllers.teamOwnerNameController, hintText: "John Doe"),
              SizedBox(height: 20),
              Text("Team Location (*)", style: AppTextStyle.H1),
              SizedBox(height: 10),
              CustomTextInput(controller: appTextControllers.teamLocationController, hintText: "USA-Street 13 "),
              SizedBox(height: 50),
              Consumer<LoadingController>(
                builder: (_, loadingController, __) {
                  return loadingController.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : PrimaryButton(
                          onPressed: () async {
                            await TeamService().uploadTeamInformation(
                              context: context,
                              teamLogo: imageController.selectedImage,
                              teamName: appTextControllers.teamNameController.text,
                              teamLocation: appTextControllers.teamLocationController.text,
                              ownerName: appTextControllers.teamOwnerNameController.text,
                            );
                            imageController.deleteUploadPhoto();
                          },
                          title: "Save Team Information",
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
