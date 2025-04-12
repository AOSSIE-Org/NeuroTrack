import 'package:flutter/material.dart';
import 'package:therapist/presentation/therapy_goals/widgets/save_therapy_button.dart';
import 'package:therapist/presentation/therapy_goals/widgets/therapy_container.dart';

class AddNewBottomSheet extends StatelessWidget {
  
  AddNewBottomSheet({
    super.key,
    required this.therapyDetailsType,
    required this.onSumbit,
  });

  final TherapyDetailsType therapyDetailsType;
  final Function(String) onSumbit;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New ${therapyDetailsType.value}',
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
            hintText: 'Enter ${therapyDetailsType.value}',
            fillColor: Colors.blue,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade600)),
            errorStyle: const TextStyle(color: Colors.red),
          ),
          ),
          const SizedBox(height: 20),
          SaveTherapyButton(
            text: 'Add ${therapyDetailsType.value}',
            onPressed: () => onSumbit(_controller.text),
          )

        ],
      ),
    );
  }
}
