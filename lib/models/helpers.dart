import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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


class NationalAssemblyPollsResult {
  final String partyInitial;
  final int numberOfVotes;
  final charts.Color color;

  NationalAssemblyPollsResult(
      this.partyInitial, this.numberOfVotes, this.color);
}

class ProvincialAssemblyPollResult {
  final String province;
  final int votes;
  final String party;
  final charts.Color color;

  ProvincialAssemblyPollResult(
      this.province, this.votes, this.party, this.color);
}

class ProvinceHelper {
  final String province;
  final int votes;
  final String party;
  final charts.Color color;

  ProvinceHelper(this.province, this.votes, this.party, this.color);
}
