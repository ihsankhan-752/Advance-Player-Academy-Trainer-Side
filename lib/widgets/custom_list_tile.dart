import 'package:flutter/material.dart';

import '../themes/text_styles.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final IconData? icon;
  const CustomListTile({super.key, this.title, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed ?? () {},
          leading: Icon(icon!),
          title: Text(title!, style: AppTextStyle.H1),
        ),
        Divider(height: 0.1),
      ],
    );
  }
}
