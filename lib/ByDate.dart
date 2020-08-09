import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';

class ByDate extends StatefulWidget {
  @override
  _ByDateState createState() => _ByDateState();
}


class _ByDateState extends State<ByDate> {

  List<Data> data = [];

  Future<List<Data>> listData() async{
    data.add(Data("Team A", "30", "8 / 6 /2020"));
    data.add(Data("Team B", "53", "22 / 3 /2020"));
    data.add(Data("Team C", "40", "12 / 4 /2020"));
    data.add(Data("Team D", "20", "3 / 5 /2020"));


    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blue
              ),
              padding: EdgeInsets.all(10),
             child: ListTile(
               leading: Text("1 / 7 / 2020"),
               trailing: Text("1 / 8 / 2020"),
             ),
            ),
            FutureBuilder(
              future: listData(),
              builder: (context , snapshot){
                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                  return ListCardItem(snapshot);
                }
                else{
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }

}

class ListCardItem extends StatelessWidget {

  final AsyncSnapshot snapshot;
  ListCardItem(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        // scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        itemBuilder: (context , position){
          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(snapshot.data[position].nameTeam , style: TextStyle(fontSize: 20),),
                    Text(snapshot.data[position].salary ,style: TextStyle(fontSize: 20),),
                    Text(snapshot.data[position].date ,style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class Data{
  String nameTeam;
  String salary;
  String date;
  Data(this.nameTeam , this.salary , this.date);
}
