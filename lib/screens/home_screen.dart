import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void traceEmailHeader(String header) async {
    final ipRegex = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
    final match = ipRegex.firstMatch(header);
    if (match == null) {
      setState(() {
        _result = 'No IP address found in header.';
      });
      return;
    }

    final ip = match.group(0);
    final url = Uri.parse('https://ipinfo.io/$ip/json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _result = '''
IP Address: $ip
City: ${data['city']}
Region: ${data['region']}
Country: ${data['country']}
Org: ${data['org']}
Location: ${data['loc']}
''';
      });
    } else {
      setState(() {
        _result = 'Failed to fetch IP information.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Tracer')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Paste email header here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => traceEmailHeader(_controller.text),
              child: const Text('Trace Email'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
