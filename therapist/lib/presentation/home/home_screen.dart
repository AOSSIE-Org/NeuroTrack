import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapist/core/utils/api_status_enum.dart';
import 'package:therapist/presentation/chatbot/chatbot_screen.dart';
import 'package:therapist/presentation/consultation/consultation_requests_screen.dart';
import 'package:therapist/presentation/home/widgets/pending_request_view.dart';
import 'package:therapist/provider/consultation_provider.dart';
import 'package:therapist/provider/therapist_provider.dart';
import 'widgets/stats_card.dart';
import 'widgets/patient_card.dart';
import '../session/session_screen.dart';
import '../profile/profile_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late Timer _refreshTimer;

  final List<Widget> _screens = [
    const HomeContent(),
    const SessionScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConsultationProvider>(context, listen: false)
          .fetchConsultationRequests();
      Provider.of<TherapistDataProvider>(context, listen: false)
          .fetchPatientsMappedToTherapist();
    });

    _refreshTimer = Timer.periodic(const Duration(minutes: 3), (_) {
      if (mounted) {
        Provider.of<ConsultationProvider>(context, listen: false)
            .fetchConsultationRequests();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 0 
        ? Consumer<ConsultationProvider>(
            builder: (context, provider, _) {
              final pendingCount = provider.pendingRequests.length;
              if (pendingCount > 0) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConsultationRequestsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: Text('$pendingCount New Requests'),
                  backgroundColor: Colors.purple,
                );
              }
              return const SizedBox.shrink();
            },
          )
        : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/Calendar.png')),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/Profile.png')),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFFFAFAFA), 
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Text(
              'Therapist',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          // Add notification icon with badge
          Consumer<ConsultationProvider>(
            builder: (context, provider, _) {
              final pendingCount = provider.pendingRequests.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConsultationRequestsScreen(),
                        ),
                      );
                    },
                  ),
                  if (pendingCount > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          pendingCount > 9 ? '9+' : pendingCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
           GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatbotScreen()),
              );
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset('assets/chatbot.png'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatsCard(
                    imagePath: 'assets/icon1.png',
                    backgroundColor: Color(0xFFFEE8E8),
                    label: 'Patients',
                    value: '02',
                  ),
                  StatsCard(
                    imagePath: 'assets/icon2.png',
                    backgroundColor: Color(0xFFF1E8FE),
                    label: 'Sessions',
                    value: '20',
                  ),
                  StatsCard(
                    imagePath: 'assets/icon3.png',
                    backgroundColor: Color(0xFFE8FEF0),
                    label: 'Therapies',
                    value: '13',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            //_buildConsultationRequestSection(context),
          //  _buildConsultationRequestSection(context),
           Consumer<TherapistDataProvider>(
            builder: (context, provider, _) {
              if(provider.patientsStatus == ApiStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if(provider.patientsStatus == ApiStatus.failure) {
                return const Center(child: Text('No patients found'));
              } else if(provider.patientsStatus == ApiStatus.success) {
                if(provider.patients.isEmpty) { 
                  return const Center(child: Text('No patients found'));
                } else {
                  return Column(
                    children: provider.patients.map((patient) => PatientCard(
                    name: patient.patientName,
                    id: patient.patientId,
                    phone: patient.phoneNo,
                    email: patient.email,
                    package: '-',
                    duration: '-',
                    imagePath: 'assets/abdul.png',
                  )).toList(),
                  );
                }
              }
              return const SizedBox.shrink();
            },
           ),
          ],
        ),
      ),
    );
  }
}
