import 'package:advance_player_academy_trainer/screens/home/chat/widgets/photo_full_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../models/chat_model.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chatModel;
  const ChatCard({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: chatModel.senderId == FirebaseAuth.instance.currentUser!.uid
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: chatModel.senderId == FirebaseAuth.instance.currentUser!.uid
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(chatModel.senderImage!),
            )
          ],
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: chatModel.senderId == FirebaseAuth.instance.currentUser!.uid
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 05),
              decoration: BoxDecoration(
                color: chatModel.senderId == FirebaseAuth.instance.currentUser!.uid
                    ? AppColors.mainColor
                    : Colors.blueGrey,
                borderRadius: chatModel.senderId == FirebaseAuth.instance.currentUser!.uid
                    ? BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeago.format(chatModel.createdAt!),
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  SizedBox(height: 4),
                  chatModel.msg != ""
                      ? Container(
                          width: 130,
                          child: Text(
                            chatModel.msg!,
                            style: AppTextStyle.H1.copyWith(
                              fontWeight: FontWeight.normal,
                              color: AppColors.primaryWhite,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Get.to(() => PhotoFullView(imageLink: chatModel.image!));
                          },
                          child: SizedBox(
                            height: 45,
                            width: 65,
                            child: Image.network(chatModel.image!, fit: BoxFit.cover),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
