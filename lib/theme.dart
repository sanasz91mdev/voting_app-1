import 'package:flutter/material.dart';

final Color _primaryColor = Colors.green;
final Color _secondaryColor = Colors.white; //Color(0xFF1b5e20);
final Color _secondaryTextColor = Color(0xFF2E7D32); //Colors.greenAccent;
final Color _accentColor = Colors.black;

final ThemeData voteAppTheme = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    secondaryHeaderColor: _secondaryTextColor,
    backgroundColor: _secondaryColor,
    primaryColor: _primaryColor,
    accentColor: _accentColor,
    buttonColor: _primaryColor,
    unselectedWidgetColor: _accentColor,
    dialogBackgroundColor: _secondaryColor,
    buttonTheme: ButtonThemeData(
      shape: StadiumBorder(),
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
