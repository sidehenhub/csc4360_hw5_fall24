import 'package:flutter/material.dart';
import '../screens/summary_screen.dart';
import '../services/trivia_api_service.dart';
import '../widgets.dart';

class QuizScreen extends StatefulWidget {
  final int numQuestions;
  final String? category;
  final String difficulty;
  final String type;

  const QuizScreen({
    Key? key,
    required this.numQuestions,
    this.category,
    required this.difficulty,
    required this.type,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<dynamic> _questions = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final questions = await TriviaAPIService.getQuestionsWithFixedAmount(); // Using the fixed API URL
      setState(() {
        _questions = questions;
        _loading = false;
        _errorMessage = questions.isEmpty ? 'No questions available.' : '';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to load questions. Please try again later.';
      });
    }
  }

  void _answerQuestion(bool correct) {
    if (correct) _score++;
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(
            score: _score,
            totalQuestions: _questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('quiztrivia')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ProgressIndicatorWidget(
                        current: _currentQuestionIndex + 1,
                        total: _questions.length,
                      ),
                      QuestionCard(
                        question: _questions[_currentQuestionIndex]['question'],
                        answers: _questions[_currentQuestionIndex]['answers'],
                        onAnswerSelected: (answer) => _answerQuestion(
                          answer == _questions[_currentQuestionIndex]['correctAnswer'],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
