import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../data/database.dart';
import '../widgets/book_card.dart';
import '../screens/edit_book.dart';

class AllBooksScreen extends StatefulWidget {
  static const routeName = '/allBooks';

  const AllBooksScreen({Key? key}) : super(key: key);

  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  final _searchController = TextEditingController();

  List<BookWithLog> books = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('allBooks')),
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
                padding: const EdgeInsets.all(8.0),
                height: 80,
                child: SearchField(
                  searchInputDecoration: const InputDecoration(
                    fillColor: Colors.transparent,
                  ),
                  suggestions: snapshot.data!.map((e) => e.book.title).toList()
                    ..sort((a, b) => a.compareTo(b)),
                  suggestionState: SuggestionState.enabled,
                  controller: _searchController,
                  hint: 'Search by book title',
                  maxSuggestionsInViewPort: 4,
                  itemHeight: 45,
                  onTap: (title) {
                    final bookWithLog =
                        snapshot.data!.firstWhere((b) => b.book.title == title);
                    Navigator.of(context).pushNamed(EditBookScreen.routeName,
                        arguments: bookWithLog.book.id);
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 80 - 60,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(15),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 5,
                          mainAxisExtent: 250,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Container(
                            height: 200,
                            child: BookCard(
                              key: ValueKey(snapshot.data![index].book.id),
                              entry: snapshot.data![index].book,
                            ),
                          ),
                          childCount: snapshot.data!.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
