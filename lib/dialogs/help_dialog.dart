import 'package:flutter/material.dart';
import 'package:smash_app/dialogs/dialog_page_enum.dart';

class CustomDialog {
  void showHelpDialog(BuildContext context, DialogPage page) {
    String title = _getTitle(page);
    String content = _getContent(page);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 20)),
          content: Container(
            child: Text(
              content,
              textAlign: TextAlign.start,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getTitle(DialogPage page) {
    switch (page) {
      case DialogPage.personal_set_records:
        return 'Personal Set Records';
      case DialogPage.tournament_set_assistant:
        return 'Tournament Set Assistant';
      case DialogPage.tournament_screen:
        return 'Tournament Set';
      default:
        return '';
    }
  }
}

String _getContent(DialogPage page) {
  switch (page) {
    case DialogPage.personal_set_records:
      return '- This page shows all the personal set records created by you.\n' +
          '- You can add new records by clicking the + button.\n' +
          '- You can also search for records by typing in the search bar.\n' +
          '- Tap on a record to see more details and edit the record.';
    case DialogPage.tournament_set_assistant:
      return '- This page shows all the tournament set records created by you.\n' +
          '- You can add new records by clicking the + button.\n' +
          '- You can also search for records by typing in the search bar.\n' +
          '- Tap on a record to see more details and edit the record.';
    case DialogPage.tournament_screen:
      return 'Follow the instructions on the screen to proceed through the tournament set.\n\n' +
          'Basic Order:\n' +
          ' - Select Stage\n' +
          ' - Play Match\n' +
          ' - Record Winner\n' +
          ' - Repeat until winner is decided';
    default:
      return '';
  }
}
