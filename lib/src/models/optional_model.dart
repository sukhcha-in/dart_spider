import 'package:dart_spider/src/models/enums.dart';

class AbstractOptional {
  ApplyMethod? apply; //Apply different functions to result
  String? regex; //Pattern
  int? regexGroup; //Match to group
  String? regexReplace; //Pattern
  String? regexReplaceWith; //Replace with selected pattern
  Map<String, String>? replace; //String to find for replacing
  int? cropStart; //Crop result from start
  int? cropEnd; //Crop result from end
  String? prepend; //Prepend string to result
  String? append; //Append string to result
  List<dynamic>? match; //Checks if result has match in predefined list
  int? nth; //Select nth result from list

  //Http
  String? url;
  HttpMethod? method;
  Map<String, dynamic>? headers;
  UserAgentDevice? userAgent;
  HttpResponseType? responseType;
  dynamic payLoad;
  HttpPayload? payloadType;

  //String between
  String? start;
  String? end;

  //Sibling
  List<String>? where;

  //Table
  String? keys;
  String? values;
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
