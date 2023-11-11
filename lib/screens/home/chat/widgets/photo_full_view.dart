import 'package:flutter/material.dart';

class PhotoFullView extends StatelessWidget {
  final String imageLink;
  const PhotoFullView({super.key, required this.imageLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo View"),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
        image: NetworkImage(imageLink),
        fit: BoxFit.cover,
      ))),
    );
  }
}
