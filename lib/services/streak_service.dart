import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class StreakService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  
  static const String _lastLoginKey = 'last_login_date';
  
  /// Updates the user's streak based on their last login date
  Future<void> updateStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    try {
      // Get current date (without time)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Get last login date from local storage
      final lastLoginString = _storage.read<String>(_lastLoginKey);
      
      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return;
      
      final userData = userDoc.data()!;
      int currentStreak = userData['streak'] ?? 0;
      
      if (lastLoginString == null) {
        // First time login or after app reinstall
        currentStreak = 1;
      } else {
        final lastLogin = DateTime.parse(lastLoginString);
        final lastLoginDate = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
        
        final daysDifference = today.difference(lastLoginDate).inDays;
        
        if (daysDifference == 0) {
          // Same day - no change to streak
          return;
        } else if (daysDifference == 1) {
          // Next day - increment streak
          currentStreak++;
        } else {
          // More than 1 day gap - reset streak
          currentStreak = 1;
        }
      }
      
      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'streak': currentStreak,
        'lastLoginDate': today.toIso8601String(),
      });
      
      // Update local storage
      _storage.write(_lastLoginKey, today.toIso8601String());
      
    } catch (e) {
      print('Error updating streak: $e');
    }
  }
  
  /// Gets the current streak for the logged-in user
  Future<int> getCurrentStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;
    
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return 0;
      
      return userDoc.data()?['streak'] ?? 0;
    } catch (e) {
      print('Error getting streak: $e');
      return 0;
    }
  }
  
  /// Gets streak milestone information
  String getStreakMilestone(int streak) {
    if (streak >= 365) return '🏆 Year Warrior!';
    if (streak >= 100) return '💯 Century Club!';
    if (streak >= 30) return '🌟 Monthly Master!';
    if (streak >= 7) return '⭐ Week Champion!';
    if (streak >= 3) return '🔥 On Fire!';
    if (streak >= 1) return '✨ Getting Started!';
    return '';
  }
  
  /// Gets motivational message based on streak
  String getMotivationalMessage(int streak) {
    if (streak >= 365) return 'Incredible dedication! A full year!';
    if (streak >= 100) return 'Amazing! You\'re unstoppable!';
    if (streak >= 30) return 'Fantastic! A month of consistency!';
    if (streak >= 7) return 'Great job! Keep it up!';
    if (streak >= 3) return 'You\'re building a habit!';
    if (streak >= 1) return 'Every journey starts with a single step!';
    return 'Start your streak today!';
  }
  
  /// Clears local login data (used on logout)
  void clearLocalData() {
    _storage.remove(_lastLoginKey);
  }
}
