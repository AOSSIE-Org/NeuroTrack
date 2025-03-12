import 'package:flutter/material.dart';
import 'package:patient/Features/home/presentation/views/widgets/date_selector.dart';
import 'package:patient/Features/home/presentation/views/widgets/therapy_datailed_card.dart';
import 'package:patient/constants.dart';


class TherapyGoalsScreen extends StatefulWidget {
  const TherapyGoalsScreen({super.key});
  static const route = '/TherapyGoals';

  @override
  _TherapyGoalsScreenState createState() => _TherapyGoalsScreenState();
}

class _TherapyGoalsScreenState extends State<TherapyGoalsScreen> with SingleTickerProviderStateMixin {
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
        title: Text("Therapy Goals"),
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
            TherapyDetailsCard(),
            SizedBox(height: 16),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGoalsContent(),
                  Center(child: Text("Achievements Section")),
                  Center(child: Text("Observations Section")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: MyColors.kPrimaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      tabs: [
        Tab(text: "Goals"),
        Tab(text: "Achievements"),
        Tab(text: "Observations"),
      ],
    );
  }

  Widget _buildGoalsContent() {
    List<String> goals = [
      "A heartbeat is a two-part pumping action that takes about a second.",
      "As blood collects in the upper chambers (the right and left atria).",
      "The heart’s natural pacemaker (the SA node) sends out an electrical signal that causes the atria to contract.",
    ];
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text("${index + 1}."),
          title: Text(goals[index]),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
