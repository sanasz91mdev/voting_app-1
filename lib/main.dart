import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(VotingApp());

class VotingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: ThemeData(primarySwatch: Colors.purple),
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
  var data = [
    Track("Mon", 250),
    Track("Tue", 1250),
    Track("Wed", 450),
    Track("Thurs", 650),
    Track("Fri", 750),
    Track("Sat", 350),
    Track("Sun", 150),
  ];

  var series = [
    charts.Series(
        domainFn: (Track track, _) => track.day,
        measureFn: (Track track, _) => track.steps,
        id: 'fitnessTrack',
        data: data)
  ];

  var pi = (22 / 7);

  var pieChart = charts.PieChart(series,
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 30,
          arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(98.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.star),
                        Icon(Icons.star_border),
                        Icon(Icons.star),
                        Icon(Icons.star_border),
                        Icon(Icons.star),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Text(
                      '23 Days Away',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.lens,
                          size: 8.0,
                        ),
                        Icon(
                          Icons.panorama_fish_eye,
                          size: 8.0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        //End of first page
        //                //
        //                //
        //                //
        //                //
        //                //
        // // // // // // //
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Card(
                  child: SizedBox(
                height: 200,
                child: pieChart,
              )),
              _buildBody(context),
            ],
          ),
        ),
      ],
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
        children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child:
      Container(
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

class Track
{
  final String day;
  final int steps;

  Track(this.day,this.steps);
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
