import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic textParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  if (parser.selector is List) {
    for (final sel in parser.selector) {
      var data = textHandler(parser, source, selectr: sel);
      if (data != null && data != [] && data != "") {
        return data;
      }
    }
  } else {
    return textHandler(parser, source, selectr: parser.selector);
  }
  return null;
}

dynamic textHandler(Parser parser, dynamic source, {required String selectr}) {
  List<String> results = [];
  if (parser.multiple) {
    var selector = source.querySelectorAll(selectr);
    if (selector.isNotEmpty) {
      for (final s in selector) {
        results.add(s.text.toString().trim());
      }
      results.removeWhere((value) => value == "");
      return results;
    }
  } else {
    var selector = source.querySelector(selectr);
    if (selector != null) {
      if (selector.text.toString().trim() != "") {
        return selector.text.toString().trim();
      }
    }
  }
  return null;
}
