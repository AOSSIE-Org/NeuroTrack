import 'package:flutter/material.dart';
import 'package:therapist/core/models/profession_model.dart';
import 'package:therapist/core/repository/therapist/therapist_repository.dart';
import 'package:therapist/core/result/result.dart';
import 'package:therapist/core/utils/api_status_enum.dart';
import 'package:therapist/model/therapist_models/therapist_patient_details_model.dart';

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
  List<ProfessionModel> _professions = [
    ProfessionModel(id: 1, name: 'Neuropsychologist'),
    ProfessionModel(id: 2, name: 'Neurologist'),
    ProfessionModel(id: 3, name: 'Neuropsychiatrist'),
    ProfessionModel(id: 4, name: 'Child Specialist'),
    ProfessionModel(id: 5, name: 'Pediatrician'),
  ];
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
  List<RegulatoryBodyModel> _regulatoryBodies = [
    RegulatoryBodyModel(id: 1, name: 'CDSCO', professionId: 1),
    RegulatoryBodyModel(id: 2, name: 'NMC', professionId: 2),
    RegulatoryBodyModel(id: 3, name: 'TGA', professionId: 3),
  ];
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
  List<SpecializationModel> _specializations = [
    SpecializationModel(id: 1, name: 'Child Specialist', professionId: 4),
    SpecializationModel(id: 2, name: 'Pediatrician', professionId: 5),
    SpecializationModel(id: 3, name: 'Neuropsychologist', professionId: 1),
    SpecializationModel(id: 4, name: 'Neurologist', professionId: 2),
    SpecializationModel(id: 5, name: 'Neuropsychiatrist', professionId: 3),
    SpecializationModel(id: 6, name: 'Child Specialist', professionId: 4),
    SpecializationModel(id: 7, name: 'Pediatrician', professionId: 5),
  ];
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

  List<TherapistPatientDetailsModel> _patients = [];
  List<TherapistPatientDetailsModel> get patients => _patients;
  ApiStatus _patientsStatus = ApiStatus.initial;
  ApiStatus get patientsStatus => _patientsStatus;

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

  Future<void> fetchPatientsMappedToTherapist() async {
    _patientsStatus = ApiStatus.loading;
    notifyListeners();

    final result = await _therapistRepository.fetchPatientsMappedToTherapist();

    if(result is ActionResultSuccess) {
      _patients = result.data;
      _patientsStatus = ApiStatus.success;
    } else if(result is ActionResultFailure) {
      _patients = <TherapistPatientDetailsModel>[];
      _patientsStatus = ApiStatus.failure;
      _errorMessage = result.errorMessage!;
    }
    notifyListeners();
  }
}
