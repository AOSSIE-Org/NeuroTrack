import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/gen/assets.gen.dart';
import 'package:patient/presentation/auth/personal_details_screen.dart';
import 'package:patient/presentation/home/home_screen.dart';
import 'package:patient/presentation/widgets/google_signin_button.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/welcome_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer _timer;
  bool hasNavigated = false;
  final supabase = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSubscription;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: Assets.illustrations.i9nActivities,
      title: 'Daily Activities',
      description: 'Personalized Daily Activities, Tracked Effortlessly!',
    ),
    OnboardingContent(
      image: Assets.illustrations.i9nGoals,
      title: 'Therapy Goals',
      description: 'Set and achieve your therapy goals with ease!',
    ),
    OnboardingContent(
      image: Assets.illustrations.i9nMilestones,
      title: 'Health Tracking',
      description: 'Monitor your health metrics with ease and accuracy!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = supabase.auth.currentSession;
      if (session != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleSuccessfulAuth(session);
        });
      }
    });
  }

  void _handleSuccessfulAuth(Session session) {
    final fullName = session.user.userMetadata?['full_name'];
    final email = session.user.email ?? 'Unknown User';

    SnackbarService.showSuccess('Signed in as ${fullName ?? email}');
    context.read<AuthProvider>().checkIfPatientExists();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _contents.length - 1) {
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
    _pageController.dispose();
    _timer.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      Widget? nextScreen;

      if (authProvider.authNavigationStatus.isHome) {
        final userName =
            supabase.auth.currentSession?.user.userMetadata?['full_name'];
        nextScreen = HomeScreen(userName: userName ?? 'User');
      } else if (authProvider.authNavigationStatus.isPersonalDetails) {
        nextScreen = const PersonalDetailsScreen();
      } else if (authProvider.authNavigationStatus.isError) {
        SnackbarService.showError('An error occurred. Please try again.');
        return;
      }

      if (nextScreen != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => nextScreen!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: true).authNavigationStatus;
    return Scaffold(
      body: Column(
        children: [
          const WelcomeHeader(),
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _contents.length,
                  onPageChanged: (int page) {
                    setState(() => _currentPage = page);
                  },
                  itemBuilder: (context, index) =>
                      _buildCarouselItem(_contents[index]),
                ),

                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _contents.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                ),

                // Google Sign-in Button
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: GoogleSignInButton(
                    onPressed: () =>
                        context.read<AuthProvider>().signInWithGoogle(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(OnboardingContent content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        content.image.svg(height: 200),
        const SizedBox(height: 35),
        Text(
          content.title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blueAccent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent {
  final SvgGenImage image;
  final String title;
  final String description;

  const OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}
