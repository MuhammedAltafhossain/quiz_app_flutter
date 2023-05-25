import 'dart:developer';

class UserModel {
  late String? id;
  late String? userName;
  late String? email;
  late String? type;

  UserModel({this.id, this.userName, this.email, this.type});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': userName,
      'email': email,
      'type': type,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': userName,
      'email': email,
      'type': type,
    };
  }

}

