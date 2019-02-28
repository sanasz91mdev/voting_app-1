import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class RadioListItem extends StatelessWidget {
  const RadioListItem({
    Key key,
    @required int radioValue,
    @required int index,
    @required this.onChanged,
    @required this.fullName,
    @required this.initials,
    @required this.flag,
  })  : _radioValue = radioValue,
        _index = index,
        super(key: key);

  final int _radioValue;
  final int _index;
  final String fullName;
  final String initials;
  final String flag;
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
            fullName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          subtitle: Text(
            initials,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: CircleAvatar(
            backgroundImage: NetworkImage(flag),
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
