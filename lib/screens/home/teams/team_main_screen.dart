import 'package:advance_player_academy_trainer/models/team_model.dart';
import 'package:advance_player_academy_trainer/screens/home/teams/widgets/team_card.dart';
import 'package:advance_player_academy_trainer/screens/home/upload/upload_team_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamMainScreen extends StatefulWidget {
  const TeamMainScreen({super.key});

  @override
  State<TeamMainScreen> createState() => _TeamMainScreenState();
}

class _TeamMainScreenState extends State<TeamMainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => UploadTeamInfoScreen());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Teams"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Team Added Yet!"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              TeamModel teamModel = TeamModel.fromDoc(snapshot.data!.docs[index]);

              return TeamCard(teamModel: teamModel);
            },
          );
        },
      ),
    );
  }
}
