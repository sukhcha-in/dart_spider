import 'package:html/dom.dart';
import '../models/parser_model.dart';

dynamic stringBetweenParser(Parser parser, dynamic dom) {
  String source = '';
  if (dom is Document) {
    source = dom.outerHtml;
  } else {
    source = dom.toString();
  }
  String tmp;
  String start = parser.optional?.start ?? "";
  String end = parser.optional?.end ?? "";
  final startIndex = source.indexOf(start);
  if (startIndex == -1) {
    return null;
  }
  final endIndex = source.indexOf(end, startIndex + start.length);
  try {
    tmp = source.substring(startIndex + start.length, endIndex);
  } catch (e) {
    return null;
  }
  return tmp.trim();
}
