import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const QuizTriviaApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
    throw Exception('Firebase initialization error');
  }
}

class QuizTriviaApp extends StatelessWidget {
  const QuizTriviaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'quiztrivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: ThemeData.light().textTheme.copyWith(
              headlineMedium: const TextStyle(fontWeight: FontWeight.bold),
              titleLarge: const TextStyle(fontSize: 20),
            ),
      ),
      home: const SetupScreen(),
    );
  }
}
