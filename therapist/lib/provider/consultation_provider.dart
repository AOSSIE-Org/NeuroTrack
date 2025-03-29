import 'package:flutter/foundation.dart';
import 'package:therapist/core/entities/consultation/consultation_request_entity.dart';
import 'package:therapist/core/repository/consultation/consultation_repository.dart';
import 'package:therapist/core/result/result.dart';

class ConsultationProvider extends ChangeNotifier {
  final ConsultationRepository _consultationRepository;
  List<ConsultationRequestEntity> _consultationRequests = [];
  bool _isLoading = false;
  String? _error;

  // Add a default empty list for pendingRequests
  List<ConsultationRequestEntity> get pendingRequests => 
    _consultationRequests.where((req) => req.status == 'pending').toList();

  ConsultationProvider(this._consultationRepository);

  List<ConsultationRequestEntity> get consultationRequests => _consultationRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchConsultationRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _consultationRepository.fetchConsultationRequests();
      
      if (result is ActionResultSuccess) {
        _consultationRequests = result.data as List<ConsultationRequestEntity>;
      } else if (result is ActionResultFailure) {
        _error = result.errorMessage;
        debugPrint(_error);
      }
    } catch (e) {
      _error = 'Failed to load consultation requests: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRequestStatus(
    String requestId, 
    String status, 
    DateTime? scheduledTime, 
    {String? notes}
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _consultationRepository.updateRequestStatus(
        requestId: requestId,
        status: status,
        scheduledTime: scheduledTime,
        notes: notes,
      );

      if (result is ActionResultSuccess) {
        // Refresh consultation requests after update
        await fetchConsultationRequests();
      } else if (result is ActionResultFailure) {
        _error = result.errorMessage;
        debugPrint(_error);
      }
    } catch (e) {
      _error = 'Failed to update request status: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter methods for UI convenience
  List<ConsultationRequestEntity> get acceptedRequests => 
      _consultationRequests.where((req) => req.status == 'accepted').toList();
      
  List<ConsultationRequestEntity> get declinedRequests => 
      _consultationRequests.where((req) => req.status == 'declined').toList();
}