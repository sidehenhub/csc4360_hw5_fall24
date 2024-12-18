class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> answers;
  final String? category; // Optional category name
  final String? difficulty; // Optional difficulty level
  final String? type; // Optional question type ("multiple" or "boolean")

  QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.answers,
    this.category,
    this.difficulty,
    this.type,
  });

  // Factory method to create QuizQuestion from JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final correct = json['correct_answer'];
    final incorrect = List<String>.from(json['incorrect_answers']);
    return QuizQuestion(
      question: json['question'],
      correctAnswer: correct,
      answers: (incorrect + [correct])..shuffle(),
      category: json['category'],
      difficulty: json['difficulty'],
      type: json['type'],
    );
  }

  // Method to create a list of QuizQuestions from data
  static List<QuizQuestion> fromData(List<Map<String, dynamic>> data) {
    return data.map((json) => QuizQuestion.fromJson(json)).toList();
  }
}
