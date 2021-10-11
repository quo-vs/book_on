import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../screens/edit_quotes.dart';
import '../screens/quote_share_screen.dart';
import '../widgets/quote_widget.dart';
import '../utils/functions.dart';

class QuotesSctreen extends StatelessWidget {
  const QuotesSctreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("quotes")),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Functions.pushPageNamed(context, EditQuoteScreen.routeName);
          },
        ),
      ),
      body: StreamBuilder(
        stream: Provider.of<QuotesDao>(context).watchAllQuotes(),
        builder: (ctx, AsyncSnapshot<List<Quote>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data?.length == 0) {
            return Center(
              child: Text(tr('addQuote')),
            );
          }

          return Container(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Functions.pushPageNamed(context, QuoteShareScreen.routeName,
                        snapshot.data![index].id);
                  },
                  child: QuoteWidget(quote: snapshot.data![index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
