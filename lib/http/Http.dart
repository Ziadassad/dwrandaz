import 'dart:convert';

import 'package:http/http.dart' as http;

class Http {
  String url = "https://eshukar.herokuapp.com";

  Future<List<dynamic>> httpGetRequest(token) async {
    var result = await http.get(
        url + "/api/v1/services/topServices?by=RequestNo",
        headers: {"Authorization": "Bearer ${token}"});
    var json = await jsonDecode(result.body);
    var listData = await json['data'] as List<dynamic>;

    return listData;
  }

  Future<List<dynamic>> httpGetMoney(token) async {
    var result = await http.get(url + "/api/v1/services/topServices?by=Money",
        headers: {"Authorization": "Bearer ${token}"});
    var json = await jsonDecode(result.body);
    var listData = await json['data'] as List<dynamic>;
//    print(listData);
    return listData;
  }

  Future<List<dynamic>> httpTopTeams(token) async {
    var result = await http.get(url + "/api/v1/teams/topTeams",
        headers: {"Authorization": "Bearer ${token}"});
    var json = await jsonDecode(result.body);
    var listData = await json['data'] as List<dynamic>;
    // print(listData);
    return listData;
  }
}
