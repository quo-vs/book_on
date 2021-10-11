import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertHelper {
  static Future<bool?> onBackAlertButtonsPressed(
      BuildContext context, Function callbackFunction) async {
    var result = await Alert(
      context: context,
      type: AlertType.warning,
      title: tr("changesNotSaved"),
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
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(250, 16, 91, 1.0),
            Color.fromRGBO(240, 38, 99, 1.0),
          ]),
        ),
        DialogButton(
          child: Text(
            tr("no"),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
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
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(250, 16, 91, 1.0),
            Color.fromRGBO(240, 38, 99, 1.0),
          ]),
        ),
        DialogButton(
          child: Text(
            tr("no"),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
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

  static showOfflineAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            tr('noInternetConnection'),
          ),
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
}
