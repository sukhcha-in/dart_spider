import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic attributeParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  if (parser.selector is List) {
    for (final sel in parser.selector) {
      List<String> split = sel.toString().split("::");
      var data = attrHandler(parser, source, selectr: split[0], attr: split[1]);
      if (data != null && data.isNotEmpty && data != "") {
        return data;
      }
    }
  } else {
    List<String> split = parser.selector.toString().split("::");
    return attrHandler(parser, source, selectr: split[0], attr: split[1]);
  }

  return null;
}

dynamic attrHandler(
  Parser parser,
  dynamic source, {
  required String selectr,
  required String attr,
}) {
  if (parser.multiple) {
    List<Element> selector = source.querySelectorAll(selectr);
    if (selector.isNotEmpty) {
      List<String> result = [];
      for (final sel in selector) {
        var attribute = sel.attributes[attr];
        if (attribute != null) {
          result.add(attribute.toString());
        }
      }
      return result;
    }
  } else {
    var selector = source.querySelector(selectr);
    if (selector != null) {
      var attribute = selector.attributes[attr];
      if (attribute != null) {
        return attribute.toString();
      }
    }
  }
  return null;
}
