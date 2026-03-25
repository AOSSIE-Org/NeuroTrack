import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme.dart';
import '../../provider/task_provider.dart';

class DailyActivitiesScreen extends StatefulWidget {
  const DailyActivitiesScreen({super.key});

  @override
  State<DailyActivitiesScreen> createState() => _DailyActivitiesScreenState();
}

class _DailyActivitiesScreenState extends State<DailyActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late DateTime today;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  double _prevProgress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TaskProvider>().getTodayActivities();
    });
    today = DateTime.now();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _animateProgress(double end) {
    setState(() {
      _progressAnimation = Tween<double>(
        begin: _prevProgress,
        end: end,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));

      _prevProgress = end;
      _progressController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Activities'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<TaskProvider>().updateActivityInBackground();
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          final completedTasks = taskProvider.completedTasksCount;
          final totalTasks = taskProvider.totalTasksCount;
          final selectedDate = taskProvider.selectedDate;
          final progressValue =
              totalTasks > 0 ? completedTasks / totalTasks : 0.0;
          return Column(
            children: [
              EasyTheme(
                data: EasyTheme.of(context).copyWith(
                  timelineOptions: const TimelineOptions(
                    height: 60,
                  ),
                  selectionMode: const SelectionMode.autoCenter(),
                  dayShape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  currentDayBorder: const WidgetStatePropertyAll(
                    BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  currentDayShape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  currentDayMiddleElementStyle: const WidgetStatePropertyAll(
                    TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  dayMiddleElementStyle: const WidgetStatePropertyAll(
                    TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                child: EasyDateTimeLinePicker(
                  firstDate: today.subtract(const Duration(days: 365)),
                  lastDate: today.add(const Duration(days: 365)),
                  focusedDate: selectedDate,
                  itemExtent: 50,
                  onDateChange: (date) {
                    taskProvider.setSelectedDate(date);
                  },
                  currentDate: today,
                  dayElementsOrder: const [
                    DayElement.middle(),
                  ],
                  headerOptions: const HeaderOptions(
                    headerType: HeaderType.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(22.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromRGBO(232, 232, 232, 1),
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activities Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Activities',
                        ),
                        const Spacer(),
                        Text(
                          '$completedTasks/$totalTasks',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _progressController.isAnimating
                              ? _progressAnimation.value
                              : progressValue,
                          backgroundColor:
                              const Color.fromRGBO(232, 232, 232, 1),
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.primaryColor,
                          minHeight: 8,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: tasks.isEmpty
                    ? const Text('No Tasks Assigned')
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            minTileHeight: 20,
                            leading: Checkbox(
                              value: tasks[index].isCompleted,
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) => taskProvider
                                  .toggleTaskCompletion(tasks[index].activityId!, value!),
                            ),
                            horizontalTitleGap: -4,
                            title: Text(
                                tasks[index].activityName ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: tasks[index].isCompleted ?? false
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: Colors.black54,
                                decorationThickness: 2,
                                color: tasks[index].isCompleted ?? false
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
