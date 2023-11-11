import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isIconReq;
  final bool isVisible;
  final Widget? widget;
  final Function(String v)? onChanged;
  const CustomTextInput(
      {super.key,
      required this.controller,
      required this.hintText,
      this.isIconReq = false,
      this.widget,
      this.isVisible = false,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlack),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 08),
        child: TextField(
          onChanged: onChanged ?? (v) {},
          obscureText: isVisible,
          controller: controller,
          decoration: InputDecoration(
            hintText: "$hintText",
            border: InputBorder.none,
            suffixIcon: isIconReq ? widget : SizedBox(),
          ),
        ),
      ),
    );
  }
}
