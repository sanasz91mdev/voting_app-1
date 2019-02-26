import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

class VotingResult extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VotingResultState();
  }
}

class VotingResultState extends State<VotingResult> {
  List<NationalAssemblyPollsResult> nationalAssemblyResultList =
      new List<NationalAssemblyPollsResult>();
  bool isNaResultReady = false;
  var naDataElements;
  var series;
  var pieChart;

  Future<List<dynamic>> getPollOptions() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('polls')
        .document('NationalAssemblyPoll')
        .get();
    var channelName = snapshot['pollOptions'];
    print(channelName);
    return channelName;
  }

  @override
  void initState() {
    super.initState();
//    getPollOptions().then((data) {
//      print("pollOptionsresuly");
//      print(data);
//      data.forEach((element) => nationalAssemblyResultList.add(
//          new NationalAssemblyPollsResult(
//              element['initials'],
//              element['numberOfVotes'],
//              charts.Color.fromHex(code: element['color']))));
//      print(nationalAssemblyResultList[0].numberOfVotes);
//
//      naDataElements = nationalAssemblyResultList;
//      series = [
//        charts.Series(
//            domainFn: (NationalAssemblyPollsResult naResult, _) =>
//                naResult.partyInitial,
//            colorFn: (NationalAssemblyPollsResult naResult, _) =>
//                naResult.color,
//            measureFn: (NationalAssemblyPollsResult naResult, _) =>
//                naResult.numberOfVotes,
//            id: 'nationalChart',
//            data: naDataElements)
//      ];
//
//      setState(() {
//        pieChart = charts.PieChart(
//          series,
//          animate: true,
//          defaultRenderer: charts.ArcRendererConfig(
//            arcWidth: 30,
//            arcRendererDecorators: [charts.ArcLabelDecorator()],
//          ),
//        );
//
//        isNaResultReady = true;
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    final provincial_data = [
      Provincial('Sindh', 75, 'PPP'),
      Provincial('Punjab', 100, 'PMLN'),
      Provincial('Balochistan', 55, 'TLP'),
      Provincial('KPK', 25, 'PTI'),
    ];
    final provincial_series = [
      charts.Series<Provincial, String>(
        id: 'provincialChart',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Provincial winner, _) => winner.province,
        measureFn: (Provincial winner, _) => winner.votes,
        data: provincial_data,
        labelAccessorFn: (Provincial winner, _) => winner.party,
      ),
    ];

    var barChart = charts.BarChart(
      provincial_series,
      animate: false,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );

    return ListView(
      children: [
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
            height: 194,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('polls').snapshots(),
              builder: (context, snapshot) {
                nationalAssemblyResultList =
                    new List<NationalAssemblyPollsResult>();
                if (!snapshot.hasData)
                  return LinearProgressIndicator(
                    backgroundColor: Colors.orange,
                  );
                DocumentSnapshot first = snapshot.data.documents.first;
                var pollResults = first['pollOptions'];

                pollResults.forEach((element) => nationalAssemblyResultList.add(
                    new NationalAssemblyPollsResult(
                        element['initials'],
                        element['numberOfVotes'],
                        charts.Color.fromHex(code: element['color']))));

                naDataElements = nationalAssemblyResultList;
                series = [
                  charts.Series(
                      domainFn: (NationalAssemblyPollsResult naResult, _) =>
                          naResult.partyInitial,
                      colorFn: (NationalAssemblyPollsResult naResult, _) =>
                          naResult.color,
                      measureFn: (NationalAssemblyPollsResult naResult, _) =>
                          naResult.numberOfVotes,
                      id: 'nationalChart',
                      data: naDataElements)
                ];

                pieChart = charts.PieChart(
                  series,
                  animate: true,
                  defaultRenderer: charts.ArcRendererConfig(
                    arcWidth: 30,
                    arcRendererDecorators: [charts.ArcLabelDecorator()],
                  ),
                );

                return pieChart;
              },
            ),
            //isNaResultReady?pieChart:Center(child: CircularProgressIndicator(backgroundColor: Colors.green,),),
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: Text(
            'PROVINCIAL ASSEMBLY',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Theme.of(context).backgroundColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
          child: Card(
              child: SizedBox(
            height: 194,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: barChart,
            ),
          )),
        ),
      ],
    );
  }
}

class NationalAssemblyPollsResult {
  final String partyInitial;
  final int numberOfVotes;
  final charts.Color color;

  NationalAssemblyPollsResult(
      this.partyInitial, this.numberOfVotes, this.color);
}

class Provincial {
  final String province;
  final int votes;
  final String party;

  Provincial(this.province, this.votes, this.party);
}
