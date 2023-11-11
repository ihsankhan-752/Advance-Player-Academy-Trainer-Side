import 'package:advance_player_academy_trainer/controllers/auth_controller.dart';
import 'package:advance_player_academy_trainer/controllers/visibility_controller.dart';
import 'package:advance_player_academy_trainer/screens/auth/forgot_pass_screen.dart';
import 'package:advance_player_academy_trainer/screens/auth/signup_screen.dart';
import 'package:advance_player_academy_trainer/widgets/buttons.dart';
import 'package:advance_player_academy_trainer/widgets/custom_text_input.dart';
import 'package:advance_player_academy_trainer/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: SizedBox(height: 130, child: LogoWidget())),
              SizedBox(height: 25),
              CustomTextInput(controller: emailController, hintText: "E-mail"),
              SizedBox(height: 10),
              Consumer<VisibilityController>(
                builder: (_, value, __) {
                  return CustomTextInput(
                    controller: passwordController,
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
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Get.to(ForgotPasswordScreen());
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: 30),
              authController.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : PrimaryButton(
                      title: "Login",
                      onPressed: () async {
                        await authController.signIn(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        emailController.clear();
                        passwordController.clear();
                      }),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Get.to(SignUpScreen());
                },
                child: Center(
                  child: Text("Don't Have an Account? SignUp"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
