import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../domain/entities/participant.dart';
import '../../domain/entities/review.dart';
import '../../modules/review/review_use_cases.dart';
import '../../services/file_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewUseCases _reviewUseCases;

  ReviewProvider(this._reviewUseCases);

  final _fileService = FileService();

  final _images = <File>[];
  final _reviewController = TextEditingController();
  int _reviewRate = 5;
  Participant? _author;

  Future<void> pickReviewImage() async {
    final image = await _fileService.pickImage();

    /// TODO: add proper validation
    if (image == null) return;

    _images.add(image);

    notifyListeners();
  }

  Future<void> addReview({required int travelStopId}) async {
    final review = Review(
      description: _reviewController.text,
      author: _author!,
      reviewDate: DateTime.now(),
      travelStopId: travelStopId,
      stars: _reviewRate,
    );

    await _reviewUseCases.addReviews(reviews: [review]);
  }

  int get reviewRate => _reviewRate;

  set reviewRate(int value) {
    _reviewRate = value;
    notifyListeners();
  }

  get reviewController => _reviewController;

  get images => _images;

  get fileService => _fileService;
}
