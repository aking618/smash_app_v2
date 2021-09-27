import 'package:flutter/material.dart';
import 'package:smash_app/dialogs/dialog_page_enum.dart';

// build confirm dialog
Future<void> showConfirmDialog(BuildContext context, DialogType dialogType,
    Map<String, Function> options) async {
  String title = getDialogTitle(dialogType);
  String content = getDialogContent(dialogType);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options
            .map((key, value) {
              return MapEntry(
                key,
                TextButton(
                  child: Text(key),
                  onPressed: () {
                    value();
                    Navigator.of(context).pop();
                  },
                ),
              );
            })
            .values
            .toList(),
      );
    },
  );
}

String getDialogTitle(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.confirm:
      return 'Confirm';
    case DialogType.info:
      return 'Info';
    case DialogType.leave:
      return 'Leave';
    case DialogType.confirm_player_win:
      return 'Confirm Player Choice';
    case DialogType.reset_set:
      return 'Confirm Reset';
    default:
      return '';
  }
}

String getDialogContent(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.confirm:
      return 'Are you sure?';
    case DialogType.info:
      return 'info text';
    case DialogType.leave:
      return 'Are you sure you want to leave?';
    case DialogType.confirm_player_win:
      return 'Are you sure you want to choose this player?';
    case DialogType.reset_set:
      return 'Are you sure you want to reset the set?';
    default:
      return '';
  }
}
