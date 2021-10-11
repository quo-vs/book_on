import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../screens/edit_book.dart';
import '../screens/settings_streen.dart';
import '../utils/functions.dart';
import '../widgets/book_card.dart';
import '../widgets/books_slider.dart';
import '../utils/constants.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {

  List<BookWithLog> _lastReadBooks(List<BookWithLog> books) {
    	
  Comparator<BookWithLog> updateDateComparator = (a, b) 
    => a.log.updatedAt.difference(b.log.updatedAt).isNegative ? 1 : -1;
  
    var result = books
     ..sort(updateDateComparator);

     return result.take(4).toList();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Functions.pushPageNamed(context, EditBookScreen.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Functions.pushPageNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
        title: Text(tr('books')),
      ),
      body: StreamBuilder(
        stream: Provider.of<BooksDao>(context).watchBookWithLogs(),
        builder: (context, AsyncSnapshot<List<BookWithLog>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data?.length == 0) {
            return Center(
              child: Text(tr('noBooksAddedYet')),
            );
          }

          return ListView(
            
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 15),
                child: Text(
                  tr('lastRead'),
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 20,),
                ),
              ),
              const SizedBox(
                height: AppConst.heightBetweenWidgets,
              ),
              Container(
                margin: const EdgeInsets.all(4),
                height: 300,
                child: BooksSlider(
                  key: ValueKey(snapshot.data!.length),
                  booksWithLogs: _lastReadBooks(snapshot.data!),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  tr('allBooks'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: AppConst.heightBetweenWidgets,
              ),
              Center(
                child: Container(
                  alignment: Alignment.topLeft,
                  height: 250,
                  child: ListView.builder(
                    primary: false,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 5, vertical: 10,),
                        child: BookCard(
                          key: ValueKey(snapshot.data![index].book.id),
                          entry: snapshot.data![index].book,),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

