import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text("Calendar Screen")),
    );
  }
}
