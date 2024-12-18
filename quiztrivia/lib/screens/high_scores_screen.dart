import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('High Scores')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FirebaseService.getHighScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final scores = snapshot.data ?? [];
          if (scores.isEmpty) {
            return const Center(child: Text('No high scores available.'));
          }

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              return ListTile(
                title: Text(
                  score['username'] ?? 'Unknown Player',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                trailing: Text(
                  score['score']?.toString() ?? '0',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  score['timestamp']?.toDate()?.toString() ?? 'No timestamp',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
