import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

class GetUserDetails extends ChangeNotifier {
  UserModel _userModel = UserModel();
  UserModel get userData => _userModel;

  UserModel? _trainerData;

  UserModel get trainerData => _trainerData!;

  getUsersDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    _userModel = UserModel.fromDoc(snap);
    notifyListeners();
  }

  getTrainerDetail(String id) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(id).get();

    _trainerData = UserModel.fromDoc(snap);
    notifyListeners();
  }
}
