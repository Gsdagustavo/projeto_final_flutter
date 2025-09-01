import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../domain/entities/review.dart';
import '../../modules/review/review_use_cases.dart';
import '../../services/file_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewUseCases _reviewUseCases;
  final _fileService = FileService();

  ReviewProvider(this._reviewUseCases);

  final _reviews = <Review>[];
  String? _errorMessage;

  Future<void> addReview(Review review) async {
    debugPrint('add review provider');
    await _reviewUseCases.addReviews(reviews: [review]);
    _reviews.add(review);
    notifyListeners();
  }

  bool get hasError => _errorMessage != null;

  String? get errorMessage => _errorMessage!;

  List<Review> get reviews => _reviews;
}
