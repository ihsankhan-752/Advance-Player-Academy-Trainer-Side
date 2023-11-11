import 'dart:io';

import 'package:advance_player_academy_trainer/controllers/storage_controller.dart';
import 'package:advance_player_academy_trainer/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/show_custom_msg.dart';

class ChatDbServices extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  sendTextMsg({
    BuildContext? context,
    String? msg,
    String? userId,
    String? docId,
  }) async {
    if (msg!.isEmpty) {
      showCustomMsg("Enter Something");
    } else {
      setLoading(true);
      try {
        DocumentSnapshot snap = await FirebaseFirestore.instance.collection('chat').doc(docId).get();
        DocumentSnapshot userSnap =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

        if (!snap.exists) {
          await FirebaseFirestore.instance.collection('chat').doc(docId).set({
            'uids': [FirebaseAuth.instance.currentUser!.uid, userId],
            'msg': msg,
            'createdAt': DateTime.now(),
          });
        } else {
          await FirebaseFirestore.instance.collection('chat').doc(docId).update({
            'msg': msg,
            'createdAt': DateTime.now(),
          });
        }
        await FirebaseFirestore.instance.collection('chat').doc(docId).collection('messages').add({
          'msg': msg,
          'senderId': FirebaseAuth.instance.currentUser!.uid,
          'image': '',
          'senderName': userSnap['username'],
          'createdAt': DateTime.now(),
          'senderImage': userSnap['image'],
          'isChecked': {
            FirebaseAuth.instance.currentUser!.uid: true,
            userId: false,
          },
        });
        await NotificationServices.sendNotificationToUser(
          userId: userId,
          title: "Text Message From ${userSnap['username']}",
          body: msg,
        );
        setLoading(false);
        FocusScope.of(context!).unfocus();
        notifyListeners();
      } on FirebaseException catch (e) {
        setLoading(false);
        showCustomMsg(e.message.toString());
      }
    }
  }

  sendImage({
    BuildContext? context,
    File? image,
    String? userId,
    String? docId,
  }) async {
    setLoading(true);
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('chat').doc(docId).get();
      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      String imageUrl = await StorageController().uploadImageToDb(image!);

      if (!snap.exists) {
        await FirebaseFirestore.instance.collection('chat').doc(docId).set({
          'uids': [FirebaseAuth.instance.currentUser!.uid, userId],
          'msg': 'You Received an Image',
          'createdAt': DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection('chat').doc(docId).update({
          'msg': 'You Received an Image',
          'createdAt': DateTime.now(),
        });
      }
      await FirebaseFirestore.instance.collection('chat').doc(docId).collection('messages').add({
        'msg': '',
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'image': imageUrl,
        'senderName': userSnap['username'],
        'createdAt': DateTime.now(),
        'senderImage': userSnap['image'],
        'isChecked': {
          FirebaseAuth.instance.currentUser!.uid: true,
          userId: false,
        },
      });
      await NotificationServices.sendNotificationToUser(
        userId: userId,
        title: "Message From ${userSnap['username']}",
        body: '${userSnap['username']} Send Image',
      );
      setLoading(false);
      FocusScope.of(context!).unfocus();
      notifyListeners();
    } on FirebaseException catch (e) {
      setLoading(false);
      showCustomMsg(e.message.toString());
    }
  }
}
