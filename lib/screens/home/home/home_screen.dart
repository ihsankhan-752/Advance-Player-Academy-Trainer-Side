import 'package:advance_player_academy_trainer/controllers/get_trainer_details.dart';
import 'package:advance_player_academy_trainer/screens/home/home/widgets/custom_drawer.dart';
import 'package:advance_player_academy_trainer/screens/home/requests/request_screen.dart';
import 'package:advance_player_academy_trainer/screens/home/upload/upload_training_screens.dart';
import 'package:advance_player_academy_trainer/screens/home/widgets/custom_training_card.dart';
import 'package:advance_player_academy_trainer/services/notification_services.dart';
import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:advance_player_academy_trainer/themes/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/training_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    Provider.of<GetUserDetails>(context, listen: false).getUsersDetails();
    notificationServices.getNotificationPermission();
    notificationServices.getDeviceToken();
    notificationServices.initNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.mainColor,
          onPressed: () {
            Get.to(() => UploadTrainingScreen());
          },
          child: Icon(Icons.add, color: AppColors.primaryWhite),
        ),
        drawer: CustomDrawer(),
        appBar: AppBar(
          actions: [
            InkWell(
                onTap: () {
                  Get.to(() => RequestScreen());
                },
                child: Icon(Icons.notification_important_outlined)),
            SizedBox(width: 10),
          ],
          title: Text("Trainings"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('trainings')
              .where('trainerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No Training Found\nUpload Some Training",
                    textAlign: TextAlign.center, style: AppTextStyle.H1),
              );
            } else {
              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  TrainingModel trainingModel = TrainingModel.fromDoc(snapshot.data!.docs[index]);
                  return CustomTrainingCard(trainingModel: trainingModel);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
