import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class ImagesSlider extends StatefulWidget {
  final Function onImageSelected;
  final String? imagePath;

  const ImagesSlider({Key? key, required this.onImageSelected, this.imagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImagesSliderState();
  }
}

class _ImagesSliderState extends State<ImagesSlider> {
  var _currentIndex = 0;

  final imageUrls = [
    '',
    'assets/images/quotes_bg/1.jpg',
    'assets/images/quotes_bg/2.jpg',
    'assets/images/quotes_bg/3.jpg',
    'assets/images/quotes_bg/4.jpg',
    'assets/images/quotes_bg/5.jpg',
    'assets/images/quotes_bg/6.jpg',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      var index = imageUrls.indexOf(widget.imagePath!);
      _currentIndex = index;
    }

    widget.onImageSelected(imageUrls[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 100,
            viewportFraction: 0.45,
            aspectRatio: 1.8,
            enableInfiniteScroll: false,
            initialPage: _currentIndex,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
                widget.onImageSelected(imageUrls[index]);
              });
            },
          ),
          items: imageUrls.map(
            (imageUri) {

              var decoration = BoxDecoration(
                  border: Border.all(
                    width: 8,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                );

              // first empty background
              if (imageUri == '') {
                 return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: imageUrls[_currentIndex] == imageUri ? 8 : 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                );
              }
              return Container(
                decoration: imageUrls[_currentIndex] == imageUri ? decoration : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                child: Image.asset(
                  imageUri,
                  fit: BoxFit.cover,
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
