import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/session_provider.dart';
import 'widgets/session_card.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Add try-catch block to handle provider not found error
    try {
      final sessionProvider = Provider.of<SessionProvider>(context);

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Schedule',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 30, // Show 30 days (1st to 30th)
                    itemBuilder: (context, index) {
                      final now = DateTime.now();
                      final firstDayOfMonth = DateTime(now.year, now.month, 1);
                      final date = firstDayOfMonth.add(Duration(days: index));

                      final isToday = date.day == now.day;
                      // final isSelected =
                      //     date.day == sessionProvider.selectedDate.day;

                      return GestureDetector(
                        onTap: () {
                          sessionProvider.setSelectedDate(date);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color:
                                isToday ? const Color(0xFFD580FF) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: !isToday
                                ? Border.all(color: Colors.grey.shade200)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              isToday ? 'Today' : date.day.toString(),
                              style: TextStyle(
                                color: isToday ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Filter tabs
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterTab(
                          context,
                          'All',
                          '12',
                          sessionProvider.selectedFilter == 'All',
                          () => sessionProvider.setSelectedFilter('All')),
                      const SizedBox(width: 8),
                      _buildFilterTab(
                          context,
                          'Pending',
                          '2',
                          sessionProvider.selectedFilter == 'Pending',
                          () => sessionProvider.setSelectedFilter('Pending')),
                      const SizedBox(width: 8),
                      _buildFilterTab(
                          context,
                          'Cancelled',
                          '1',
                          sessionProvider.selectedFilter == 'Cancelled',
                          () => sessionProvider.setSelectedFilter('Cancelled')),
                      const SizedBox(width: 8),
                      _buildFilterTab(
                          context,
                          'Completed',
                          '1',
                          sessionProvider.selectedFilter == 'Completed',
                          () => sessionProvider.setSelectedFilter('Completed')),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Session cards
                Expanded(
                  child: ListView.builder(
                    itemCount: sessionProvider.filteredSessions.length,
                    itemBuilder: (context, index) {
                      final session = sessionProvider.filteredSessions[index];

                      // Assign card color based on session status
                      Color cardColor;
                      if (session['status'] == 'Completed') {
                        cardColor = Colors.lightGreen.shade400;
                      } else if (session['status'] == 'Cancelled') {
                        cardColor = Colors.red.shade400;
                      } else {
                        cardColor = Colors.white; // Default color
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SessionCard(
                            patientName: session['patientName'],
                            patientId: session['patientId'],
                            phone: session['phone'],
                            therapyName: session['therapyName'],
                            therapyMode: session['therapyMode'],
                            time: session['time'],
                            duration: session['duration'],
                            status: session['status'],
                            cancelMessage: session.containsKey('cancelMessage')
                                ? session['cancelMessage']
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // Return a fallback UI when provider is not found
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Session data is being loaded...'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Refresh the screen when user taps the button
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SessionScreen()),
                  );
                },
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildFilterTab(BuildContext context, String text, String count,
      bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD580FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '$text ($count)',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
