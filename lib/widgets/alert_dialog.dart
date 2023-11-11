import 'package:flutter/cupertino.dart';

customAlertDialog(BuildContext context, Function() onPressed, String title) {
  return showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    builder: (_) {
      return CupertinoAlertDialog(
        title: Text("Wait!"),
        content: Text(title),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No"),
          ),
          CupertinoActionSheetAction(
            onPressed: onPressed,
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}
