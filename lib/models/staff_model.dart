import 'package:cloud_firestore/cloud_firestore.dart';

class StaffModel {
  String? docId;
  String? image;
  String? name;
  String? email;
  int? contact;
  String? role;
  String? trainerId;

  StaffModel({
    this.image,
    this.docId,
    this.email,
    this.name,
    this.contact,
    this.role,
    this.trainerId,
  });

  factory StaffModel.fromDoc(DocumentSnapshot snap) {
    return StaffModel(
      docId: snap['docId'],
      image: snap['image'],
      name: snap['name'],
      email: snap['email'],
      contact: snap['contact'],
      role: snap['role'],
      trainerId: snap['trainerId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'image': image,
      'name': name,
      'email': email,
      'contact': contact,
      'role': role,
      'trainerId': trainerId,
    };
  }
}
