import 'package:flutter/material.dart';
import 'package:patient/Core/utils/assets.dart';

class TherapyDetailsCard extends StatelessWidget {
  const TherapyDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(AssetsData.home), 
                  radius: 24,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Therapist Name", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Neurologist", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildDetailRow("Therapy", "Hassnaa Mohamed"),
            _buildDetailRow("Done at", "05:30 PM"),
            _buildDetailRow("Therapy Mode", "Offline"),
            _buildDetailRow("Duration", "1 hour 20 mins"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
