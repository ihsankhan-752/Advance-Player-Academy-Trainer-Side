import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  String? teamId;
  String? ownerId;
  String? teamLogo;
  String? teamName;
  String? teamOwnerName;
  String? teamLocation;
  List? players;

  TeamModel({
    this.ownerId,
    this.teamId,
    this.teamLocation,
    this.teamLogo,
    this.teamName,
    this.players,
    this.teamOwnerName,
  });

  factory TeamModel.fromDoc(DocumentSnapshot snapshot) {
    return TeamModel(
        ownerId: snapshot['ownerId'],
        teamId: snapshot['teamId'],
        teamLogo: snapshot['teamLogo'],
        teamName: snapshot['teamName'],
        teamOwnerName: snapshot['teamOwnerName'],
        players: snapshot['players'],
        teamLocation: snapshot['teamLocation']);
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'teamId': teamId,
      'teamLogo': teamLogo,
      'teamName': teamName,
      'teamOwnerName': teamOwnerName,
      'teamLocation': teamLocation,
      'players': players,
    };
  }
}
