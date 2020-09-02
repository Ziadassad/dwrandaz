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

  // String url = "http://192.168.100.230:3000/getOverAll";
  String url = "http://192.168.100.3:3000/";

  List<Task> list = [];
  List<Task> listAllService = [];
  List<Task> pieData;

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
    var result = await http.get(url + "getOverAll");
    var json = jsonDecode(result.body) as List<dynamic>;
    json.forEach((element) {
      list.add(
          Task(element['name'], double.parse(element['req']), Colors.white));
    });

//    double A = (reqA / json.length) * 100;
//    double B = (reqB / json.length) * 100;
//    double C = (reqC / json.length) * 100;
//    double D = (reqD / json.length) * 100;
//    A = num.parse(A.toStringAsFixed(1));
//    B = num.parse(B.toStringAsFixed(1));
//    C = num.parse(C.toStringAsFixed(1));
//    D = num.parse(D.toStringAsFixed(1));

    pieData = [
      new Task(list[0].team, list[0].salary, Color(0xff3366cc)),
      new Task(list[1].team, list[1].salary, Color(0xff990099)),
      new Task(list[2].team, list[2].salary, Color(0xff109618)),
      new Task(list[3].team, list[3].salary, Color(0xfffdbe19)),
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

    return _seriesPieData;
  }

  getAllService() async {
    var resultAll = await http.get(url + "getService");
    var jsonAll = jsonDecode(resultAll.body) as List<dynamic>;
    jsonAll.forEach((element) {
//      print(element);
      listAllService.add(Task(
          element['name'], double.parse(element['salary']), Colors.lightBlue));
    });
    Comparator<Task> sortBySalary = (a, b) => a.salary.compareTo(b.salary);
    listAllService.sort(sortBySalary);
    listAllService = listAllService.reversed.toList();
    return listAllService;
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
                                behaviors: [
                                  charts.DatumLegend(
                                      position: charts.BehaviorPosition.bottom,
                                      outsideJustification: charts
                                          .OutsideJustification.end,
                                      desiredMaxColumns: 2,
                                      cellPadding: EdgeInsets.only(
                                          right: 10, bottom: 10),
                                      entryTextStyle: charts.TextStyleSpec(
                                          color: charts.MaterialPalette.black,
                                          fontFamily: 'Georgia',
                                          fontSize: 15
                                      )
                                  )
                                ],
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
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic)),
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
                      child: FutureBuilder(
                          future: getAllService(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ListView.separated(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  separatorBuilder: (BuildContext context,
                                      int index) =>
                                      Divider(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, position) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: listAllService[position].color,
                                          borderRadius: BorderRadius.circular(
                                              5)),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupTeam(
                                                      listAllService[position]
                                                          .team)));
                                        },
                                        child: ListTile(
                                          title: Text(
                                            " ${snapshot.data[position].team}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          leading: Text("${position + 1}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),),
                                          trailing: Text(
                                            "\$ ${format(
                                                listAllService[position]
                                                    .salary)}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                            else {
                              return Center(
                                child: CircularProgressIndicator(),);
                            }
                          }
                      ),
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