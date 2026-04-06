import 'package:flutter/material.dart';
import '../aplhabet_signs/alphabet_sign_class.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
  
}


class _QuizState extends State<Quiz> {
  
  // Game state

  
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  List<String> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _startNewQuiz();
  }

  void _startNewQuiz() {
    // Create a shuffled copy of the alphabets list and take only 10
    setState(() {
      _questions = (List.from(alphabets)..shuffle()).take(10).toList();
      _currentIndex = 0;
      _score = 0;
      _isAnswered = false;
      _selectedAnswer = null;
      _generateOptions();
    });
  }

  void _generateOptions() {
    if (_currentIndex >= _questions.length) return;

    final correctLetter = _questions[_currentIndex].letter;
    // Get all other letters to form distractors
    final otherLetters = alphabets
        .where((a) => a.letter != correctLetter)
        .map((a) => a.letter)
        .toList();
    
    // Shuffle distractors and pick 3
    otherLetters.shuffle();
    final distractors = otherLetters.take(3).toList();

    // Combine and shuffle to randomize positions
    _currentOptions = [...distractors, correctLetter]..shuffle();
  }
  void _checkAnswer(String selectedLetter) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedAnswer = selectedLetter;
      if (selectedLetter == _questions[_currentIndex].letter) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      if (_currentIndex < _questions.length) {
        _isAnswered = false;
        _selectedAnswer = null;
        _generateOptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading if questions aren't ready (though they should be instant)
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isFinished = _currentIndex >= _questions.length;

    if (isFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Result')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                const SizedBox(height: 20),
                const Text(
                  'Quiz Completed!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Score: $_score / ${_questions.length}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  '${((_score / _questions.length) * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20, 
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startNewQuiz,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Restart Quiz',style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),color: Colors.brown.shade300
            ),
            const SizedBox(height: 24),
            
            // Image Display
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        currentQuestion.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "What letter does this sign represent?",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Options Grid
            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final letter = _currentOptions[index];
                  Color backgroundColor = Theme.of(context).cardColor;
                  Color textColor = Colors.black87;
                  
                  if (_isAnswered) {
                    if (letter == currentQuestion.letter) {
                      backgroundColor = Colors.green.shade400;
                      textColor = Colors.white;
                    } else if (letter == _selectedAnswer) {
                      backgroundColor = Colors.red.shade400;
                      textColor = Colors.white;
                    }
                  } else {
                     backgroundColor = Colors.blue.shade50;
                  }

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: textColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _checkAnswer(letter),
                    child: Text(letter),
                  );
                },
              ),
            ),
            
            // Next Button Area
            SizedBox(
              height: 60,
              width: double.infinity,
              child: _isAnswered
                  ? ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Next Question', style: TextStyle(fontSize: 18,color: Colors.black )),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
