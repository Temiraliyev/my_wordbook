import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../l10n/locale_provider.dart';
import '../models/group.dart';
import '../models/word.dart';

class TestScreen extends StatefulWidget {
  final Group group;
  const TestScreen({super.key, required this.group});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Word> _words = [];
  int _index = 0;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await DatabaseHelper.instance.getWordsByGroup(
      widget.group.id!,
    );
    setState(() => _words = words);
  }

  void _next() {
    if (_index < _words.length - 1) {
      setState(() {
        _index++;
        _showTranslation = false;
      });
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _showTranslation = false;
      });
    }
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
      body: _words.isEmpty
          ? _buildEmptyState(context, s)
          : _buildTestBody(context, s),
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.quiz_rounded,
                size: 52,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              s.testNoWords,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              s.testNoWordsDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(s.goBack),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestBody(BuildContext context, s) {
    final colorScheme = Theme.of(context).colorScheme;
    final word = _words[_index];
    final isLast = _index == _words.length - 1;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_words.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _index
                      ? colorScheme.primary
                      : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '${_index + 1} / ${_words.length}',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  setState(() => _showTranslation = !_showTranslation),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      word.word,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _showTranslation
                          ? Column(
                              key: const ValueKey('shown'),
                              children: [
                                Divider(
                                  indent: 40,
                                  endIndent: 40,
                                  color: Colors.grey.shade200,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  word.translation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              key: const ValueKey('hidden'),
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                s.tapToReveal,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _index > 0 ? _prev : null,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: Text(s.prev),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isLast
                    ? FilledButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check_rounded),
                        label: Text(s.finish),
                      )
                    : FilledButton.icon(
                        onPressed: _next,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(s.next),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
