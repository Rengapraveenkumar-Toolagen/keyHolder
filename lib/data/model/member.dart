import 'dart:convert';

class Member {
  String? projectMemberId;
  String? userId;
  String? userName;
  Member(
    this.projectMemberId,
    this.userId,
    this.userName,
  );

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      map['projectMemberId'],
      map['userId'],
      map['userName'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'projectMemberId': projectMemberId,
      'userId': userId,
      'userName': userName,
    };
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source));
}
