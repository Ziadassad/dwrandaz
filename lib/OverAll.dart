import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:connectivity/connectivity.dart';
import 'package:dwrandaz/GroupTeam.dart';
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
  List<Task> totalSalary;

  double salaryTeamA = 0;
  double salaryTeamB = 0;
  double salaryTeamC = 0;
  double salaryTeamD = 0;

  int reqA = 0;
  int reqB = 0;
  int reqC = 0;
  int reqD = 0;

  Future _generateData() async {
    reqA = 0;
    reqB = 0;
    reqC = 0;
    reqD = 0;
    var result = await http.get(url);
    var json = jsonDecode(result.body) as List<dynamic>;

    json.forEach((element) {
      switch (element['name']) {
        case "Team A":
          reqA++;
          salaryTeamA = salaryTeamA + int.parse(element['salary']);
          break;
        case "Team B":
          reqB++;
          salaryTeamB = salaryTeamB + int.parse(element['salary']);
          break;
        case "Team C":
          reqC++;
          salaryTeamC = salaryTeamC + int.parse(element['salary']);
          break;
        case "Team D":
          reqD++;
          salaryTeamD = salaryTeamD + int.parse(element['salary']);
          break;
      }
    });
    double A = (reqA / json.length) * 100;
    double B = (reqB / json.length) * 100;
    double C = (reqC / json.length) * 100;
    double D = (reqD / json.length) * 100;
    A = num.parse(A.toStringAsFixed(1));
    B = num.parse(B.toStringAsFixed(1));
    C = num.parse(C.toStringAsFixed(1));
    D = num.parse(D.toStringAsFixed(1));

    pieData = [
      new Task('teamA', A, Color(0xff3366cc)),
      new Task('teamB', B, Color(0xff990099)),
      new Task('teamC', C, Color(0xff109618)),
      new Task('teamD', D, Color(0xfffdbe19)),
    ];

    totalSalary = [
      new Task('teamA', salaryTeamA, Color(0xff3366cc)),
      new Task('teamB', salaryTeamB, Color(0xff990099)),
      new Task('teamC', salaryTeamC, Color(0xff109618)),
      new Task('teamD', salaryTeamD, Color(0xfffdbe19)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.team,
        measureFn: (Task task, _) => task.salary,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
        id: 'Air Pollution',
        data: pieData,
        labelAccessorFn: (Task row, _) => '\% ${row.salary}',
      ),
    );
    Comparator<Task> sortBySalary = (a, b) => a.salary.compareTo(b.salary);
    totalSalary.sort(sortBySalary);
    totalSalary = totalSalary.reversed.toList();
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
                  SizedBox(
                    height: 20.0,
                  ),
                  check == true
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(12)),
                          height: 350,
                          child: Expanded(
                            child: charts.PieChart(_seriesPieData,
                                animate: true,
                                animationDuration: Duration(milliseconds: 700),
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
                          itemCount: totalSalary.length,
                          itemBuilder: (context, position) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: totalSalary[position].color,
                                  borderRadius: BorderRadius.circular(5)),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          GroupTeam(
                                              totalSalary[position].team)));
                                },
                                child: ListTile(
                                  title: Text(
                                    " ${totalSalary[position].team}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  leading: Text("${position + 1}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),),
                                  trailing: Text(
                                    "\$ ${format(
                                        totalSalary[position].salary)}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
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

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}


class Task {
  String team;
  double salary;
  Color color;

  Task(this.team, this.salary, this.color);
}