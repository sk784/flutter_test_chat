import 'package:data_model/data_model.dart';

class User implements Model<UserId> {
  UserId id;
  String name;
  String password;
  int phone;
  String email;
  bool isChecked = false;
  User({this.id, this.name, this.password,this.phone,this.email, this.isChecked});
  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
        id: UserId(json['id']), name: json['name'], password: json['password'],
        phone: json['phone'], email: json['email'], isChecked: json['isChecked']);
  }


  Map<String, dynamic> get json => {
        'id': id?.json,
        'name': name,
        'password': password,
        'phone': phone,
        'email': email,
        'isChecked': isChecked
      }..removeWhere((key, value) => value == null);
}

class UserId extends ObjectId {
  UserId._(id) : super(id);
  factory UserId(id) {
    if (id == null) return null;
    return UserId._(id);
  }
}
