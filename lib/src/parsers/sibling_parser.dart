import 'package:dart_spider/dart_spider.dart';
import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic siblingParser(Parser parser, dynamic dom) {
  dynamic source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  var selector = source!.querySelectorAll(parser.selector);
  if (selector.isNotEmpty) {
    for (final sel in selector) {
      if (parser.optional != null) {
        dynamic sib;
        if (parser.optional!.siblingDirection == SiblingDirection.previous) {
          sib = sel.previousElementSibling;
        } else {
          sib = sel.nextElementSibling;
        }
        if (parser.optional!.where != null) {
          List<String> where = parser.optional!.where!;
          String selectorText = sel.text.toString().trim();
          for (final w in where) {
            if (selectorText.contains(w)) {
              if (sib != null) {
                return sib.outerHtml;
              }
            }
          }
        }
        if (sib != null) {
          return sib.outerHtml;
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
