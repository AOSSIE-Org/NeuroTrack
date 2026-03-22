import 'package:flutter/material.dart';
import 'package:patient/core/core.dart';

enum MilestoneCardType {
  completed,
  missed,
  regressed,
}

class ReportsProvider with ChangeNotifier {

  final PatientRepository _patientRepository;

  ReportsProvider({
    required PatientRepository patientRepository,
  }) : _patientRepository = patientRepository;


  ApiStatus _apiStatus = ApiStatus.initial;
  ApiStatus get apiStatus => _apiStatus;

  List<String> _completedActivities = [];
  List<String> _incompleteActivities = [];
  List<String> _regressions = [];

  List<String> get completedActivities => _completedActivities;
  List<String> get incompleteActivities => _incompleteActivities;
  List<String> get regressions => _regressions;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    getReports();
  }


  Future<void> getReports() async {
    try {
      _apiStatus = ApiStatus.loading;
      notifyListeners();

      final result = await _patientRepository.getReports(date: selectedDate);

      if (result is ActionResultSuccess) {
        _apiStatus = ApiStatus.success;
        _completedActivities = result.data.$1;
        _incompleteActivities = result.data.$2;
        _regressions = result.data.$3;
      } else {
        _apiStatus = ApiStatus.failure;
      }

      notifyListeners();
    } catch(e) {
      _apiStatus = ApiStatus.failure;
      notifyListeners();
    }
  }

}
