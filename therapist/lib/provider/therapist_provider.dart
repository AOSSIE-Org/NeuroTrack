import 'package:flutter/material.dart';
import 'package:therapist/core/entities/auth_entities/therapist_personal_info_entity.dart';
import 'package:therapist/core/models/profession_model.dart';
import 'package:therapist/core/repository/therapist/therapist_repository.dart';
import 'package:therapist/core/result/result.dart';

class TherapistDataProvider extends ChangeNotifier {
  final TherapistRepository _therapistRepository;

  TherapistDataProvider({
    required TherapistRepository therapistRepository,
  }) : _therapistRepository = therapistRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Professions
  List<ProfessionModel> _professions = [];
  List<ProfessionModel> get professions => _professions;

  List<DropdownMenuEntry<int>> get professionDropdownItems {
    return _professions
        .map((profession) => DropdownMenuEntry<int>(
              value: profession.id,
              label: profession.name,
            ))
        .toList();
  }

  // Regulatory Bodies
  List<RegulatoryBodyModel> _regulatoryBodies = [];
  List<RegulatoryBodyModel> get regulatoryBodies => _regulatoryBodies;

  List<DropdownMenuEntry<String>> get regulatoryBodyDropdownItems {
    return _regulatoryBodies
        .map((body) => DropdownMenuEntry<String>(
              value: body.name,
              label: body.name,
            ))
        .toList();
  }

  // Specializations
  List<SpecializationModel> _specializations = [];
  List<SpecializationModel> get specializations => _specializations;

  List<DropdownMenuEntry<String>> get specializationDropdownItems {
    return _specializations
        .map((specialization) => DropdownMenuEntry<String>(
              value: specialization.name,
              label: specialization.name,
            ))
        .toList();
  }

  // Therapies
  List<TherapyModel> _therapies = [];
  List<String> get therapies => _therapies.map((therapy) => therapy.name).toList();

  // Selected values
  int? _selectedProfessionId;
  int? get selectedProfessionId => _selectedProfessionId;

  String? _selectedProfessionName;
  String? get selectedProfessionName => _selectedProfessionName;

  String? _selectedRegulatoryBody;
  String? get selectedRegulatoryBody => _selectedRegulatoryBody;

  String? _selectedSpecialization;
  String? get selectedSpecialization => _selectedSpecialization;

  // Fetch professions
  Future<void> fetchProfessions() async {
    _isLoading = true;
    notifyListeners();

    final result = await _therapistRepository.fetchProfessions();

    if (result is ActionResultSuccess) {
      _professions = result.data;
      _errorMessage = '';
    } else if (result is ActionResultFailure) {
      _errorMessage = result.errorMessage!;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch regulatory bodies based on selected profession
  Future<void> fetchRegulatoryBodies(int professionId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _therapistRepository.fetchRegulatoryBodies(professionId);

    if (result is ActionResultSuccess) {
      _regulatoryBodies = result.data;
      _errorMessage = '';
    } else if (result is ActionResultFailure) {
      _errorMessage = result.errorMessage!;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch specializations based on selected profession
  Future<void> fetchSpecializations(int professionId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _therapistRepository.fetchSpecializations(professionId);

    if (result is ActionResultSuccess) {
      _specializations = result.data;
      _errorMessage = '';
    } else if (result is ActionResultFailure) {
      _errorMessage = result.errorMessage ?? '';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch therapies based on selected profession
  Future<void> fetchTherapies(int professionId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _therapistRepository.fetchTherapies(professionId);

    if (result is ActionResultSuccess) {
      _therapies = result.data;
      _errorMessage = '';
    } else if (result is ActionResultFailure) {
      _errorMessage = result.errorMessage!;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Set selected profession and fetch related data
  Future<void> setSelectedProfession(int professionId, String professionName) async {
    _selectedProfessionId = professionId;
    _selectedProfessionName = professionName;
    
    // Reset related selections
    _selectedRegulatoryBody = null;
    _selectedSpecialization = null;
    
    // Fetch related data
    await fetchRegulatoryBodies(professionId);
    await fetchSpecializations(professionId);
    await fetchTherapies(professionId);
    
    notifyListeners();
  }

  // Set selected regulatory body
  void setSelectedRegulatoryBody(String regulatoryBody) {
    _selectedRegulatoryBody = regulatoryBody;
    notifyListeners();
  }

  // Set selected specialization
  void setSelectedSpecialization(String specialization) {
    _selectedSpecialization = specialization;
    notifyListeners();
  }

  // Clear selections
  void clearSelections() {
    _selectedProfessionId = null;
    _selectedProfessionName = null;
    _selectedRegulatoryBody = null;
    _selectedSpecialization = null;
    notifyListeners();
  }
}
