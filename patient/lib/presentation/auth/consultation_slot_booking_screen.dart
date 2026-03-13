import 'package:flutter/material.dart';
import 'package:patient/presentation/auth/widgets/slot_booking_card.dart';

class ConsultationSlotBookingScreen extends StatelessWidget {
  const ConsultationSlotBookingScreen({
    super.key,
    required this.therapistId,
  });

  final String therapistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select a Slot,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff111847),
                  ),
              ),
              SlotBookingCard(therpistId: therapistId,)
            ],
          ),
        ),
      ),
    );
  }
}