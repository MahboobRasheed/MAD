// main.dart
// Mini Flashcards app demonstrating:
// - Scrollable list of flashcards
// - Swipe to mark as "learned" (Dismissible)// - Pull to refresh for a new set (RefreshIndicator)
// - Tap to reveal answer
// - Collapsing header (SliverAppBar) showing progress
// - Add new question dynamically using AnimatedList

import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardsApp());
}

class Flashcard {
  final String id;
  final String question;
  final String answer;
  bool learned;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.learned = false,
  });
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Flashcards',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const FlashcardsHome(),
    );
  }
}

class FlashcardsHome extends StatefulWidget {
  const FlashcardsHome({Key? key}) : super(key: key);

  @override
  State<FlashcardsHome> createState() => _FlashcardsHomeState();
}

class _FlashcardsHomeState extends State<FlashcardsHome> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  List<Flashcard> _cards = [];
  int _initialTotal = 0; // tracks size of current quiz set when loaded
  int _learnedCount = 0;

  // track expanded states by id so expansion survives rebuilds
  final Set<String> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    _loadNewSet(animated: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Generates a sample set of flashcards
  List<Flashcard> _generateSampleSet(int count) {
    final rnd = Random();
    return List.generate(count, (i) {
      final id = DateTime.now().microsecondsSinceEpoch.toString() + '_${i}_${rnd.nextInt(9999)}';
      return Flashcard(
        id: id,
        question: 'Question ${i + 1}: What is ${i + 1} + ${i + 2}?',
        answer: '${(i + 1) + (i + 2)}',
      );
    });
  }

  Future<void> _loadNewSet({bool animated = true}) async {
    final newSet = _generateSampleSet(10);

    // If no animation requested, just set state
    if (!animated) {
      setState(() {
        _cards = newSet;
        _initialTotal = _cards.length;
        _learnedCount = 0;
        _expandedIds.clear();
      });
      return;
    }

    // Animate removal of existing items
    final oldLength = _cards.length;
    for (int i = oldLength - 1; i >= 0; i--) {
      final removed = _cards.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: _buildCardTile(removed, i),
        ),
        duration: const Duration(milliseconds: 250),
      );
      await Future.delayed(const Duration(milliseconds: 40));
    }

    // Small delay to allow removals to finish
    await Future.delayed(const Duration(milliseconds: 200));

    // Insert new items
    setState(() {
      _cards = [];
      _initialTotal = newSet.length;
      _learnedCount = 0;
      _expandedIds.clear();
    });

    for (int i = 0; i < newSet.length; i++) {
      _cards.insert(i, newSet[i]);
      _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 250));
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Widget _buildCardTile(Flashcard card, int index) {
    final isExpanded = _expandedIds.contains(card.id);
    return Card(
      key: ValueKey(card.id),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Dismissible(
        key: ValueKey('dismiss_${card.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.green,
          child: const Icon(Icons.check, color: Colors.white),
        ),
        onDismissed: (_) => _markAsLearned(index),
        child: InkWell(
          onTap: () {
            setState(() {
              if (isExpanded) _expandedIds.remove(card.id);
              else _expandedIds.add(card.id);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        card.question,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (card.learned)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Learned', style: TextStyle(fontSize: 12)),
                      ),
                    const SizedBox(width: 8),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text('Answer: ${card.answer}', style: const TextStyle(fontSize: 15)),
                  ),
                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _markAsLearned(int index) {
    if (index < 0 || index >= _cards.length) return;
    final removedCard = _cards.removeAt(index);
    setState(() {
      removedCard.learned = true;
      _learnedCount += 1;
      _expandedIds.remove(removedCard.id);
    });

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _buildCardTile(removedCard, index),
      ),
      duration: const Duration(milliseconds: 300),
    );

    // Show a Snackbar with undo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked "${removedCard.question}" as learned.'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Undo: insert back at index
            _cards.insert(index, removedCard);
            setState(() {
              _learnedCount = (_learnedCount - 1).clamp(0, _initialTotal);
            });
            _listKey.currentState?.insertItem(index, duration: const Duration(milliseconds: 250));
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadNewSet(animated: true);
  }

  void _addNewCard() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final qCtl = TextEditingController();
        final aCtl = TextEditingController();
        return AlertDialog(
          title: const Text('Add new flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: qCtl,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              TextField(
                controller: aCtl,
                decoration: const InputDecoration(labelText: 'Answer'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                final q = qCtl.text.trim();
                final a = aCtl.text.trim();
                if (q.isEmpty || a.isEmpty) return;
                final newCard = Flashcard(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  question: q,
                  answer: a,
                );
                Navigator.of(context).pop();

                // Insert at top of list with animation
                _cards.insert(0, newCard);
                _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 300));
                setState(() {
                  _initialTotal += 1;
                });

                // Scroll to top so user sees the inserted item
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressText = '$_learnedCount of $_initialTotal learned';

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Flashcards Quiz'),
                    Text(progressText, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade400, Colors.indigo.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _onRefresh(),
                  tooltip: 'Load new quiz set',
                ),
              ],
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _cards.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index, animation) {
              final card = _cards[index];
              return SizeTransition(
                sizeFactor: animation,
                child: _buildCardTile(card, index),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        tooltip: 'Add new flashcard',
        child: const Icon(Icons.add),
      ),
    );
  }
}
