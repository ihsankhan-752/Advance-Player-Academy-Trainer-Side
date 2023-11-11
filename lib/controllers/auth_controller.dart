import 'dart:io';

import 'package:advance_player_academy_trainer/controllers/storage_controller.dart';
import 'package:advance_player_academy_trainer/screens/home/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../screens/auth/login_screen.dart';
import '../widgets/show_custom_msg.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  signUp({
    String? email,
    String? password,
    String? username,
    File? userImage,
  }) async {
    if (userImage == null) {
      showCustomMsg("Image is Required");
    } else if (email!.isEmpty) {
      showCustomMsg("Email Must Be Filled");
    } else if (username!.isEmpty) {
      showCustomMsg("Enter username");
    } else if (password!.isEmpty) {
      showCustomMsg("Enter Your Password");
    } else {
      setLoading(true);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        String imageUrl = await StorageController().uploadImageToDb(userImage);
        UserModel userModel = UserModel(
          email: email,
          userId: FirebaseAuth.instance.currentUser!.uid,
          username: username,
          userImage: imageUrl,
          isCoach: true,
          players: [],
          requests: [],
          trainers: [],
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(userModel.toMap());
        email = '';
        password = '';
        username = '';
        userImage = null;
        notifyListeners();
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        showCustomMsg("Please Verify Your Email And Login With Your Credentials");
        setLoading(false);
        Get.to(() => LoginScreen());
      } on FirebaseAuthException catch (error) {
        setLoading(false);
        showCustomMsg(error.message.toString());
      }
    }
  }

  signIn({String? email, String? password}) async {
    if (email!.isEmpty) {
      showCustomMsg('Email Must Be Filled');
    } else if (password!.isEmpty) {
      showCustomMsg('Password Must Be Filled');
    } else {
      setLoading(true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        email = '';
        password = '';
        setLoading(false);
        notifyListeners();
        DocumentSnapshot snap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        if (snap['isCoach'] == true) {
          Get.to(HomeScreen());
        } else {
          showCustomMsg("Trainer Side Only Trainer Are Allowed");
        }
      } on FirebaseAuthException catch (error) {
        setLoading(false);
        showCustomMsg(error.message.toString());
      }
    }
  }

  resetPassword(String email) async {
    setLoading(true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      email = '';
      notifyListeners();
      setLoading(false);
      showCustomMsg("Reset Your Email and Login Again with New Password");
      Get.to(LoginScreen());
    } on FirebaseAuthException catch (err) {
      setLoading(false);
      showCustomMsg(err.message.toString());
    }
  }
}
