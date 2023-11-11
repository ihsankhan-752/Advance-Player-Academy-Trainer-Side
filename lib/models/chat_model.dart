import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? senderId;
  String? msg;
  String? senderName;
  DateTime? createdAt;
  String? senderImage;
  String? image;
  ChatModel({this.msg, this.senderId, this.senderName, this.createdAt, this.senderImage, this.image});

  factory ChatModel.fromDoc(DocumentSnapshot snap) {
    return ChatModel(
      createdAt: (snap['createdAt'].toDate()),
      msg: snap['msg'],
      senderName: snap['senderName'],
      senderId: snap['senderId'],
      senderImage: snap['senderImage'],
      image: snap['image'],
    );
  }
}
