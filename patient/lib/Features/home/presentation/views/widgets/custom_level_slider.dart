import 'package:flutter/material.dart';

Widget buildAutismLevelCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDFA8F6), // Purple
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Autism Level",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Slider(
                  value: 4,
                  min: 0,
                  max: 10,
                  onChanged: null, // Disabled for now
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                ),
              ),
              const Text(
                "4",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
