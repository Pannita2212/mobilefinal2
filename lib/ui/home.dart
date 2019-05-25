import 'package:flutter/material.dart';
import '../model/db.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  int tmp = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home",),centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            ListTile(
              title: Text('Hello ${CurrentUser.NAME}'),
              subtitle: Text('this is my quote "${CurrentUser.QUOTE != null ? CurrentUser.QUOTE == '' ? 'ยังไม่มีการระบุข้อมูล' : CurrentUser.QUOTE : 'ยังไม่มีการระบุข้อมูล'}"'),
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed('/friend');
                Navigator.of(context).pushNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                CurrentUser.USERID = null;
                CurrentUser.NAME = null;
                CurrentUser.AGE = null;
                CurrentUser.PASSWORD = null;
                CurrentUser.QUOTE = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}