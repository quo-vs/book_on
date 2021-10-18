import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../data/database.dart';

class BookLogFormWidget extends StatefulWidget {
  final int pagesAmount;
  final bool isFinished;
  final int? bookLogId;
  final Function(bool?) isFinishedHandler;
  final TextEditingController currentPageController;
  final TextEditingController dateController;
  final bool editBookMode;

  const BookLogFormWidget({
    Key? key,
    required this.pagesAmount,
    required this.bookLogId,
    required this.currentPageController,
    required this.dateController,
    required this.isFinished,
    required this.isFinishedHandler,
    this.editBookMode = false,
  }) : super(key: key);

  @override
  _BookLogFormWidgetState createState() => _BookLogFormWidgetState();
}

class _BookLogFormWidgetState extends State<BookLogFormWidget> {
  bool? isFinishedCheckbox = false;

  @override
  void initState() {
    super.initState();
    isFinishedCheckbox = widget.isFinished;
    final bookLogsDao = Provider.of<BookLogsDao>(context, listen: false);
    if (widget.bookLogId != null) {
      bookLogsDao.findBookLogById(widget.bookLogId!).then((log) {
        widget.currentPageController.text =
            log?.currentPage != null ? log!.currentPage.toString() : '';
        widget.dateController.text = log!.sessionDate.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.editBookMode == false
        ? Column(children: [
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
                  child: _buildCurrentPageFormField(),
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
                  child: _buildDatePickerFormField(context),
                ),
              ],
            ),
            _buildIsFinishedCombobox(),
          ])
        : Column(
            children: [
              _buildCurrentPageFormField(),
              _buildDatePickerFormField(context),
              _buildIsFinishedCombobox()
            ],
          );
  }

  Container _buildIsFinishedCombobox() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tr('isFinished'),
            style: widget.editBookMode ? null : const TextStyle(fontSize: 14),
          ),
          Checkbox(
            value: isFinishedCheckbox,
            onChanged: (bool? value) {
              setState(() {
                isFinishedCheckbox = value;
                widget.isFinishedHandler(value);
              });
            },
          ),
        ],
      ),
    );
  }

  TextFormField _buildDatePickerFormField(BuildContext context) {
    return TextFormField(
        readOnly: true,
        style: widget.editBookMode ? null : const TextStyle(fontSize: 12),
        controller: widget.dateController,
        textAlign: widget.editBookMode ? TextAlign.start : TextAlign.end,
        onTap: () async {
          var date = await showDatePicker(
            context: context,
            initialDate: widget.dateController.text.isNotEmpty
                ? DateTime.parse(widget.dateController.text)
                : DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 5 * 365)),
            lastDate: DateTime.now(),
          );
          widget.dateController.text = date != null
              ? date.toString().substring(0, 10)
              : DateTime.now().toString().substring(0, 10);
        },
        decoration: widget.editBookMode
            ? InputDecoration(
                labelText: tr('sessionDate'),
                fillColor: Colors.transparent,
              )
            : _buildInputDecoration());
  }

  TextFormField _buildCurrentPageFormField() {
    return TextFormField(
      style: widget.editBookMode ? null : const TextStyle(fontSize: 12),
      textAlign: widget.editBookMode ? TextAlign.start : TextAlign.end,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      validator: (value) {
        if (value != null && int.parse(value) > widget.pagesAmount) {
          widget.currentPageController.text = widget.pagesAmount.toString();
        }
        return null;
      },
      controller: widget.currentPageController,
      decoration: widget.editBookMode
          ? InputDecoration(
              labelText: tr('setCurrentPage'),
              fillColor: Colors.transparent,
            )
          : _buildInputDecoration(),
    );
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
}
