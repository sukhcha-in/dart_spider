import 'dart:convert';
import 'dart:io';
import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/models/parser_model.dart';
import 'package:dart_spider/src/utils/spider_functions.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future httpParser(Parser parser, dynamic dom) async {
  String url = '';
  HttpMethod method = HttpMethod.get;
  dynamic payLoad;
  HttpPayload payloadType = HttpPayload.string;
  Map<String, String> headers = {};
  //Set from optional
  if (parser.optional != null) {
    if (parser.optional!.url != null) {
      url = parser.optional!.url!;
    } else {
      url = dom.toString();
    }
    if (parser.optional!.method != null) {
      method = parser.optional!.method!;
    }
    //Let's create headers
    if (parser.optional!.headers != null) {
      parser.optional!.headers!.forEach((k, v) {
        headers.addAll({k.toString(): v.toString()});
      });
    }
    if (parser.optional!.userAgent != null) {
      headers.addAll({
        HttpHeaders.userAgentHeader:
            generateUserAgent(parser.optional!.userAgent!)
      });
    }
  } else {
    url = dom.toString();
  }
  //If method is post, which means optional is not null
  if (method == HttpMethod.post) {
    //Set default payLoad
    if (parser.optional!.payLoad != null) {
      payLoad = parser.optional!.payLoad!;
    }
    //Set default payloadType
    if (parser.optional!.payloadType != null) {
      payloadType = parser.optional!.payloadType!;
    }
    //Convert payload based on payloadType
    if (payloadType == HttpPayload.json) {
      payLoad = jsonEncode(payLoad);
    } else {
      payLoad = payLoad.toString();
    }
  }
  //If url contains slot
  if (url.contains('@slot')) {
    url = url.replaceFirst('@slot', dom);
  }
  //If payload contains slot
  if (payLoad != null && payLoad.contains('@slot')) {
    payLoad = payLoad.replaceFirst('@slot', dom);
  }
  //Declare empty result
  dynamic result;
  if (method == HttpMethod.get) {
    result = await getMethod(parser, url, headers);
  } else if (method == HttpMethod.post) {
    result = await postMethod(parser, url, headers, payLoad);
  } else {
    return null;
  }
  //If result is there
  if (result != null) {
    if (parser.optional != null && parser.optional!.responseType != null) {
      switch (parser.optional!.responseType!) {
        case HttpResponseType.json:
          return jsonDecode(result.toString());
        default:
          return parse(result);
      }
    } else {
      return result;
    }
  }
  return null;
}

Future getMethod(Parser parser, String url, dynamic headers) async {
  try {
    var html = await http.get(Uri.parse(url.toString()), headers: headers);
    if (html.statusCode == 200) {
      return html.body;
    }
  } catch (_) {
    return null;
  }
  return null;
}

Future postMethod(
    Parser parser, String url, dynamic headers, dynamic body) async {
  try {
    var html = await http.post(Uri.parse(url.toString()),
        body: body, headers: headers);
    if (html.statusCode == 200) {
      return html.body;
    }
  } catch (_) {
    return null;
  }
  return null;
}
