import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/note.dart';
import 'package:todo_app/utils/database_helper.dart';

class NotePage extends StatefulWidget {
  final String noteState;
  final Note editNote;
  NotePage({this.noteState, this.editNote});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> _allCategories;
  DatabaseHelper _databaseHelper;
  int categoryId;
  int precedenceId;
  static var _notePrecedence = ["Low", "Medium", "High"];
  String noteTitle, noteContent;
  var hasCategoryData;
  //int notePrecedence;

  @override
  void initState() {
    super.initState();
    _allCategories = List<Category>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.getAllCategories().then((allCategoriesMap) {
      for (var item in allCategoriesMap) {
        _allCategories.add(Category.fromMap(item));
      }
      if (widget.editNote != null) {
        categoryId = widget.editNote.categoryId;
        precedenceId = widget.editNote.notePrecedence;
      } else {
        _allCategories.length == 0
            ? hasCategoryData = false
            : hasCategoryData = true;
        precedenceId = 0;
        categoryId =
            _allCategories.length != 0 ? _allCategories[0].categoryId : 1;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasCategoryData == false
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                widget.noteState,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 21.0,
                ),
              ),
            ),
            body: Center(
              child: Text(
                "Please add a category !",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 36.0,
                ),
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                widget.noteState,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 21.0,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: _allCategories.length == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 8.0),
                                  child: Text(
                                    "Select Category : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.indigo,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(16.0),
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.indigoAccent,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      items: _getAllCategoryItem(),
                                      onChanged: (selectedCategoryId) {
                                        setState(() {
                                          categoryId = selectedCategoryId;
                                        });
                                      },
                                      value: categoryId,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: widget.editNote != null
                                    ? widget.editNote.noteTitle
                                    : "",
                                validator: (noteTitleData) {
                                  if (noteTitleData.isEmpty) {
                                    return "Note title is must area !";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (noteTitleData) {
                                  noteTitle = noteTitleData;
                                },
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.title),
                                  labelText: "Note Title",
                                  labelStyle: TextStyle(fontSize: 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: widget.editNote != null
                                    ? widget.editNote.noteContent
                                    : "",
                                onSaved: (noteContentData) {
                                  noteContent = noteContentData;
                                },
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.content_paste),
                                  labelText: "Note Content",
                                  labelStyle: TextStyle(fontSize: 20.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 8.0),
                                  child: Text(
                                    "Select Note Precedence : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.indigo,
                                        fontSize: 18.0),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(16.0),
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.indigoAccent,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      items:
                                          _notePrecedence.map((precedenceData) {
                                        return DropdownMenuItem<int>(
                                          child: Text(
                                            precedenceData,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          value: _notePrecedence
                                              .indexOf(precedenceData),
                                        );
                                      }).toList(),
                                      onChanged: (selectedPrecedenceId) {
                                        setState(() {
                                          precedenceId = selectedPrecedenceId;
                                        });
                                      },
                                      value: precedenceId,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.blueGrey.shade400,
                                  child: Text(
                                    "CANCEL",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if (widget.editNote == null) {
                                        var currentDate = DateTime.now();
                                        _databaseHelper
                                            .insertNote(
                                          Note(
                                            categoryId,
                                            noteTitle,
                                            noteContent,
                                            currentDate.toString(),
                                            precedenceId,
                                          ),
                                        )
                                            .then((dbResult) {
                                          if (dbResult > 0) {
                                            showSnackBar(
                                                "Note Saving Successful...",
                                                true);
                                          } else {
                                            showSnackBar(
                                                "Note Saving Failed !", false);
                                          }
                                        });
                                      } else {
                                        var currentDate = DateTime.now();
                                        _databaseHelper
                                            .updateNote(
                                          Note.withIds(
                                            widget.editNote.noteId,
                                            categoryId,
                                            noteTitle,
                                            noteContent,
                                            currentDate.toString(),
                                            precedenceId,
                                          ),
                                        )
                                            .then((dbResult) {
                                          if (dbResult > 0) {
                                            showSnackBar(
                                                "Note Updated Successful...",
                                                true);
                                          } else {
                                            showSnackBar(
                                                "Note Updated Failed !", false);
                                          }
                                        });
                                      }
                                    }
                                  },
                                  color: Colors.blueGrey.shade600,
                                  child: Text(
                                    "SAVE NOTE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          );
  }

  List<DropdownMenuItem<int>> _getAllCategoryItem() {
    return _allCategories
        .map((categoryItem) => DropdownMenuItem<int>(
              value: categoryItem.categoryId,
              child: Text(
                categoryItem.categoryName,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ))
        .toList();
  }

  showSnackBar(String message, bool state) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: state == true ? Colors.greenAccent : Colors.redAccent,
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
    ));
  }
}
