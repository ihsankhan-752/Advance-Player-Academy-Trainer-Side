import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingModel {
  String? docId;
  String? trainerId;
  String? resourceName;
  String? categoryName;
  String? image;
  String? description;
  String? videoUrl;

  TrainingModel({
    this.docId,
    this.videoUrl,
    this.image,
    this.description,
    this.categoryName,
    this.resourceName,
    this.trainerId,
  });

  factory TrainingModel.fromDoc(DocumentSnapshot snap) {
    return TrainingModel(
      docId: snap['docId'],
      trainerId: snap['trainerId'],
      resourceName: snap['resourceName'],
      categoryName: snap['categoryName'],
      image: snap['image'],
      description: snap['description'],
      videoUrl: snap['videoUrl'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'trainerId': trainerId,
      'resourceName': resourceName,
      'categoryName': categoryName,
      'image': image,
      'description': description,
      'videoUrl': videoUrl,
    };
  }
}
