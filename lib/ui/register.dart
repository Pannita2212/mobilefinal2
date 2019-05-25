import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import '../model/db.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  List<TextEditingController> txtControl = [
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
  ];
  final _formKey = GlobalKey<FormState>();
  bool chk = false;
  UserProvider user = UserProvider();

  bool exist = false;

  int space(String val) {
    int _temp = 0;
    for (int i = 0; i < val.length; i++) {
      if (val[i] == ' ') {
        _temp += 1;
      }
    }
    return _temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.fromLTRB(35, 15, 35, 10),
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: txtControl[0],
                    decoration: InputDecoration(
                      hintText: "User Id",
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุ User Id";
                      } else if (value.compareTo("admin") == 0) {
                        chk = true;
                      } else if (value.length < 6 || value.length > 12) {
                        return "User Id ต้องอยู่ระหว่าง 6-12 ตัวอักษร";
                        chk = false;
                      } else {
                        chk = false;
                      }
                    },
                  ),
                  TextFormField(
                    controller: txtControl[1],
                    decoration: InputDecoration(
                      hintText: "Name",
                      prefixIcon: Icon(Icons.portrait),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุ Name";
                      } else if (space(value) != 1) {
                        return "ต้องมี space คั่นกลางระหว่างชื่อ-สกุล";
                      } else {
                        chk = false;
                      }
                    },
                  ),
                  TextFormField(
                    controller: txtControl[2],
                    decoration: InputDecoration(
                      hintText: "Age",
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุ Age";
                      }
                      if (isNumeric(value) == false) {
                        return "Age ต้องเป็นตัวเลข";
                        chk = false;
                      }
                      if (int.parse(value) < 10 || int.parse(value) > 80) {
                        return "Age ต้องอยู่ในช่วง 10-80";
                      } else {
                        chk = false;
                      }
                    },
                  ),
                  TextFormField(
                    controller: txtControl[3],
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาใส่ password";
                      } else if (value.length <= 6) {
                        return "Password ต้อง > 6";
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(40, 20, 30, 0),
                    child: RaisedButton(
                      child: Text("REGISTER NEW ACCOUNT"),
                      onPressed: () async {
                        
                          await user.open("user.db");
                          User userData = User();
                          userData.user_id = txtControl[0].text;
                          userData.name = txtControl[1].text;
                          userData.age = txtControl[2].text;
                          userData.password = txtControl[3].text;
                          Future<List<User>> allUser = user.getAll();

                          Future temp(User user) async {
                            var _list = await allUser;
                            for (var i = 0; i < _list.length; i++) {
                              if (user.user_id == _list[i].user_id) {
                                this.exist = true;
                                break;
                              }
                            }
                          }

                          await temp(userData);
                          if (_formKey.currentState.validate()) {
                            if (await !this.exist) {
                              txtControl[0].text = "";
                              txtControl[1].text = "";
                              txtControl[2].text = "";
                              txtControl[3].text = "";
                              await user.insertUser(userData);
                              Navigator.pop(context);
                            }
                          }this.exist = false;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
