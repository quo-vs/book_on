import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';
import '../../screens/quotes/edit_quotes.dart';
import '../../screens/quotes/quote_share_screen.dart';
import '../../widgets/quote_widget.dart';
import '../../utils/helper.dart';

class QuotesSctreen extends StatefulWidget {
  const QuotesSctreen({Key? key}) : super(key: key);

  @override
  State<QuotesSctreen> createState() => _QuotesSctreenState();
}

class _QuotesSctreenState extends State<QuotesSctreen> {
  @override
  Widget build(BuildContext context) {
    var dao = Provider.of<QuotesDao>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(tr("quotes")),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Helper.pushPageNamed(context, EditQuoteScreen.routeName);
          },
        ),
      ),
      body: StreamBuilder(
        stream: dao.watchAllQuotes(),
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
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await dao.deleteQuote(snapshot.data![index]);
                      setState(() {                        
                        snapshot.data!.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(tr('quoteDeleted'), textAlign: TextAlign.end,),
                        backgroundColor: Theme.of(context).errorColor,
                      ));
                    }
                  },
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    color: Colors.blue,
                    child: const Icon(Icons.archive_outlined, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () {
                      Helper.pushPageNamed(context,
                          QuoteShareScreen.routeName, snapshot.data![index].id);
                    },
                    child: QuoteWidget(quote: snapshot.data![index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
