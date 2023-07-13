import 'package:flutter/material.dart';

class IndividualChat extends StatelessWidget {
  final String roomId;
  IndividualChat({super.key, required this.roomId});
  final Map<String,dynamic> usermap={};
  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Name"),
        ),
      ),
    );
  }
}
