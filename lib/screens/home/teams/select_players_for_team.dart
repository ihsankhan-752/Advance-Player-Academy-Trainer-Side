import 'package:advance_player_academy_trainer/controllers/loading_controller.dart';
import 'package:advance_player_academy_trainer/models/team_model.dart';
import 'package:advance_player_academy_trainer/models/user_model.dart';
import 'package:advance_player_academy_trainer/services/team_services.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:advance_player_academy_trainer/widgets/alert_dialog.dart';
import 'package:advance_player_academy_trainer/widgets/custom_profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../themes/app_colors.dart';

class SelectPlayersForTeam extends StatefulWidget {
  final TeamModel teamModel;
  const SelectPlayersForTeam({super.key, required this.teamModel});

  @override
  State<SelectPlayersForTeam> createState() => _SelectPlayersForTeamState();
}

class _SelectPlayersForTeamState extends State<SelectPlayersForTeam> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Players"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          UserModel userModel = UserModel.fromDoc(snapshot.data!);

          List myPlayerList = List.from(userModel.players!);
          if (myPlayerList.isEmpty) {
            return Center(
              child: Text(
                "No Player Found",
              ),
            );
          }

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').where('uid', whereIn: myPlayerList).snapshots(),
            builder: (context, userSnap) {
              if (!userSnap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (userSnap.data!.docs.isEmpty) {
                return Center(
                  child: Text("No Player Found"),
                );
              }

              return ListView.builder(
                itemCount: userSnap.data!.docs.length,
                itemBuilder: (context, index) {
                  var userData = userSnap.data!.docs[index];
                  if (widget.teamModel.players!.contains(userData['uid'])) {
                    return SizedBox();
                  } else {
                    return Column(
                      children: [
                        CustomProfileCard(
                            image: userData['image'],
                            title: userData['username'],
                            subTitle: userData['email'],
                            trailingWidget: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainColor,
                              ),
                              onPressed: () {
                                customAlertDialog(context, () async {
                                  Get.back();
                                  await TeamService().addingPlayerToTeam(
                                    context: context,
                                    docId: widget.teamModel.teamId,
                                    userID: userData['uid'],
                                  );
                                }, "Are you Sure To Add This Player?");
                              },
                              child: Text(
                                "Add",
                                style: AppTextStyle.H1.copyWith(
                                  color: AppColors.primaryWhite,
                                ),
                              ),
                            )),
                        Divider(height: 0.1),
                      ],
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
