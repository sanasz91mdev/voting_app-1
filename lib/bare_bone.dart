import 'package:flutter/material.dart';
import 'package:voting_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:voting_app/controls/poll_header.dart';
import 'package:voting_app/controls/radio_list_item.dart';
import 'package:voting_app/controls/voting_results.dart';
import 'package:voting_app/models/firestore_helper.dart';

void main() => runApp(VotingApp());

class VotingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: voteAppTheme,
      home: MainPage(
        title: 'ELECTIONS 2019',
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          
        ],
      ),
    );
  }
}
