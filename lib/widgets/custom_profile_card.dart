import 'package:flutter/material.dart';

import '../themes/text_styles.dart';

class CustomProfileCard extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final Widget? trailingWidget;
  const CustomProfileCard({super.key, required this.image, required this.title, required this.subTitle, this.trailingWidget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 35,
        backgroundImage: NetworkImage(image),
      ),
      title: Text(title, style: AppTextStyle.H1),
      subtitle: Text(subTitle,
          style: AppTextStyle.H1.copyWith(
            fontSize: 12,
          )),
      trailing: trailingWidget ?? SizedBox(),
    );
  }
}
