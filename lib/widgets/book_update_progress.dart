import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../data/database.dart';
import '../widgets/adding_book_card.dart';
import '../utils/constants.dart';
import '../widgets/book_log_form_widget.dart';
import '../utils/alerts_helper.dart';

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
  final loginFormKey = GlobalKey<FormState>();
  late BookLog? currentBookLog;

  @override
  void initState() {
    super.initState();
    final bookLogsDao = Provider.of<BookLogsDao>(context, listen: false);
    if (widget.bookEntry.bookLogId != null) {
      bookLogsDao.findBookLogById(widget.bookEntry.bookLogId!).then((log) {
        _currentPageController.text =
            log?.currentPage != null ? log!.currentPage.toString() : '';
        _dateController.text = log!.sessionDate.toString().substring(0, 10);
        currentBookLog = log;
      });
    }
  }

  Future<void> _updateBookProgres(BuildContext context) async {
    final booksDao = Provider.of<BooksDao>(context, listen: false);
    final bookLogsDao = Provider.of<BookLogsDao>(context, listen: false);

    DateTime sessionDate = _dateController.text.isNotEmpty
        ? DateTime.parse(_dateController.text).add(Duration(minutes: 1))
        : DateTime.now();
    
    var finishedDate = _isFinished == true
            ? moor.Value(sessionDate)
            : const moor.Value(null);
    var currentPage = int.tryParse(_currentPageController.text) ?? 0;
    if (currentPage >= widget.bookEntry.pagesAmount) {
      currentPage = widget.bookEntry.pagesAmount;
     var isBookFinished = await AlertHelper.tooMachAmountOfPagesAlert(context);
     if (isBookFinished) {
       _isFinished = true;
       finishedDate = moor.Value(sessionDate);
     }
    }
    var bookLog = BookLogsCompanion.insert(
        sessionDate: sessionDate,
        currentPage: moor.Value(currentPage),
        isFinished: _isFinished,
        finishedDate: finishedDate,
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

  void _setIsFinished(bool? value) {
    _isFinished = value ?? false;
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
                  Expanded(
                    child: Container(
                      height: 120,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.bookEntry.title,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.bookEntry.author,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            tr('pagesAmount', args: [widget.bookEntry.pagesAmount.toString()]),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppConst.heightBetweenWidgets,
              ),
              BookLogFormWidget(
                pagesAmount: widget.bookEntry.pagesAmount, 
                bookLogId: widget.bookEntry.bookLogId,
                dateController: _dateController, 
                currentPageController: _currentPageController, 
                isFinished: _isFinished, 
                isFinishedHandler: _setIsFinished,                
              )
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
