import 'dart:convert';
import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/parsers/json_parser.dart';

import '../models/parser_model.dart';

dynamic jsonTableParser(Parser parser, dynamic dom) {
  dynamic json;
  if (dom is String) {
    try {
      json = jsonDecode(dom);
    } catch (_) {
      return null;
    }
  } else {
    json = dom;
  }

  try {
    Map<String, dynamic> result = {};
    var parsed = jsonParser(parser, json);
    if (parsed is List) {
      for (final p in parsed) {
        var key = jsonParser(
          Parser(
            id: "key",
            parent: ["parent"],
            type: ParserType.json,
            selector: parser.optional!.keys!,
          ),
          p,
        );
        var val = jsonParser(
          Parser(
            id: "val",
            parent: ["parent"],
            type: ParserType.json,
            selector: parser.optional!.values!,
          ),
          p,
        );
        if (key != null && val != null) {
          if (key is List && val is List && key.length == val.length) {
            for (var i = 0; i < key.length; i++) {
              result.addAll({key[i]: val[i]});
            }
          } else {
            result.addAll({key: val});
          }
        }
      }
      return result;
    }
    return null;
  } catch (e) {
    return null;
  }
}
