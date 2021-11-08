import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';
import '../../screens/books/edit_book.dart';
import '../settings_streen.dart';
import '../../utils/helper.dart';
import '../../widgets/book_card.dart';
import '../../widgets/books_slider.dart';
import '../../utils/constants.dart';
import '../../screens/books/all_books_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<BookWithLog> _lastReadBooks(List<BookWithLog> books) {
    Comparator<BookWithLog> updateDateComparator = (a, b) =>
        a.log.updatedAt.difference(b.log.updatedAt).isNegative ? 1 : -1;

    var result = books..sort(updateDateComparator);

    return result.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Helper.pushPageNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Helper.pushPageNamed(context, EditBookScreen.routeName);
          },
        ),
        centerTitle: true,
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
                  style: const TextStyle(
                    fontSize: 20,
                  ),
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
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 5, // Space between underline and text
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ))),
                    child: Text(
                      tr('allBooks'),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AllBooksScreen.routeName);
                  },
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        child: BookCard(
                          key: ValueKey(snapshot.data![index].book.id),
                          entry: snapshot.data![index].book,
                        ),
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
