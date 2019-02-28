import 'package:flutter/material.dart';

class PollHeader extends StatelessWidget {
  const PollHeader({Key key, @required String headerName})
      : headerName = headerName,
        super(key: key);

  final String headerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              headerName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Theme.of(context).primaryColor),
              Icon(Icons.star, color: Theme.of(context).accentColor),
              Icon(Icons.star, color: Theme.of(context).primaryColor),
              Icon(Icons.star, color: Theme.of(context).accentColor),
              Icon(Icons.star, color: Theme.of(context).primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}
