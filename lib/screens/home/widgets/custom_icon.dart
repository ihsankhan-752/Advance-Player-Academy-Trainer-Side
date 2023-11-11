import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String? image;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const CustomIcon({
    super.key,
    this.image,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/images/${image}.png',
              height: 25,
              width: 25,
            ),
          )),
    );
  }
}
