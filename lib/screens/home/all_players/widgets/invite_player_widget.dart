import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';
import '../../../../services/request_services.dart';
import '../../../../themes/text_styles.dart';
import '../../../../widgets/show_custom_msg.dart';

class InvitePlayerWidget extends StatelessWidget {
  const InvitePlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').where('isCoach', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No User Found"),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            UserModel userModel = UserModel.fromDoc(snapshot.data!.docs[index]);
            if (userModel.trainers!.contains(FirebaseAuth.instance.currentUser!.uid)) {
              return null;
            } else {
              return ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(userModel.userImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(userModel.username!, style: AppTextStyle.H1),
                subtitle: Text(userModel.email!,
                    style: AppTextStyle.H1.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    )),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                  ),
                  onPressed: () async {
                    if (userModel.requests!.contains(FirebaseAuth.instance.currentUser!.uid)) {
                      showCustomMsg("Invitation Sent");
                    } else {
                      await RequestServices().sendRequestToPlayer(userModel);
                    }
                  },
                  child: userModel.requests!.contains(FirebaseAuth.instance.currentUser!.uid)
                      ? Text(
                          "Invited",
                          style: AppTextStyle.H1.copyWith(
                            color: AppColors.primaryWhite,
                          ),
                        )
                      : Text(
                          "Invite",
                          style: AppTextStyle.H1.copyWith(
                            color: AppColors.primaryWhite,
                          ),
                        ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
