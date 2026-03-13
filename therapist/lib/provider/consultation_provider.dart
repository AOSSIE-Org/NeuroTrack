import 'package:flutter/foundation.dart';
import 'package:therapist/core/repository/consultation/consultation_repository.dart';
import 'package:therapist/core/result/result.dart';
import 'package:therapist/core/utils/api_status_enum.dart';
import 'package:therapist/model/consultation/consultation_request_model.dart';

class ConsultationProvider extends ChangeNotifier {
  final ConsultationRepository _consultationRepository;
  List<ConsultationRequestModel> _consultationRequests = [];
  bool _isLoading = false;
  String? _error;

  // Add a default empty list for pendingRequests
  List<ConsultationRequestModel> get pendingRequests => 
    _consultationRequests.where((req) => req.status == 'pending').toList();

  ConsultationProvider(this._consultationRepository);

  List<ConsultationRequestModel> get consultationRequests => _consultationRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ApiStatus _sessionUpdateStatus = ApiStatus.initial;
  ApiStatus get sessionUpdateStatus => _sessionUpdateStatus; 

  Future<void> fetchConsultationRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _consultationRepository.fetchConsultationRequests();
      
      if (result is ActionResultSuccess) {
        _consultationRequests = result.data as List<ConsultationRequestModel>;
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
  List<ConsultationRequestModel> get acceptedRequests => 
      _consultationRequests.where((req) => req.status == 'accepted').toList();
      
  List<ConsultationRequestModel> get declinedRequests => 
      _consultationRequests.where((req) => req.status == 'declined').toList();

  void updateConsultationRequest(String sessionId, String status, String? reason) async {
    _sessionUpdateStatus = ApiStatus.loading;
    notifyListeners();

    final result = await _consultationRepository.updateRequestStatus(
      requestId: sessionId,
      status: status,
      reason: reason
    );

    if (result is ActionResultSuccess) {
      _sessionUpdateStatus = ApiStatus.success;
      notifyListeners();
    } else if (result is ActionResultFailure) {
      _sessionUpdateStatus = ApiStatus.failure;
      notifyListeners();
    }
  }

  void resetSessionUpdateStatus() {
    _sessionUpdateStatus = ApiStatus.initial;
    notifyListeners();
  }
}