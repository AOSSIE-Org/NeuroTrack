import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  // Mock data for sessions - replace with actual data fetching logic
  List<Map<String, dynamic>> _sessions = [
    {
      'patientName': 'John Doe',
      'patientId': 'P001',
      'phone': '+1 234 567 8900',
      'therapyName': 'Cognitive Behavioral Therapy',
      'therapyMode': 'In-person',
      'time': '10:00 AM',
      'duration': '60 min',
      'status': 'Pending',
    },
    {
      'patientName': 'Jane Smith',
      'patientId': 'P002',
      'phone': '+1 234 567 8901',
      'therapyName': 'Occupational Therapy',
      'therapyMode': 'Virtual',
      'time': '2:00 PM',
      'duration': '45 min',
      'status': 'Completed',
    },
    {
      'patientName': 'Alice Johnson',
      'patientId': 'P003',
      'phone': '+1 234 567 8902',
      'therapyName': 'Physical Therapy',
      'therapyMode': 'In-person',
      'time': '4:30 PM',
      'duration': '60 min',
      'status': 'Cancelled',
    },
  ];

  List<Map<String, dynamic>> get sessions => _sessions;

  List<Map<String, dynamic>> get filteredSessions {
    if (_selectedFilter == 'All') {
      return _sessions;
    } else {
      return _sessions.where((session) => session['status'] == _selectedFilter).toList();
    }
  }

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Methods to add, update, or delete sessions
  void addSession(Map<String, dynamic> session) {
    _sessions.add(session);
    notifyListeners();
  }

  void updateSession(int index, Map<String, dynamic> updatedSession) {
    if (index >= 0 && index < _sessions.length) {
      _sessions[index] = updatedSession;
      notifyListeners();
    }
  }

  void deleteSession(int index) {
    if (index >= 0 && index < _sessions.length) {
      _sessions.removeAt(index);
      notifyListeners();
    }
  }


  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}

