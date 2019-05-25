import 'package:sqflite/sqflite.dart';

final String userTable = "user";
final String _id = "id";
final String _userId = "user_id";
final String _name = "name";
final String _age = "age";
final String _password = "password";
final String _quote = "quote";

class User {
  int id;
  String user_id;
  String name;
  String age;
  String password;
  String quote;

  User();

  User.formMap(Map<String, dynamic> map) {
    this.id = map[_id];
    this.user_id = map[_userId];
    this.name = map[_name];
    this.age = map[_age];
    this.password = map[_password];
    this.quote = map[_quote];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _userId: user_id,
      _name: name,
      _age: age,
      _password: password,
      _quote: quote,
    };
    if (id != null) {
      map[_id] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'id: ${this.id}, user_id: ${this.user_id}, name: ${this.name}, age: ${this.age}, password: ${this.password}, quote: ${this.quote}';
  }
}

class UserProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $userTable (
        $_id integer primary key autoincrement,
        $_userId text not null unique,
        $_name text not null,
        $_age text not null,
        $_password text not null,
        $_quote text
      )
      ''');
    });
  }

  Future<User> insertUser(User user) async {
    user.id = await db.insert(userTable, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(userTable,
        columns: [_id, _userId, _name, _age, _password, _quote],
        where: '$_id = ?',
        whereArgs: [id]);
    maps.length > 0 ? new User.formMap(maps.first) : null;
  }

  Future<int> delUser(int id) async {
    return await db.delete(userTable, where: '$_id = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    return db.update(userTable, user.toMap(),
        where: '$_id = ?', whereArgs: [user.id]);
  }

  Future<List<User>> getAll() async {
    await this.open("user.db");
    var res = await db.query(userTable,
        columns: [_id, _userId, _name, _age, _password, _quote]);
    List<User> userList =
        res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();
}

class CurrentUser {
    static int ID;
    static var USERID;
    static var NAME;
    static var AGE;
    static var PASSWORD;
    static var QUOTE;

    static String whoCurrent(){
      return "current -> _id: ${ID}, userid: ${USERID}, name: ${NAME}, age: ${AGE}, password: ${PASSWORD}, quote: ${QUOTE}";
   }
}