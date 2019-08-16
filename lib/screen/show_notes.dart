import 'package:flutter/material.dart';
import 'package:todo_app/models/note.dart';
import 'package:todo_app/utils/database_helper.dart';
import 'note_page.dart';

class ShowNotes extends StatefulWidget {
  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  List<Note> _allNotes;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    _allNotes = List<Note>();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.getAllNotesAndToList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _allNotes = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: _getPrecedenceIcon(_allNotes[index].notePrecedence),
                title: Text(
                  _allNotes[index].noteTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                    fontSize: 22.0,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  size: 32.0,
                ),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Category : ",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.amber.shade900,
                                fontSize: 21.0,
                              ),
                            ),
                            Text(
                              _allNotes[index].categoryName,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.red,
                                fontSize: 21.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Creation Date : ",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.red,
                                fontSize: 21.0,
                              ),
                            ),
                            Text(
                              databaseHelper.dateFormat(
                                  DateTime.parse(_allNotes[index].noteDate)),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.amber.shade900,
                                fontSize: 21.0,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Note Content :",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                              color: Colors.lightBlue,
                              fontSize: 21.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            _allNotes[index].noteContent,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w800,
                              color: Colors.blue.shade800,
                              fontSize: 21.0,
                            ),
                          ),
                        ),
                        _buildUpdateDeleteButtonBar(index)
                      ],
                    ),
                  ),
                ],
              );
            },
            itemCount: _allNotes.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _getPrecedenceIcon(int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/low.png"),
          ),
        );
        break;
      case 1:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/medium.png"),
          ),
        );
        break;
      case 2:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/high.png"),
          ),
        );
        break;
    }
  }

  _buildUpdateDeleteButtonBar(int index) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: () => _deleteNote(_allNotes[index].noteId),
          child: Text(
            "DELETE",
            style: TextStyle(
              color: Colors.red.shade900,
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
        ),
        FlatButton(
          onPressed: () => _updateNote(_allNotes[index]),
          child: Text(
            "UPDATE",
            style: TextStyle(
              color: Colors.green.shade900,
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
        ),
      ],
    );
  }

  _deleteNote(int index) {
    databaseHelper.deleteNote(index).then((deletedNoteId) {
      if (deletedNoteId != 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "Note Deleted",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
            ),
          ),
        ));
        setState(() {});
      }
    });
  }

  _updateNote(Note note) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotePage(
            noteState: "Update Note",
            editNote: note,
          ),
        ),
      );
}
