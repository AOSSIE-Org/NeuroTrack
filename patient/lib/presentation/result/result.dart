import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:patient/presentation/result/book_appointment.dart';
import 'package:patient/presentation/result/widgets/buildresult.dart';  // Import the widgets file

// Initialize Supabase Client
final supabase = Supabase.instance.client;

class ResultScreen extends StatefulWidget {
  final List<Map<String, String>> responses;
  final String patientId;

  const ResultScreen({
    Key? key,
    required this.responses,
    required this.patientId,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  String analysisResult = "";
  bool isLoading = true;
  int score = 80; // This would come from your analysis or be calculated
  late AnimationController _animationController;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();

  // Enhanced therapist data with more details
  final List<Map<String, dynamic>> therapists = [
    {
      "name": "Dr. John Doe",
      "specialisation": "Neurologist",
      "avatar_url": "https://via.placeholder.com/150",
      "experience": "10 years",
      "rating": 4.8,
      "availability": "Today at 14:30",
      "hospital": "Central Medical Center",
      "consultationFee": "\$120"
    },
    {
      "name": "Dr. Jane Smith",
      "specialisation": "Psychiatrist",
      "avatar_url": "https://via.placeholder.com/150",
      "experience": "8 years",
      "rating": 4.7,
      "availability": "Tomorrow at 10:00",
      "hospital": "Mind Wellness Clinic",
      "consultationFee": "\$150"
    },
    {
      "name": "Dr. Emily Brown",
      "specialisation": "Child Psychologist",
      "avatar_url": "https://via.placeholder.com/150",
      "experience": "12 years",
      "rating": 4.9,
      "availability": "Today at 16:45",
      "hospital": "Children's Development Institute",
      "consultationFee": "\$135"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Setup animation for score indicator
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(begin: 0, end: score / 100).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void bookAppointment(Map<String, dynamic> therapist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TherapistDetailsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Your Assessment Results", 
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          )
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.green),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: isLoading
          ? ResultWidgets.buildLoadingView()
          : _buildResultsView(),
    );
  }

  Widget _buildResultsView() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                // Score Visualization
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Circular progress background
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 15,
                              color: Colors.grey.shade200,
                            ),
                          ),
                          // Animated progress
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: _animation.value,
                              strokeWidth: 15,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ResultWidgets.getScoreColor((_animation.value * 100).toInt()),
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          // Inner circle and score
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(_animation.value * 100).toInt()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 54,
                                    color: ResultWidgets.getScoreColor((_animation.value * 100).toInt()),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: ResultWidgets.getScoreColor((_animation.value * 100).toInt()).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "in the top 5%",
                                    style: TextStyle(
                                      color: ResultWidgets.getScoreColor((_animation.value * 100).toInt()),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                // Status indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ResultWidgets.buildStatusItem("Attention", "Good", Colors.green),
                    ResultWidgets.buildStatusItem("Focus", "Great", Colors.blue),
                    ResultWidgets.buildStatusItem("Social", "Average", Colors.orange),
                  ],
                ),
                SizedBox(height: 10),
                // Brief summary
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Based on your responses, we've created personalized recommendations to help improve cognitive skills and daily functioning.",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Recommended Doctors Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommended Specialists",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Based on your assessment",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to all doctors
                  },
                  icon: Icon(Icons.people_outline, size: 16, color: Colors.green),
                  label: Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Doctor List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final therapist = therapists[index];
              return ResultWidgets.buildTherapistCard(
                therapist, 
                () => bookAppointment(therapist)
              );
            },
            childCount: therapists.length,
          ),
        ),
      ],
    );
  }  
}