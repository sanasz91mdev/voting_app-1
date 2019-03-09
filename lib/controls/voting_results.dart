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
  List<ProvincialAssemblyPollResult> provincialAssemblyPollResultList =
      new List<ProvincialAssemblyPollResult>();
  List<ProvinceHelper> provinceHelperList = new List<ProvinceHelper>();
  bool isNaResultReady = false;
  var naDataElements;
  var series;
  var pieChart;

  Future<List<dynamic>> getPollOptions() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('polls')
        .document('NationalAssemblyPoll')
        .get();
    var polls = snapshot['pollOptions'];
    return polls;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: ListView(
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
                elevation: 4.0,
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

                      pollResults.forEach((element) =>
                          nationalAssemblyResultList.add(
                              new NationalAssemblyPollsResult(
                                  element['initials'],
                                  element['numberOfVotes'],
                                  charts.Color.fromHex(
                                      code: element['color']))));

                      naDataElements = nationalAssemblyResultList;
                      series = [
                        charts.Series(
                            domainFn:
                                (NationalAssemblyPollsResult naResult, _) =>
                                    naResult.partyInitial,
                            colorFn:
                                (NationalAssemblyPollsResult naResult, _) =>
                                    naResult.color,
                            measureFn:
                                (NationalAssemblyPollsResult naResult, _) =>
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
                elevation: 4.0,
                child: SizedBox(
                  height: 194, //TODO: refactor provincial stream builder
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
                              "Sindh",
                              element['numberOfVotes'],
                              element['initials'],
                              charts.Color.fromHex(code: element['color']))));

                      provinceHelperList
                          .sort((a, b) => a.votes.compareTo(b.votes));
                      var sindhPartyWithMaxVotes =
                          provinceHelperList[provinceHelperList.length - 1];

                      provincialAssemblyPollResultList.add(
                          new ProvincialAssemblyPollResult(
                              "Sindh",
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

class ProvincialAssemblyPollResult {
  final String province;
  final int votes;
  final String party;
  final charts.Color color;

  ProvincialAssemblyPollResult(
      this.province, this.votes, this.party, this.color);
}

//TODO: Refactor other way
class ProvinceHelper {
  final String province;
  final int votes;
  final String party;
  final charts.Color color;

  ProvinceHelper(this.province, this.votes, this.party, this.color);
}
