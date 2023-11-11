import 'package:advance_player_academy_trainer/models/training_model.dart';
import 'package:advance_player_academy_trainer/screens/home/home/home_screen.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:advance_player_academy_trainer/widgets/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingDetailScreen extends StatelessWidget {
  final TrainingModel trainingModel;
  const TrainingDetailScreen({super.key, required this.trainingModel});

  @override
  Widget build(BuildContext context) {
    String? youtubeVideoId = "";
    if (trainingModel.videoUrl == "") {
      youtubeVideoId = "";
    } else {
      youtubeVideoId = YoutubePlayer.convertUrlToId(trainingModel.videoUrl!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(trainingModel.categoryName!),
        actions: [
          InkWell(
              onTap: () {
                customAlertDialog(context, () async {
                  print(trainingModel.trainerId);
                  await FirebaseFirestore.instance.collection('trainings').doc(trainingModel.docId).delete();
                  Get.to(() => HomeScreen());
                }, "Are You Sure To Delete It?");
              },
              child: Icon(Icons.delete_forever, color: Colors.red[900])),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("Resource", style: AppTextStyle.H1.copyWith(fontWeight: FontWeight.normal)),
            SizedBox(height: 4),
            Text(trainingModel.resourceName!, style: AppTextStyle.H1),
            SizedBox(height: 2),
            Divider(thickness: 1, height: 1),
            SizedBox(height: 15),
            Text("Category", style: AppTextStyle.H1.copyWith(fontWeight: FontWeight.normal)),
            SizedBox(height: 4),
            Text(trainingModel.categoryName!, style: AppTextStyle.H1),
            SizedBox(height: 2),
            Divider(thickness: 1, height: 1),
            SizedBox(height: 15),
            Text("Image", style: AppTextStyle.H1.copyWith(fontWeight: FontWeight.normal)),
            SizedBox(height: 4),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(trainingModel.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 2),
            Divider(thickness: 1, height: 1),
            SizedBox(height: 15),
            Text("Video ", style: AppTextStyle.H1.copyWith(fontWeight: FontWeight.normal)),
            SizedBox(height: 4),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: YoutubePlayer(
                  bottomActions: [
                    ProgressBar(isExpanded: false),
                  ],
                  controller: YoutubePlayerController(
                    initialVideoId: youtubeVideoId!,
                    flags: YoutubePlayerFlags(
                      showLiveFullscreenButton: false,
                      hideThumbnail: true,
                      enableCaption: false,
                      forceHD: false,
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text("Description", style: AppTextStyle.H1.copyWith(fontWeight: FontWeight.normal)),
            SizedBox(height: 4),
            Text(trainingModel.description!, style: AppTextStyle.H1),
            SizedBox(height: 2),
            Divider(thickness: 1, height: 1),
          ],
        ),
      ),
    );
  }
}
