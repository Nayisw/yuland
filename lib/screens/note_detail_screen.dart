import 'package:flutter/material.dart';
import 'package:yuland/models/note_model.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final String category; // Add the 'category' parameter

  NoteDetailScreen({required this.note, required this.category});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}


class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the edited note and send it back to the previous screen.
                Note updatedNote = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  date: widget.note.date,
                  category: widget.category,
                );
                Navigator.pop(context, updatedNote);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
