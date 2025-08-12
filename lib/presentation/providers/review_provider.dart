import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../services/file_service.dart';

class ReviewProvider with ChangeNotifier {
  final _fileService = FileService();

  final _images = <File>[];
  final _reviewController = TextEditingController();
  double _reviewRate = 5;

  Future<void> pickReviewImage() async {
    final image = await _fileService.pickImage();

    /// TODO: add proper validation
    if (image == null) return;

    _images.add(image);

    notifyListeners();
  }

  Future<void> addReview() async {}

  double get reviewRate => _reviewRate;

  set reviewRate(double value) {
    _reviewRate = value;
  }

  get reviewController => _reviewController;

  get images => _images;

  get fileService => _fileService;
}
