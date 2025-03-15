import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/home_provider.dart';
import 'presentation/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'Therapist App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: const Color(0xFFF8F8F8),
          fontFamily: 'Poppins',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
