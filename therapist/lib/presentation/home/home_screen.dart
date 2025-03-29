import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:therapist/presentation/consultation/consultation_request_detail_screen.dart';
import 'package:therapist/presentation/consultation/consultation_requests_screen.dart';
import 'package:therapist/provider/consultation_provider.dart';
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
            _buildConsultationRequestSection(context),
          //  _buildConsultationRequestSection(context),
            const SizedBox(height: 24),
            const PatientCard(
              name: 'Abdul Aziz',
              id: '#234312',
              phone: '+91 9845567890',
              email: 'abdul@mail.com',
              package: 'Basic',
              duration: '60 Days',
              imagePath: 'assets/abdul.png',
            ),
            const SizedBox(height: 16),
            const PatientCard(
              name: 'Rohit Kumar',
              id: '#87213',
              phone: '+91 9834564392',
              email: 'rohit@mail.com',
              package: 'Basic',
              duration: '30 Days',
              imagePath: 'assets/rohit.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationRequestSection(BuildContext context) {
    return Consumer<ConsultationProvider>(
      builder: (context, provider, _) {
        // Check if provider is initialized and has data
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (provider.error != null) {
          return Text('Error: ${provider.error}');
        }
        
        if (provider.pendingRequests.isEmpty) {
          return const SizedBox.shrink(); // Don't show section if no pending requests
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Consultations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConsultationRequestsScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 135,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.pendingRequests.take(3).length, // Show only first 3
                itemBuilder: (context, index) {
                  final request = provider.pendingRequests[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.purple.withOpacity(0.2),
                              child: Text(
                                request.patientName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.patientName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    request.assessmentType,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (_) => ConsultationRequestDetailScreen(
                              request: request,
                            ),
                            ),
                          );
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.purple),
                          ),
                          ),
                          child: const Text(
                          'Review Request',
                          style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
