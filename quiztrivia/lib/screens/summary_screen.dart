import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const SummaryScreen({Key? key, required this.score, required this.totalQuestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quiz Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: $score / $totalQuestions',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: score / totalQuestions,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Retake Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
