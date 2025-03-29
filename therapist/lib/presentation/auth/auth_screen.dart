import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:therapist/presentation/auth/personal_details_screen.dart';
import 'package:therapist/presentation/auth/widgets/google_signin_button.dart';
import '../home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:therapist/provider/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  final supabase = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleSuccessfulAuth(session);
        });
      }
    });
  }

  Future<void> _handleSuccessfulAuth(Session session) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.checkAuthentication();
    final isNewUser = await authProvider.checkIfUserIsNew();

    final fullName = session.user.userMetadata?['full_name'];
    final email = session.user.email ?? 'Unknown User';
  
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in as ${fullName ?? email}'),
          duration: const Duration(seconds: 2),
        ),
      );
      authProvider.navigateBasedOnUserStatus(context);
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(screenWidth, screenHeight),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildPage(
                  description: "Effortlessly manage patients & enhance therapy progress.",
                  image: "assets/manage_patients.png",
                ),
                _buildPage(
                  description: "Personalized Daily Activities, Tracked Effortlessly!",
                  image: "assets/daily_activities.png",
                ),
                _buildPage(
                  description: "Track your health and therapy goals effectively.",
                  image: "assets/health_tracking.png",
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.purple,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: GoogleSignInButton(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight * 0.2,
          decoration: const BoxDecoration(
            color: Color(0xFFB066E4),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(200),
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.07,
          left: screenWidth * 0.08,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome To,",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Therapy App",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPage({
    required String description,
    required String image,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
