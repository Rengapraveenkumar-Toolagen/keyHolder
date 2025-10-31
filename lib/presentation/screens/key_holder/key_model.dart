class KeyModel {
  final int id;
  final String name;
  final String imgUrl;

  KeyModel({
    required this.id,
    required this.name,
    required this.imgUrl,
  });

  factory KeyModel.fromJson(Map<String, dynamic> json) {
    return KeyModel(
      id: json['id'],
      name: json['name'],
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
    };
  }
}