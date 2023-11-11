import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/request_services.dart';
import '../themes/app_colors.dart';
import '../themes/text_styles.dart';

class WidgetForAcceptOrRejectRequest extends StatelessWidget {
  final UserModel userModel;
  final String docId;
  const WidgetForAcceptOrRejectRequest({super.key, required this.userModel, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 05),
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(userModel.userImage!),
          ),
          title: Text(userModel.username!, style: AppTextStyle.H1),
          subtitle: Row(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await RequestServices().acceptReceiveRequest(
                    userId: userModel.userId!,
                    requestId: docId,
                  );
                },
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      "Accept",
                      style: AppTextStyle.H1.copyWith(
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await RequestServices().cancelReceiveRequest(userModel.userId!, docId);
                },
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      "Reject",
                      style: AppTextStyle.H1.copyWith(
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(height: 0.1),
      ],
    );
  }
}
