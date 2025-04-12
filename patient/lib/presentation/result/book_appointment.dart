import 'package:flutter/material.dart';

class TherapistDetailsScreen extends StatefulWidget {
  const TherapistDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TherapistDetailsScreen> createState() => _TherapistDetailsScreenState();
}

class _TherapistDetailsScreenState extends State<TherapistDetailsScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;

  final List<String> timeSlots = [
    "09:00 AM - 09:30 AM",
    "09:30 AM - 10:00 AM",
    "10:00 AM - 10:30 AM",
    "10:30 AM - 11:00 AM",
    "11:00 AM - 11:30 AM",
    "11:30 AM - 12:00 PM",
    "02:00 PM - 02:30 PM",
    "02:30 PM - 03:00 PM",
    "03:00 PM - 03:30 PM",
    "03:30 PM - 04:00 PM",
  ];

  final Map<String, dynamic> therapist = {
    "name": "Dr. Alex Johnson",
    "email": "alex.johnson@example.com",
    "phone": "+1 234 567 890",
    "specialisation": "Clinical Psychologist",
    "gender": "Male",
    "offered_therapies": ["Cognitive Behavioral Therapy", "Mindfulness Therapy"],
    "age": 45,
    "license": "XYZ123456",
    "regulatory_body": "American Psychological Association",
    "description": "Dr. Alex Johnson has over 20 years of experience in psychology and specializes in cognitive behavioral therapy.",
  };

  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), // Allow booking for 30 days
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlot = null; // Reset time slot when date changes
      });

      _selectTimeSlot(context);
    }
  }

  // Function to select a 30-minute time slot
  void _selectTimeSlot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: timeSlots.map((slot) {
              return ListTile(
                title: Text(slot),
                onTap: () {
                  setState(() {
                    selectedTimeSlot = slot;
                  });
                  Navigator.pop(context); // Close modal
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(therapist["name"])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/doctor_placeholder.png"),
              ),
              const SizedBox(height: 10),

              // Therapist Details Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      buildDetailRow(Icons.person, "Name", therapist["name"]),
                      buildDetailRow(Icons.email, "Email", therapist["email"]),
                      buildDetailRow(Icons.phone, "Phone", therapist["phone"]),
                      buildDetailRow(Icons.badge, "Specialisation", therapist["specialisation"]),
                      buildDetailRow(Icons.people, "Gender", therapist["gender"]),
                      buildDetailRow(Icons.healing, "Offered Therapies", therapist["offered_therapies"].join(", ")),
                      buildDetailRow(Icons.calendar_today, "Age", "${therapist["age"]} years"),
                      buildDetailRow(Icons.assignment, "License", therapist["license"]),
                      buildDetailRow(Icons.verified, "Regulatory Body", therapist["regulatory_body"]),
                      buildDetailRow(Icons.description, "Description", therapist["description"]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Selected Date & Time Display
              if (selectedDate != null)
                Text(
                  "Selected Date: ${selectedDate!.toLocal()}".split(' ')[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              if (selectedTimeSlot != null)
                Text(
                  "Selected Time: $selectedTimeSlot",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 10),

              // Select Date & Time Button
              ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: const Text("Select Date & Time"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),

              // Book Appointment Button (Only appears after selection)
              if (selectedDate != null && selectedTimeSlot != null) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement appointment booking logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Appointment booked on ${selectedDate!.toLocal()} at $selectedTimeSlot")),
                    );
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Book Appointment"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for displaying therapist details
  Widget buildDetailRow(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
