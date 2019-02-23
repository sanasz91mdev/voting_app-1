import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:voting_app/live_view.dart';
import 'package:voting_app/voting_results.dart';

//TODO: can we put page view at the screen bottom below submit or finish button? there is a random exception at following 2 events:
//1 - getting back from Live view to home
//2 - Stepper tap
//exception: The page property cannot be read when multiple PageViews are attached to the same PageController.

void main() => runApp(VotingApp());

class VotingApp extends StatelessWidget {
  Color _primaryColor = Color(0xFF5AC4E5);
  Color _secondaryColor = Color(0xFF030A27);
  Color _accentColor = Colors.white;

  Color _primaryColor1 = Color(0xFF5AC4E5);
  Color _secondaryColor2 = Color(0xFF33691E); //TODO: thinking to give green, white (pakistan theme) outlook if others welcome this opinion
  Color _accentColor3 = Colors.grey;

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
      ),
      home: MainPage(
        title: 'ELECTIONS 2019',
      ),
      routes: {
        '/vote_result': (context) => new LiveView(),
      },
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
  int _radioValue1 = -1;
  VotingData model = new VotingData(currentStep: 0);


  List<Step> buildStepper() {
    return [
      Step(
          title: Text(
            "Poll 1",style: TextStyle(color: Colors.white),
          ),
          content: Container(),
          state: StepState.indexed,
          isActive: model.currentStep == 0),
      Step(
          title: Text(
            "Poll 2",style: TextStyle(color: Colors.white)
          ),
          state: StepState.indexed,
          content: Container(),
          isActive: model.currentStep == 1),
    ];
  }

  Widget getStepper()
  {
    final ThemeData theme = Theme.of(context);

    return Theme(
        data: theme.copyWith(canvasColor:theme.primaryColor,primaryColor: Color(0xFF030A27)),
        child: SizedBox(
          height: 74.0,
          child: Stepper(
            steps: buildStepper(),
            type: StepperType.horizontal,
            currentStep: model.currentStep,
            onStepTapped: (step) {
              setState(() {

                model.currentStep = step;

              });
            },
          ),
        ));
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          //Fluttertoast.showToast(msg: 'Correct !',toastLength: Toast.LENGTH_SHORT);
          break;
        case 1:
          //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          break;
        case 2:
          //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          break;
        case 3:
          //Fluttertoast.showToast(msg: 'Try again !',toastLength: Toast.LENGTH_SHORT);
          break;
        case 4:
          break;
      }
    });
  }

  @override
  void initState() {
    controller = new PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    final ThemeData theme = Theme.of(context);


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        //leading: IconButton(icon: new Icon(Icons.settings,color: Colors.white,),onPressed: ()=>_scaffoldKey.currentState.openDrawer()),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(92.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Theme.of(context).backgroundColor),
                    Icon(Icons.star, color: Theme.of(context).accentColor),
                    Icon(Icons.star, color: Theme.of(context).backgroundColor),
                    Icon(Icons.star, color: Theme.of(context).accentColor),
                    Icon(Icons.star, color: Theme.of(context).backgroundColor),
                  ],
                ),
              ),
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
                  '${DateTime(2019, 03, 16).difference(DateTime.now()).inDays} Days Away',
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
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Elections 2019",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0,color: Colors.white),),
                  Padding(
                    padding: const EdgeInsets.only(top:48.0),
                    child: Text("Sana Zehra",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Colors.white),),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0),),
                  Text("Karachi, NA - 252",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Colors.white),)
                ],
              ),
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.assessment, color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Live Results'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    new MaterialPageRoute(
                    builder: (BuildContext context) => new LiveView()));              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.settings, color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Settings'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/vote_result");
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.help_outline, color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Help & Feedback'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/vote_result");
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.info, color: Theme.of(context).backgroundColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('About'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/vote_result");
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: controller,
        children: <Widget>[
          //Start of first page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //
          Container(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'NATIONAL ASSEMBLY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                  ],
                ),
                Padding(padding: const EdgeInsets.all(8.0)),
                ListTile(
                  leading: Radio(
                    value: 0,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan Tahrek-e-Insaf',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PTI',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 1,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Tahrek-e-Labaik Pakistan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'TLP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 2,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan Muslim League',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PMLN',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 3,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan People Party',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PPP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 4,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Awami National Party',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'ANP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0,top: 8),
                  child: FlatButton(
                    onPressed: () {
                      controller.jumpToPage(1);
                    },
                    shape: Border.all(
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            color: Theme.of(context).backgroundColor,
          ),

          //End of first page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //

          model.currentStep==0? Container(
            child:
            ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'PROVINCIAL ASSEMBLY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                  ],
                ),

                Padding(padding: const EdgeInsets.all(8.0)),
                getStepper(),
                Padding(padding: const EdgeInsets.all(8.0)),
                Padding(
                  padding: const EdgeInsets.only(left:32.0),
                  child: Text("Vote for Sindh Assembly",style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Radio(
                    value: 0,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan Tahrek-e-Insaf',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PTI',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 1,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Tahrek-e-Labaik Pakistan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'TLP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 2,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan Muslim League',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PMLN',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0,top: 8),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        print("called");
                        model.currentStep=1;
                      });


                    },
                    shape: Border.all(
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            color: Theme.of(context).backgroundColor,
          ):
          Container(
            child:
            ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'PROVINCIAL ASSEMBLY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                    Icon(Icons.star, color: Colors.red),
                    Icon(Icons.star, color: Theme.of(context).primaryColor),
                  ],
                ),

                Padding(padding: const EdgeInsets.all(8.0)),
                getStepper(),
                Padding(padding: const EdgeInsets.all(8.0)),
                Padding(
                  padding: const EdgeInsets.only(left:32.0),
                  child: Text("Vote for Punjab Assembly",style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Radio(
                    value: 0,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan Tahrek-e-Insaf',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PTI',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 1,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Tahrek-e-Labaik Pakistan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'TLP',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                ListTile(
                  leading: Radio(
                    value: 2,
                    activeColor: Theme.of(context).accentColor,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  title: Text(
                    'Pakistan Muslim League',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  subtitle: Text(
                    'PMLN',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Divider(
                  color: Theme.of(context).accentColor,
                  indent: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0,top: 8),
                  child: FlatButton(
                    onPressed: () {
                      controller.jumpToPage(2);
                    },
                    shape: Border.all(
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(
                      'FINISH',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            color: Theme.of(context).backgroundColor,
          ),
          //End of second page
          //                //
          //                //
          //                //
          //                //
          //                //
          // // // // // // //

          VotingResults()

        ],
      ),
    );
  }

//  Widget _buildBody(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('users').snapshots(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) return LinearProgressIndicator();
//
//        return _buildList(context, snapshot.data.documents);
//      },
//    );
//  }
//
//  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//    return Expanded(
//      child: ListView(
//        padding: const EdgeInsets.only(top: 20.0),
//        children:
//            snapshot.map((data) => _buildListItem(context, data)).toList(),
//      ),
//    );
//  }
//
//  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//    final record = Record.fromSnapshot(data);
//
//    return Padding(
//      key: ValueKey(record.name),
//      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//      child: Container(
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.purple),
//          borderRadius: BorderRadius.circular(5.0),
//        ),
//        child: ListTile(
//          title: Text(record.name),
//          trailing: Text(record.age.toString()),
//          onTap: () => print(record),
//        ),
//      ),
//    );
//  }
}



class VotingData
{
  int currentStep = 0;
  int pageView=0;

  VotingData({this.currentStep,this.pageView});

}


