import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;

import 'file:///C:/Users/snap%20shot/Desktop/dwrandaz/lib/model/Data.dart';

class GroupTeam extends StatefulWidget {
  final String nameTeam;

  GroupTeam(this.nameTeam);

  @override
  _GroupTeamState createState() => _GroupTeamState();
}

class _GroupTeamState extends State<GroupTeam> {
  List<Data> data = [];
  List<Data> filter = [];

  ScrollController _controller = ScrollController();

  String url = "http://192.168.100.3:3000/";

  var json;
  bool isLoad = true;

  Future refresh() async {
    filter.clear();
    data.clear();

    var result = await http.get(url + widget.nameTeam);
    json = jsonDecode(result.body) as List<dynamic>;

    json.forEach((element) {
      data.add(Data(element['name'], element['salary'], element['date']));
    });
    filter.addAll(data);
    setState(() {
      Comparator<Data> sortBySalary = (a, b) => a.salary.compareTo(b.salary);
      filter.sort(sortBySalary);
      if (dropdownSort == 'up to down') {
        return filter;
      } else if (dropdownSort == 'down to up') {
        return filter.reversed.toList();
      } else {
        return data;
      }
    });
  }

  Future<List<Data>> loadData() async {
    if (dropdownSort == 'up to down') {
      return filter.reversed.toList();
    } else if (dropdownSort == 'down to up') {
      return filter;
    } else {
      return data;
    }
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
    refresh();
    loadData();
  }

  String dropdownValue = 'AllDate';
  String dropdownSort = 'ByDefault';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameTeam),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26))),
            width: double.infinity,
            height: 120,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (dropdownValue == 'ByDate')
                      Column(
                        children: <Widget>[
                          Container(
                            width: 120,
                            height: 68,
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                    bottomLeft: Radius.circular(55))),
                            child: FlatButton(
                              onPressed: () {
                                dateTime(1);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Start Date",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.date_range),
                                    onPressed: () {
                                      dateTime(1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Text(startDate)
                        ],
                      ) else
                      Container(),
                    Column(
                      children: <Widget>[
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: dropdownValue,
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['AllDate', 'ByDate']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: dropdownSort,
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownSort = newValue;
                            });
                          },
                          items: <String>[
                            'ByDefault',
                            'up to down',
                            'down to up'
                          ]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    dropdownValue == 'ByDate' ? Column(
                      children: <Widget>[
                        Container(
                          width: 120,
                          height: 68,
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(55))),
                          child: FlatButton(
                            onPressed: () {
                              dateTime(2);
                            },
                            child: Column(
                              children: <Widget>[
                                Text("End Date",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic)),
                                IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed: () {
                                    dateTime(2);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 9,),
                        Text(endDate)
                      ],
                    ) : Container(),
                  ],
                ),
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: refresh,
            child: FutureBuilder(
              future: loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return dataTable(snapshot.data);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dataTable(List<Data> list) {
    List<Data> byDate = [];
    DateTime sDate = DateTime.parse(startDate);
    DateTime eDate = DateTime.parse(endDate);
    if (dropdownValue != 'AllDate') {
      list.forEach((element) {
        DateTime oDate = DateTime.parse(element.date + " 13:27:00");
        if (sDate.isBefore(oDate) && eDate.isAfter(oDate)) {
          byDate.add(element);
        }
      });
    }

    return Transform.translate(
      offset: Offset(0, 110),
      child: Container(
        width: double.infinity,
        height: 550,
        child: SingleChildScrollView(
          child: DataTable(
            horizontalMargin: 20,
            columns: <DataColumn>[
              DataColumn(
                  label: Text(
                "NameTeam",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              )),
              DataColumn(
                  label: Text(
                    "Salary",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  )),
              DataColumn(
                  label: Text(
                    "Date",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ))
            ],
            rows: dropdownValue == 'AllDate'
                ? list
                .map((data) => DataRow(cells: [
              DataCell(Text(data.nameTeam)),
              DataCell(Text('\$ ${data.salary}')),
              DataCell(Text(data.date))
            ]))
                .toList()
                : byDate
                .map((data) => DataRow(cells: [
              DataCell(Text(data.nameTeam)),
              DataCell(Text('\$ ${data.salary}')),
              DataCell(Text(data.date))
            ]))
                .toList(),
          ),
        ),
      ),
    );
  }

  String startDate = "2020-08-01";
  String endDate = "2020-12-30";

  dateTime(index) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2020, 8, 10), onChanged: (date) {
      setState(() {
        if (index == 1) {
              String date1 = date.toString();
              startDate = date1.substring(0, 10);
            } else {
              String date1 = date.toString();
              endDate = date1.substring(0, 10);
            }
          });
        },
        onConfirm: (date) {
          setState(() {
            if (index == 1) {
              String date1 = date.toString();
              startDate = date1.substring(0, 10);
            } else {
              String date1 = date.toString();
              endDate = date1.substring(0, 10);
            }
          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }
}


