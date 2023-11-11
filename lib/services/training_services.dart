import 'dart:io';

import 'package:advance_player_academy_trainer/controllers/storage_controller.dart';
import 'package:advance_player_academy_trainer/models/training_model.dart';
import 'package:advance_player_academy_trainer/screens/home/home/home_screen.dart';
import 'package:advance_player_academy_trainer/widgets/show_custom_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TrainingServices extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  uploadTraining({
    String? resourceName,
    String? categoryName,
    File? image,
    String? description,
    String? videoUrl,
  }) async {
    if (image == null) {
      showCustomMsg('Select Any Image');
    } else if (description!.isEmpty) {
      showCustomMsg('Add Description');
    } else if (videoUrl!.isEmpty) {
      showCustomMsg('Video Url is Required');
    } else {
      setLoading(true);

      try {
        var docId = Uuid().v4();
        String imageUrl = await StorageController().uploadImageToDb(File(image.path));

        TrainingModel trainingModel = TrainingModel(
          docId: docId,
          trainerId: FirebaseAuth.instance.currentUser!.uid,
          resourceName: resourceName,
          categoryName: categoryName,
          image: imageUrl,
          description: description,
          videoUrl: videoUrl,
        );
        await FirebaseFirestore.instance.collection('trainings').doc(docId).set(trainingModel.toMap());
        setLoading(false);
        showCustomMsg("Training Upload Successfully");
        Get.to(() => HomeScreen());
      } on FirebaseException catch (err) {
        setLoading(false);
        showCustomMsg(err.message.toString());
      }
    }
  }
}
