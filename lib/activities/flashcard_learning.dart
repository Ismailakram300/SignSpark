import 'package:flutter/material.dart';
import '../aplhabet_signs/alphabet_sign_class.dart';

class FlashcardLearning extends StatefulWidget {
  const FlashcardLearning({super.key});

  @override
  State<FlashcardLearning> createState() => _FlashcardLearningState();
}

class _FlashcardLearningState extends State<FlashcardLearning> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  Set<int> _learnedCards = {};

  void _nextCard() {
    setState(() {
      if (_currentIndex < alphabets.length - 1) {
        _currentIndex++;
        _showAnswer = false;
      }
    });
  }

  void _previousCard() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _showAnswer = false;
      }
    });
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _toggleLearned() {
    setState(() {
      if (_learnedCards.contains(_currentIndex)) {
        _learnedCards.remove(_currentIndex);
      } else {
        _learnedCards.add(_currentIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSign = alphabets[_currentIndex];
    final isLearned = _learnedCards.contains(_currentIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Learning'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_learnedCards.length}/${alphabets.length} learned',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentIndex + 1) / alphabets.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text(
              'Card ${_currentIndex + 1} of ${alphabets.length}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Flashcard
            Expanded(
              child: GestureDetector(
                onTap: _toggleAnswer,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Container(
                    key: ValueKey(_showAnswer),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLearned
                            ? [Colors.green.shade100, Colors.green.shade50]
                            : [Colors.blue.shade100, Colors.blue.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isLearned ? Colors.green : Colors.blue,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_showAnswer) ...[
                          const Icon(Icons.help_outline, size: 60, color: Colors.grey),
                          const SizedBox(height: 20),
                          const Text(
                            'What letter is this?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Image.asset(
                              currentSign.image,
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Tap to reveal',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ] else ...[
                          const Icon(Icons.check_circle_outline,
                              size: 60, color: Colors.green),
                          const SizedBox(height: 20),
                          Text(
                            currentSign.letter,
                            style: const TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Image.asset(
                              currentSign.image,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mark as Learned Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _toggleLearned,
                icon: Icon(isLearned ? Icons.check_circle : Icons.circle_outlined),
                label: Text(isLearned ? 'Learned' : 'Mark as Learned'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: isLearned ? Colors.green : Colors.grey,
                    width: 2,
                  ),
                  foregroundColor: isLearned ? Colors.green : Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex > 0 ? _previousCard : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex < alphabets.length - 1 ? _nextCard : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
