import 'package:flutter/material.dart';
import 'package:therapist/core/core.dart';
import 'package:therapist/model/model.dart';

enum SaveTherapyStatus {
  initial,
  loading,
  success,
  failure,
}

extension SaveTherapyStatusX on SaveTherapyStatus {
  bool get isInitial => this == SaveTherapyStatus.initial;
  bool get isLoading => this == SaveTherapyStatus.loading;
  bool get isSuccess => this == SaveTherapyStatus.success;
  bool get isFailure => this == SaveTherapyStatus.failure;
}

class TherapyProvider extends ChangeNotifier {

  TherapyProvider({
    required TherapyRepository therapyRepository,
  }) : _therapyRepository = therapyRepository;

  final TherapyRepository _therapyRepository;

  String? _patientId;
  String? get patientId => _patientId;

  List<TherapyTypeModel> _therapyTypes = [];
  List<TherapyTypeModel> get therapyTypes => _therapyTypes;

  String? _selectedTherapyType;
  String? get selectedTherapyType => _selectedTherapyType;

  DateTime? _selectedDateTime;
  DateTime? get selectedDateTime => _selectedDateTime;

  List<TherapyModel> _therapyGoals = [];
  List<TherapyModel> get therapyGoals => _therapyGoals;

  List<TherapyModel> _therapyObservations = [];
  List<TherapyModel> get therapyObservations => _therapyObservations;

  List<TherapyModel> _therapyRegressions = [];
  List<TherapyModel> get therapyRegressions => _therapyRegressions;

  List<TherapyModel> _therapyActivities = [];
  List<TherapyModel> get therapyActivities => _therapyActivities;

  List<TherapyModel> _selectedTherapyGoals = [];
  List<TherapyModel> get selectedTherapyGoals => _selectedTherapyGoals;

  List<TherapyModel> _selectedTherapyObservations = [];
  List<TherapyModel> get selectedTherapyObservations => _selectedTherapyObservations;

  List<TherapyModel> _selectedTherapyRegressions = [];
  List<TherapyModel> get selectedTherapyRegressions => _selectedTherapyRegressions;

  List<TherapyModel> _selectedTherapyActivities = [];
  List<TherapyModel> get selectedTherapyActivities => _selectedTherapyActivities;

  SaveTherapyStatus _saveTherapyStatus = SaveTherapyStatus.initial;
  SaveTherapyStatus get saveTherapyStatus => _saveTherapyStatus;

  String _saveTherapyErrorMessage = '';
  String get saveTherapyErrorMessage => _saveTherapyErrorMessage;

  void getThearpyType() async {
    final ActionResult result = await _therapyRepository.getTherapyTypes();
    if(result is ActionResultSuccess) {
      _therapyTypes = result.data;
      notifyListeners();
    } else {
      _therapyTypes = [];
      notifyListeners();
    }
  }

  set setPatientId(String patientId) {
    _patientId = patientId;
    notifyListeners();
  }

  set setSelectedTherapyType(String therapyType) {
    _selectedTherapyType = therapyType;
    _selectedTherapyActivities = [];
    _selectedTherapyGoals = [];
    _selectedTherapyObservations = [];
    _selectedTherapyRegressions = [];
    notifyListeners();
  }

  setSelectedDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  String _getTherapyIdFromSelectedTherapy() {
    final therapyType = _therapyTypes.firstWhere((element) => element.name == _selectedTherapyType);
    return therapyType.therapyId;
  }

