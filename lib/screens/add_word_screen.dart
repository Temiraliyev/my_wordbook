import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../l10n/locale_provider.dart';
import '../models/group.dart';
import '../models/word.dart';
import '../widgets/word_tile.dart';
import 'edit_word_screen.dart';

class AddWordScreen extends StatefulWidget {
  final Group group;
  const AddWordScreen({super.key, required this.group});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  List<Word> _words = [];
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();
  final _wordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _wordFocus.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    final words = await DatabaseHelper.instance.getWordsByGroup(
      widget.group.id!,
    );
    setState(() => _words = words);
  }

  void _addWord() async {
    if (_wordController.text.trim().isNotEmpty &&
        _translationController.text.trim().isNotEmpty) {
      await DatabaseHelper.instance.insertWord(
        Word(
          word: _wordController.text.trim(),
          translation: _translationController.text.trim(),
          groupId: widget.group.id!,
        ),
      );
      _wordController.clear();
      _translationController.clear();
      _wordFocus.requestFocus();
      _loadWords();
    }
  }

  void _editWord(Word word) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditWordScreen(word: word)),
    ).then((_) => _loadWords());
  }

  void _deleteWord(int id) async {
    await DatabaseHelper.instance.deleteWord(id);
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocaleProvider>().strings;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLowest,
        title: Text(
          widget.group.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _wordController,
                        focusNode: _wordFocus,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: s.word,
                          hintText: s.wordHint,
                          prefixIcon: const Icon(Icons.translate_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _translationController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addWord(),
                        decoration: InputDecoration(
                          labelText: s.translation,
                          hintText: s.translationHint,
                          prefixIcon: const Icon(Icons.spellcheck_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _addWord,
                  icon: const Icon(Icons.add),
                  label: Text(s.addWord),
                ),
              ],
            ),
          ),
          Expanded(
            child: _words.isEmpty
                ? _buildEmptyState(context, s)
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    itemCount: _words.length,
                    itemBuilder: (context, index) {
                      final w = _words[index];
                      return WordTile(
                        word: w,
                        onEdit: () => _editWord(w),
                        onDelete: () => _deleteWord(w.id!),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, s) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 40,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              s.noWords,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              s.noWordsDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
