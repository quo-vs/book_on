import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../data/database.dart';
import '../widgets/book_card.dart';
import '../widgets/book_update_progress.dart';

class BooksSlider extends StatefulWidget {
  final List<BookWithLog> booksWithLogs;
   var _currentIndex = 0;

  BooksSlider({
    Key? key,
    required this.booksWithLogs
  });

  @override
  State<StatefulWidget> createState() {
    return _BooksSliderState();
  }
}

class _BooksSliderState extends State<BooksSlider> {
 

  @override
  Widget build(BuildContext context) {
    var finished = widget.booksWithLogs[widget._currentIndex].log.isFinished;

    return  widget.booksWithLogs.isEmpty ? Center(
      child: Text(tr('noBooks')),
    ) : Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 196,
              viewportFraction: 0.5,
              aspectRatio: 0.1,
              enableInfiniteScroll: false,
              initialPage: 0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  widget._currentIndex = index;
                });
              }),
          items: widget.booksWithLogs.map((bookWithLog) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              child: BookCard(
                key: ValueKey(bookWithLog.book.id),
                entry: bookWithLog.book,
                withTitle: false,
                isFinished: bookWithLog.log.isFinished,
              ),
            );
          }).toList(),
        ),
        Column(
          children: [
            Text(widget.booksWithLogs[widget._currentIndex].book.title),
            const SizedBox(
              height: 3,
            ),
            Text(widget.booksWithLogs[widget._currentIndex].book.author),
            const SizedBox(
              height: 6,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: finished 
                    ? null 
                    : () {
                    _onAlertWithCustomContentPressed(
                        context, widget.booksWithLogs[widget._currentIndex].book);
                  },                  
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: const BorderSide(
                    ),
                  ),
                  child: Text(
                    finished ? tr("finished") : tr("updateProgress"),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Alert custom content
  _onAlertWithCustomContentPressed(context, Book book) {
    Alert(
      context: context,
      content: BookUpdateProgressAlert(bookEntry: book),
      buttons: []
    ).show();
  }
}
