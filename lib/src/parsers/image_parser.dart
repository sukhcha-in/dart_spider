import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic imageParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  if (parser.selector is List) {
    for (final sel in parser.selector) {
      var data = imgHandler(parser, source, selectr: sel);
      if (data != null && data != [] && data != "") {
        return data;
      }
    }
  } else {
    return imgHandler(parser, source, selectr: parser.selector);
  }
  return null;
}

dynamic imgHandler(Parser parser, dynamic source, {required String selectr}) {
  var selector = source.querySelector(selectr);
  if (selector != null) {
    var src = selector.attributes['src'];
    if (src != null) {
      return src.toString();
    }
  }
  return null;
}
