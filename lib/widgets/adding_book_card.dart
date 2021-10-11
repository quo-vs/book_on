import 'package:flutter/material.dart';

import 'package:book_on/data/database.dart';

class AddBookCard extends StatelessWidget {
  final Book? bookEntry;
  final VoidCallback? onShowMenuCallback;

  const AddBookCard({Key? key, this.bookEntry, this.onShowMenuCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: onShowMenuCallback,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: bookEntry?.image != null
                ? Image.memory(
                    bookEntry!.image,
                    fit: BoxFit.cover,
                  )
                : Text(bookEntry!.title),
          ),
        ),
      ),
    );
  }
}
