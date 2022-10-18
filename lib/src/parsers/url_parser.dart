import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic urlParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  var selector = source.querySelector(parser.selector);
  if (selector != null) {
    String? attribute = selector.attributes['href'];
    if (attribute != null) {
      String prepend = "";
      if (parser.optional != null && parser.optional!.prepend != null) {
        prepend = parser.optional!.prepend!;
      }
      if (attribute.startsWith('/')) {
        return prepend + attribute.toString();
      }
      if (attribute.contains('http')) {
        return prepend + attribute.toString();
      }
      return null;
    }
  }
  return null;
}
