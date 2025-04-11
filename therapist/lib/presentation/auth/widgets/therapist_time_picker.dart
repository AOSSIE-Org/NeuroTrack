
import 'package:flutter/material.dart';

class TherapistTimePicker extends StatefulWidget {
  final Function(TimeOfDay start, TimeOfDay end) onTimeSelected;

  const TherapistTimePicker({super.key, required this.onTimeSelected});

  @override
  _TherapistTimePickerState createState() => _TherapistTimePickerState();
}

class _TherapistTimePickerState extends State<TherapistTimePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? errorText;

  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? (startTime ?? initialTime) : (endTime ?? initialTime),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }

        if (startTime != null && endTime != null) {
          final startMinutes = startTime!.hour * 60 + startTime!.minute;
          final endMinutes = endTime!.hour * 60 + endTime!.minute;

          if (endMinutes <= startMinutes) {
            setState(() {
              errorText = "End time must be after start time.";
            });
          } else {
            errorText = null;
            widget.onTimeSelected(startTime!, endTime!);
          }
        }
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "Select";
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Available Time", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(true),
                child: _TimeBox(label: "Start Time", value: _formatTime(startTime)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(false),
                child: _TimeBox(label: "End Time", value: _formatTime(endTime)),
              ),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(errorText!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String value;

  const _TimeBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
