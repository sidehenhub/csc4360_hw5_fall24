import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int current;
  final int total;

  const ProgressIndicatorWidget({Key? key, required this.current, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(
          'Question $current of $total',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final List<String> answers;
  final void Function(String) onAnswerSelected;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.answers,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...answers.map(
              (answer) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () => onAnswerSelected(answer),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
