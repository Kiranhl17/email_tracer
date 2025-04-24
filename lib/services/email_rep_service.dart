import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchEmailReputation(String email) async {
  final response = await http.get(
    Uri.parse('https://emailrep.io/$email'),
    headers: {'User-Agent': 'EmailTracerApp'}
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return {'status': 'fail', 'reason': 'API call failed'};
  }
}
