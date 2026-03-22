import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:therapist/core/entities/consultation/consultation_request_entity.dart';
import 'package:therapist/model/consultation/consultation_request_model.dart';
import 'package:therapist/provider/consultation_provider.dart';

class ConsultationRequestDetailScreen extends StatefulWidget {
  final ConsultationRequestModel request;

  const ConsultationRequestDetailScreen({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  State<ConsultationRequestDetailScreen> createState() =>
      _ConsultationRequestDetailScreenState();
}

class _ConsultationRequestDetailScreenState
    extends State<ConsultationRequestDetailScreen> {
  final TextEditingController _declineReasonController = TextEditingController();
  final DateFormat dateFormat = DateFormat('EEEE, MMM d, yyyy • h:mm a');
  bool _isAssessmentExpanded = false;
  
  // Mock assessment response data - in a real app this would come from the request
  final Map<String, String> _assessmentResponses = {
    'How often do you feel down, depressed, or hopeless?': 'Several days',
    'Trouble falling or staying asleep?': 'More than half the days',
    'Feeling tired or having little energy?': 'Nearly every day',
    'Poor appetite or overeating?': 'Several days',
    'Feeling bad about yourself?': 'More than half the days',
    'Trouble concentrating?': 'Several days',
    'Moving or speaking slowly?': 'Not at all',
    'Thoughts of self-harm?': 'Not at all',
  };

  @override
  void dispose() {
    _declineReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Request from ${widget.request.patientName}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF6A1B9A), // Deep purple
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientInfoSection(),
                    const SizedBox(height: 16),
                    _buildAssessmentSection(),
                    const SizedBox(height: 16),
                    _buildCollapsibleAssessmentResponses(),
                    const SizedBox(height: 16),
                    _buildSelectedTimeSection(),
                    // if (widget.request.notes != null && widget.request.notes!.isNotEmpty)
                    //   _buildNotesSection(),
                    const SizedBox(height: 80), // Space for bottom buttons
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6A1B9A).withOpacity(0.05),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF6A1B9A).withOpacity(0.15),
            child: Text(
              widget.request.patientName[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A), // Deep purple
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.request.patientName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Request date: ${DateFormat('MMM d, yyyy').format(DateTime.parse(widget.request.timestamp!))}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Assessment Overview'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildDetailRow(
                //   'Type',
                //   widget.request.assessmentType,
                //   Icons.assessment,
                // ),
                // const Divider(height: 20),
                // _buildDetailRow(
                //   'Summary',
                //   widget.request.assessmentSummary,
                //   Icons.summarize,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleAssessmentResponses() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isAssessmentExpanded = !_isAssessmentExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6A1B9A).withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(_isAssessmentExpanded ? 0 : 12),
                  bottomRight: Radius.circular(_isAssessmentExpanded ? 0 : 12),
                ),
                border: Border.all(
                  color: const Color(0xFF6A1B9A).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.question_answer,
                    color: const Color(0xFF6A1B9A).withOpacity(0.7),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Assessment Responses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                  ),
                  Icon(
                    _isAssessmentExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF6A1B9A),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isAssessmentExpanded ? null : 0,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border.all(
                  color: const Color(0xFF6A1B9A).withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _assessmentResponses.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getResponseColor(entry.value),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        if (entry != _assessmentResponses.entries.last)
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Divider(height: 1),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get color based on response severity
  Color _getResponseColor(String response) {
    switch (response) {
      case 'Not at all':
        return Colors.green.shade300; // Lighter green
      case 'Several days':
        return Colors.amber.shade300; // Lighter amber
      case 'More than half the days':
        return Colors.orange.shade300; // Lighter orange
      case 'Nearly every day':
        return Colors.red.shade300; // Lighter red
      default:
        return Colors.grey.shade300; // Lighter grey
    }
  }

  Widget _buildSelectedTimeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Selected Time Slot'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF6A1B9A).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.event_available,
                  color: Color(0xFF6A1B9A),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient selected:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   dateFormat.format(widget.request.proposedTimes[0]),
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //     color: Color(0xFF6A1B9A),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showDeclineDialog(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red[700],
                side: BorderSide(color: Colors.red[700]!.withOpacity(0.7)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Decline',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showAcceptDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Accept',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6A1B9A),
      ),
    );
  }

  void _showAcceptDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Consultation',
          style: TextStyle(color: const Color(0xFF6A1B9A).withOpacity(0.9)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You are about to accept this consultation request for:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6A1B9A).withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF6A1B9A).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: const Color(0xFF6A1B9A).withOpacity(0.8),
                  ),
                  const SizedBox(width: 12),
                  // Expanded(
                  //   child: Text(
                  //     dateFormat.format(widget.request.proposedTimes[0]),
                  //     style: const TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Provider.of<ConsultationProvider>(context, listen: false)
              //     .updateRequestStatus(
              //         widget.request.id, 'accepted', widget.request.proposedTimes[0]);
              // Navigator.pop(context); // Close dialog
              // Navigator.pop(context); // Go back to list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showDeclineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Decline Consultation',
          style: TextStyle(color: Colors.red[400]),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for declining:'),
            const SizedBox(height: 16),
            TextField(
              controller: _declineReasonController,
              decoration: InputDecoration(
                hintText: 'Reason for declining',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red[400]!),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_declineReasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for declining'),
                  ),
                );
                return;
              }
              
              // Provider.of<ConsultationProvider>(context, listen: false)
              //     .updateRequestStatus(
              //         widget.request.id, 'declined', null, 
              //         notes: _declineReasonController.text);
              // Navigator.pop(context); // Close dialog
              // Navigator.pop(context); // Go back to list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}