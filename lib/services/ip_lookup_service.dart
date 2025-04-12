import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> traceIP(String ip) async {
  final response = await http.get(Uri.parse('http://ip-api.com/json/$ip'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return {'status': 'fail'};
  }
}
