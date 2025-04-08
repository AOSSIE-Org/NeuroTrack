class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay
    if (authProvider.isAuthenticated) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('user_id', authProvider.user!.id)
          .maybeSingle();
      if (profile == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('NeuroTrack')),
    );
  }
}