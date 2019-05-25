import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../model/db.dart';

class LogIn extends StatefulWidget {
  @override
  LogInState createState() {
    return LogInState();
  }
}

class LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  List<bool> chk = [false, false];
  List<TextEditingController> txtControl = [
    new TextEditingController(),
    new TextEditingController()
  ];
  UserProvider user = UserProvider();
  bool isValid = false;
  int formState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: Image.asset(
                    "resources/key.png",
                    height: 150,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 30, 0),
                  child: TextFormField(
                    controller: txtControl[0],
                    decoration: InputDecoration(
                      labelText: "User Id",
                      hintText: "Please input your user",
                      icon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุ user";
                      } else{
                        this.formState += 1;
                      }
                      // else if (value.compareTo("admin") == 0) {
                      //   chk[0] = true;
                      // }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 30, 0),
                  child: TextFormField(
                    controller: txtControl[1],
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Please input your password",
                      icon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุ password";
                      } 
                      // else if (value.compareTo("admin") == 0) {
                      //   chk[1] = true;
                      // }
                      else{
                        this.formState += 1;
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(60, 10, 30, 0),
                  child: RaisedButton(
                    color: Color.fromRGBO(183, 28, 23, 1.0),
                    textColor: Colors.white,
                    child: Text("LOGIN"),
                    onPressed: () async {
                      _formKey.currentState.validate();
                      await user.open("user.db");
                      Future<List<User>> allUser = user.getAll();

                      Future isUserValid(String userid, String password) async {
                        var userList = await allUser;
                        for (var i = 0; i < userList.length; i++) {
                          if (userid == userList[i].user_id &&
                              password == userList[i].password) {
                            CurrentUser.ID = userList[i].id;
                            CurrentUser.USERID = userList[i].user_id;
                            CurrentUser.NAME = userList[i].name;
                            CurrentUser.AGE = userList[i].age;
                            CurrentUser.PASSWORD = userList[i].password;
                            CurrentUser.QUOTE = userList[i].quote;
                            this.isValid = true;
                            print("this user valid");
                            break;
                          }
                        }
                      }

                      if (this.formState != 2) {
                        Toast.show("Please fill out this form", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                        this.formState = 0;  
                      } else {
                        this.formState = 0;
                        await isUserValid(txtControl[0].text, txtControl[1].text);


                        if (!this.isValid) {
                          Toast.show("Invalid user or password", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                          txtControl[0].text = "";
                          txtControl[1].text = "";
                        }
                      }

                      Future showAllUser() async {
                        var userList = await allUser;
                        for (var i = 0; i < userList.length; i++) {
                          print(userList[i]);
                        }
                      }
                      showAllUser();
                      print(CurrentUser.whoCurrent());

                      // if (!_formKey.currentState.validate()) {
                      //   Scaffold.of(context).showSnackBar(SnackBar(
                      //       content: Text("Please fill out this form")));
                      // } else if (chk[0] == true && chk[1] == false) {
                      //   Scaffold.of(context).showSnackBar(SnackBar(
                      //       content: Text("user or password ไม่ถูกต้อง")));
                      // } else if (chk[1] == true && chk[0] == false) {
                      //   Scaffold.of(context).showSnackBar(SnackBar(
                      //     content: Text("user or password ไม่ถูกต้อง"),
                      //   ));
                      // } else if (chk[1] == true && chk[0] == true) {
                      //   Navigator.pushNamed(context, "/home");
                      // } else {
                      //   Scaffold.of(context).showSnackBar(SnackBar(
                      //     content: Text("user or password ไม่ถูกต้อง"),
                      //   ));
                      // }
                      chk[0] = false;
                      chk[1] = false;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text("Register New Account"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
