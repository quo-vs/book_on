import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';

class QuotesService {
  static final QuotesService _instance = QuotesService.internal();
  factory QuotesService() => _instance;
  QuotesService.internal();

  addQuotes(BuildContext context) async {
    CollectionReference quotes =
        FirebaseFirestore.instance.collection('quotes');
    var localQuotes =
        await Provider.of<QuotesDao>(context, listen: false).getQuotes();

    for (var quote in localQuotes) {
      quotes
          .add(quote.toJson())
          .then((value) => print("Quote Added"))
          .catchError((error) => print("Failed to add quote: $error"));
    }
  }
}
