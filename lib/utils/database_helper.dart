import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database _db;

    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "todo.db");
          var file = new File(path);

          // check if file exists
          if (!await file.exists()) {
            // Copy from asset
            ByteData data =
                await rootBundle.load(join("assets/database", "todo.db"));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          // open the database
          _db = await openDatabase(path);
        }
      });
    }

    return _db;
  }

  // Category table CRUD operations
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    var _db = await _getDatabase();
    var dbResult = await _db.query("categories");
    return dbResult;
  }
  Future<List<Category>> getAllCategoriesAndToList() async {
    var _allCategoriesMap = await getAllCategories();
    var allCategoryList = List<Category>();
    for (var item in _allCategoriesMap) {
      allCategoryList.add(Category.fromMap(item));
    }
    return allCategoryList;
  }

  Future<int> insertCategory(Category category) async {
    var _db = await _getDatabase();
    var dbResult = await _db.insert("categories", category.toMap());
    return dbResult;
  }

  Future<int> updateCategory(Category category) async {
    var _db = await _getDatabase();
    var dbResult = await _db.update(
      "categories",
      category.toMap(),
      where: "categoryId = ? ",
      whereArgs: [category.categoryId],
    );
    return dbResult;
  }

  Future<int> deleteCategory(int categoryId) async {
    var _db = await _getDatabase();
    var dbResult = await _db.delete(
      "categories",
      where: "categoryId = ? ",
      whereArgs: [categoryId],
    );
    return dbResult;
  }

  //Notes table CRUD operations
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var _db = await _getDatabase();
    var dbResult = await _db.rawQuery(
        "SELECT * FROM notes INNER JOIN categories ON categories.categoryId = notes.categoryId;");
    return dbResult;
  }

  Future<List<Note>> getAllNotesAndToList() async {
    var _allNotesMap = await getAllNotes();
    var allNoteList = List<Note>();
    for (var item in _allNotesMap) {
      allNoteList.add(Note.fromMap(item));
    }
    return allNoteList;
  }

  Future<int> insertNote(Note note) async {
    var _db = await _getDatabase();
    var dbResult = await _db.insert("notes", note.toMap());
    return dbResult;
  }

  Future<int> updateNote(Note note) async {
    var _db = await _getDatabase();
    var dbResult = await _db.update(
      "notes",
      note.toMap(),
      where: "noteId = ? ",
      whereArgs: [note.noteId],
    );
    return dbResult;
  }

  Future<int> deleteNote(int noteId) async {
    var _db = await _getDatabase();
    var dbResult = await _db.delete(
      "notes",
      where: "noteId = ? ",
      whereArgs: [noteId],
    );
    return dbResult;
  }

  // noteDate operatiion
  String dateFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
