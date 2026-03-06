import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/presentation/assessments/assessments_list_screen.dart';
import 'package:patient/presentation/auth/auth_screen.dart';
import 'package:patient/presentation/auth/consultation_request_screen.dart';
import 'package:patient/presentation/auth/personal_details_screen.dart';
import 'package:patient/presentation/home/home_screen.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // User already has an active session — resolve their onboarding status
      await context.read<AuthProvider>().checkIfPatientExists();
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();
      final status = authProvider.authNavigationStatus;

      Widget nextScreen;
      if (status.isHome) {
        final userName = session.user.userMetadata?['full_name'];
        nextScreen = HomeScreen(userName: userName ?? 'User');
      } else if (status.isPersonalDetails) {
        nextScreen = const PersonalDetailsScreen();
      } else if (status.isAssessment) {
        nextScreen = const AssessmentsListScreen();
      } else if (status.isInitialConsultation) {
        nextScreen = const ConsultationRequestScreen();
      } else {
        // error or unknown — fall back to sign-in with feedback
        if (status.isError) {
          SnackbarService.showError('Something went wrong. Please sign in again.');
        }
        nextScreen = const AuthScreen();
      }

      authProvider.resetNavigationStatus();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => nextScreen),
      );
      return;
    }

    // No session — go to sign-in
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.logos.lgNeurotrack.svg(width: 100),
            const SizedBox(height: 20),
            Text(
              "Neurotrack",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
