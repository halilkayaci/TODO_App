import 'package:flutter/material.dart';
import 'package:todo_app/screen/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO App',
      theme: ThemeData(
        fontFamily: "Farro",
        primarySwatch: Colors.indigo,
        accentColor: Colors.indigoAccent,
      ),
      home: HomePage(),
    );
  }
}