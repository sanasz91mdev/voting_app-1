import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class RadioListItem extends StatelessWidget {
  const RadioListItem({
    Key key,
    @required int radioValue,
    @required int index,
    @required this.onChanged,
    @required this.title,
    @required this.subtitle,
    @required this.trailing,
  })  : _radioValue = radioValue,
        _index = index,
        super(key: key);

  final int _radioValue;
  final int _index;
  final String title;
  final String subtitle;
  final String trailing;
  final RadioCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: _index,
            activeColor: Theme.of(context).accentColor,
            groupValue: _radioValue,
            onChanged: onChanged,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          trailing: CircleAvatar(
            backgroundImage: NetworkImage(trailing),
          ),
        ),
        Divider(
          color: Theme.of(context).accentColor,
          indent: 16.0,
        ),
      ],
    );
  }
}

typedef RadioCallback = void Function(int value);
