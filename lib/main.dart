import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

void main() => runApp(VotingApp());

class VotingApp extends StatelessWidget {
  Color _primaryColor = Color(0xFF5AC4E5);
  Color _secondaryColor = Color(0xFF030A27);
  Color _accentColor = Colors.white;
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
    var data = [
      Track("PPP", 250),
      Track("PTI", 1250),
      Track("PMLN", 450),
      Track("TLP", 650),
    ];
    final provincial_data = [
      Provincial('Sindh', 75, 'PPP'),
      Provincial('Punjab', 100, 'PMLN'),
      Provincial('Balochistan', 55, 'TLP'),
      Provincial('KPK', 25, 'PTI'),
    ];
    final provincial_series = [
      charts.Series<Provincial, String>(
        id: 'provincialChart',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Provincial winner, _) => winner.province,
        measureFn: (Provincial winner, _) => winner.votes,
        data: provincial_data,
        labelAccessorFn: (Provincial winner, _) => winner.party,
      ),
    ];
    var series = [
      charts.Series(
          domainFn: (Track track, _) => track.day,
          measureFn: (Track track, _) => track.steps,
          id: 'nationalChart',
          data: data)
    ];

    var barChart = charts.BarChart(
      provincial_series,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );

    var pieChart = charts.PieChart(
      series,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 30,
        arcRendererDecorators: [charts.ArcLabelDecorator()],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(94.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                  count: 2,
                ),
              ),
            ],
          ),
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
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Text(
                  'NATIONAL ASSEMBLY',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                    child: SizedBox(
                  height: 200,
                  child: pieChart,
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Text(
                  'PROVINCIAL ASSEMBLY',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                    child: SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: barChart,
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.age.toString()),
          onTap: () => print(record),
        ),
      ),
    );
  }
}

class Track {
  final String day;
  final int steps;

  Track(this.day, this.steps);
}

class Provincial {
  final String province;
  final int votes;
  final String party;

  Provincial(this.province, this.votes, this.party);
}

class Record {
  final String name;
  final int age;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['age'] != null),
        name = map['name'],
        age = map['age'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$age>";
}
