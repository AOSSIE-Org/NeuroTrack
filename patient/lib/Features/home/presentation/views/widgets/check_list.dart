import 'package:flutter/material.dart';
import 'package:patient/constants.dart';

class CheckListWidget extends StatefulWidget {
  const CheckListWidget({super.key});

  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {
  List<Map<String, dynamic>> tasks = [
    {"title": "Brush Teeth", "isChecked": true},
    {"title": "Have Breakfast", "isChecked": false},
    {"title": "Have Breakfast", "isChecked": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasks.map((task) {
        return CheckboxListTile(
          value: task["isChecked"],
          onChanged: (value) {
            setState(() {
              task["isChecked"] = value!;
            });
          },
          title: Text(
            task["title"],
            style: TextStyle(
              decoration: task["isChecked"] ? TextDecoration.lineThrough : null,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          activeColor: MyColors.kPrimaryColor, 
          checkColor: Colors.white, 
          controlAffinity: ListTileControlAffinity.leading, 
        );
      }).toList(),
    );
  }
}