  void addTherapyGoals(String goal) async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    await _therapyRepository.addTherapyGoals(therapyId,goal);
    notifyListeners();
  }

  void addTherapyObservations(String observation) async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    await _therapyRepository.addTherapyObservations(therapyId, observation);
    notifyListeners();
  }

  void addTherapyRegressions(String regression) async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    await _therapyRepository.addTherapyRegressions(therapyId, regression);
  }

  void addTherapyActivities(String activity) async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    await _therapyRepository.addTherapyActivities(therapyId, activity);
  }

  void getTherapyGoals() async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    final ActionResult result = await _therapyRepository.getAllGoals(therapyId);
    if(result is ActionResultSuccess) {
      _therapyGoals = result.data;
      notifyListeners();
    } else {
      _therapyGoals = [];
      notifyListeners();
    }
  }

  void getTherapyObservations() async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    final ActionResult result = await _therapyRepository.getAllObservations(therapyId);
    if(result is ActionResultSuccess) {
      _therapyObservations = result.data;
      notifyListeners();
    } else {
      _therapyObservations = [];
      notifyListeners();
    }
  }

  void getTherapyRegressions() async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    final ActionResult result = await _therapyRepository.getAllRegressions(therapyId);
    if(result is ActionResultSuccess) {
      _therapyRegressions = result.data;
      notifyListeners();
    } else {
      _therapyRegressions = [];
      notifyListeners();
    }
  }

  void getTherapyActivities() async {
    final therapyId = _getTherapyIdFromSelectedTherapy();
    final ActionResult result = await _therapyRepository.getAllActivities(therapyId);
    if(result is ActionResultSuccess) {
      _therapyActivities = result.data;
      notifyListeners();
    } else {
      _therapyActivities = [];
      notifyListeners();
    }
  }

  void resetTherapyData() {
    _therapyGoals = [];
    _therapyObservations = [];
    _therapyRegressions = [];
    _therapyActivities = [];
    notifyListeners();
  }

  void addToSelectedGoals(TherapyModel therapyModel) {
    _selectedTherapyGoals.add(therapyModel);
    notifyListeners();
  }

  void removeFromSelectedGoals(TherapyModel therapyModel) {
    _selectedTherapyGoals.removeWhere((element) => element.id == therapyModel.id);
    notifyListeners();
  }

  void addToSelectedObservations(TherapyModel therapyModel) {
    _selectedTherapyObservations.add(therapyModel);
    notifyListeners();
  }
  
  void removeFromSelectedObservations(TherapyModel therapyModel) {
    _selectedTherapyObservations.removeWhere((element) => element.id == therapyModel.id);
    notifyListeners();
  }

  void addToSelectedRegressions(TherapyModel therapyModel) {
    _selectedTherapyRegressions.add(therapyModel);
    notifyListeners();
  }

  void removeFromSelectedRegressions(TherapyModel therapyModel) {
    _selectedTherapyRegressions.removeWhere((element) => element.id == therapyModel.id);
    notifyListeners();
  }

  void addToSelectedActivities(TherapyModel therapyModel) {
    _selectedTherapyActivities.add(therapyModel);
    notifyListeners();
  }

  void removeFromSelectedActivities(TherapyModel therapyModel) {
    _selectedTherapyActivities.removeWhere((element) => element.id == therapyModel.id);
    notifyListeners();
  }

  void saveTherapyDetails() async {
    _saveTherapyStatus = SaveTherapyStatus.loading;
    final therapyGoalModel = TherapyGoalModel(
      performedOn: _selectedDateTime ?? DateTime.now(),
      therapyTypeId: _getTherapyIdFromSelectedTherapy(),
      goals: _selectedTherapyGoals,
      observations: _selectedTherapyObservations,
      regressions: _selectedTherapyRegressions,
      activities: _selectedTherapyActivities,
    );

    final ActionResult result = await _therapyRepository.saveTherapyGoals(therapyGoalModel.toEntity());

    if(result is ActionResultSuccess) {
      _saveTherapyStatus = SaveTherapyStatus.success;
      _saveTherapyErrorMessage = '';
      notifyListeners();
    } else {
      _saveTherapyStatus = SaveTherapyStatus.failure;
      _saveTherapyErrorMessage = result.errorMessage.toString();
      notifyListeners();
    }
  }

  void resetAllFields() {
    _patientId = null;
    _therapyTypes = [];
    _selectedTherapyType = null;
    _selectedDateTime = null;
    _therapyGoals = [];
    _therapyObservations = [];
    _therapyRegressions = [];
    _therapyActivities = [];
    _selectedTherapyGoals = [];
    _selectedTherapyObservations = [];
    _selectedTherapyRegressions = [];
    _selectedTherapyActivities = [];
    _saveTherapyStatus = SaveTherapyStatus.initial;
    _saveTherapyErrorMessage = '';
    notifyListeners();
  }



}