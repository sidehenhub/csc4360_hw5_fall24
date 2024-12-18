import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveScore(String username, int score) async {
    try {
      await _firestore.collection('scores').add({
        'username': username,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save score: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getHighScores() async {
    try {
      final querySnapshot = await _firestore
          .collection('scores')
          .orderBy('score', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'username': data['username'] ?? 'Unknown Player',
          'score': data['score'] ?? 0,
          'timestamp': data['timestamp'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch high scores: $e');
    }
  }
}
