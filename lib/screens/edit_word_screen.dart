import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../l10n/locale_provider.dart';
import '../models/word.dart';

class EditWordScreen extends StatefulWidget {
  final Word word;
  const EditWordScreen({super.key, required this.word});

  @override
  State<EditWordScreen> createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _wordController.text = widget.word.word;
    _translationController.text = widget.word.translation;
  }

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_wordController.text.trim().isEmpty ||
        _translationController.text.trim().isEmpty) {
      return;
    }
    await DatabaseHelper.instance.updateWord(
      Word(
        id: widget.word.id,
        word: _wordController.text.trim(),
        translation: _translationController.text.trim(),
        groupId: widget.word.groupId,
      ),
    );
    if (!mounted) return;
    Navigator.pop(context);
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
          s.editWord,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _wordController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: s.word,
                hintText: s.wordHint,
                prefixIcon: const Icon(Icons.translate_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _translationController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: s.translation,
                hintText: s.translationHint,
                prefixIcon: const Icon(Icons.spellcheck_rounded),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded),
              label: Text(s.save),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(s.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
