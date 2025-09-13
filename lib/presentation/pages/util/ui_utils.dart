import 'package:flutter/material.dart';

import '../../../domain/entities/enums.dart';

/// Global padding to use in cards
const double cardPadding = 16;

/// Returns a map associating [Experience] enum values to icons.
Map<Experience, IconData> experiencesIcons() {
  return {
    Experience.cultureImmersion: Icons.language,
    Experience.alternativeCuisines: Icons.dining_outlined,
    Experience.visitHistoricalPlaces: Icons.account_balance,
    Experience.visitLocalEstablishments: Icons.storefront,
    Experience.contactWithNature: Icons.park,
    Experience.socialEvents: Icons.celebration,
  };
}