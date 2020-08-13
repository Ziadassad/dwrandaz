import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Data.dart';

class OverAll extends StatefulWidget {
  @override
  _OverAllState createState() => _OverAllState();
}

class _OverAllState extends State<OverAll> {
  List<charts.Series<Task, String>> _seriesPieData;

  String url = "http://192.168.100.3:3000/getOverAll";
  List<Data> data = [];

  double salaryTeamA = 0;
  double salaryTeamB = 0;
  double salaryTeamC = 0;
  double salaryTeamD = 0;

  Future _generateData() async {
    data.clear();

    var result = await http.get(url);
    var json = jsonDecode(result.body) as List<dynamic>;

    json.forEach((element) {
      switch (element['name']) {
        case "Team A":
          salaryTeamA = salaryTeamA + int.parse(element['salary']);
          break;
        case "Team B":
          salaryTeamB = salaryTeamB + int.parse(element['salary']);
          break;
        case "Team C":
          salaryTeamC = salaryTeamC + int.parse(element['salary']);
          break;
        case "Team D":
          salaryTeamD = salaryTeamD + int.parse(element['salary']);
          break;
      }
    });

    var piedata = [
      new Task('team A', salaryTeamA, Color(0xff3366cc)),
      new Task('team B', salaryTeamB, Color(0xff990099)),
      new Task('team C', salaryTeamC, Color(0xff109618)),
      new Task('team D', salaryTeamD, Color(0xfffdbe19)),
    ];
    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.team,
        measureFn: (Task task, _) => task.salary,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '\$ ${row.salary}',
      ),
    );

    return await _seriesPieData;
  }

  var connectivityResult;
  bool check = false;

  connection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      check = true;
    } else {
      check = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connection();
    _seriesPieData = List<charts.Series<Task, String>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _generateData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                      check == true ? Expanded(
                        child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                              new charts.DatumLegend(
                                outsideJustification: charts
                                    .OutsideJustification
                                    .middleDrawArea,
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
                                      labelPosition: charts.ArcLabelPosition
                                          .inside
                                  )
                                ])
                        ),
                      ) : Center(child: Text("No Internet"),),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator(),);
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