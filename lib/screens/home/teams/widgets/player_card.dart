// import 'package:advance_player_academy_trainer/models/team_model.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../themes/text_styles.dart';
//
// class PlayerCard extends StatelessWidget {
//   final TeamModel teamModel;
//   const PlayerCard({super.key, required this.teamModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: teamModel.playerNames!.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               ListTile(
//                 leading: Container(
//                   height: 45,
//                   width: 45,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(teamModel.playerImages![index]),
//                       fit: BoxFit.cover,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 title: Text(teamModel.playerNames![index], style: AppTextStyle.H1),
//                 subtitle: Text(teamModel.playerRole![index], style: AppTextStyle.H1.copyWith(fontSize: 12)),
//                 trailing: Text(
//                   teamModel.playerAges![index].toString() + " " + "years",
//                   style: AppTextStyle.H1.copyWith(fontSize: 10),
//                 ),
//               ),
//               Divider(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
