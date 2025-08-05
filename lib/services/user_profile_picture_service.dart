import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePictureService {
  static const String _profilePictureKey = 'profilePicture';

  Future<File?> getCurrentProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();

    final filePath = prefs.getString(_profilePictureKey);

    if (!prefs.containsKey(_profilePictureKey) || filePath == null) {
      return null;
    }

    return File(filePath);
  }

  Future<void> saveProfilePicture(File? profilePicture) async {
    final prefs = await SharedPreferences.getInstance();

    if (profilePicture == null) return;

    await prefs.setString(_profilePictureKey, profilePicture.path);
  }
}
