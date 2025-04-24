import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/header_parser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void traceEmailHeader(String header) async {
    setState(() {
      _result = 'Tracing...';
    });

    final ipRegex = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
    final match = ipRegex.firstMatch(header);
    final ip = match?.group(0);

    final sourceEmail = extractSourceEmail(header);
    final senderName = extractSenderName(header);
    final xFromName = extractXFromName(header);
    final domain = extractDomainFromEmail(sourceEmail);
    final tracerRoute = extractTracerRoute(header);

    String ipInfo = '';
    if (ip != null) {
      final url = Uri.parse('https://ipinfo.io/$ip/json');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ipInfo = '''
IP Address: $ip
City: ${data['city']}
Region: ${data['region']}
Country: ${data['country']}
Org: ${data['org']}
Location: ${data['loc']}
''';
      }
    }

    setState(() {
      _result = '''
🔍 Source Email ID: $sourceEmail

👤 Sender Info:
  • From Name: $senderName
  • X-From Name: $xFromName
  • Domain: $domain

📍 IP Info:
${ipInfo.isNotEmpty ? ipInfo : 'No IP info found.'}

🛰️ Tracer Route:
${tracerRoute.isNotEmpty ? tracerRoute.join('\n') : 'No tracer route found in header.'}
''';
    });
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
