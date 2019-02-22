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

  @override
  void initState() {
    controller = new PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      Track("Mon", 250),
      Track("Tue", 1250),
      Track("Wed", 450),
      Track("Thurs", 650),
      Track("Fri", 750),
      Track("Sat", 350),
      Track("Sun", 150),
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
          labelAccessorFn: (Provincial winner, _) => winner.party,),
    ];
    var series = [
      charts.Series(
          domainFn: (Track track, _) => track.day,
          measureFn: (Track track, _) => track.steps,
          id: 'fitnessTrack',
          data: data)
    ];

    var pi = (22 / 7);

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
