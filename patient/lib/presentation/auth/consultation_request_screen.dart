import 'package:flutter/material.dart';
import 'package:patient/core/core.dart';
import 'package:patient/presentation/auth/widgets/consultation_request_card.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ConsultationRequestScreen extends StatefulWidget {
  const ConsultationRequestScreen({super.key});

  @override
  State<ConsultationRequestScreen> createState() => _ConsultationRequestScreenState();
}

class _ConsultationRequestScreenState extends State<ConsultationRequestScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.getAllTherapist();  
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Book a Consultation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111847),
                ),
              ),
              const SizedBox(height: 17,),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if(authProvider.apiStatus.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if(authProvider.apiStatus.isFailure) {
                    return const Center(
                      child: Text('Error fetching data'),
                    );
                  } else if(authProvider.therapistList.isEmpty) {
                    return const Center(
                      child: Text('No therapists available'),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: authProvider.therapistList.length,
                        itemBuilder: (context, index) {
                          final therapist = authProvider.therapistList[index];
                          return ConsultationRequestCard(therapistData: therapist,);
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}