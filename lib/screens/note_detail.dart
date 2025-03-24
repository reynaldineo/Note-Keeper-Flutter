import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_5/models/note.dart';
import 'package:tugas_5/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail(this.note, this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() => NoteDetailState();
}

class NoteDetailState extends State<NoteDetail> {
  static final _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  late String appBarTitle;
  late Note note;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    appBarTitle = widget.appBarTitle;
    note = widget.note;

    titleController = TextEditingController(text: note.title);
    descriptionController = TextEditingController(text: note.description);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        moveToLastScreen();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.indigo[800],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              //* Priority Dropdown
              ListTile(
                title: DropdownButton<String>(
                  isExpanded: true,
                  items:
                      _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem, style: textStyle),
                        );
                      }).toList(),
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser!);
                    });
                  },
                ),
              ),

              //* Title TextField
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle.copyWith(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.indigo, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.indigoAccent,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                  ),
                ),
              ),

              //* Description TextField
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    updateDescription();
                  },
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle.copyWith(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.indigo, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.indigoAccent,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                  ),
                ),
              ),

              //* Action Buttons (Save, Delete)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildActionButton(
                    text: 'Delete',
                    colorStart: Colors.redAccent,
                    colorEnd: Colors.red,
                    onPressed: () {
                      _delete();
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton(
                    text: 'Save',
                    colorStart: Colors.indigo[800]!,
                    colorEnd: Colors.indigoAccent,
                    onPressed: () {
                      _save();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a stylish action button
  Widget _buildActionButton({
    required String text,
    required Color colorStart,
    required Color colorEnd,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorStart, colorEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priorities[0]; // 'High'
      case 2:
        return _priorities[1]; // 'Low'
      default:
        return _priorities[1]; // 'Low' if an invalid value exists
    }
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    int result = await helper.deleteNote(note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occurred while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          backgroundColor:
              Colors.transparent, // Transparent background to apply gradient
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // White background for the dialog
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 10,
                  offset: Offset(0, 4), // Shadow effect
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0), // Padding inside the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min, // Size the dialog to the content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800], // Dark indigo color for title
                  ),
                ),
                const SizedBox(height: 12), // Space between title and message
                // Message Text
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Colors.black87, // Slightly muted black for description
                    height: 1.5, // Line height for better readability
                  ),
                ),
                const SizedBox(height: 20), // Space between message and button
                // Action Button
                Align(
                  alignment: Alignment.centerRight, // Align button to the right
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo, // Indigo button background
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ), // Rounded button
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text for contrast
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
