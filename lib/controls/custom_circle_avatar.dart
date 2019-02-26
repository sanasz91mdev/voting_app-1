import 'package:flutter/material.dart';

class CircleAvatarWithShadow extends StatelessWidget {
  const CircleAvatarWithShadow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: CircleAvatar(
        foregroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).accentColor,
        radius: 32.0,
        child: Container(),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
          ),
        ],
        shape: BoxShape.circle,
      ),
    );
  }
}
