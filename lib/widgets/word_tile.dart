import 'package:flutter/material.dart';
import '../models/word.dart';

class WordTile extends StatelessWidget {
  final Word word;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WordTile({
    super.key,
    required this.word,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.abc_rounded,
                color: colorScheme.tertiary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    word.translation,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_rounded, color: colorScheme.primary, size: 20),
              onPressed: onEdit,
              tooltip: 'Tahrirlash',
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 20),
              onPressed: onDelete,
              tooltip: "O'chirish",
            ),
          ],
        ),
      ),
    );
  }
}
