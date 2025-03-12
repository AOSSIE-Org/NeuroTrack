import 'package:flutter/material.dart';
import 'package:patient/Features/home/presentation/views/widgets/check_list.dart';
import 'package:patient/Features/home/presentation/views/widgets/custom_level_slider.dart';
import 'package:patient/Features/home/presentation/views/widgets/date_selector.dart';


class DailyActivities extends StatefulWidget {
  const DailyActivities({super.key});
  static const route = '/DailyActivities';

  @override
  _TherapyGoalsScreenState createState() => _TherapyGoalsScreenState();
}

class _TherapyGoalsScreenState extends State<DailyActivities> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Activities"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDateSelector(),
            SizedBox(height: 16),
            SizedBox(height: 16),
            buildAutismLevelCard(),
            SizedBox(height: 25),
            CheckListWidget(),
          ],
        ),
      ),
    );
  }
}