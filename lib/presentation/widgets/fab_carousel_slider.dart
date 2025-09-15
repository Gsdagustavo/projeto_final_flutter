import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

/// A carousel slider widget that displays a list of images with optional
/// zooming capabilities using [InstaImageViewer].
///
/// Supports automatic sliding, infinite scroll, and indicator dots for multiple
/// images.
class FabCarouselSlider extends StatefulWidget {
  /// Creates a [FabCarouselSlider].
  ///
  /// The [photos] parameter must not be null and should contain at least one
  /// image file.
  const FabCarouselSlider({
    super.key,
    this.autoPlay = true,
    required this.photos,
    this.useImageViewer = true,
  });

  /// Determines whether tapping on an image should allow zooming
  /// using [InstaImageViewer]. Defaults to `true`.
  final bool useImageViewer;

  /// Determines whether the carousel should automatically scroll
  /// through the images. Defaults to `true`.
  final bool autoPlay;

  /// A list of image files to be displayed in the carousel.
  final List<File?> photos;

  @override
  State<FabCarouselSlider> createState() => _FabCarouselSliderState();
}

/// The state for [FabCarouselSlider] that manages the current photo index
/// and builds the carousel slider with optional indicators.
class _FabCarouselSliderState extends State<FabCarouselSlider> {
  /// The index of the currently displayed photo in the carousel.
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.photos.length,
          itemBuilder: (context, index, realIndex) {
            final img = widget.photos[index];

            return AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: _currentPhotoIndex == index ? 1.0 : 0.9,
              curve: Curves.easeInOut,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Builder(
                  builder: (context) {
                    final image = Image.file(
                      img!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    );

                    return widget.useImageViewer
                        ? InstaImageViewer(child: image)
                        : image;
                  },
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: widget.autoPlay,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPhotoIndex = index % widget.photos.length;
              });
            },
          ),
        ),

        /// Shows indicator dots if there is more than one image.
        if (widget.photos.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.photos.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPhotoIndex == index ? 12 : 8,
                  height: _currentPhotoIndex == index ? 12 : 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPhotoIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
