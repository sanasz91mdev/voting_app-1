import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/helpers.dart';

class VotingResult extends StatefulWidget {
  @override
  VotingResultState createState() {
    return new VotingResultState();
  }
}

class VotingResultState extends State<VotingResult> {
  List<NationalAssemblyPollsResult> nationalAssemblyResultList =
      new List<NationalAssemblyPollsResult>();

  List<ProvincialAssemblyPollResult> provincialAssemblyPollResultList =
      new List<ProvincialAssemblyPollResult>();

  List<ProvinceHelper> provinceHelperList = new List<ProvinceHelper>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 16.0),
              child: Text(
                'NATIONAL ASSEMBLY',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 4.0,
                  child: SizedBox(
                      height: 194,
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            Firestore.instance.collection('polls').snapshots(),
                        builder: (context, snapshot) {
                          nationalAssemblyResultList =
                              new List<NationalAssemblyPollsResult>();
                          if (!snapshot.hasData) return LinearProgressIndicator();

                          DocumentSnapshot nationalAssemblyDoc =
                              snapshot.data.documents.first;
                          var results = nationalAssemblyDoc['pollOptions'];

                          results.forEach((element) => nationalAssemblyResultList
                              .add(new NationalAssemblyPollsResult(
                                  element['initials'],
                                  element['numberOfVotes'],
                                  charts.Color.fromHex(code: element['color']))));

                          var series = [
                            charts.Series(
                                data: nationalAssemblyResultList,
                                domainFn: (NationalAssemblyPollsResult na, _) =>
                                    na.partyInitial,
                                measureFn: (NationalAssemblyPollsResult na, _) =>
                                    na.numberOfVotes,
                                colorFn: (NationalAssemblyPollsResult na, _) =>
                                    na.color,
                                id: "natAssemblyVote")
                          ];

                          var pieChart = charts.PieChart(
                            series,
                            animate: true,
                            defaultRenderer: charts.ArcRendererConfig(arcWidth: 30,arcRendererDecorators: [charts.ArcLabelDecorator()],
                          ));

                          return pieChart;

                        },
                      )),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 16.0),
              child: Text(
                "PROVINCIAL ASSEMBLY",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Card(
                  elevation: 4.0,
                  child: SizedBox(
                    height: 194,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('polls').snapshots(),
                      builder: (context, snapshot) {
                        provincialAssemblyPollResultList =
                            new List<ProvincialAssemblyPollResult>();
                        if (!snapshot.hasData)
                          return LinearProgressIndicator(
                            backgroundColor: Colors.orange,
                          );
                        DocumentSnapshot first = snapshot.data.documents.last;
                        var pollResults = first['pollOptionsBalochistan'][0];
                        provincialAssemblyPollResultList.add(
                            new ProvincialAssemblyPollResult(
                                'Balochistan',
                                pollResults['numberOfVotes'],
                                pollResults['initials'],
                                charts.Color.fromHex(
                                    code: pollResults['color'])));
                        var pollResultsKPK = first['pollOptionsKPK'][0];
                        provincialAssemblyPollResultList.add(
                            new ProvincialAssemblyPollResult(
                                'KPK',
                                pollResultsKPK['numberOfVotes'],
                                pollResultsKPK['initials'],
                                charts.Color.fromHex(
                                    code: pollResultsKPK['color'])));
                        var pollResultsPunjab = first['pollOptionsPunjab'][0];
                        provincialAssemblyPollResultList.add(
                            new ProvincialAssemblyPollResult(
                                'Punjab',
                                pollResultsPunjab['numberOfVotes'],
                                pollResultsPunjab['initials'],
                                charts.Color.fromHex(
                                    code: pollResultsPunjab['color'])));
                        var pollResultsSindh = first['pollOptionsSindh'];
                        pollResultsSindh.forEach((element) =>
                            provinceHelperList.add(new ProvinceHelper(
                                'sindh',
                                element['numberOfVotes'],
                                element['initials'],
                                charts.Color.fromHex(code: element['color']))));
                        provinceHelperList
                            .sort((a, b) => a.votes.compareTo(b.votes));
                        var sindhPartyWithMaxVotes =
                            provinceHelperList[provinceHelperList.length - 1];
                        provincialAssemblyPollResultList.add(
                            new ProvincialAssemblyPollResult(
                                'sindh',
                                sindhPartyWithMaxVotes.votes,
                                sindhPartyWithMaxVotes.party,
                                sindhPartyWithMaxVotes.color));
                        var provincialSeries = [
                          charts.Series<ProvincialAssemblyPollResult, String>(
                            id: 'provincialChart',
                            colorFn: (ProvincialAssemblyPollResult winner, _) =>
                                winner.color,
                            domainFn: (ProvincialAssemblyPollResult winner, _) =>
                                winner.province,
                            measureFn: (ProvincialAssemblyPollResult winner, _) =>
                                winner.votes,
                            data: provincialAssemblyPollResultList,
                            labelAccessorFn:
                                (ProvincialAssemblyPollResult winner, _) =>
                                    winner.party,
                          ),
                        ];
                        var barChart = charts.BarChart(
                          provincialSeries,
                          animate: false,
                          vertical: false,
                          barRendererDecorator:
                              charts.BarLabelDecorator<String>(),
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: barChart,
                        );
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

