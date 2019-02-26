import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';



class LiveView extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return LiveViewState();
  }

}


class LiveViewState extends State<LiveView>
{
  @override
  Widget build(BuildContext context) {

    void initState() {
      super.initState();

    }

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
     appBar: AppBar(title: Text("Live Results",style:TextStyle(color: Colors.white) ,),),
     body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16.0),
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
                  child: pieChart,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16.0),
            child: Text(
              'PROVINCIAL ASSEMBLY',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
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
