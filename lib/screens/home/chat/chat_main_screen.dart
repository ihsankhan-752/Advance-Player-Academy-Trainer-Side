import 'dart:io';

import 'package:advance_player_academy_trainer/controllers/image_controller.dart';
import 'package:advance_player_academy_trainer/screens/home/chat/widgets/chat_card.dart';
import 'package:advance_player_academy_trainer/screens/home/chat/widgets/chat_input_bottom.dart';
import 'package:advance_player_academy_trainer/widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/get_trainer_details.dart';
import '../../../../models/chat_model.dart';
import '../../../../services/chat_db_services.dart';
import '../../../../utils/text_controllers.dart';

class ChatMainScreen extends StatefulWidget {
  final String userId;
  const ChatMainScreen({super.key, required this.userId});

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  String docId = '';
  var myId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    if (myId.hashCode > widget.userId.hashCode) {
      docId = myId + widget.userId;
    } else {
      docId = widget.userId + myId;
    }
    Provider.of<GetUserDetails>(context, listen: false).getTrainerDetail(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTextControllers appTextControllers = AppTextControllers();
    var imageController = Provider.of<ImageController>(context);
    return imageController.selectedImage == null
        ? Scaffold(
            appBar: AppBar(
              title: Consumer<GetUserDetails>(
                builder: (_, trainerDetails, __) {
                  return Text(trainerDetails.trainerData.username!);
                },
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Consumer<ChatDbServices>(
                builder: (_, chatController, __) {
                  return ChatInputBottom(
                    onCameraClicked: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomListTile(
                                  onPressed: () {
                                    Get.back();
                                    imageController.getUserImage(ImageSource.camera);
                                  },
                                  icon: Icons.camera_alt_outlined,
                                  title: "From Camera",
                                ),
                                CustomListTile(
                                  onPressed: () {
                                    Get.back();
                                    imageController.getUserImage(ImageSource.gallery);
                                  },
                                  icon: Icons.photo,
                                  title: "From Gallery",
                                ),
                                CustomListTile(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icons.cancel_outlined,
                                  title: "Cancel",
                                ),
                              ],
                            );
                          });
                    },
                    msgController: appTextControllers.chatController,
                    onPressed: () async {
                      chatController.sendTextMsg(
                        context: context,
                        msg: appTextControllers.chatController.text,
                        userId: widget.userId,
                        docId: docId,
                      );
                    },
                  );
                },
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(docId)
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No Message Found"),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 80, left: 10, right: 10),
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      ChatModel chatModel = ChatModel.fromDoc(snapshot.data!.docs[index]);
                      return ChatCard(chatModel: chatModel);
                    },
                  );
                },
              ),
            ))
        : Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    imageController.deleteUploadPhoto();
                  },
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
                SizedBox(width: 10),
                Consumer<ChatDbServices>(
                  builder: (_, chatController, __) {
                    return FloatingActionButton(
                      onPressed: () async {
                        chatController.sendImage(
                          context: context,
                          image: imageController.selectedImage,
                          userId: widget.userId,
                          docId: docId,
                        );
                        setState(() {
                          imageController.deleteUploadPhoto();
                        });
                      },
                      child: Icon(Icons.send),
                    );
                  },
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(imageController.selectedImage!.path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }
}
