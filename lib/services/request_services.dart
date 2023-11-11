import 'package:advance_player_academy_trainer/models/user_model.dart';
import 'package:advance_player_academy_trainer/services/notification_services.dart';
import 'package:advance_player_academy_trainer/widgets/show_custom_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestServices {
  sendRequestToPlayer(UserModel userModel) async {
    DocumentSnapshot userSnap =
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    try {
      if (userModel.requests!.contains(FirebaseAuth.instance.currentUser!.uid)) {
        showErrorMsg("Invitation Sent!");
      } else {
        await FirebaseFirestore.instance.collection('users').doc(userModel.userId).update({
          'requests': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });
        await FirebaseFirestore.instance.collection('requests').add({
          'toUserId': userModel.userId,
          'fromUserId': FirebaseAuth.instance.currentUser!.uid,
          'createdAt': DateTime.now(),
        });
        await NotificationServices.sendNotificationToUser(
          title: "Player Invitation Request",
          body: "${userSnap['username']} Want to Join Their Team",
          userId: userModel.userId,
        );
      }
    } on FirebaseAuthException catch (e) {
      showErrorMsg(e.message.toString());
    }
  }

  cancelSendRequest(UserModel userModel, requestId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userModel.userId).update({
        'requests': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
    } on FirebaseException catch (e) {
      showErrorMsg(e.message.toString());
    }
  }

  cancelReceiveRequest(String playerId, requestId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'requests': FieldValue.arrayRemove([playerId]),
      });
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
    } on FirebaseException catch (e) {
      showCustomMsg(e.message.toString());
    }
  }

  acceptReceiveRequest({String? userId, String? requestId}) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'players': FieldValue.arrayUnion([userId]),
        'requests': FieldValue.arrayRemove([userId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'trainers': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
      await NotificationServices.sendNotificationToUser(
        title: "Request Accepted",
        body: "${snapshot['username']} Accept Request of Player Joining",
        userId: userId,
      );
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
    } on FirebaseAuthException catch (e) {
      showCustomMsg(e.message.toString());
    }
  }
}
