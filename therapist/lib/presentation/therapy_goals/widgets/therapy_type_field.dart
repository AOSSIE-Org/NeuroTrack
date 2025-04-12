import 'package:flutter/material.dart';
import 'package:therapist/model/model.dart';

class TherapyTypeField extends StatelessWidget {
  const TherapyTypeField({
    super.key,
    required this.therapyType,
    required this.onChanged,
    this.selectedTherapyType,
  });

  final List<TherapyTypeModel> therapyType;
  final String? selectedTherapyType;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 53,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedTherapyType,
        items: [
          for (final type in therapyType)
            DropdownMenuItem(
              value: type.name,
              child: Text(
                type.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff121417),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
        onChanged: onChanged,
        hint: const Text(
          'Select Therapy Type',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff121417),
            fontWeight: FontWeight.w500,
          ),
        ),
        underline: const SizedBox.shrink(),
        icon: Image.asset('assets/arrow_down.png'),
        isExpanded: true,
      ),
    );
  }
}