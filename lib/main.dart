import 'package:flutter/material.dart';
import 'package:googleform_api/frontPage.dart';
import 'package:googleform_api/secondPage.dart';
//entry.2005620554=Sarthak&entry.1045781291=abc@gmail.com&entry.1065046570=abcd&entry.1166974658=1111111111
// https://docs.google.com/forms/d/e/1FAIpQLSd1zHtMH3vbysWm6RdN12qVrw3rRFSZYz2dqjs2tc3qOHh-EQ/viewform
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center( child: Front_Page())
      ),
    );
  }
}
