import 'package:flutter/material.dart';

class StreakDialog extends StatelessWidget {
  final int streak;
  final String milestone;
  final String message;

  const StreakDialog({
    super.key,
    required this.streak,
    required this.milestone,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade50,
              Colors.red.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fire emoji animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, double scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: const Text(
                    '🔥',
                    style: TextStyle(fontSize: 80),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Streak count
            Text(
              '$streak Day Streak!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 8),

            // Milestone
            if (milestone.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade300, width: 2),
                ),
                child: Text(
                  milestone,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Motivational message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),

            // Progress indicators for milestones
            _buildMilestoneProgress(streak),
            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Keep Going!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneProgress(int streak) {
    final milestones = [
      {'days': 3, 'label': '3 Days', 'icon': '🔥'},
      {'days': 7, 'label': '1 Week', 'icon': '⭐'},
      {'days': 30, 'label': '1 Month', 'icon': '🌟'},
      {'days': 100, 'label': '100 Days', 'icon': '💯'},
    ];

    return Column(
      children: [
        const Text(
          'Milestones',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: milestones.map((milestone) {
            final days = milestone['days'] as int;
            final achieved = streak >= days;
            return Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: achieved
                        ? Colors.green.shade100
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: achieved ? Colors.green : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      milestone['icon'] as String,
                      style: TextStyle(
                        fontSize: 24,
                        color: achieved ? null : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: achieved ? Colors.green : Colors.grey,
                    fontWeight: achieved ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
