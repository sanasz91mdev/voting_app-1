import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:voting_app/controls/poll_header.dart';
import 'package:voting_app/controls/radio_list_item.dart';
import 'package:voting_app/controls/voting_results.dart';
import 'package:voting_app/models/firestore_helper.dart';
import 'package:voting_app/models/helpers.dart';
import 'package:voting_app/theme.dart';

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
  int _naRadioGroupValue = -1;
  int _paRadioGroupValue = -1;
  bool _naVoteCasted = false;
  bool _paVoteCasted = false;

  void _handleRadioValueChangeNA(int value) {
    if (!_naVoteCasted) {
      setState(() {
        _naRadioGroupValue = value;
      });
    }
  }

  void _handleRadioValueChangePA(int value) {
    if (!_paVoteCasted) {
      setState(() {
        _paRadioGroupValue = value;
      });
    }
  }

  buildAppBar() {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(88.0),
        child: Column(
          children: [
            // Application title
            Text(
              widget.title,
              style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),

            // Election date label
            Text(
              'SATURDAY, MARCH 16',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),

            // Time remaining label
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '${DateTime(2019, 03, 16).difference(DateTime.now()).inHours} Hours Away',
                style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w500),
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: PageIndicator(
                color: Theme.of(context).accentColor,
                activeColor: Theme.of(context).backgroundColor,
                layout: PageIndicatorLayout.WARM,
                size: 8.0,
                controller: controller,
                space: 4.0,
                count: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: PageView(
        controller: controller,
        children: [
          // Start of first page
          // // // // // // // //
          Stack(children: [
            Opacity(
              opacity: 0.2,
              child: Center(
                child: Container(
                  child: Image.asset('assets/vote5.png'),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: <Widget>[
                  //Poll title
                  PollHeader(
                    headerName: "NATIONAL ASSEMBLY",
                  ),

                  // List of poll options
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('polls').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return LinearProgressIndicator();

                        DocumentSnapshot nationalAssemblyPoll =
                            snapshot.data.documents.first;
                        var pollOptionsArray =
                            nationalAssemblyPoll['pollOptions'];
                        int index = 0;

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView(
                            children: pollOptionsArray
                                .map<Widget>((data) => buildListItem(
                                    data,
                                    index++,
                                    _naRadioGroupValue,
                                    _handleRadioValueChangeNA))
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: RaisedButton(
                      onPressed: _naVoteCasted
                          ? null
                          : () {
                              if (_naRadioGroupValue == -1) {
                                showAlertDialog(context, 'Unable to proceed',
                                    'Please select a party to vote.');
                              } else {
                                setState(() {
                                  _naVoteCasted = true;
                                });
                                addNationalAssemblyVote(_naRadioGroupValue);
                                showAlertDialog(context, 'Success',
                                    'Your vote has been submitted successfully.');
                              }
                            },
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: _paVoteCasted
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),

          // End of first page
          // // // // // // //

          Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: <Widget>[
                //Poll title
                PollHeader(
                  headerName: "PROVINCIAL ASSEMBLY",
                ),

                // List of poll options
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('polls').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();

                      DocumentSnapshot provincialAssemblyPoll =
                          snapshot.data.documents.last;
                      var pollOptionsArray =
                          provincialAssemblyPoll['pollOptionsSindh'];
                      int index = 0;

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView(
                          children: pollOptionsArray
                              .map<Widget>((data) => buildListItem(
                                  data,
                                  index++,
                                  _paRadioGroupValue,
                                  _handleRadioValueChangePA))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ),

                // Submit button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: RaisedButton(
                    onPressed: _paVoteCasted
                        ? null
                        : () {
                            if (_paRadioGroupValue == -1) {
                              showAlertDialog(context, 'Unable to proceed',
                                  'Please select a party to vote.');
                            } else {
                              setState(() {
                                _paVoteCasted = true;
                              });
                              addProvincialAssemblyVote(_paRadioGroupValue);
                              showAlertDialog(context, 'Success',
                                  'Your vote has been submitted successfully.');
                            }
                          },
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: _paVoteCasted
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // End of second page
          // // // // // // //

          VotingResult()
        ],
      ),
      drawer: buildDrawer(),
    );
  }

  Widget buildListItem(
      Map data, int index, int radioGroupValue, Function handleValueChange) {
    final record = FirebaseResponse.fromMap(data);

    return RadioListItem(
      trailing: record?.flag,
      fullName: record?.fullName,
      index: index,
      initials: record?.initials,
      radioValue: radioGroupValue,
      onChanged: handleValueChange,
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // SizedBox(height: 40.0, child: Image.asset('assets/vote5.png')),
            ]),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/vote.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.assessment, color: Theme.of(context).primaryColor),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Live Results'),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              controller.jumpToPage(2);
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.settings, color: Theme.of(context).primaryColor),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Settings'),
                ),
              ],
            ),
            onTap: null,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.help_outline, color: Theme.of(context).primaryColor),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Help & Feedback'),
                ),
              ],
            ),
            onTap: null,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).primaryColor),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('About'),
                ),
              ],
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class FirebaseResponse {
  final String color;
  final String flag;
  final String fullName;
  final String initials;
  final int numberOfVoters;
  final DocumentReference reference;

  FirebaseResponse.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['color'] != null),
        assert(map['flag'] != null),
        assert(map['fullName'] != null),
        assert(map['initials'] != null),
        color = map['color'],
        flag = map['flag'],
        fullName = map['fullName'],
        initials = map['initials'],
        numberOfVoters = map['numberOfVoters'];
}
