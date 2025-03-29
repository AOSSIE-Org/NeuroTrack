import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:therapist/provider/consultation_provider.dart';
import 'package:therapist/provider/session_provider.dart';
import 'package:therapist/provider/therapy_provider.dart';
import 'package:therapist/repository/supabase_therapy_repository.dart';

import 'presentation/splash_screen.dart';
import 'provider/auth_provider.dart';
import 'provider/home_provider.dart';
import 'provider/therapist_provider.dart';
import 'repository/supabase_consultation_repository.dart';

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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => TherapistDataProvider()),
        ChangeNotifierProvider(create: (context) => ConsultationProvider(SupabaseConsultationRepository())),
        ChangeNotifierProvider(create: (context) => SessionProvider(),),
        ChangeNotifierProvider(create: (context) => TherapyProvider(therapyRepository: SupabaseTherapyRepository()))
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
      debugShowCheckedModeBanner: false,
      title: 'Therapist App',
      theme: ThemeData.light(),
      home: const SplashScreen(),
    );
  }
}
