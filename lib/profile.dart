import 'package:chat_app/auth_service.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                AuthService().signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: const Column(
          children: <Widget>[
            Text("data"),
          ],
        ),
      ),
    );
  }
}
