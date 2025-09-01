import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../domain/entities/participant.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/travel_stop.dart';
import '../../modules/review/review_use_cases.dart';
import '../../services/file_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewUseCases _reviewUseCases;

  ReviewProvider(this._reviewUseCases);

  final _fileService = FileService();

  final _images = <File>[];

  final _key = GlobalKey<FormState>();

  final _reviewController = TextEditingController();

  int _reviewRate = 5;

  Participant? _author;

  String? _errorMessage;

  Future<void> pickReviewImage() async {
    final image = await _fileService.pickImage();

    if (image == null) {
      _errorMessage = 'Invalid image';
      notifyListeners();
      return;
    }

    _images.add(image);

    notifyListeners();
  }

  Future<void> addReview(TravelStop stop) async {
    final review = Review(
      description: _reviewController.text,
      author: _author!,
      reviewDate: DateTime.now(),
      travelStopId: stop.id,
      stars: _reviewRate,
    );

    await _reviewUseCases.addReviews(reviews: [review]);
    notifyListeners();
  }

  Future<void> submitReview(TravelStop stop) async {
    if (!_key.currentState!.validate()) {
      /// TODO: intl
      _errorMessage = 'Invalid review description';
      notifyListeners();
      return;
    }

    await addReview(stop);
    notifyListeners();
  }

  int get reviewRate => _reviewRate;

  set reviewRate(int value) {
    _reviewRate = value;
    notifyListeners();
  }

  TextEditingController get reviewController => _reviewController;

  List<File> get images => _images;

  GlobalKey<FormState> get key => _key;
}
