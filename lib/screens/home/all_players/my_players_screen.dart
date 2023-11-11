import 'package:advance_player_academy_trainer/screens/home/all_players/player_for_joining_team.dart';
import 'package:advance_player_academy_trainer/screens/home/all_players/widgets/my_player_widget.dart';
import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPlayersScreen extends StatefulWidget {
  const AllPlayersScreen({super.key});

  @override
  State<AllPlayersScreen> createState() => _AllPlayersScreenState();
}

class _AllPlayersScreenState extends State<AllPlayersScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          Get.to(() => PlayersForJoiningTeam());
        },
        child: Icon(Icons.add, color: AppColors.primaryWhite),
      ),
      appBar: AppBar(
        title: Text("Players"),
      ),
      body: Column(
        children: [
          MyPlayerWidget(),
        ],
      ),
    );
  }
}
