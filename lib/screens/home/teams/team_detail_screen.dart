import 'package:advance_player_academy_trainer/controllers/loading_controller.dart';
import 'package:advance_player_academy_trainer/models/team_model.dart';
import 'package:advance_player_academy_trainer/models/user_model.dart';
import 'package:advance_player_academy_trainer/screens/home/teams/select_players_for_team.dart';
import 'package:advance_player_academy_trainer/screens/home/teams/team_main_screen.dart';
import 'package:advance_player_academy_trainer/services/team_services.dart';
import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:advance_player_academy_trainer/widgets/alert_dialog.dart';
import 'package:advance_player_academy_trainer/widgets/custom_profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TeamDetailScreen extends StatelessWidget {
  final TeamModel teamModel;
  const TeamDetailScreen({super.key, required this.teamModel});

  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          Get.to(
            () => SelectPlayersForTeam(teamModel: teamModel),
          );
        },
        child: Icon(Icons.add, color: AppColors.primaryWhite),
      ),
      appBar: AppBar(
        title: Text("Team Details"),
        actions: [
          InkWell(
            onTap: () {
              customAlertDialog(context, () async {
                await FirebaseFirestore.instance.collection('teams').doc(teamModel.teamId).delete();
                Get.to(() => TeamMainScreen());
              }, "Are You Sure To Delete This Team?");
            },
            child: Icon(Icons.delete_forever, color: Colors.red[900], size: 25),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(teamModel.teamLogo!),
              ),
              title: Text("Team Name : ${teamModel.teamName!}", style: AppTextStyle.H1),
              subtitle: Text(
                "Owner Name : ${teamModel.teamOwnerName!}",
                style: AppTextStyle.H1.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text("Player Information", style: AppTextStyle.H1),
            Column(
              children: [
                ...teamModel.players!.map((e) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(e).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        UserModel userModel = UserModel.fromDoc(snapshot.data!);
                        return CustomProfileCard(
                          image: userModel.userImage!,
                          title: userModel.username!,
                          subTitle: userModel.email!,
                          trailingWidget: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                            ),
                            onPressed: () {
                              customAlertDialog(context, () async {
                                Get.back();
                                await TeamService().removePlayerFromTeam(
                                  context: context,
                                  docId: teamModel.teamId,
                                  userId: userModel.userId,
                                );
                              }, "Are you Sure To Remove This Player");
                            },
                            child: Text("Remove", style: AppTextStyle.H1.copyWith(color: AppColors.primaryWhite)),
                          ),
                        );
                      });
                }).toList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
