import 'package:flutter/material.dart';
import 'package:sign_spark/activities/memory_match_game.dart';
import 'package:sign_spark/activities/sign_speed_challenge.dart';
import 'package:sign_spark/activities/flashcard_learning.dart';
import 'package:sign_spark/activities/word_builder_game.dart';
import 'package:sign_spark/activities/practice_mode.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final List<ActivityItem> activities = [
    ActivityItem(
      title: 'Memory Match',
      description: 'Match sign language cards with their letters',
      icon: Icons.grid_on,
      color: Colors.blue,
      screen: const MemoryMatchGame(),
    ),
    ActivityItem(
      title: 'Sign Speed Challenge',
      description: 'How fast can you identify signs?',
      icon: Icons.speed,
      color: Colors.orange,
      screen: const SignSpeedChallenge(),
    ),
    ActivityItem(
      title: 'Flashcard Learning',
      description: 'Learn signs one by one at your pace',
      icon: Icons.style,
      color: Colors.green,
      screen: const FlashcardLearning(),
    ),
    ActivityItem(
      title: 'Word Builder',
      description: 'Spell words using sign language',
      icon: Icons.abc,
      color: Colors.purple,
      screen: const WordBuilderGame(),
    ),
    ActivityItem(
      title: 'Practice Mode',
      description: 'Free practice with all signs',
      icon: Icons.school,
      color: Colors.teal,
      screen: const PracticeMode(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Activities'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ActivityCard(activity: activity),
          );
        },
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget screen;

  ActivityItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

class ActivityCard extends StatelessWidget {
  final ActivityItem activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            activity.color.withOpacity(0.1),
            activity.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: activity.color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => activity.screen),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: activity.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    activity.icon,
                    size: 36,
                    color: activity.color,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: activity.color.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activity.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: activity.color.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
