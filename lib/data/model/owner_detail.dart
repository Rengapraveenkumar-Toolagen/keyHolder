import 'dart:convert';

class Owner {
  String? userId;
  String? userName;

  Owner({this.userId, this.userName});

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      userId: map['userId'],
      userName: map['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
    };
  }

  factory Owner.fromJson(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);
}
