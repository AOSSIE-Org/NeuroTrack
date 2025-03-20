import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),automaticallyImplyLeading: false,),
      body: Center(child: Text("Profile Screen")),
    );
  }
}
