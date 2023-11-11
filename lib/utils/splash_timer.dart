import 'dart:async';

import 'package:advance_player_academy_trainer/screens/auth/login_screen.dart';
import 'package:advance_player_academy_trainer/screens/home/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

splashTimer() {
  Timer(Duration(seconds: 3), () {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.to(HomeScreen());
    } else {
      Get.to(LoginScreen());
    }
  });
}
