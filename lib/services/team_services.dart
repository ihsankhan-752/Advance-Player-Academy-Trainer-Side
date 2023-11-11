import 'dart:io';

import 'package:advance_player_academy_trainer/controllers/loading_controller.dart';
import 'package:advance_player_academy_trainer/controllers/storage_controller.dart';
import 'package:advance_player_academy_trainer/models/team_model.dart';
import 'package:advance_player_academy_trainer/screens/home/home/home_screen.dart';
import 'package:advance_player_academy_trainer/screens/home/teams/team_main_screen.dart';
import 'package:advance_player_academy_trainer/widgets/show_custom_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TeamService {
  uploadTeamInformation({
    BuildContext? context,
    File? teamLogo,
    String? teamName,
    String? ownerName,
    String? teamLocation,
  }) async {
    if (teamLogo == null) {
      showErrorMsg('Upload Team Logo');
    } else if (teamName!.isEmpty) {
      showErrorMsg('Team Name Required');
    } else if (ownerName!.isEmpty) {
      showErrorMsg('Owner Name Required');
    } else if (teamLocation!.isEmpty) {
      showErrorMsg('Team Location Required');
    } else {
      Provider.of<LoadingController>(context!, listen: false).setLoading(true);
      try {
        var docId = Uuid().v4();

        String teamImage = await StorageController().uploadImageToDb(teamLogo);
        TeamModel teamModel = TeamModel(
          ownerId: FirebaseAuth.instance.currentUser!.uid,
          teamId: docId,
          teamLogo: teamImage,
          teamName: teamName,
          teamOwnerName: ownerName,
          teamLocation: teamLocation,
          players: [],
        );
        await FirebaseFirestore.instance.collection('teams').doc(docId).set(teamModel.toMap());
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        Get.to(() => HomeScreen());
      } on FirebaseException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showErrorMsg(e.message.toString());
      }
    }
  }

  addingPlayerToTeam({BuildContext? context, String? docId, String? userID}) async {
    try {
      Provider.of<LoadingController>(context!, listen: false).setLoading(true);
      await FirebaseFirestore.instance.collection('teams').doc(docId).update({
        'players': FieldValue.arrayUnion([userID]),
      });
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Get.to(() => TeamMainScreen());
      showCustomMsg("Player Added Successfully");
    } on FirebaseException catch (e) {
      showCustomMsg(e.message.toString());
      Provider.of<LoadingController>(context!, listen: false).setLoading(false);
    }
  }

  removePlayerFromTeam({BuildContext? context, String? docId, String? userId}) async {
    try {
      Provider.of<LoadingController>(context!, listen: false).setLoading(true);
      await FirebaseFirestore.instance.collection('teams').doc(docId).update({
        'players': FieldValue.arrayRemove([userId]),
      });
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Get.back();
      showCustomMsg('Player is Removed From Team');
    } on FirebaseException catch (e) {
      showCustomMsg(e.message.toString());
      Provider.of<LoadingController>(context!, listen: false).setLoading(false);
    }
  }
}
