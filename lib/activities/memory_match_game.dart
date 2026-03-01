import 'package:flutter/material.dart';
import 'dart:math';
import '../aplhabet_signs/alphabet_sign_class.dart';

class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({super.key});

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  List<MemoryCard> _cards = [];
  MemoryCard? _firstCard;
  MemoryCard? _secondCard;
  int _moves = 0;
  int _matches = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Select 6 random alphabets
    final selectedAlphabets = List.from(alphabets)..shuffle();
    final gameAlphabets = selectedAlphabets.take(6).toList();

    // Create pairs: one with image, one with letter
    List<MemoryCard> cards = [];
    for (int i = 0; i < gameAlphabets.length; i++) {
      cards.add(MemoryCard(
        id: 'img_$i',
        content: gameAlphabets[i].image,
        matchId: gameAlphabets[i].letter,
        isImage: true,
      ));
      cards.add(MemoryCard(
        id: 'letter_$i',
        content: gameAlphabets[i].letter,
        matchId: gameAlphabets[i].letter,
        isImage: false,
      ));
    }

    cards.shuffle();

    setState(() {
      _cards = cards;
      _firstCard = null;
      _secondCard = null;
      _moves = 0;
      _matches = 0;
      _isChecking = false;
    });
  }

  void _onCardTap(MemoryCard card) {
    if (_isChecking || card.isFlipped || card.isMatched) return;

    setState(() {
      card.isFlipped = true;

      if (_firstCard == null) {
        _firstCard = card;
      } else if (_secondCard == null) {
        _secondCard = card;
        _moves++;
        _isChecking = true;

        // Check for match after a delay
        Future.delayed(const Duration(milliseconds: 800), () {
          _checkMatch();
        });
      }
    });
  }

  void _checkMatch() {
    if (_firstCard!.matchId == _secondCard!.matchId) {
      // Match found
      setState(() {
        _firstCard!.isMatched = true;
        _secondCard!.isMatched = true;
        _matches++;
        _firstCard = null;
        _secondCard = null;
        _isChecking = false;
      });
    } else {
      // No match
      setState(() {
        _firstCard!.isFlipped = false;
        _secondCard!.isFlipped = false;
        _firstCard = null;
        _secondCard = null;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGameWon = _matches == 6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(label: 'Moves', value: _moves.toString()),
                _StatCard(label: 'Matches', value: '$_matches / 6'),
              ],
            ),
          ),

          // Game Grid
          Expanded(
            child: isGameWon
                ? _buildWinScreen()
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      return _MemoryCardWidget(
                        card: _cards[index],
                        onTap: () => _onCardTap(_cards[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
          const SizedBox(height: 20),
          const Text(
            'Congratulations!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'You completed the game in $_moves moves!',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _initializeGame,
            icon: const Icon(Icons.refresh),
            label: const Text('Play Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryCardWidget extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;

  const _MemoryCardWidget({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isMatched
              ? Colors.green.shade100
              : card.isFlipped
                  ? Colors.white
                  : Colors.blue.shade300,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: card.isMatched ? Colors.green : Colors.blue.shade400,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: card.isFlipped || card.isMatched
            ? card.isImage
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      card.content,
                      fit: BoxFit.contain,
                    ),
                  )
                : Center(
                    child: Text(
                      card.content,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
            : Center(
                child: Icon(
                  Icons.question_mark,
                  size: 48,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
      ),
    );
  }
}

class MemoryCard {
  final String id;
  final String content;
  final String matchId;
  final bool isImage;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.content,
    required this.matchId,
    required this.isImage,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
