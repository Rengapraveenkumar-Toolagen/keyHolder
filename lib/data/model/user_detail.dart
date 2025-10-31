import 'dart:convert';

class UserDetail {
  String? id;
  String? userName;
  String? email;
  String? phoneNumber;
  bool? isAdmin;
  bool? pushNotification;
  bool? emailNotification;
  bool isSelected = false;

  UserDetail(this.id, this.userName, this.email, this.phoneNumber, this.isAdmin,
      this.pushNotification, this.emailNotification,
      {this.isSelected = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'isAdmin': isAdmin,
      'pushNotification': pushNotification,
      'emailNotification': emailNotification,
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
      map['id'],
      map['userName'],
      map['email'],
      map['phoneNumber'],
      map['isAdmin'] == null ? false : map['isAdmin'] as bool,
      map['pushNotification'] == null ? false : map['pushNotification'] as bool,
      map['emailNotification'] == null
          ? false
          : map['emailNotification'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetail.fromJson(String source) =>
      UserDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
