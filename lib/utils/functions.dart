import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:moor_flutter/moor_flutter.dart';

import '../data/database.dart';

class Functions {
  static Future pushPageNamed(BuildContext context, String routeName,
      [Object? arguments]) {
    if (arguments != null) {
      return Navigator.of(context).pushNamed(routeName, arguments: arguments);
    }

    return Navigator.of(context).pushNamed(
      routeName,
    );
  }

  static Future pushPage(BuildContext context, Widget page) {
    var result = Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );

    return result;
  }

  static Future pushPageDialog(BuildContext context, Widget page) {
    var result = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );

    return result;
  }

  static pushPageReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketExeption') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  static bool sameValues(String a, String b) {
    return a.toString().compareTo(b) == 0;
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static int getPageAmountReadToday(List<BookWithLog>? books) {
    if (books != null && books.isNotEmpty) {
      var booksToday = books
          .where((bookWithLog) =>
              isToday(bookWithLog.log.sessionDate) ||
              (bookWithLog.log.isFinished &&
                  isToday(bookWithLog.log.finishedDate!)))
          .toList();
      int _pagesToday = 0;
      booksToday.forEach((book) {
        if (book.log.isFinished) {
          _pagesToday += book.book.pagesAmount;
        }
        _pagesToday += book.log.currentPage!;
      });
      return _pagesToday;
    }

    return 0;
  }

  static bool isToday(DateTime date) {
    var now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(date.year, date.month, date.day) == today;
  }

  static bool isSameDate(DateTime first, DateTime second) {
    final firstDate = DateTime(first.year, first.month, first.day);
    return DateTime(second.year, second.month, second.day) == firstDate;
  }

  static int getBooksReadThisMonth(List<BookWithLog>? books) {
    if (books != null && books.isNotEmpty) {
      var now = DateTime.now();
      var firstDayOfTheMonth = DateTime(now.year, now.month, 1);
      var lastDayOfTheMonth = DateTime(now.year, now.month + 1, 0);
      var booksInMonth = books
          .where((bookWithLog) =>
              bookWithLog.log.isFinished &&
              bookWithLog.log.finishedDate!.isAfter(firstDayOfTheMonth) &&
              bookWithLog.log.finishedDate!.isBefore(lastDayOfTheMonth))
          .toList();
      if (booksInMonth.isNotEmpty) {
        return booksInMonth.length;
      }
    }
    return 0;
  }

  static int getBooksReadThisYear(List<BookWithLog>? books) {
    if (books != null && books.isNotEmpty) {
      var now = DateTime.now();
      var firstDayOfTheYear = DateTime(now.year, 1, 1);
      var lastDayOfTheYear = DateTime(now.year, 12 + 1, 0);
      var booksInYear = books
          .where((bookWithLog) =>
              bookWithLog.log.isFinished &&
              bookWithLog.log.finishedDate!.isAfter(firstDayOfTheYear) &&
              bookWithLog.log.finishedDate!.isBefore(lastDayOfTheYear))
          .toList();
      if (booksInYear.isNotEmpty) {
        return booksInYear.length;
      }
    }
    return 0;
  }

  static bool isEmail(String? string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }
}
