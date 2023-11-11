import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? trainerId;
  String? username;
  String? email;
  bool? isCoach;
  String? userImage;
  List? requests;
  List? players;
  List? trainers;

  UserModel({
    this.email,
    this.username,
    this.trainerId,
    this.isCoach,
    this.userId,
    this.userImage,
    this.players,
    this.requests,
    this.trainers,
  });

  factory UserModel.fromDoc(DocumentSnapshot snap) {
    return UserModel(
      userId: snap['uid'],
      username: snap['username'],
      email: snap['email'],
      isCoach: snap['isCoach'],
      userImage: snap['image'],
      trainerId: snap['trainerId'],
      requests: snap['requests'],
      players: snap['players'],
      trainers: snap['trainers'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': userId,
      'image': userImage,
      'username': username,
      'email': email,
      'isCoach': isCoach,
      'trainerId': trainerId,
      'players': players,
      'requests': requests,
      'trainers': trainers,
    };
  }
}
