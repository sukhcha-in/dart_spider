import 'dart:convert';

import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic jsonLdParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  List results = [];
  var selector = source.querySelectorAll('script[type="application/ld+json"]');
  if (selector.length > 0) {
    for (final s in selector) {
      var json = s.innerHtml.replaceAll("\n", "");
      json = json.replaceAll("\t", "");
      json = jsonDecode(json);
      String runtimeType = json.runtimeType.toString();
      if (runtimeType == '_InternalLinkedHashMap<String, dynamic>' ||
          runtimeType == '_JsonMap') {
        if (json["@graph"] != null) {
          results.addAll(json["@graph"]);
        } else {
          results.add(json);
        }
      } else {
        results.addAll(json);
      }
    }
    return jsonEncode(results);
  }
  return null;
}
