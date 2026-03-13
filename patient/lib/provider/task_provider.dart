import 'package:flutter/foundation.dart';
import 'package:patient/core/core.dart';
import 'package:patient/model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<PatientTaskModel> _allTasks = [];
  DateTime _selectedDate = DateTime.now();
  final PatientRepository _patientRepository;
  String? _activityId;
  String? _activitySetId;

  TaskProvider({
    required PatientRepository patientRepository,
  }): _patientRepository = patientRepository;

 
  Future<void> getTodayActivities({
    DateTime? date,
  }) async {
    try {
      notifyListeners();
      final result = await _patientRepository.getTodayActivities(date: date);
      if(result is ActionResultSuccess) {
        _allTasks = result.data.$1;
        _activityId = result.data.$2;
        _activitySetId = result.data.$3;
      } else {
        _allTasks = [];
      }
      notifyListeners();
    } catch(e) {
      notifyListeners();
    }
  }

  Future<void> updateActivityCompletion(List<PatientTaskModel> tasks) async {
    try {
      await _patientRepository.updateActivityCompletion(tasks: _allTasks, activityId: _activityId, activitySetId: _activitySetId);
    } catch(e) {
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    if(_allTasks.isNotEmpty) {
      updateActivityCompletion(_allTasks);
    }
    getTodayActivities(date: date);
  }

  List<PatientTaskModel> get tasks {
    return _allTasks;
  }

  void toggleTaskCompletion(String activityId, bool isCompleted) async {
    _allTasks = _allTasks.map(
      (task) => task.activityId == activityId ? task.copyWith(isCompleted: isCompleted) : task)
      .toList();
    notifyListeners();
  }

  int get completedTasksCount => tasks.where((task) => task.isCompleted ?? false).length;
  int get totalTasksCount => tasks.length;
}
