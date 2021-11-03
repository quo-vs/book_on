import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../data/database.dart';
import '../../screens/quotes/edit_quotes.dart';
import '../../utils/helper.dart';
import '../../widgets/quote_widget.dart';

class QuoteShareScreen extends StatefulWidget {
  static const routeName = '/share-quote';

  const QuoteShareScreen({ 
    Key? key, 
  }) : super(key: key);

  @override
  State<QuoteShareScreen> createState() => _QuoteShareScreenState();
}

class _QuoteShareScreenState extends State<QuoteShareScreen> {
  late Quote quote;
  var _isLoading = false;

   @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final quoteId = ModalRoute.of(context)?.settings.arguments as int?;
    if (quoteId != null) {
      setState(() {
        _isLoading = true;
      });

      var dao = Provider.of<QuotesDao>(context, listen: false);
      var foundQuote = await dao.findQueryById(quoteId);
      if (foundQuote == null) {
        return;
      }
      quote = foundQuote.copyWith();

      setState(() {
        _isLoading = false;
      });
    }
  }


  _editQuote(BuildContext context) {
    Helper.pushPageNamed(context, EditQuoteScreen.routeName, quote.id);
  }

  Future<void> _shareQuote(context) async {
    final ByteData bytes = await rootBundle.load(quote.imageUri);
    final moor.Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/${quote.imageUri.split('/').last}').create();
      file.writeAsBytesSync(list);

    final RenderBox box = context.findRenderObject() as RenderBox;
      await Share.shareFiles(['${file.path}'],
          text: quote.quoteText,
          subject: quote.author,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('share'),
        ),
        actions: [
            IconButton(icon: const Icon(Icons.edit),
                onPressed: () => _editQuote(context)),
            IconButton(icon: const Icon(Icons.share), onPressed: () => _shareQuote(context)),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(),)
        : Center(
          child: Container(
                    height: 210,
                    child: QuoteWidget(quote: quote)
                  ),
          )
      );
  }
}