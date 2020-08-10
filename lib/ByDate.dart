import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ByDate extends StatefulWidget {
  @override
  _ByDateState createState() => _ByDateState();
}

class _ByDateState extends State<ByDate> {
  List<Data> data = [];

  Future<List<Data>> listData() async {
    data.add(Data("Team A", "30", "8 / 6 /2020"));
    data.add(Data("Team B", "53", "22 / 3 /2020"));
    data.add(Data("Team C", "40", "12 / 4 /2020"));
    data.add(Data("Team D", "20", "3 / 5 /2020"));
    data.add(Data("Team A", "30", "8 / 6 /2020"));
    data.add(Data("Team B", "53", "22 / 3 /2020"));
    data.add(Data("Team C", "40", "12 / 4 /2020"));
    data.add(Data("Team D", "20", "3 / 5 /2020"));

    return data;
  }

  String startDate = "2020-8-10";

  String endDate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(26),
                  bottomRight: Radius.circular(26))),
          width: double.infinity,
          height: 100,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Start Date",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {
                              dateTime();
                            },
                          ),
                          Text(startDate),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("End Date",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {
                              dateTime();
                            },
                          ),
                          Text(startDate),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: listData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return itemCard(snapshot);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  dateTime() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2020, 8, 10),
        onChanged: (date) {
          setState(() {
            String date1 = date.toString();
            startDate = date1.substring(0, 10);
          });
        },
        onConfirm: (date) {
          setState(() {
            String date1 = date.toString();
            startDate = date1.substring(0, 10);
          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }

  Widget itemCard(snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 100, 10, 10),
      child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, position) {
            return renderCard(snapshot.data, position);
          }),
    );
  }
}

renderCard(data, int position) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    height: 100,
    width: double.infinity,
    decoration: BoxDecoration(
        color: colorTeam(data[position].nameTeam),
        borderRadius: BorderRadius.circular(16)),
    child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Team  :  ${data[position].nameTeam}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Salary :  \$ ${data[position].salary}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Date    :  ${data[position].date}',
              style: TextStyle(fontSize: 20),
            )
          ],
        )),
  );
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

class Data {
  String nameTeam;
  String salary;
  String date;

  Data(this.nameTeam, this.salary, this.date);
}

