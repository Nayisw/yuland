import 'package:flutter/material.dart';
import 'package:yuland/screens/notes_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yuland Notes',
      debugShowCheckedModeBanner: false,
      home: NotesScreen(),
    );
  }
}
