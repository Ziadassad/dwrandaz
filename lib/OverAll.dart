import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OverAll extends StatefulWidget {
  @override
  _OverAllState createState() => _OverAllState();
}

class _OverAllState extends State<OverAll> {

  List<charts.Series<Task, String>> _seriesPieData;

  Future _generateData() async{
    var piedata = [
      new Task('team A', 26.8, Color(0xff3366cc)),
      new Task('team B', 8.3, Color(0xff990099)),
      new Task('team C', 10.8, Color(0xff109618)),
      new Task('team D', 15.6, Color(0xfffdbe19)),
      new Task('team E', 19.2, Color(0xffff9900)),
      new Task('team F', 10.3, Color(0xffdc3912)),
    ];
    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.team,
        measureFn: (Task task, _) => task.salary,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.color),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '\$ ${row.salary}',
      ),
    );

    return await _seriesPieData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _generateData();
    _seriesPieData = List<charts.Series<Task, String>>();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _generateData(),
        builder: (context , snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Team and Salary', style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                              new charts.DatumLegend(
                                outsideJustification: charts.OutsideJustification
                                    .startDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                                cellPadding: new EdgeInsets.only(right: 4.0,
                                    bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.purple
                                        .shadeDefault,
                                    fontFamily: 'Georgia',
                                    fontSize: 16),
                              )
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 170,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition: charts.ArcLabelPosition.inside
                                  )
                                ])
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }
}


class Task {
  String team;
  double salary;
  Color color;

  Task(this.team, this.salary, this.color);
}