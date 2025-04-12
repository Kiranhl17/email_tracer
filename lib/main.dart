import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(EmailTracerApp());
}

class EmailTracerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email Tracer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
