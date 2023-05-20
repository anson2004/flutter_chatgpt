import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class ApiService {
  static Future<void> getModals() async {
    try {
      var response = await http.get(Uri.parse('$BASE_URL/models'),
          headers: {"Authorization": "Bearer $API_KEY"});
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error']!= null) {
        print("Http error ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      print("jsonRes $jsonResponse");
    } catch (error) {
      print("error $error");
    }
  }
}
