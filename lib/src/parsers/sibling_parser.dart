import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic siblingParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  var selector = source.querySelectorAll(parser.selector);
  if (selector.isNotEmpty) {
    for (final sel in selector) {
      if (parser.optional != null && parser.optional!.where != null) {
        List<dynamic> where = parser.optional!.where!;
        if (where.contains(sel.text.toString().trim())) {
          var sib = sel.nextElementSibling;
          if (sib != null) {
            return sib.outerHtml;
          }
        }
      } else {
        var sib = sel.nextElementSibling;
        if (sib != null) {
          return sib.outerHtml;
        }
      }
    }
  }
  return null;
}
