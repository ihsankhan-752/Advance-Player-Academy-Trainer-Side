import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';
import '../../../../widgets/widget_for_accept_or_reject_request.dart';

class ReceivedRequestTab extends StatelessWidget {
  const ReceivedRequestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('toUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                  stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index]['fromUserId']).snapshots(),
                  builder: (context, userSnap) {
                    if (!userSnap.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    UserModel userModel = UserModel.fromDoc(userSnap.data!);
                    return WidgetForAcceptOrRejectRequest(
                      userModel: userModel,
                      docId: snapshot.data!.docs[index].id,
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
