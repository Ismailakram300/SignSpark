import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../random_words/random_words_model.dart';

class PhraseQuiz extends StatefulWidget {
  const PhraseQuiz({super.key});

  @override
  State<PhraseQuiz> createState() => _PhraseQuizState();
}

class _PhraseQuizState extends State<PhraseQuiz> {
  // Game state
  List<RandomWordsModel> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  List<String> _currentOptions = [];
  
  // Video player
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _startNewQuiz();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _startNewQuiz() {
    // Use all available phrases (currently 4)
    setState(() {
      _questions = List.from(randomWord)..shuffle();
      _currentIndex = 0;
      _score = 0;
      _isAnswered = false;
      _selectedAnswer = null;
      _generateOptions();
    });
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (_currentIndex >= _questions.length) return;
    
    // Dispose previous controller
    await _videoController?.dispose();
    
    setState(() {
      _isVideoInitialized = false;
    });

    try {
      _videoController = VideoPlayerController.asset(_questions[_currentIndex].video);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.setVolume(0.0); // Muted
      _videoController!.play();
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _generateOptions() {
    if (_currentIndex >= _questions.length) return;

    final correctPhrase = _questions[_currentIndex].word;
    // Get all other phrases to form distractors
    final otherPhrases = randomWord
        .where((p) => p.word != correctPhrase)
        .map((p) => p.word)
        .toList();
    
    // If we have enough phrases, shuffle and pick distractors
    otherPhrases.shuffle();
    final distractors = otherPhrases.take(3).toList();

    // Combine and shuffle to randomize positions
    _currentOptions = [...distractors, correctPhrase]..shuffle();
  }

  void _checkAnswer(String selectedPhrase) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedAnswer = selectedPhrase;
      if (selectedPhrase == _questions[_currentIndex].word) {
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
        _initializeVideo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading if questions aren't ready
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
              borderRadius: BorderRadius.circular(4),
              color: Colors.purple.shade300,
            ),
            const SizedBox(height: 24),
            
            // Instruction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                //color: Colors.purple.shade50,
                color: Colors.green.shade100,

                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Which phrase does this sign represent?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            
            // Video Display
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _isVideoInitialized && _videoController != null
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Options List
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: _currentOptions.length,
                itemBuilder: (context, index) {
                  final phrase = _currentOptions[index];
                  Color backgroundColor = Colors.green.shade100;
                  Color textColor = Colors.black87;
                  
                  if (_isAnswered) {
                    if (phrase == currentQuestion.word) {
                      backgroundColor = Colors.green.shade400;
                      textColor = Colors.white;
                    } else if (phrase == _selectedAnswer) {
                      backgroundColor = Colors.red.shade400;
                      textColor = Colors.white;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: textColor,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _checkAnswer(phrase),
                      child: Text(
                        phrase,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Next Question', style: TextStyle(fontSize: 18, color: Colors.white)),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
