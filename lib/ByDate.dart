import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dwrandaz/Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;

class ByDate extends StatefulWidget {
  @override
  _ByDateState createState() => _ByDateState();
}

class _ByDateState extends State<ByDate> {
  List<Data> data = [];
  List<Data> filter = [];

  ScrollController _controller = ScrollController();
 // String url = "http://192.168.100.224:3000/get";
  String url = "http://192.168.100.3:3000/get";

  var json;
  bool isLoad = true;

  Future refresh() async {
    filter.clear();
    data.clear();

    var result = await http.get(url);
    json = jsonDecode(result.body) as List<dynamic>;

    json.forEach((element) {
      data.add(Data(element['name'], element['salary'], element['date']));
    });
    print(data[0]);
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
//    data.add(Data("Team A", "30", "8 / 6 /2020"));
//    data.add(Data("Team B", "53", "22 / 3 /2020"));
//    data.add(Data("Team C", "40", "12 / 4 /2020"));
//    data.add(Data("Team D", "20", "3 / 5 /2020"));
//    data.add(Data("Team A", "30", "8 / 6 /2020"));
//    data.add(Data("Team B", "53", "22 / 3 /2020"));
//    data.add(Data("Team C", "40", "12 / 4 /2020"));
//    data.add(Data("Team D", "20", "3 / 5 /2020"));
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
    return Stack(
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
                        items: <String>['ByDefault', 'up to down', 'down to up']
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
        child: SingleChildScrollView(
          child: DataTable(
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

//  Widget itemCard(snapshot) {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(10.0, 120, 10, 10),
//      child: check == true
//          ? ListView.builder(
//              physics: AlwaysScrollableScrollPhysics(),
//              itemCount: snapshot.data.length,
//              controller: _controller,
//              itemBuilder: (context, position) {
//                DateTime oDate =
//                    DateTime.parse(snapshot.data[position].date + " 13:27:00");
//                DateTime sDate = DateTime.parse(startDate);
//                DateTime eDate = DateTime.parse(endDate);
//                if (sDate.isBefore(oDate) &&
//                    eDate.isAfter(oDate) &&
//                    dropdownValue != 'AllDate') {
//                  return renderCard(snapshot.data, position);
//                } else if (dropdownValue == 'AllDate') {
//                  return renderCard(snapshot.data, position);
//                }
//                return Container();
//              })
//          : Center(
//              child: Text("No Internet"),
//            ),
//    );
//  }
//}
//
//renderCard(data, int position) {
//  return Container(
//    margin: EdgeInsets.only(top: 10),
//    height: 100,
//    width: double.infinity,
//    decoration: BoxDecoration(
//        color: colorTeam(data[position].nameTeam),
//        borderRadius: BorderRadius.circular(16)),
//    child: Padding(
//        padding: EdgeInsets.symmetric(horizontal: 20),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
//          children: <Widget>[
//            Text(
//              'Team  :  ${data[position].nameTeam}',
//              style: TextStyle(fontSize: 20),
//            ),
//            Text(
//              'Salary :  \$ ${data[position].salary}',
//              style: TextStyle(fontSize: 20),
//            ),
//            Text(
//              'Date    :  ${data[position].date}',
//              style: TextStyle(fontSize: 20),
//            )
//          ],
//        )),
//  );
}

colorTeam(String str) {
  switch (str) {
    case "Team A":
      return Colors.redAccent;
      break;
    case "Team B":
      return Colors.yellow;
      break;
    case "Team C":
      return Colors.cyan;
      break;
    case "Team D":
      return Colors.green;
      break;
  }
}

