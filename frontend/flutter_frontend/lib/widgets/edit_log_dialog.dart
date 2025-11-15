// lib/widgets/edit_log_dialog.dart
import 'package:flutter/material.dart';

import '../constants/workout_categories.dart';

class EditLogResult {
  EditLogResult({
    required this.content,
    required this.category,
  });

  final String content;
  final String category;
}

class EditLogDialog extends StatefulWidget {
  const EditLogDialog({
    super.key,
    required this.initialContent,
    required this.initialCategory,
  });

  final String initialContent;
  final String initialCategory;

  @override
  State<EditLogDialog> createState() => _EditLogDialogState();
}

class _EditLogDialogState extends State<EditLogDialog> {
  late TextEditingController _controller;
  late String _category;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
    _category = widget.initialCategory.isEmpty
        ? workoutCategories.last
        : widget.initialCategory;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit log'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _category = value;
              });
            },
            items: workoutCategories
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            EditLogResult(
              content: _controller.text.trim(),
              category: _category,
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}