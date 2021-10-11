import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../data/database.dart';
import '../widgets/adding_book_card.dart';
import '../utils/constants.dart';

class BookUpdateProgressAlert extends StatefulWidget {
  final Book bookEntry;

  const BookUpdateProgressAlert({
    Key? key,
    required this.bookEntry,
  }) : super(key: key);

  @override
  _BookUpdateProgressAlertState createState() =>
      _BookUpdateProgressAlertState();
}

class _BookUpdateProgressAlertState extends State<BookUpdateProgressAlert> {
  var _isFinished = false;
  final _currentPageController = TextEditingController();
  final _dateController = TextEditingController();
  final _saveButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final bookLogsDao = Provider.of<BookLogsDao>(context, listen: false);
    if (widget.bookEntry.bookLogId != null) {
      bookLogsDao.findBookLogById(widget.bookEntry.bookLogId!).then((log) {
        _currentPageController.text =
            log?.currentPage != null ? log!.currentPage.toString() : '';
        _dateController.text = log!.sessionDate.toString().substring(0, 10);
      });
    }
  }

  @override
  void dispose() {
    _saveButtonFocusNode.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration() {
    return const InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      fillColor: Colors.transparent,
    );
  }

  Future<void> _updateBookProgres(BuildContext context) async {
    final booksDao = Provider.of<BooksDao>(context, listen: false);
    final bookLogsDao = Provider.of<BookLogsDao>(context, listen: false);

    DateTime sessionDate = _dateController.text.isNotEmpty
        ? DateTime.parse(_dateController.text).add(Duration(minutes: 1))
        : DateTime.now();
    var bookLog = BookLogsCompanion.insert(
        sessionDate: sessionDate,
        currentPage: _currentPageController.text.isNotEmpty
            ? moor.Value(int.parse(_currentPageController.text))
            : const moor.Value(0),
        isFinished: _isFinished,
        finishedDate: _isFinished == true
            ? moor.Value(sessionDate)
            : const moor.Value(null),
        updatedAt: DateTime.now());

    var insertedBookLogId = await bookLogsDao.insertBookLog(bookLog);

    var _updatedBook = BooksCompanion.insert(
        id: moor.Value(widget.bookEntry.id),
        bookLogId: moor.Value(insertedBookLogId),
        title: widget.bookEntry.title,
        author: widget.bookEntry.author,
        createdAt: widget.bookEntry.createdAt,
        image: widget.bookEntry.image,
        pagesAmount: widget.bookEntry.pagesAmount);

    await booksDao.updateBook(_updatedBook);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 120,
                    child: Stack(
                      children: [
                        AddBookCard(
                          bookEntry: widget.bookEntry,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookEntry.title,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.bookEntry.author,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppConst.heightBetweenWidgets,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("setCurrentPage"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 60,
                        height: 20,
                        margin: const EdgeInsets.only(right: 12),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.end,
                          controller: _currentPageController,
                          decoration: _buildInputDecoration(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppConst.heightBetweenWidgets,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr('sessionDate'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 20,
                        margin: const EdgeInsets.only(right: 14),
                        child: TextFormField(
                            readOnly: true,
                            style: TextStyle(fontSize: 12),
                            controller: _dateController,
                            textAlign: TextAlign.end,
                            onTap: () async {
                              var date = await showDatePicker(
                                context: context,
                                initialDate: _dateController.text.isNotEmpty
                                    ? DateTime.parse(_dateController.text)
                                    : DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 5 * 365)),
                                lastDate: DateTime.now(),
                              );
                              _dateController.text = date != null
                                  ? date.toString().substring(0, 10)
                                  : DateTime.now().toString().substring(0, 10);
                              // FocusScope.of(context)
                              //     .requestFocus(_saveButtonFocusNode);
                            },
                            decoration: _buildInputDecoration()),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr('isFinished'),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Checkbox(
                        value: _isFinished,
                        onChanged: (bool? value) {
                          setState(() {
                            _isFinished = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        DialogButton(
          onPressed: () async {
            await _updateBookProgres(context);
            Navigator.pop(context);
          },
          child: Text(
            tr('save'),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    );
  }
}
