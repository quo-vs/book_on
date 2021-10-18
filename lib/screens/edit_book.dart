import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';

import '../utils/alerts_helper.dart';
import '../screens/page_controller_screen.dart';
import '../data/database.dart';
import '../utils/functions.dart';
import '../utils/constants.dart';
import '../widgets/book_log_form_widget.dart';

class EditBookScreen extends StatefulWidget {
  static const routeName = '/edit-book';

  const EditBookScreen({Key? key}) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _authorFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  var _isFinished = false;
  final _currentPageController = TextEditingController();
  final _dateController = TextEditingController();

  var _editedBook = BooksCompanion.insert(
      title: '',
      author: '',
      createdAt: DateTime.now(),
      image: moor.Uint8List(0),
      pagesAmount: 0);

  var _editedBookLog = BookLogsCompanion.insert(
    sessionDate: DateTime.now(),
    isFinished: false,
    updatedAt: DateTime.now(),
  );

  BookInitial? initial;

  var _isLoading = false;
  var _isEditMode = false;
  var _isInit = true;

  File? imageFile;
  late moor.Uint8List _imageBase64String;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit) {
      final bookId = ModalRoute.of(context)?.settings.arguments as int?;
      if (bookId != null) {
        setState(() {
          _isLoading = true;
        });

        var dao = Provider.of<BooksDao>(context, listen: false);
        var book = await dao.findBookById(bookId);
        if (book == null) {
          return;
        }
        _editedBook = _editedBook.copyWith(
            id: moor.Value(book.id),
            image: moor.Value(book.image),
            bookLogId:
                book.bookLogId != null ? moor.Value(book.bookLogId) : null);

        BookLog? bookLog;
        if (book.bookLogId != null) {
          var logsDao = Provider.of<BookLogsDao>(context, listen: false);
          bookLog = await logsDao.findBookLogById(bookId);
          if (bookLog != null) {
            _editedBookLog = _editedBookLog.copyWith(
              currentPage: moor.Value(bookLog.currentPage),
              sessionDate: moor.Value(bookLog.sessionDate),
              isFinished: moor.Value(bookLog.isFinished),
            );
          }
        }

        setState(() {
          initial = BookInitial(
              title: book.title,
              author: book.author,
              image: Functions.base64String(book.image),
              pagesAmount: book.pagesAmount,
              currentPage: bookLog != null && bookLog.currentPage != null
                  ? bookLog.currentPage!
                  : 0,
              isFinished: bookLog != null ? bookLog.isFinished : false,
              sessionDate: DateTime.now());

          _isLoading = false;
          _isEditMode = true;
        });
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    _authorFocusNode.dispose();
    super.dispose();
  }

  bool _isBookNotDitry() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return false;
    }
    _formKey.currentState?.save();
    return Functions.sameValues(initial!.title, _editedBook.title.value) &&
        Functions.sameValues(initial!.author, _editedBook.author.value) &&
        Functions.sameValues(initial!.pagesAmount.toString(),
            _editedBook.pagesAmount.value.toString()) &&
        Functions.sameValues(
            initial!.image, Functions.base64String(_editedBook.image.value));
  }

  Future<void> _deleteBook() async {
    if (!_isEditMode) {
      return;
    }

    var dao = Provider.of<BooksDao>(context, listen: false);
    var bookLogsDao = Provider.of<BookLogsDao>(context, listen: false);

    if (_editedBook.bookLogId.value != null) {
      await bookLogsDao.deleteBookLog(_editedBook.bookLogId.value!);
    }
    Functions.pushPageReplacement(context, PageControllerScreen());
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
    var dao = Provider.of<BooksDao>(context, listen: false);
    var bookLogsDao = Provider.of<BookLogsDao>(context, listen: false);

    if (_editedBook.id.toString() != moor.Value.absent().toString()) {
      await dao.updateBook(_editedBook);
      if (_editedBook.bookLogId.value != null) {
        var log = await bookLogsDao.findBookLogById(_editedBook.bookLogId.value!);

        DateTime sessionDate = _dateController.text.isNotEmpty
            ? DateTime.parse(_dateController.text).add(Duration(minutes: 1))
            : DateTime.now();
        var updatedLog = log?.copyWith(
            sessionDate: sessionDate,
            currentPage: _currentPageController.text.isNotEmpty
                ? int.parse(_currentPageController.text)
                : 0,
            isFinished: _isFinished,
            finishedDate: _isFinished == true ? sessionDate : null,
            updatedAt: DateTime.now());
        await bookLogsDao.updateBookLog(updatedLog!);
      }
    } else {
      try {
        var emptyBookLog = BookLogsCompanion.insert(
            sessionDate: DateTime.now(),
            isFinished: false,
            updatedAt: DateTime.now(),
            currentPage: const moor.Value(0));
        var bookLogId = await bookLogsDao.insertBookLog(emptyBookLog);

        if (imageFile != null) {
          _editedBook =
              _editedBook.copyWith(image: moor.Value(_imageBase64String));
        }
        _editedBook = _editedBook.copyWith(bookLogId: moor.Value(bookLogId));

        await dao.insertBook(_editedBook);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              tr('anErrorOccured'),
            ),
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
    Navigator.of(context).pop();
  }

  void _setIsFinished(bool? value) {
    _isFinished = value ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isEditMode && !_isBookNotDitry()) {
          await AlertHelper.onBackAlertButtonsPressed(context, _saveForm);
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? tr('editBook') : tr('addBook')),
          actions: [
            if (_isEditMode)
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    AlertHelper.onDeleteAlertButtonsPressed(
                        context, _deleteBook);
                  }),
            IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 30),
                            width: 130,
                            height: 170,
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              elevation: 4,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                onTap: () {
                                  AlertHelper.showPictureSelectionBottonMenu(
                                      context, _getPictureFrom);
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: imageFile != null
                                      ? Image.memory(
                                          imageFile!.readAsBytesSync(),
                                          fit: BoxFit.cover,
                                        )
                                      : initial?.image != null &&
                                              initial?.image != ""
                                          ? Container(
                                              child: Functions
                                                  .imageFromBase64String(
                                                initial!.image,
                                              ),
                                            )
                                          : const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: tr('bookTitle'),
                                fillColor: Colors.transparent,
                              ),
                              initialValue: initial?.title.toString(),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_authorFocusNode);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr('requiredField');
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedBook = _editedBook.copyWith(
                                    title: moor.Value(value ?? ''));
                              },
                            ),
                            const SizedBox(
                              height: AppConst.heightBetweenWidgets,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: tr('author'),
                                fillColor: Colors.transparent,
                              ),
                              initialValue: initial?.author.toString() ?? '',
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_authorFocusNode);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr('requiredField');
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedBook = _editedBook.copyWith(
                                    author: moor.Value(value ?? ''));
                              },
                            ),
                            const SizedBox(
                              height: AppConst.heightBetweenWidgets,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: tr('numberOfPages'),
                                fillColor: Colors.transparent,
                              ),
                              initialValue:
                                  initial?.pagesAmount.toString() ?? '',
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_authorFocusNode);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr('requiredField');
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedBook = _editedBook.copyWith(
                                    pagesAmount: moor.Value(
                                        value != null ? int.parse(value) : 0));
                              },
                            ),
                            if (_isEditMode)
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(tr("updateProgress")),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18)),
                                    ),
                                    child: BookLogFormWidget(
                                      pagesAmount:
                                          _editedBook.pagesAmount.value,
                                      bookLogId: _editedBook.bookLogId.value,
                                      dateController: _dateController,
                                      currentPageController:
                                          _currentPageController,
                                      isFinished: _isFinished,
                                      isFinishedHandler: _setIsFinished,
                                      editBookMode: true,
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _getPictureFrom(ImageSource source) async {
    var pickedFile = await ImagePicker()
        .pickImage(source: source, maxWidth: 400, maxHeight: 400);

    if (pickedFile != null) {
      var pickedImageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64String = pickedImageBytes;
        imageFile = File(pickedFile.path);
      });
    }
  }
}

// helper class
class BookInitial {
  final String title;
  final String author;
  final String image;
  final int pagesAmount;
  final int currentPage;
  final DateTime sessionDate;
  final bool isFinished;

  BookInitial(
      {required this.title,
      required this.author,
      required this.image,
      required this.pagesAmount,
      required this.currentPage,
      required this.isFinished,
      required this.sessionDate});
}
