import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic elementParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  if (parser.selector is List) {
    for (final sel in parser.selector) {
      var data = elemHandler(parser, source, selectr: sel);
      if (data != null && data != [] && data != "") {
        return data;
      }
    }
  } else {
    return elemHandler(parser, source, selectr: parser.selector);
  }
  return null;
}

dynamic elemHandler(Parser parser, dynamic dom, {required String selectr}) {
  if (parser.multiple) {
    List selector = dom.querySelectorAll(selectr);

    if (selector.isNotEmpty) {
      return selector;
    }
  } else {
    var selector = dom.querySelector(selectr);
    if (selector != null) {
      return selector;
    }
  }
  return null;
}
