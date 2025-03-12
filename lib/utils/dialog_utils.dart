import 'package:flutter/material.dart';
import 'package:mynotes/utils/language_helper.dart';

void deleteDialog(BuildContext context,
    {required VoidCallback onDelete, required String title}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(S.of(context)!.deleteNote),
      content: Text(S.of(context)!.areYouSureWantToDelete(title)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(S.of(context)!.cancel),
        ),
        TextButton(
          onPressed: onDelete,
          child: Text(S.of(context)!.delete),
        ),
      ],
    ),
  );
}
