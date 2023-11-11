import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';
import '../../../../services/request_services.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/text_styles.dart';
import '../../../../widgets/custom_profile_card.dart';

class SendRequestTab extends StatelessWidget {
  const SendRequestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('fromUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Request Found"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index]['toUserId']).snapshots(),
                  builder: (context, userSnap) {
                    if (!userSnap.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    UserModel userModel = UserModel.fromDoc(userSnap.data!);
                    return CustomProfileCard(
                      image: userModel.userImage!,
                      title: userModel.username!,
                      subTitle: userModel.email!,
                      trailingWidget: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          await RequestServices().cancelSendRequest(userModel, snapshot.data!.docs[index].id);
                        },
                        child: Text("Cancel", style: AppTextStyle.H1.copyWith(color: AppColors.primaryWhite)),
                      ),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
