import 'package:flutter/material.dart';
import 'package:tugas_5/models/note.dart';
import 'package:tugas_5/screens/note_detail.dart';
import 'package:tugas_5/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      noteList = <Note>[];
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NoteKeeper',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo[800],
        elevation: 0,
        centerTitle: true,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Note',
        backgroundColor: Colors.indigo[800],
        elevation: 8.0,
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black.withAlpha((0.1 * 255).toInt()),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[position].priority),
              child: getPriorityIcon(noteList[position].priority),
            ),
            title: Text(noteList[position].title, style: titleStyle),
            subtitle: Text(
              noteList[position].date,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.redAccent),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              navigateToDetail(noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red[400]!;
      case 2:
        return Colors.orange[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.warning_amber_rounded, color: Colors.white);
      case 2:
        return Icon(Icons.info_outline_rounded, color: Colors.white);
      default:
        return Icon(Icons.more_horiz_rounded, color: Colors.white);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetail(note, title)),
    );

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
