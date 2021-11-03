import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertHelper {
  static Future<bool?> onBackAlertButtonsPressed(
      BuildContext context, Function callbackFunction) async {
    var result = await Alert(
      context: context,
      type: AlertType.warning,
      title: tr("changesNotSavedDescription"),
      buttons: [
        DialogButton(
          child: Text(
            tr("yes"),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () async {
            await callbackFunction();
            return Navigator.of(context).pop(true);
          },
          color: Theme.of(context).primaryColor,
        ),
        DialogButton(
          child: Text(
            tr("no"),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          color: Theme.of(context).errorColor,
        ),
      ],
    ).show();
    return result;
  }

  static onDeleteAlertButtonsPressed(
      BuildContext context, Function callbackFunction) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: tr("deleteBook"),
      buttons: [
        DialogButton(
            child: Text(
              tr("yes"),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () async {
              await callbackFunction();
            },
            color: Theme.of(context).errorColor),
        DialogButton(
            child: Text(
              tr("no"),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).primaryColor),
      ],
    ).show();
  }

  static showPictureSelectionBottonMenu(
      BuildContext context, Function(ImageSource source) getPictureHandler) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: (56 * 2).toDouble(),
                  child: Container(
                    child: Stack(
                      alignment: const Alignment(0, 0),
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  tr('pictureFromCamera'),
                                ),
                                leading: const Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  getPictureHandler(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                title: Text(
                                  tr('pictureFromGallery'),
                                ),
                                leading: const Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  getPictureHandler(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static Future<void> showErrorAlert(
      BuildContext context, String errorText) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(errorText),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.pop(context),
              child: Text(
                tr('ok'),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> tooMachAmountOfPagesAlert(BuildContext context) async {
    var _isRead = false;

    await Alert(
      context: context,
      type: AlertType.warning,
      title: tr("bookWasRead"),
      buttons: [
        DialogButton(
            child: Text(
              tr("yes"),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {
              _isRead = true;

              Navigator.of(context).pop();
            },
            color: Theme.of(context).errorColor),
        DialogButton(
            child: Text(
              tr("no"),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {
              _isRead = false;
              Navigator.of(context).pop();
            },
            color: Theme.of(context).primaryColor),
      ],
    ).show();

    return _isRead;
  }

  static late ProgressDialog progressDialog;

  static showProgress(
      BuildContext context, String message, bool isDismissible) async {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: isDismissible);
    progressDialog.style(
        message: message,
        borderRadius: 10.0,
        progressWidget: Container(
          padding: const EdgeInsets.all(8),
          child: const CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle:
            const TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold));
    await progressDialog.show();
  }

  static updateProgress(String message) {
    progressDialog.update(message: message);
  }

  static hideProgress() async {
    await progressDialog.hide();
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
      ));
  }
}
