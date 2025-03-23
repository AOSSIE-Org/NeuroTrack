import 'package:flutter/material.dart';
import '../../../provider/activity_provider.dart';

class ActivitySetCard extends StatefulWidget {
  final String title;
  final bool isExpanded;
  final bool isActive;
  final List<String> activities;
  final String? repeatInfo;
  final String? additionalInfo;
  final VoidCallback onExpandToggle;
  final Function(bool) onActiveToggle;
  final Function(int, bool)? onDaySelected;
  final List<bool> selectedDays;

  const ActivitySetCard({
    Key? key,
    required this.title,
    required this.isExpanded,
    required this.isActive,
    required this.activities,
    this.repeatInfo,
    this.additionalInfo,
    required this.onExpandToggle,
    required this.onActiveToggle,
    this.onDaySelected,
    required this.selectedDays,
  }) : super(key: key);

  @override
  _ActivitySetCardState createState() => _ActivitySetCardState();
}

class _ActivitySetCardState extends State<ActivitySetCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: widget.onExpandToggle,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (!widget.isExpanded) ...[
            // Collapsed view
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show first two activities
                  ...widget.activities
                      .take(2)
                      .map((activity) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    activity,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),

                  // Additional info
                  if (widget.additionalInfo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        widget.additionalInfo!,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),

                  // Repeat info and toggle
                  if (widget.repeatInfo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.repeatInfo!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                          Switch(
                            value: widget.isActive,
                            onChanged: widget.onActiveToggle,
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFFCB6CE6),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            // Expanded view
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activities
                  ...widget.activities
                      .map((activity) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style: TextStyle(fontSize: 14)),
                                Expanded(
                                  child: Text(
                                    activity,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),

                  if (widget.additionalInfo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        widget.additionalInfo!,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),

                  // Repeat info
                  if (widget.repeatInfo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.repeatInfo!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                          Switch(
                            value: widget.isActive,
                            onChanged: widget.onActiveToggle,
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xFFCB6CE6),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),

                  // Day selector
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          List.generate(7, (index) => _buildDayCircle(index)),
                    ),
                  ),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        _buildActionButton(Icons.calendar_today, 'Schedule'),
                        const SizedBox(height: 12),
                        _buildActionButton(Icons.add_circle_outline,
                            'Add / Remove Activities'),
                        const SizedBox(height: 12),
                        _buildActionButton(Icons.delete_outline, 'Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDayCircle(int dayIndex) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return GestureDetector(
      onTap: () {
        if (widget.onDaySelected != null) {
          widget.onDaySelected!(dayIndex, !widget.selectedDays[dayIndex]);
        }
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              widget.selectedDays[dayIndex] ? const Color(0xFFCB6CE6) : Colors.white,
          border: Border.all(
            color: widget.selectedDays[dayIndex]
                ? const Color(0xFFCB6CE6)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            days[dayIndex],
            style: TextStyle(
              color: widget.selectedDays[dayIndex] ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}