import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class FabCarouselSlider extends StatefulWidget {
  const FabCarouselSlider({
    super.key,
    this.autoPlay = true,
    required this.photos,
    this.useImageViewer = true,
  });

  final bool useImageViewer;
  final bool autoPlay;
  final List<File?> photos;

  @override
  State<FabCarouselSlider> createState() => _FabCarouselSliderState();
}

class _FabCarouselSliderState extends State<FabCarouselSlider> {
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
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPhotoIndex = index % widget.photos.length;
              });
            },
          ),
        ),

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
