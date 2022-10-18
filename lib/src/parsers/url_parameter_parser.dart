import '../models/parser_model.dart';

dynamic urlParamParser(Parser parser, dynamic dom) {
  String source = dom.toString();

  try {
    var uri = Uri.parse(source);
    if (uri.queryParameters.containsKey(parser.selector)) {
      return uri.queryParameters[parser.selector];
    }
  } catch (_) {
    return null;
  }

  return null;
}
