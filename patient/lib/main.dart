import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/splash_screen.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/appointments_provider.dart';
import 'package:patient/provider/assessment_provider.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:patient/repository/supabase_auth_repository.dart';

import 'package:patient/provider/reports_provider.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'provider/task_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authRepository: SupabaseAuthRepository(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Patient App',
        theme: AppTheme.lightTheme(),
        home: const SplashScreen());
  }
}
