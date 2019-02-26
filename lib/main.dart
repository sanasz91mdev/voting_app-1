import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:voting_app/controls/custom_circle_avatar.dart';
import 'package:voting_app/controls/poll_header.dart';
import 'package:voting_app/controls/radio_list_item.dart';
import 'package:voting_app/controls/voting_results.dart';

void main() => runApp(VotingApp());

class VotingApp extends StatelessWidget {
  final Color _primaryColor = Color(0xFF00c853);
  final Color _secondaryColor = Color(0xFF1b5e20);
  final Color _accentColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: ThemeData(
        backgroundColor: _secondaryColor,
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        buttonColor: _primaryColor,
        unselectedWidgetColor: _accentColor,
        dialogBackgroundColor: _secondaryColor,
      ),
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
  //final List<String> _allActivities = <String>['PTI', 'PMLN', 'MQM', 'TLP', 'PSP', 'PPP', 'PAT', 'ANP', 'JUI', ];
  //String _activity = 'PTI';
  int _naRadioGroupValue = -1;
  int _paRadioGroupValue = -1;
  bool naVoteCasted = false;
  bool paVoteCasted = false;
  bool votingComplete = false;

  void _handleRadioValueChange1(int value) {
    if (!naVoteCasted) {
      setState(() {
        _naRadioGroupValue = value;
      });
    }
  }

  void _handleRadioValueChange2(int value) {
    if (!paVoteCasted) {
      setState(() {
        _paRadioGroupValue = value;
      });
    }
  }

  @override
  void initState() {
    controller = new PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: PageView(
        controller: controller,
        children: [
          //Start of first page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //

          //Now working :D
          Column(
            children: <Widget>[
              PollHeader(
                headerName: "NATIONAL ASSEMBLY",
              ),
              Expanded(
                //flex: 5,
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('polls').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();

                      DocumentSnapshot first = snapshot.data.documents.first;
                      var pollArray = first['pollOptions'];
                      int i = 0;

                      return ListView(
                        padding: const EdgeInsets.only(top: 20.0),
                        children: pollArray
                            .map<Widget>((data) => _buildListItem(
                                context,
                                data,
                                i++,
                                _naRadioGroupValue,
                                _handleRadioValueChange1))
                            .toList(),
                      );
                    },
                  ),
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0, top: 8),
                  child: RaisedButton(
                    onPressed: naVoteCasted
                        ? null
                        : () {
                            if (_naRadioGroupValue == -1) {
                              showAlertDialog(context, 'Unable to proceed',
                                  'Please select a party to vote.');
                            } else {
                              setState(() {
                                naVoteCasted = true;
                              });
                              controller.jumpToPage(1);
                            }
                          },
                    shape: Border.all(
                      color: naVoteCasted
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).accentColor,
                    ),
                    color: Theme.of(context).backgroundColor,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: naVoteCasted
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                color: Theme.of(context).backgroundColor,
              )
            ],
          ),

          //End of first page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //

          Column(
            children: <Widget>[
              PollHeader(
                headerName: "PROVINCIAL ASSEMBLY",
              ),
              Expanded(
                //flex: 5,
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('polls').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      DocumentSnapshot first = snapshot.data.documents.first;
                      var pollArray = first['pollOptions'];
                      print(pollArray);
                      int i = 0;

                      return ListView(
                        padding: const EdgeInsets.only(top: 20.0),
                        children: pollArray
                            .map<Widget>((data) => _buildListItem(
                                context,
                                data,
                                i++,
                                _paRadioGroupValue,
                                _handleRadioValueChange2))
                            .toList(),
                      );
                    },
                  ),
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0, top: 8),
                  child: RaisedButton(
                    onPressed: paVoteCasted
                        ? null
                        : () {
                            if (_paRadioGroupValue == -1) {
                              showAlertDialog(context, 'Unable to proceed',
                                  'Please select a party to vote.');
                            } else {
                              setState(() {
                                paVoteCasted = true;
                              });
                              controller.jumpToPage(2);
                            }
                          },
                    shape: Border.all(
                      color: paVoteCasted
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).accentColor,
                    ),
                    color: Theme.of(context).backgroundColor,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: paVoteCasted
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                color: Theme.of(context).backgroundColor,
              )
            ],
          ),

          //End of second page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //
          VotingResult()
        ],
      ),
      drawer: getDrawer(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(92.0),
        child: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
            Text(
              'SATURDAY, MARCH 16TH',
              style: TextStyle(color: Theme.of(context).backgroundColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                '${DateTime(2019, 03, 16).difference(DateTime.now()).inHours} Hours Away',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageIndicator(
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

  Widget _buildListItem(BuildContext context, Map data, int index,
      int radioGroupValue, Function handleValueChange) {
    print(index);
    print("data");
    final record = FirebaseNaResponse.fromMap(data);
    print("data from rdo");
    //print(record?.flag);

    var item = RadioListItem(
      flag: record?.flag,
      fullName: record?.fullName,
      index: index,
      initials: record?.initials,
      radioValue1: radioGroupValue,
      onChanged: handleValueChange,
    );
    print(item);
    return item;
  }

  Drawer getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CircleAvatarWithShadow(),
            ]),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://www.federalretirees.ca/~/media/Images/Advocacy/ElectionBallot_553558978.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.assessment,
                    color: Theme.of(context).backgroundColor),
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
                Icon(Icons.settings, color: Theme.of(context).backgroundColor),
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
                Icon(Icons.help_outline,
                    color: Theme.of(context).backgroundColor),
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
                Icon(Icons.info, color: Theme.of(context).backgroundColor),
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

class FirebaseNaResponse {
  final String color;
  final String flag;
  final String fullName;
  final String initials;
  final int numberOfVoters;
  final DocumentReference reference;

  FirebaseNaResponse.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['color'] != null),
        assert(map['flag'] != null),
        assert(map['fullName'] != null),
        assert(map['initials'] != null),
        color = map['color'],
        flag = map['flag'],
        fullName = map['fullName'],
        initials = map['initials'],
        numberOfVoters = map['numberOfVoters'];

  FirebaseNaResponse.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
