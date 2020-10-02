import 'package:charts_flutter/flutter.dart' as charts;
import 'package:connectivity/connectivity.dart';
import 'package:dwrandaz/GroupTeam.dart';
import 'package:dwrandaz/http/Http.dart';
import 'package:dwrandaz/model/Service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverAll extends StatefulWidget {
  @override
  _OverAllState createState() => _OverAllState();
}

class _OverAllState extends State<OverAll> {
  SharedPreferences sharedPreferences;

  List<charts.Series<Service, String>> _seriesPieData;
  var connectivityResult;
  bool check = false;

  List<Service> list = [];
  List<Service> listAllService = [];

  List colors = [
    Color(0xff3366cc),
    Color(0xff990099),
    Color(0xff109618),
    Color(0xfffdbe19)
  ];

  String token = "";

  Future _generateData() async {
    List data = await Http().httpGetRequest(token);

    int i = 0;
    data.forEach((element) {
      list.add(Service(
          element['name'].toString(), element['percentage'], colors[i]));
      i++;
    });

    _seriesPieData.add(
      charts.Series(
        domainFn: (Service Service, _) => Service.team,
        measureFn: (Service Service, _) => Service.salary,
        colorFn: (Service Service, _) =>
            charts.ColorUtil.fromDartColor(Service.color),
        id: 'Air Pollution',
        data: list,
        labelAccessorFn: (Service row, _) => '\% ${row.salary}',
      ),
    );
    return _seriesPieData;
  }

  getAllService() async {
    List data = [];
    data = await Http().httpTopTeams(token);

    // print(data);
    data.forEach((element) {
      listAllService.add(
          Service(element['name'], element['sum'], Color(0x000000)));
    });

    Comparator<Service> sortBySalary = (a, b) => a.salary.compareTo(b.salary);
    listAllService.sort(sortBySalary);
    listAllService = listAllService.reversed.toList();

    return listAllService;
  }

  connection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      check = true;
    } else {
      check = false;
    }
  }

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("token");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    connection();
    _seriesPieData = List<charts.Series<Service, String>>();
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
                            child: charts.PieChart(snapshot.data,
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
                                      int index) => Divider(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, position) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                              5)),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupTeam(
                                                      snapshot.data[position]
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
                                            "\$ ${listAllService[position]
                                                .salary}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                            if (snapshot.hasError || snapshot.connectionState ==
                                ConnectionState.none) {
                              return Container();
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
            if (snapshot.connectionState == ConnectionState.none) {
              return Container(child: Center(child: Text("No Data Found")),);
            }
            else {
              return Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}

