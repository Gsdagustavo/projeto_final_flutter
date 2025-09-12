import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/assets_paths.dart';

/// A service for handling file-related operations such as
/// retrieving the default profile picture and picking images from the gallery.
class FileService {
  /// Returns a [File] representing the default profile picture.
  ///
  /// If the file already exists in the application's documents directory,
  /// it returns that file. Otherwise, it copies the default profile picture
  /// from the assets to the documents directory and then returns it.
  Future<File> getDefaultProfilePictureFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/default_profile_picture.png');
    if (await file.exists()) return file;

    final data = await rootBundle.load(AssetsPaths.defaultProfilePicturePath);

    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes);

    return file;
  }

  /// Opens the image picker for the user to select an image from the gallery.
  ///
  /// Returns a [File] representing the selected image, or `null` if
  /// the user cancels the selection.
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
