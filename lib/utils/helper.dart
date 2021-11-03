import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:moor_flutter/moor_flutter.dart';

import '../data/database.dart';

class Helper {
  static pushPageNamed(BuildContext context, String routeName,
      [Object? arguments]) {
    if (arguments != null) {
      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    } else {
      Navigator.of(context).pushNamed(routeName);
    }
  }

  static pushReplacement(BuildContext context, Widget destination) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => destination));
  }

  static push(BuildContext context, Widget destination) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => destination));
  }

  static pushAndRemoveUntil(
      BuildContext context, Widget destination, bool predict) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => destination),
        (Route<dynamic> route) => predict);
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

  static bool isDarkMode(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return false;
    } else {
      return true;
    }
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

  static String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? '')) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    if ((value?.length ?? 0) < 6) {
      return 'Password must be more than 5 characters';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return 'Password doesn\'t match';
    } else if (confirmPassword?.isEmpty ?? true) {
      return 'Confirm password is required';
    } else {
      return null;
    }
  }

  static InputDecoration getInputDecoration({required String hint}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      hintText: hint,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        //borderSide: BorderSide(color: errorColor),
        borderRadius: BorderRadius.circular(25.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        //borderSide: BorderSide(color: errorColor),
        borderRadius: BorderRadius.circular(25.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(25.0),
      ),
    );
  }

  static String numberToMonth(int monthNumber) {
    if (monthNumber < 1 && monthNumber > 12) {
      return "UNKNOWN MONTH";
    }
    switch (monthNumber) {
      case 1:
        return tr('jan');
      case 2:
        return tr('feb');
      case 3:
        return tr('mar');
      case 4:
        return tr('apr');
      case 5:
        return tr('may');
      case 6:
        return tr('jun');
      case 7:
        return tr('jul');
      case 8:
        return tr('aug');
      case 9:
        return tr('sep');
      case 10:
        return tr('oct');
      case 11:
        return tr('nov');
      case 12:
        return tr('dec');

      default:
        return "UNKNOWN MONTH";
    }
  }
}
