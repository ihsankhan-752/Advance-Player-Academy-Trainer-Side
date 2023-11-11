import 'package:advance_player_academy_trainer/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_profile_card.dart';
import '../../chat/chat_main_screen.dart';

class MyPlayerWidget extends StatelessWidget {
  const MyPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('isCoach', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data!.docs
              .map((doc) => UserModel.fromDoc(doc))
              .where((userModel) => userModel.trainers!.contains(FirebaseAuth.instance.currentUser!.uid))
              .toList();

          if (users.isEmpty) {
            return Center(
              child: Text("No Player Found"),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel userModel = users[index];
              return CustomProfileCard(
                image: userModel.userImage!,
                title: userModel.username!,
                subTitle: userModel.email!,
                trailingWidget: InkWell(
                  onTap: () {
                    Get.to(() => ChatMainScreen(userId: userModel.userId!));
                  },
                  child: Icon(Icons.chat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
