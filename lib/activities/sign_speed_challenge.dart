import 'package:flutter/material.dart';
import 'dart:async';
import '../aplhabet_signs/alphabet_sign_class.dart';

class SignSpeedChallenge extends StatefulWidget {
  const SignSpeedChallenge({super.key});

  @override
  State<SignSpeedChallenge> createState() => _SignSpeedChallengeState();
}

class _SignSpeedChallengeState extends State<SignSpeedChallenge> {
  List<AlphabetSign> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _timeLeft = 30;
  bool _isGameActive = false;
  bool _isGameOver = false;
  Timer? _timer;
  List<String> _currentOptions = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _questions = List.from(alphabets)..shuffle();
      _currentIndex = 0;
      _score = 0;
      _streak = 0;
      _timeLeft = 30;
      _isGameActive = true;
      _isGameOver = false;
      _generateOptions();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _generateOptions() {
    if (_currentIndex >= _questions.length) {
      _currentIndex = 0;
      _questions.shuffle();
    }

    final correctLetter = _questions[_currentIndex].letter;
    final otherLetters = alphabets
        .where((a) => a.letter != correctLetter)
        .map((a) => a.letter)
        .toList();

    otherLetters.shuffle();
    final distractors = otherLetters.take(3).toList();

    _currentOptions = [...distractors, correctLetter]..shuffle();
  }

  void _checkAnswer(String selectedLetter) {
    if (!_isGameActive) return;

    setState(() {
      if (selectedLetter == _questions[_currentIndex].letter) {
        _score += (1 + (_streak ~/ 3)); // Bonus points for streaks
        _streak++;
      } else {
        _streak = 0;
      }
      _currentIndex++;
      _generateOptions();
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isGameActive = false;
      _isGameOver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGameActive && !_isGameOver) {
      return _buildStartScreen();
    }

    if (_isGameOver) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBadge(
                  icon: Icons.timer,
                  label: 'Time',
                  value: '$_timeLeft s',
                  color: _timeLeft <= 10 ? Colors.red : Colors.blue,
                ),
                _StatBadge(
                  icon: Icons.star,
                  label: 'Score',
                  value: _score.toString(),
                  color: Colors.amber,
                ),
                _StatBadge(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: _streak.toString(),
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sign Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  _questions[_currentIndex].image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options Grid
            Expanded(
              flex: 2,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final letter = _currentOptions[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _checkAnswer(letter),
                    child: Text(letter),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Speed Challenge')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.speed, size: 100, color: Colors.orange.shade400),
              const SizedBox(height: 20),
              const Text(
                'Speed Challenge',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Identify as many signs as you can in 30 seconds!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Text(
                'Build streaks for bonus points!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _startGame,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Challenge'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    String performance = _score >= 20
        ? 'Amazing!'
        : _score >= 15
            ? 'Great Job!'
            : _score >= 10
                ? 'Good Effort!'
                : 'Keep Practicing!';

    return Scaffold(
      appBar: AppBar(title: const Text('Challenge Complete')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                performance,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Final Score: $_score',
                style: const TextStyle(fontSize: 28, color: Colors.blue),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _startGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
