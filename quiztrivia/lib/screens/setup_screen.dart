import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import '../services/trivia_api_service.dart';
import '../utils.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _numQuestions = 10;
  String? _selectedCategory;
  String _difficulty = 'easy';
  String _type = 'multiple';
  List<dynamic> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    if (await Utils.isConnected()) {
      try {
        final categories = await TriviaAPIService.getCategories();
        setState(() {
          _categories = categories;
          _loadingCategories = false;
        });
      } catch (e) {
        setState(() {
          _loadingCategories = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: $e')),
        );
      }
    } else {
      setState(() {
        _loadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection')),
      );
    }
  }

  void _startQuiz() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          numQuestions: _numQuestions,
          category: _selectedCategory,
          difficulty: _difficulty,
          type: _type,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: _numQuestions,
              items: [5, 10, 15].map((num) {
                return DropdownMenuItem(
                  value: num,
                  child: Text('$num Questions'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _numQuestions = value!),
              decoration: const InputDecoration(labelText: 'Number of Questions'),
            ),
            const SizedBox(height: 20),
            if (_loadingCategories)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select a Category:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200, // Adjust height as needed
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category['id'].toString();

                        return ListTile(
                          title: Text(category['name']),
                          tileColor: isSelected ? Colors.blue[100] : null,
                          trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category['id'].toString();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _difficulty,
              items: ['easy', 'medium', 'hard'].map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => _difficulty = value!),
              decoration: const InputDecoration(labelText: 'Difficulty'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _type,
              items: ['multiple', 'boolean'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => _type = value!),
              decoration: const InputDecoration(labelText: 'Question Type'),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _startQuiz,
                child: const Text('Start Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
