import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controllers/image_controller.dart';
import 'custom_list_tile.dart';

photoUploadingBottomSheet(BuildContext context) {
  final imageController = Provider.of<ImageController>(context, listen: false);
  showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomListTile(
              onPressed: () {
                Navigator.pop(context);
                imageController.getUserImage(ImageSource.camera);
              },
              icon: Icons.camera_alt,
              title: "From Camera",
            ),
            CustomListTile(
              onPressed: () {
                Navigator.pop(context);
                imageController.getUserImage(ImageSource.gallery);
              },
              icon: Icons.photo,
              title: "From Gallery",
            ),
            CustomListTile(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icons.close,
              title: "Cancel",
            )
          ],
        );
      });
}
