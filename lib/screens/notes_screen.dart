import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yuland/models/note_model.dart';
import 'package:yuland/screens/note_detail_screen.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
  final String selectedCategory;

  NotesScreen({required this.selectedCategory});
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late TabController _tabController;
  final DateFormat _dateFormatter = DateFormat('dd MMM');
  // final DateFormat _timeFormatter = DateFormat('h:mm');
  TextEditingController _noteTitleController = TextEditingController();
  TextEditingController _noteContentController = TextEditingController();
  List<Note> _notes = [];

  final Map<String, int> categories = {
    'Notes': 0,
    'Work': 0,
    'Home': 0,
    'Complete': 0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  Widget _buildCategoryCard(int index, String title, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        height: 240.0,
        width: 175.0,
        decoration: BoxDecoration(
          color: _selectedCategoryIndex == index
              ? Color(0xFF417BFB)
              : Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            _selectedCategoryIndex == index
                ? BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 10.0)
                : BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                title,
                style: TextStyle(
                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Color(0xFFAFB4C6),
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Colors.black,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Delete the note when swiped from start to end
          _deleteNote(note);
        } else if (direction == DismissDirection.endToStart) {
          // Edit the note when swiped from end to start
          _viewOrEditNote(note);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width /
            2, // Customize the width as needed
        child: Card(
          margin: EdgeInsets.all(10.0), // Adjust margins as needed
          elevation: 2, // Add elevation for a shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Add rounded corners
          ),
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white, // Set the card background color
              borderRadius: BorderRadius.circular(8.0), // Match the shape
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 16.0, // Set the title font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 14.0, // Set the content font size
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  _dateFormatter.format(note.date),
                  style: TextStyle(
                    fontSize: 12.0, // Set the date font size
                    color: Colors.grey, // Set the date text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteNote(Note note) {
    setState(() {
      _notes.remove(note);
    });
    _updateCategoryCounts(); // Move this line out of setState
  }

  void _viewOrEditNote(Note note) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(
            note: note,
            category:
                note.category), // Pass the category to the NoteDetailScreen
      ),
    );

    if (updatedNote != null) {
      int noteIndex = _notes.indexWhere((element) => element == note);
      if (noteIndex != -1) {
        setState(() {
          _notes[noteIndex] = updatedNote;
        });
      }
      _updateCategoryCounts();
    }
  }

  void _addNote() {
    setState(() {
      String title = _noteTitleController.text;
      String content = _noteContentController.text;
      DateTime date = DateTime.now();

      String selectedCategory =
          categories.keys.toList()[_selectedCategoryIndex];
      Note newNote = Note(
        title: title,
        content: content,
        date: date,
        category: selectedCategory, // Assign the selected category to the note
      );
      _notes.add(newNote);
      _noteTitleController.clear();
      _noteContentController.clear();
      _updateCategoryCounts(); // Call _updateCategoryCounts to update the category counts
    });
  }

  void _updateCategoryCounts() {
    for (var category in categories.keys) {
      int count = _notes.where((note) => note.category == category).length;
      categories[category] = count;
    }
  }

  Widget _buildCategories() {
    List<Widget> categoryWidgets = [];

    for (int index = 0; index < categories.length; index++) {
      categoryWidgets.add(_buildCategoryCard(
        index,
        categories.keys.toList()[index],
        categories.values.toList()[index],
      ));
    }

    // Add a '+' icon for adding new notes
    categoryWidgets.add(
      GestureDetector(
        onTap: () {
          _addNote(); // Call the method to add a new note when the '+' icon is tapped.
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          height: 240.0,
          width: 175.0,
          decoration: BoxDecoration(
            color:
                Colors.green, // Change the color for the '+' icon as desired.
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [BoxShadow(color: Colors.transparent)],
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: 80.0, // Adjust the size of the '+' icon as desired.
              color:
                  Colors.white, // Change the color of the '+' icon as desired.
            ),
          ),
        ),
      ),
    );

    return Container(
      height: 280.0,
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(), // Change the physics here
        scrollDirection: Axis.horizontal,
        children: categoryWidgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 40.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/app_icon.png'),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(width: 20.0),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.0),
          _buildCategories(), // Use the custom _buildCategories widget for categories
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Color(0xFFAFB4C6),
              indicatorColor: Color(0xFF417BFB),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 4.0,
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Important',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Performed',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          // Display the list of notes
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              return _buildNoteCard(_notes[index]);
            },
          ),
        ],
      ),
    );
  }
}
