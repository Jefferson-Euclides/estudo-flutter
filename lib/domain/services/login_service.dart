import 'dart:convert';

import 'package:estudo/domain/response.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Response> login(String login, String senha) async{
    var url = "http://livrowebservices.com.br/rest/login";

    final response = await http.post(url, body: { "login": login, "senha": senha });
    final Map<String, dynamic> map = json.decode(response.body);

    final r = Response.fromJson(map);

    return r;
  }
}
