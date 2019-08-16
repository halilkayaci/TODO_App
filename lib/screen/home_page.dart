import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/screen/categories_page.dart';
import 'package:todo_app/screen/show_notes.dart';
import 'package:todo_app/utils/database_helper.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String categoryName;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            "TODO List",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 21.0,
            ),
          ),
        ),
        actions: <Widget>[_showPopUpMenu()],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Add Category",
            tooltip: "Add Category",
            onPressed: _addCategoryDialog,
            elevation: 8.0,
            child: Icon(
              Icons.category,
              size: 22.0,
            ),
            mini: true,
          ),
          FloatingActionButton(
            heroTag: "Add Note",
            tooltip: "Add Note",
            onPressed: _goToNotePage,
            elevation: 8.0,
            child: Icon(
              Icons.note_add,
              size: 32.0,
            ),
          ),
        ],
      ),
      body: ShowNotes(),
    );
  }

  _showPopUpMenu() {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        size: 32.0,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.indigoAccent,
              ),
              title: Text(
                "Categories",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.indigoAccent,
                  fontSize: 18.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _goToCategoriesPage();
              },
            ),
          ),
        ];
      },
    );
  }

  _goToCategoriesPage() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoriesPage(),
        ),
      );

  _goToNotePage() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotePage(
            noteState: "New Note",
          ),
        ),
      );

  _addCategoryDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Add Category",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.indigo,
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  onSaved: (categoryNameData) {
                    categoryName = categoryNameData;
                  },
                  decoration: InputDecoration(
                      labelText: "Category Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                  validator: (categoryNameData) {
                    if (categoryNameData.isEmpty) {
                      return "Category name is must area !";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.indigo.shade100,
                  child: Text("CANCEL"),
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      databaseHelper
                          .insertCategory(Category(categoryName))
                          .then((dbResult) {
                        if (dbResult > 0) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Registration Successful...",
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0),
                            ),
                            duration: Duration(seconds: 3),
                          ));
                        } else {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Registration Failed !",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0),
                            ),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      });
                    }
                  },
                  color: Colors.indigoAccent.shade100,
                  child: Text("ADD"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
