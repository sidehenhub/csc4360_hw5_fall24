import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

class TriviaAPIService {
  static const String _baseUrl = 'https://opentdb.com';

  // Fetch trivia categories from the API
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api_category.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['trivia_categories'] != null) {
          return List<Map<String, dynamic>>.from(data['trivia_categories']);
        } else {
          throw Exception('Invalid response format: Missing "trivia_categories" key.');
        }
      } else {
        throw Exception('Failed to fetch categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getCategories: $e');
      rethrow;
    }
  }

  // Fetch trivia questions using dynamic parameters
  static Future<List<QuizQuestion>> getQuestions({
    required int numQuestions,
    required String? category,
    required String difficulty,
    required String type,
  }) async {
    try {
      // Construct the URL dynamically
      String url = '$_baseUrl/api.php?amount=$numQuestions';
      if (difficulty.isNotEmpty) {
        url += '&difficulty=$difficulty';
      }
      if (type.isNotEmpty) {
        url += '&type=$type';
      }
      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }

      // Fetch data from the API
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null) {
          return List<QuizQuestion>.from(
            data['results'].map((questionJson) => QuizQuestion.fromJson(questionJson)),
          );
        } else {
          throw Exception('Invalid response format: Missing "results" key.');
        }
      } else {
        throw Exception('Failed to fetch questions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getQuestions: $e');
      rethrow;
    }
  }

  // Fetch trivia questions with a fixed amount (10 questions)
  static Future<List<QuizQuestion>> getQuestionsWithFixedAmount({
    String? difficulty,
    String? category,
  }) async {
    try {
      // Construct the URL dynamically for fixed 10 questions
      String url = '$_baseUrl/api.php?amount=10';
      if (difficulty != null && difficulty.isNotEmpty) {
        url += '&difficulty=$difficulty';
      }
      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }

      // Fetch data from the API
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null) {
          return List<QuizQuestion>.from(
            data['results'].map((questionJson) => QuizQuestion.fromJson(questionJson)),
          );
        } else {
          throw Exception('Invalid response format: Missing "results" key.');
        }
      } else {
        throw Exception('Failed to fetch questions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getQuestionsWithFixedAmount: $e');
      rethrow;
    }
  }
}
