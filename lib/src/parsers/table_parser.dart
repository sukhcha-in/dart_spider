import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../models/parser_model.dart';

dynamic tableParser(Parser parser, dynamic dom) {
  Document source;
  if (dom is String) {
    source = parse(dom);
  } else {
    source = dom;
  }
  List<Element> selector = source.querySelectorAll(parser.selector);
  Map<String, String> result = {};
  if (selector.isNotEmpty) {
    for (final sel in selector) {
      if (parser.optional != null && parser.optional!.keys != null) {
        Element? keySelector = sel.querySelector(parser.optional!.keys!);
        String? key = keySelector?.text;
        String? value;
        if (parser.optional!.values != null) {
          value = sel.querySelector(parser.optional!.values!)?.text;
        } else {
          value = keySelector?.nextElementSibling?.text;
        }
        if (key != null && value != null) {
          value = value.replaceAll(RegExp('[^\x00-\x7F]+'), '');
          result.addAll({key.trim(): value.trim()});
        }
      }
    }
    return result;
  }
  return null;
}
