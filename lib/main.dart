import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'data/local/database/database.dart';
import 'domain/entities/participant.dart';
import 'domain/entities/review.dart';
import 'modules/review/review_repository.dart';
import 'modules/review/review_use_cases.dart';
import 'modules/travel/travel_repository.dart';
import 'modules/travel/travel_use_cases.dart';
import 'presentation/providers/login_provider.dart';
import 'presentation/providers/register_travel_provider.dart';
import 'presentation/providers/review_provider.dart';
import 'presentation/providers/travel_list_provider.dart';
import 'presentation/providers/user_preferences_provider.dart';
import 'presentation/widgets/my_app.dart';
import 'services/file_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase App
  await Firebase.initializeApp();

  /// Instantiate dependencies needed for dependency injection
  final travelRepository = TravelRepositoryImpl();
  final travelUseCases = TravelUseCasesImpl(travelRepository);

  final reviewRepository = ReviewRepositoryImpl();
  final reviewUseCases = ReviewUseCasesImpl(reviewRepository);

  /// Build App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TravelListProvider(travelUseCases),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterTravelProvider(travelUseCases),
        ),
        ChangeNotifierProvider(create: (context) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(reviewUseCases),
        ),
      ],
      child: const MyApp(),
    ),
  );

  /// Initialize dotenv
  await dotenv.load(fileName: '.env');

  /// Resets the database
  await DBConnection().getDatabase(reset: true);

  /// DEBUG
  /// TESTING PURPOSES ONLY
  // final reviews = await generateMockReviews();
  // await reviewUseCases.addReviews(reviews: reviews);
  // await reviewUseCases.getReviews();
}

Future<List<Review>> generateMockReviews() async {
  final mockAuthor1 = Participant(
    id: 1,
    name: 'Alice',
    age: 15,
    profilePicture: await FileService().getDefaultProfilePictureFile(),
  );

  return [
    Review(
      description: 'A fantastic place with beautiful views!',
      author: mockAuthor1,
      reviewDate: DateTime(2023, 10, 26),
      travelStopId: 1,
      stars: 5,
    ),
    Review(
      description: 'The food was great, but the service was a bit slow.',
      author: mockAuthor1,
      reviewDate: DateTime(2023, 10, 25),
      travelStopId: 2,
      stars: 3,
    ),
    Review(
      description: 'An unforgettable experience! Highly recommend.',
      author: mockAuthor1,
      reviewDate: DateTime(2023, 10, 24),
      travelStopId: 2,
      stars: 5,
    ),
  ];
}
