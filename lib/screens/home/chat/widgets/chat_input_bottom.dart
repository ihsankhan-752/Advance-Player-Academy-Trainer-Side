import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/chat_db_services.dart';
import '../../../../../themes/app_colors.dart';

class ChatInputBottom extends StatelessWidget {
  final TextEditingController msgController;
  final Function()? onPressed;
  final Function()? onCameraClicked;
  const ChatInputBottom({super.key, required this.msgController, this.onPressed, this.onCameraClicked});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatDbServices>(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                style: TextStyle(
                  color: AppColors.primaryWhite,
                ),
                controller: msgController,
                decoration: InputDecoration(
                  hintText: "Message..",
                  hintStyle: TextStyle(
                    color: AppColors.primaryWhite,
                  ),
                  border: InputBorder.none,
                  suffixIcon: InkWell(
                      onTap: onCameraClicked ?? () {},
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primaryWhite,
                      )),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: onPressed ?? () {},
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mainColor,
            ),
            child: Center(
              child: chatController.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Icon(Icons.send, color: AppColors.primaryWhite),
            ),
          ),
        ),
      ],
    );
  }
}
