/// A centralized class for storing asset paths used throughout the app.
///
/// This helps avoid hardcoding asset paths in multiple places,
/// making maintenance easier and reducing typos.
class AssetsPaths {
  /// Path to the default profile picture.
  ///
  /// This image is used whenever a user has not set a custom profile picture.
  static const defaultProfilePicturePath =
      'assets/images/default_profile_picture.png';

  /// Path to a placeholder image.
  ///
  /// Can be used as a temporary image while loading network images
  /// or for empty content placeholders.
  static const placeholderImage = 'assets/images/placeholder.png';

  /// Path to a app logo image.
  static const appLogo = 'assets/images/app_logo.png';
}
