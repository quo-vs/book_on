import 'package:flutter/material.dart';

import '../data/database.dart';
import '../utils/constants.dart';

class QuoteWidget extends StatelessWidget {
  QuoteWidget({
    Key? key,
    required this.quote,
  }) : super(key: key) {
    imageIsEmpty = quote.imageUri.isEmpty;
  }

  final Quote quote;
  late bool imageIsEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: !imageIsEmpty
                  ? Image.asset(
                      quote.imageUri,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : null),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: imageIsEmpty
              ? BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: !imageIsEmpty ? 120 : 60,
                child: Text(
                  quote.quoteText,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.fontMontserratAlternates,
                    color:
                        imageIsEmpty ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Container(
                height: !imageIsEmpty ? 50 : 20,
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.bottomRight,
                child: Text(
                  quote.author,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.fontMontserratAlternates,
                    color:
                        imageIsEmpty ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
