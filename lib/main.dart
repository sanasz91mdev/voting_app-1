import 'package:flutter/material.dart';
import 'package:voting_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:voting_app/controls/poll_header.dart';
import 'package:voting_app/controls/radio_list_item.dart';
import 'package:voting_app/models/firestore_helper.dart';
import 'package:voting_app/models/helpers.dart';

import 'controls/voting_result.dart';

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
  bool _naVoteCasted = false;
  int _paRadioGroupValue = -1;
  bool _paVoteCasted = false;

  void _handleRadioValueChangePA(int value) {
    if (!_paVoteCasted) {
      setState(() {
        _paRadioGroupValue = value;
      });
    }
  }

  void _naHandleValueChange(int value) {
    if (!_naVoteCasted)
      setState(() {
        _naRadioGroupValue = value;
      });
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  Widget buildListItem(
      Map data, int index, int radioGroupValue, Function handleValueChange) {
    final record = FirebaseResponse.fromMap(data);
    return RadioListItem(
      index: index,
      title: record.fullName,
      subtitle: record.initials,
      radioValue: radioGroupValue,
      trailing: record.flag,
      onChanged: handleValueChange,
    );
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
                '${DateTime(2019, 03, 16, 12).difference(DateTime.now()).inMinutes} Minutes Away',
                style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PageIndicator(
                color: Theme.of(context).accentColor,
                activeColor: Theme.of(context).backgroundColor,
                size: 8.0,
                controller: controller,
                space: 4.0,
                layout: PageIndicatorLayout.WARM,
                count: 3 /*  */,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: PageView(
        controller: controller,
        children: <Widget>[
          Column(
            children: <Widget>[
              PollHeader(
                headerName: 'NATIONAL ASSEMBLY',
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('polls').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  DocumentSnapshot nationalAssemblyPoll =
                      snapshot.data.documents.first;
                  var pollOptionsArray = nationalAssemblyPoll['pollOptions'];
                  int index = 0;
                  return ListView(
                    children: pollOptionsArray
                        .map<Widget>((data) => buildListItem(data, index++,
                            _naRadioGroupValue, _naHandleValueChange))
                        .toList(),
                  );
                },
              )),
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
                      color: _naVoteCasted
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          // End of first page // // // // // // //
          Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: <Widget>[
                //Poll title PollHeader( headerName: 'PROVINCIAL ASSEMBLY', ),
                // List of poll options
                PollHeader(headerName: 'PROVINVIAL ASSEMBLY',),
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
          // End of second page // // // // // // //
          VotingResult()
        ],
      ),
    );
  }
}
