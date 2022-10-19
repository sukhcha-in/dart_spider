import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/models/optional_model.dart';

/// Definition of a parser.
class Parser {
  /// ID to store value of result.
  String id;

  /// List of parent IDs to tell parser when to trigger, base value is _root.
  List<String> parent;

  /// Keep result of this parser private, just for internal use.
  bool isPrivate = true;

  /// Parser type.
  ParserType type;

  /// CSS Selector for this parser.
  dynamic selector;

  /// If result can contain multiple results as a List. Default is false.
  bool multiple = false;

  /// Optional parameters.
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
