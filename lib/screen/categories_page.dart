import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/utils/database_helper.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> _allCategories;
  DatabaseHelper databaseHelper;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (_allCategories == null) {
      _allCategories = List<Category>();
      _getAllCategories();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 21.0,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _allCategories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8.0,
            color: Colors.indigoAccent.shade100,
            child: ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.indigoAccent,
                size: 28.0,          
              ),
              title: Text(
                _allCategories[index].categoryName,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 19.0,
                ),
              ),
              trailing: InkWell(
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 32.0,
                ),
                onTap: () => _deleteCategory(_allCategories[index].categoryId),
              ),
              onTap: () => _updateCategory(_allCategories[index]),
            ),
          );
        },
      ),
    );
  }

  _updateCategory(Category category) {
    _updateCategoryDialog(category);
  }

  _deleteCategory(int categoryId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "DELETE CATEGORY",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.indigo,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "When you delete a category, all notes will be deleted.\n\n Are you sure ?",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      databaseHelper
                          .deleteCategory(categoryId)
                          .then((dbResult) {
                        if (dbResult > 0) {
                          setState(() {
                            _getAllCategories();
                            Navigator.pop(context);
                          });
                        }
                      });
                    },
                    color: Colors.indigoAccent.shade100,
                    child: Text("DELETE ANYWAY"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _getAllCategories() {
    databaseHelper.getAllCategoriesAndToList().then((categoryListData) {
      setState(() {
        _allCategories = categoryListData;
      });
    });
  }

  _updateCategoryDialog(Category category) {
    var _formKey = GlobalKey<FormState>();
    String newCategoryName;

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Update Category Name",
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
                  initialValue: category.categoryName,
                  onSaved: (categoryNameData) {
                    newCategoryName = categoryNameData;
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
                          .updateCategory(
                        Category.withId(
                          category.categoryId,
                          newCategoryName,
                        ),
                      )
                          .then((dbResult) {
                        if (dbResult > 0) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Update Successful...",
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0),
                            ),
                            duration: Duration(seconds: 3),
                          ));
                          _getAllCategories();
                        } else {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Update Failed !",
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
                  child: Text("UPDATE"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
