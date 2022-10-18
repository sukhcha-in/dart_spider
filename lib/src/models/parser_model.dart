import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/models/optional_model.dart';

class Parser {
  String id;
  List<String> parent;
  bool isPrivate = true;
  ParserType type;
  dynamic selector;
  bool multiple = false;
  AbstractOptional? optional;

  Parser({
    required this.id,
    required this.parent,
    required this.type,
    this.selector = "",
    this.isPrivate = false,
    this.multiple = false,
    this.optional,
  });

  factory Parser.fromMap(Map<String, dynamic> map) {
    return Parser(
      id: map['id'],
      parent: map['parent'].cast<String>(),
      isPrivate: map['is_private'],
      type: map['type'],
      selector: map['selector'] ?? "",
      multiple: map['multiple'] ?? false,
      optional: map['optional'],
    );
  }
}
