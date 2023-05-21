import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatcptapp/models/models_model.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class ApiService {
  static Future<List<ModelsModel>> getModals() async {
    try {
      var response = await http.get(Uri.parse('$BASE_URL/models'),
          headers: {"Authorization": "Bearer $API_KEY"});
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error']!= null) {
        // print("Http error ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      // print("jsonRes $jsonResponse");

      List temp = [];
      for (var v in jsonResponse['data']) {
        temp.add(v);
        // print("temp ${v["id"]}");
      }
      var ret =  ModelsModel.modelsFromSnapshot(temp);
      //print(ret.toString());
      return ret;
      


    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
