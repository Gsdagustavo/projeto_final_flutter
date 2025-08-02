import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  static const _defaultProfilePicturePath =
      'assets/images/default_profile_picture.png';

  Future<File> getDefaultProfilePictureFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/default_profile_picture.png');
    if (await file.exists()) return file;

    final data = await rootBundle.load(
      'assets/images/default_profile_picture.png',
    );

    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes);

    return file;
  }

  Future<File?> pickImage() async {
    final imageXFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (imageXFile == null) {
      debugPrint('Image XFile is null');
      return null;
    }

    return File(imageXFile.path);
  }
}
