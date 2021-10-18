import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';

import '../screens/page_controller_screen.dart';
import '../utils/alerts_helper.dart';
import '../utils/functions.dart';
import '../data/database.dart';
import '../widgets/images_slider.dart';
import '../utils/constants.dart';


class EditQuoteScreen extends StatefulWidget {
  static const routeName = '/edit-quote';

  const EditQuoteScreen({Key? key}) : super(key: key);

  @override
  _EditQuoteScreenState createState() => _EditQuoteScreenState();
}

class _EditQuoteScreenState extends State<EditQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quoteTextController = TextEditingController();
  final _authorTextController = TextEditingController();
  var _isLoading = false;
  var _isEditMode = false;
  var _selectedImagePath = "";
  var _editedQuote = QuotesCompanion.insert(
      author: '', createdAt: DateTime.now(), quoteText: '', imageUri: '');

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final quoteId = ModalRoute.of(context)?.settings.arguments as int?;
    if (quoteId != null) {
      setState(() {
        _isLoading = true;
      });

      var dao = Provider.of<QuotesDao>(context, listen: false);
      var quote = await dao.findQueryById(quoteId);
      if (quote == null) {
        return;
      }

      _editedQuote = _editedQuote.copyWith(
        id: moor.Value(quote.id),
        imageUri: moor.Value(quote.imageUri),
        createdAt: moor.Value(quote.createdAt)
      );

      _quoteTextController.text = quote.quoteText;
      _authorTextController.text = quote.author;
      _selectedImagePath = quote.imageUri;

      setState(() {
        _isEditMode = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    var dao = Provider.of<QuotesDao>(context, listen: false);

    if (_editedQuote.id.toString() != moor.Value.absent().toString()) 
    {
      _editedQuote = _editedQuote.copyWith(
            quoteText: moor.Value(_quoteTextController.text),
            author: moor.Value(_authorTextController.text),
            imageUri: moor.Value(_selectedImagePath));
      await dao.updateQuote(_editedQuote);
    } 
    else {
      try {
        var newQuote = QuotesCompanion.insert(
            quoteText: _quoteTextController.text,
            author: _authorTextController.text,
            createdAt: DateTime.now(),
            imageUri: _selectedImagePath);
        await Provider.of<QuotesDao>(context, listen: false)
            .insertQuote(newQuote);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(tr('anErrorOccured')),
            content: Text(error.toString()),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(tr('ok')),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Functions.pushPageReplacement(context, PageControllerScreen(initialPage: 1,));
  }

  _onImageSelected(String imagePath) {
    _selectedImagePath = imagePath;
  }

  
  Future<void> _deleteQuote() async {
    if (!_isEditMode) {
      return;
    }

    var dao = Provider.of<QuotesDao>(context, listen: false);
    dao.deleteQuote(_editedQuote);
    Functions.pushPageReplacement(context, PageControllerScreen(initialPage: 1,));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? tr('editQuote') : tr("addQuote"),
        ),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => AlertHelper.onDeleteAlertButtonsPressed(context, _deleteQuote),
            ),
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: tr('quote'),
                              fillColor: Colors.transparent, 
                            ),
                            maxLength: 128,
                            maxLines: 4,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            controller: _quoteTextController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return tr('requiredField');
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                          const SizedBox(
                            height: AppConst.heightBetweenWidgets,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: tr('author'),
                              fillColor: Colors.transparent,
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            controller: _authorTextController,
                            maxLength: 60,
                          ),
                          const SizedBox(
                            height: AppConst.heightBetweenWidgets,
                          ),
                          Container(
                            child: Text(tr('selectBackground')),
                          ),
                          const SizedBox(
                            height: AppConst.heightBetweenWidgets,
                          ),
                          ImagesSlider(
                              onImageSelected: _onImageSelected,
                              imagePath: _isEditMode ? _selectedImagePath : null)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
