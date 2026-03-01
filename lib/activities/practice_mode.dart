import 'package:flutter/material.dart';
import '../aplhabet_signs/alphabet_sign_class.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PracticeMode extends StatefulWidget {
  const PracticeMode({super.key});

  @override
  State<PracticeMode> createState() => _PracticeModeState();
}

class _PracticeModeState extends State<PracticeMode> {
  final FlutterTts _flutterTts = FlutterTts();
  String _searchQuery = '';
  String? _selectedCategory;

  final Map<String, List<String>> _categories = {
    'All': [],
    'A-F': ['A', 'B', 'C', 'D', 'E', 'F'],
    'G-L': ['G', 'H', 'I', 'J', 'K', 'L'],
    'M-R': ['M', 'N', 'O', 'P', 'Q', 'R'],
    'S-Z': ['S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'All';
  }

  List<AlphabetSign> get _filteredSigns {
    var signs = alphabets;

    // Filter by category
    if (_selectedCategory != null && _selectedCategory != 'All') {
      final categoryLetters = _categories[_selectedCategory]!;
      signs = signs.where((s) => categoryLetters.contains(s.letter)).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      signs = signs
          .where((s) => s.letter.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return signs;
  }

  void _showSignDetail(AlphabetSign sign) {
    _flutterTts.speak(sign.letter);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sign.letter,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, size: 32),
                    onPressed: () => _flutterTts.speak(sign.letter),
                    color: Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal.shade200, width: 2),
                ),
                child: Image.asset(
                  sign.image,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSigns = _filteredSigns;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Mode'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search letters...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              // Category Chips
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: _categories.keys.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: Colors.teal.shade200,
                        checkmarkColor: Colors.teal.shade900,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: filteredSigns.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No signs found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: filteredSigns.length,
              itemBuilder: (context, index) {
                final sign = filteredSigns[index];
                return _PracticeCard(
                  sign: sign,
                  onTap: () => _showSignDetail(sign),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Random sign practice
          final randomSign = (alphabets..shuffle()).first;
          _showSignDetail(randomSign);
        },
        icon: const Icon(Icons.shuffle),
        label: const Text('Random'),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final AlphabetSign sign;
  final VoidCallback onTap;

  const _PracticeCard({required this.sign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sign.letter,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    sign.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.teal.shade100,
                child: const Icon(
                  Icons.touch_app,
                  size: 20,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
