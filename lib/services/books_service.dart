import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../data/database.dart';

class BooksService {
  static final BooksService _instance = BooksService.internal();
  factory BooksService() => _instance;
  BooksService.internal();

  addBooks(BuildContext context) async {
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    var localBooksStream =
        Provider.of<BooksDao>(context, listen: false).watchBookWithLogs();
    var fre = await localBooksStream.firstWhere((item) => true);

    for (var entry in fre) {
      var bookInJson = entry.book.toJson();

      var imageUrl = await uploadFile(entry.book);
      bookInJson['image'] = imageUrl;

      books
          .add(bookInJson)
          .then((value) => print("Book Added"))
          .catchError((error) => print("Failed to add book: $error"));
    }
  }

  Future<String> uploadFile(Book book) async {
    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    var fileName = '/${book.title}-${book.author}.jpg';
    firebase_storage.Reference ref =
        FirebaseStorage.instance.ref().child('books').child(fileName);

    final metadata = SettableMetadata(contentType: 'image/jpeg');
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.writeAsBytes(book.image);

    uploadTask = ref.putFile(file, metadata);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}
