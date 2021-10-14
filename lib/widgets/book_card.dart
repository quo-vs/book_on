import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

import 'package:uuid/uuid.dart';

import '../data/database.dart';
import '../screens/edit_book.dart';

class BookCard extends StatelessWidget {
  final Book? entry;
  final bool withTitle;
  final bool isFinished;

  BookCard(
      {Key? key, this.entry, this.withTitle = true, this.isFinished = false})
      : super(key: key);

  static final uuid = Uuid();
  final String imgTag = uuid.v4();

  BorderRadius _borderRadius() {
    return BorderRadius.all(Radius.circular(10));
  }

  @override
  Widget build(BuildContext context) {
    var bgForFinishedBook = RotatedCornerDecoration(
      color: Colors.blue,
      geometry: const BadgeGeometry(
        width: 48,
        height: 48,
        cornerRadius: 10,
        alignment: BadgeAlignment.topLeft,
      ),
      labelInsets: const LabelInsets(baselineShift: 3),
      textSpan: TextSpan(
        text: tr('finished'),
        style: const TextStyle(fontSize: 8),
      ),
    );

    return Container(
      width: withTitle ? 130 : 135,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: _borderRadius(),
            ),
            elevation: 4,
            child: InkWell(
              borderRadius: _borderRadius(),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EditBookScreen.routeName, arguments: entry?.id);
              },
              child: Container(
                foregroundDecoration: isFinished ? bgForFinishedBook : null,
                child: ClipRRect(
                  borderRadius: _borderRadius(),
                  child: Hero(
                    tag: imgTag,
                    child: entry != null && entry!.image.isNotEmpty
                        ? Column(
                            children: [
                              Image.memory(entry!.image),
                            ],
                          )
                        : Container(
                            width: 130,
                            height: 170,
                            child: Center(
                              child: Text(
                                tr('noImage'),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          if (withTitle)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                entry!.title,
                textAlign: TextAlign.start,
              ),
            ),
        ],
      ),
    );
  }
}
