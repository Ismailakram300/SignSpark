import 'package:flutter/material.dart';
import 'package:sign_spark/Quiz/quiz.dart';
import 'package:sign_spark/Quiz/phrase_quiz.dart';
import 'package:sign_spark/aplhabet_signs/aplhabetic_ui.dart';
import 'package:sign_spark/random_words/random_words_ui.dart';
import 'package:sign_spark/activities.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Sample progress data (in a real app, this would come from a database)
  final int alphabetsLearned = 18;
  final int totalAlphabets = 26;
  final int phrasesLearned = 3;
  final int totalPhrases = 4;
  final int quizzesTaken = 5;
  final int practiceMinutes = 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Header
              const Text(
                'Your Learning Journey',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your progress and achievements',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),

              // Daily Goals Section
              _buildSectionTitle('Daily Goals'),
              const SizedBox(height: 16),
              _buildDailyGoals(),
              const SizedBox(height: 30),

              // Progress Overview
              _buildSectionTitle('Learning Progress'),
              const SizedBox(height: 16),
              _buildProgressCards(),
              const SizedBox(height: 30),

              // Quick Actions
              _buildSectionTitle('Quick Actions'),
              const SizedBox(height: 16),
              _buildQuickActions(),
              const SizedBox(height: 30),

              // Achievements
              _buildSectionTitle('Recent Achievements'),
              const SizedBox(height: 16),
              _buildAchievements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDailyGoals() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🎯 Today\'s Goals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '2/3 Complete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGoalItem('Learn 5 new signs', true),
          const SizedBox(height: 12),
          _buildGoalItem('Complete 1 quiz', true),
          const SizedBox(height: 12),
          _buildGoalItem('Practice for 10 minutes', false),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String goal, bool completed) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: completed ? Colors.white : Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: completed
              ? const Icon(Icons.check, size: 16, color: Colors.green)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            goal,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              decoration: completed ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildProgressCard(
                'Alphabets',
                alphabetsLearned,
                totalAlphabets,
                Icons.abc,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProgressCard(
                'Phrases',
                phrasesLearned,
                totalPhrases,
                Icons.chat_bubble,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Quizzes',
                quizzesTaken.toString(),
                Icons.quiz,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Practice',
                '$practiceMinutes min',
                Icons.timer,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    String title,
    int current,
    int total,
    IconData icon,
    Color color,
  ) {
    final progress = current / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$current / $total',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildActionButton(
          'Continue Learning Alphabets',
          Icons.abc,
          Colors.orange,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AplhabeticUi())),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Practice Common Phrases',
          Icons.video_library,
          Colors.green,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RandomWordsUi())),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Take Alphabet Quiz',
          Icons.quiz,
          Colors.blue,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Quiz())),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Take Phrase Quiz',
          Icons.question_answer,
          Colors.purple,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhraseQuiz())),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      children: [
        _buildAchievementItem(
          '🔥 5 Day Streak',
          'Logged in for 5 consecutive days',
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildAchievementItem(
          '⭐ Quiz Master',
          'Completed 5 quizzes',
          Colors.amber,
        ),
        const SizedBox(height: 12),
        _buildAchievementItem(
          '📚 Alphabet Expert',
          'Learned 18 alphabet signs',
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildAchievementItem(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                title.split(' ')[0],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.substring(title.indexOf(' ') + 1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
