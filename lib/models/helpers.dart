import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: Border.all(
          color: Theme.of(context).accentColor,
        ),
        //backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Ok',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
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
