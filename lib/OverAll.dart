import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class OverAll extends StatefulWidget {
  @override
  _OverAllState createState() => _OverAllState();
}

class _OverAllState extends State<OverAll> {
  List<charts.Series<Task, String>> _seriesPieData;

  // String url = "http://192.168.100.224:3000/getOverAll";
  String url = "http://192.168.100.3:3000/getOverAll";

  List<Task> pieData;

  double salaryTeamA = 0;
  double salaryTeamB = 0;
  double salaryTeamC = 0;
  double salaryTeamD = 0;

  Future _generateData() async {
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

    pieData = [
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
        data: pieData,
        labelAccessorFn: (Task row, _) => '\$ ${row.salary}',
      ),
    );
    Comparator<Task> sortBySalary = (a, b) => a.salary.compareTo(b.salary);
    pieData.sort(sortBySalary);
    pieData = pieData.reversed.toList();
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
    return Container(
      child: FutureBuilder(
          future: _generateData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    child: Stack(
                        children: <Widget>[
//                          Text(
//                            'Team and Salary', style: TextStyle(
//                              fontSize: 24.0, fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 20.0,
                  ),
                  check == true
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.yellowAccent[100],
                              borderRadius: BorderRadius.circular(12)),
                          height: 350,
                          child: Expanded(
                            child: charts.PieChart(_seriesPieData,
                                animate: true,
                                animationDuration: Duration(seconds: 2),
                                defaultRenderer: new charts.ArcRendererConfig(
                                    arcWidth: 170,
                                    arcRendererDecorators: [
                                      new charts.ArcLabelDecorator(
                                          labelPosition:
                                              charts.ArcLabelPosition.inside)
                                    ])),
                          ),
                        )
                      : Center(
                          child: Text("No Internet"),
                        ),
                  Transform.translate(
                    offset: Offset(0, 350),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Text("Top"),
                            title: Text("Name Team",
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            trailing: Text(
                              "TotalSalary",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            width: double.infinity,
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: Offset(0, 420),
                    child: Container(
                      height: 250,
                      child: ListView.separated(
                          physics: AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          itemCount: pieData.length,
                          itemBuilder: (context, position) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: pieData[position].color,
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                title: Text(
                                  " ${pieData[position].team}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                leading: Text("${position + 1}"),
                                trailing: Text(
                                  "\$ ${pieData[position].salary}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }),
                            ),
                          )
                        ]
                    )
                ),
              );
            }
            return Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }
}


class Task {
  String team;
  double salary;
  Color color;

  Task(this.team, this.salary, this.color);
}