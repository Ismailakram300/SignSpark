import 'package:flutter/material.dart';
import '../aplhabet_signs/alphabet_sign_class.dart';

class WordBuilderGame extends StatefulWidget {
  const WordBuilderGame({super.key});

  @override
  State<WordBuilderGame> createState() => _WordBuilderGameState();
}

class _WordBuilderGameState extends State<WordBuilderGame> {
  final List<String> _words = [
    'CAT',
    'DOG',
    'BAT',
    'HAT',
    'PIG',
    'BIG',
    'SUN',
    'FUN',
    'RUN',
    'BED',
    'RED',
    'PEN',
    'TEN',
    'BOX',
    'FOX',
  ];

  String _currentWord = '';
  List<String> _userAnswer = [];
  int _currentWordIndex = 0;
  int _score = 0;
  bool _showingResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _startNewWord();
  }

  void _startNewWord() {
    setState(() {
      _currentWord = _words[_currentWordIndex];
      _userAnswer = [];
      _showingResult = false;
      _isCorrect = false;
    });
  }

  void _selectLetter(String letter) {
    if (_showingResult || _userAnswer.length >= _currentWord.length) return;

    setState(() {
      _userAnswer.add(letter);

      if (_userAnswer.length == _currentWord.length) {
        _checkAnswer();
      }
    });
  }

  void _removeLetter() {
    if (_userAnswer.isEmpty || _showingResult) return;

    setState(() {
      _userAnswer.removeLast();
    });
  }

  void _checkAnswer() {
    final userWord = _userAnswer.join('');
    setState(() {
      _isCorrect = userWord == _currentWord;
      _showingResult = true;
      if (_isCorrect) {
        _score++;
      }
    });
  }

  void _nextWord() {
    setState(() {
      if (_currentWordIndex < _words.length - 1) {
        _currentWordIndex++;
        _startNewWord();
      } else {
        // Game completed
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'You scored $_score out of ${_words.length}!',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentWordIndex = 0;
                _score = 0;
                _startNewWord();
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Builder'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Score: $_score/${_words.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress
            LinearProgressIndicator(
              value: (_currentWordIndex + 1) / _words.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey.shade200,
              color: Colors.purple,
            ),
            const SizedBox(height: 8),
            Text(
              'Word ${_currentWordIndex + 1} of ${_words.length}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Instruction
            const Text(
              'Spell the word using sign language:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // Target Word Display (as signs)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade200, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _currentWord.split('').map((letter) {
                  final sign = alphabets.firstWhere((s) => s.letter == letter);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Image.asset(
                          sign.image,
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 30,
                          height: 3,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // User Answer Display
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _showingResult
                    ? (_isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _showingResult
                      ? (_isCorrect ? Colors.green : Colors.red)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_userAnswer.isEmpty)
                    Text(
                      'Tap letters below...',
                      style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                    )
                  else
                    ..._userAnswer.map((letter) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  if (_showingResult)
                    Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: _isCorrect ? Colors.green : Colors.red,
                      size: 40,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Delete Button
            if (_userAnswer.isNotEmpty && !_showingResult)
              ElevatedButton.icon(
                onPressed: _removeLetter,
                icon: const Icon(Icons.backspace),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade900,
                ),
              ),
            const SizedBox(height: 24),

            // Letter Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: 26,
                itemBuilder: (context, index) {
                  final letter = String.fromCharCode(65 + index);
                  final isInWord = _currentWord.contains(letter);
                  
                  return ElevatedButton(
                    onPressed: _showingResult ? null : () => _selectLetter(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInWord
                          ? Colors.purple.shade100
                          : Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      letter,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Next Button
            if (_showingResult)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextWord,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentWordIndex < _words.length - 1
                        ? 'Next Word'
                        : 'Finish',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
