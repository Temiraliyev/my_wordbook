// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/group.dart';

class EditGroupScreen extends StatefulWidget {
  final Group group;
  const EditGroupScreen({super.key, required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.group.name;
  }

  void _save() async {
    await DatabaseHelper.instance.updateGroup(
      Group(id: widget.group.id, name: _nameController.text),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guruh nomini tahrirlash")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Guruh nomi"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text("Saqlash")),
          ],
        ),
      ),
    );
  }
}
