import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageController {
  Future<String> uploadImageToDb(File selectedImage) async {
    FirebaseStorage fs = FirebaseStorage.instance;
    Reference reference = await fs.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
    await reference.putFile(File(selectedImage.path));
    String imageUrl = await reference.getDownloadURL();

    return imageUrl;
  }
}
