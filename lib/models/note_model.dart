class Note {
  String title;
  String content;
  DateTime date;

  Note({required this.title, required this.content, required this.date});
}

final Map<String, int> categories = {
  'Notes': 112,
  'Work': 58,
  'Home': 23,
  'Complete': 31,
};

final List<Note> notes = [
  Note(
    title: 'Something.note',
    content: 'In velit dolore fugiat occaecat in elit sit veniam non enim laborum elit. Aliqua est qui sint incididunt amet minim magna anim aliqua. Excepteur veniam deserunt nulla excepteur velit quis fugiat reprehenderit ut velit voluptate. Ipsum anim ullamco consequat irure tempor labore consequat quis elit enim.',
    date: DateTime(2019, 10, 10, 8, 30),
  ),
  Note(
    title: 'Lorem Ipsum',
    content: 'Aliqua labore nostrud incididunt exercitation.',
    date: DateTime(2019, 10, 10, 8, 30),
  ),
];
