import 'package:flutter/material.dart';
import './ui/login.dart';
import './ui/register.dart';
import './ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(183, 28, 28, 1.0)
      ),
      // home: MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => LogIn(),
        '/register': (context) => Register(),
        '/home': (context) => Home(),
        // '/login': (context) => LogIn()
      },
    );
  }
}