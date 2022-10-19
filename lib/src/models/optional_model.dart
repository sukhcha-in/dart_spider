import 'package:dart_spider/src/models/enums.dart';

class AbstractOptional {
  /// Apply different functions to result.
  ApplyMethod? apply;

  /// Regex pattern.
  String? regex;

  /// Match to group.
  int? regexGroup;

  /// Regex Replace pattern.
  String? regexReplace;

  /// Replace with selected pattern.
  String? regexReplaceWith;

  /// Map to find keys and replace them with values.
  Map<String, String>? replace;

  /// Crop result from start.
  int? cropStart;

  /// Crop result from end.
  int? cropEnd;

  /// Prepend string to result.
  String? prepend;

  /// Append string to result.
  String? append;

  /// Checks if result has match in predefined list.
  List<dynamic>? match;

  /// Select nth result from list.
  int? nth;

  ///
  /// Based on ParserType.
  ///

  ///* [ParserType.http].
  /// Target URL.
  /// URLs can have [@slot] where parent value will be inserted.
  String? url;

  /// HttpMethod as GET/POST.
  HttpMethod? method;

  /// Add Custom Headers.
  Map<String, dynamic>? headers;

  /// Custom User Agent.
  UserAgentDevice? userAgent;

  /// responseType defines what to do once we grab data from URL.
  /// if [HttpResponseType.html] then result will be converted to element.
  /// if [HttpResponseType.json] then result will be decoded from JSON.
  HttpResponseType? responseType;

  /// For POST requests you can add custom payLoad.
  dynamic payLoad;

  /// payLoad can be String or JSON.
  HttpPayload? payloadType;

  ///* [ParserType.strBetween].
  /// Start of a string.
  String? start;

  /// End of a string.
  String? end;

  ///* [ParserType.sibling].
  /// If where is passed, value of selector is matched, result is sibling of an element where match was found.
  List<String>? where;

  ///* [ParserType.json].
  /// JSON Table keys path.
  String? keys;

  /// JSON Table values path.
  String? values;

  /// JSON Table whitelist values.
  /// Stll Pending.
  List<String>? whitelist;

  AbstractOptional({
    this.apply,
    this.regex,
    this.regexGroup,
    this.regexReplace,
    this.regexReplaceWith,
    this.replace,
    this.cropStart,
    this.cropEnd,
    this.prepend,
    this.append,
    this.match,
    this.nth,
    this.url,
    this.method,
    this.headers,
    this.userAgent,
    this.responseType,
    this.payLoad,
    this.payloadType,
    this.start,
    this.end,
    this.where,
    this.keys,
    this.values,
    this.whitelist,
  });
}

class Optional extends AbstractOptional {
  Optional({
    ApplyMethod? apply,
    String? regex,
    int? regexGroup,
    String? regexReplace,
    String? regexReplaceWith,
    Map<String, String>? replace,
    int? cropStart,
    int? cropEnd,
    String? prepend,
    String? append,
    List<dynamic>? match,
    int? nth,
  }) : super(
          apply: apply,
          regex: regex,
          regexGroup: regexGroup,
          regexReplace: regexReplace,
          regexReplaceWith: regexReplaceWith,
          replace: replace,
          cropStart: cropStart,
          cropEnd: cropEnd,
          prepend: prepend,
          append: append,
          match: match,
          nth: nth,
        );
}

class HttpOptional extends AbstractOptional {
  HttpOptional({
    String? url,
    HttpMethod? method,
    Map<String, dynamic>? headers,
    UserAgentDevice? userAgent,
    HttpResponseType? responseType,
    dynamic payload,
    HttpPayload? payloadType,
  }) : super(
          url: url,
          method: method,
          headers: headers,
          userAgent: userAgent,
          responseType: responseType,
          payLoad: payload,
          payloadType: payloadType,
        );
}

class StrBtwOptional extends AbstractOptional {
  StrBtwOptional({String? start, String? end}) : super(start: start, end: end);
}

class SiblingOptional extends AbstractOptional {
  SiblingOptional({List<String>? where}) : super(where: where);
}

class TableOptional extends AbstractOptional {
  TableOptional({String? keys, String? values, List<String>? whitelist})
      : super(keys: keys, values: values, whitelist: whitelist);
}
