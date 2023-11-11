import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final String? title;
  const PrimaryButton({super.key, this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primaryBlack,
        ),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(
              color: AppColors.primaryWhite,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectionAndUnSelectionButton extends StatelessWidget {
  final Function() onPressed;
  final Color backgroundColor;
  final String title;
  final Color textColor;
  const SelectionAndUnSelectionButton(
      {super.key,
      required this.onPressed,
      required this.backgroundColor,
      required this.title,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
      onPressed: onPressed,
      child: Text(
        "$title",
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
