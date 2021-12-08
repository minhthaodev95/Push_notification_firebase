import 'package:flutter/material.dart';

class AnotherScreen extends StatefulWidget {
  const AnotherScreen({Key? key}) : super(key: key);

  @override
  _AnotherScreenState createState() => _AnotherScreenState();
}

class _AnotherScreenState extends State<AnotherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Another Screen")),
      body: const Center(child: Text('AnotherScreen')),
    );
  }
}
