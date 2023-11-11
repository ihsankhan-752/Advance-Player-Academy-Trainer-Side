import 'package:advance_player_academy_trainer/controllers/auth_controller.dart';
import 'package:advance_player_academy_trainer/widgets/buttons.dart';
import 'package:advance_player_academy_trainer/widgets/custom_text_input.dart';
import 'package:advance_player_academy_trainer/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    final authController = Provider.of<AuthController>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SizedBox(height: 130, child: LogoWidget())),
            SizedBox(height: 25),
            CustomTextInput(controller: emailController, hintText: "E-mail"),
            SizedBox(height: 30),
            authController.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : PrimaryButton(
                    title: "Reset",
                    onPressed: () async {
                      await authController.resetPassword(emailController.text);
                      emailController.clear();
                    }),
          ],
        ),
      ),
    );
  }
}
