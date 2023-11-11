import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/image_controller.dart';
import '../../controllers/visibility_controller.dart';
import '../../themes/app_colors.dart';
import '../../utils/text_controllers.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/logo_widget.dart';
import '../../widgets/photo_upload_bottom_sheet.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppTextControllers appTextController = AppTextControllers();
    final imageController = Provider.of<ImageController>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),
              Center(child: SizedBox(height: 120, child: LogoWidget())),
              SizedBox(height: 15),
              imageController.selectedImage == null
                  ? CircleAvatar(
                      radius: 45,
                      child: GestureDetector(
                        onTap: () {
                          photoUploadingBottomSheet(context);
                        },
                        child: Icon(Icons.photo),
                      ),
                    )
                  : CircleAvatar(
                      radius: 45,
                      backgroundImage: FileImage(
                        File(imageController.selectedImage!.path),
                      ),
                    ),
              SizedBox(height: 20),
              CustomTextInput(controller: appTextController.usernameController, hintText: "Trainer Name"),
              SizedBox(height: 10),
              CustomTextInput(controller: appTextController.emailController, hintText: "E-mail"),
              SizedBox(height: 10),
              Consumer<VisibilityController>(
                builder: (_, value, __) {
                  return CustomTextInput(
                    controller: appTextController.passwordController,
                    hintText: "Password",
                    isIconReq: true,
                    isVisible: value.isVisible,
                    widget: GestureDetector(
                      onTap: () {
                        value.hideAndUnHideVisibility();
                      },
                      child: Icon(value.isVisible ? Icons.visibility_off : Icons.visibility),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              Consumer<AuthController>(
                builder: (_, authController, __) {
                  return authController.isLoading
                      ? CircularProgressIndicator(color: AppColors.primaryBlack)
                      : PrimaryButton(
                          onPressed: () async {
                            await authController.signUp(
                              email: appTextController.emailController.text,
                              password: appTextController.passwordController.text,
                              username: appTextController.usernameController.text,
                              userImage: imageController.selectedImage,
                            );
                            appTextController.emailController.clear();
                            appTextController.passwordController.clear();
                            appTextController.usernameController.clear();
                            imageController.deleteUploadPhoto();
                          },
                          title: "Create",
                        );
                },
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Get.to(LoginScreen());
                },
                child: Center(
                  child: Text("Already Have an Account? Login"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
