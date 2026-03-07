import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:patient/core/core.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/splash_screen.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/appointments_provider.dart';
import 'package:patient/provider/assessment_provider.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:patient/provider/reports_provider.dart';
import 'package:patient/provider/task_provider.dart';
import 'package:patient/provider/therapy_goals_provider.dart';
import 'package:patient/repository/supabase_auth_repository.dart';
import 'package:patient/repository/supabase_patient_repository.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];
    final geminiKey = dotenv.env['GEMINI_API_KEY'];

    // Validate env variables
    if (supabaseUrl == null || supabaseKey == null || geminiKey == null) {
      throw Exception("Missing environment variables in .env file");
    }

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );

    // Initialize Gemini
    Gemini.init(apiKey: geminiKey);

    // System UI styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Setup dependency injection
    setupDependencyInjection();

    // Create shared repositories
    final supabaseClient = Supabase.instance.client;
    final patientRepository =
        SupabasePatientRepository(supabaseClient: supabaseClient);
    final authRepository =
        SupabaseAuthRepository(supabaseClient: supabaseClient);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AssessmentProvider()),

          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              authRepository: authRepository,
            ),
          ),

          ChangeNotifierProvider(
            create: (_) => ReportsProvider(
              patientRepository: patientRepository,
            ),
          ),

          ChangeNotifierProvider(
            create: (_) => TaskProvider(
              patientRepository: patientRepository,
            ),
          ),

          ChangeNotifierProvider(
            create: (_) => TherapyGoalsProvider(
              patientRepository: patientRepository,
            ),
          ),

          ChangeNotifierProvider(
            create: (_) => AppointmentsProvider(
              authRepository: authRepository,
              patientRepository: patientRepository,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint("App initialization failed: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'NeuroTrack Patient',
      theme: AppTheme.lightTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}