import 'package:dart_spider/src/models/target_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future<String?> getRequest(
    String url, String? proxy, Map<String, String> headers) async {
  String reqUrl = url;
  if (proxy != null) {
    reqUrl = Uri.encodeComponent(url);
  }
  try {
    var html = await http
        .get(
          Uri.parse((proxy ?? '') + reqUrl),
          headers: headers,
        )
        .timeout(
          Duration(seconds: 15),
        );
    if (url.contains('www.amazon.')) {
      bool isBlocked = isBlockedByAmazon(html.body);
      if (isBlocked) {
        return null;
      }
    }
    return html.body;
  } catch (e) {
    return null;
  }
}

bool isBlockedByAmazon(String html) {
  List images = parse(html).querySelectorAll('img');
  if (images.isNotEmpty) {
    for (final image in images) {
      var src = image.attributes['src'];
      if (src.toString().contains("captcha")) {
        return true;
      }
    }
    return false;
  } else {
    return false;
  }
}

String htmlMinify(String url, String html, Target config) {
  String tmpHtml = html;
  try {
    if (config.minifyHtmlHead) {
      Document doc = parse(tmpHtml);
      tmpHtml = doc.querySelector('body')!.innerHtml;
    }
    if (config.minifyHtmlScripts) {
      Document doc = parse(tmpHtml);
      for (final script in doc.querySelectorAll('script')) {
        script.remove();
      }
      tmpHtml = doc.outerHtml;
    }
    if (config.minifyHtmlStyles) {
      Document doc = parse(tmpHtml);
      for (final style in doc.querySelectorAll('style')) {
        style.remove();
      }
      tmpHtml = doc.outerHtml;
    }
    if (config.minifyHtmlForms) {
      Document doc = parse(tmpHtml);
      for (final form in doc.querySelectorAll('form')) {
        form.remove();
      }
      tmpHtml = doc.outerHtml;
    }
    return tmpHtml;
  } catch (_) {}
  return tmpHtml;
}
