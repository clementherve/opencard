import 'dart:ui';

class CardModel {
  late Color backgroundColor;
  late Color foregroundColor;

  late String type;
  late String name;
  late String content;

  CardModel({
    required this.name,
    required this.type,
    required this.content,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  CardModel.fromJSON(Map<String, dynamic> json) {
    backgroundColor = Color(json['backgroundColor'] as int);
    foregroundColor = Color(json['foregroundColor'] as int);

    type = json['type'] as String;

    name = json['name'] as String;
    content = json['content'] as String;
  }

  Map<String, dynamic> toJSON() {
    return {
      'backgroundColor': backgroundColor.value,
      'foregroundColor': foregroundColor.value,
      'type': type,
      'name': name,
      'content': content,
    };
  }
}
