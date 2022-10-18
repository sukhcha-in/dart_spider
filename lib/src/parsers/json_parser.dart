import 'dart:convert';
import '../models/parser_model.dart';

dynamic jsonParser(Parser parser, dynamic dom) {
  if (parser.selector == '') {
    try {
      return jsonDecode(dom);
    } catch (_) {
      return null;
    }
  }
  dynamic json;
  if (dom is String) {
    try {
      json = jsonDecode(dom);
    } catch (_) {
      return null;
    }
  } else {
    json = dom;
  }
  if (parser.selector is List) {
    for (final listSelector in parser.selector) {
      List<String> path = listSelector.split(".");
      var data = jsonHandler(parser, json, path, listSelector);
      if (data != null && data != [] && data != "" && data != "null") {
        return data;
      }
    }
  } else {
    List<String> path = parser.selector.split(".");
    var data = jsonHandler(parser, json, path, parser.selector);
    if (data != null && data != [] && data != "" && data != "null") {
      return data;
    }
  }
  return null;
}

dynamic jsonHandler(parser, json, path, listSelector) {
  try {
    for (String i in path) {
      if (int.tryParse(i) != null) {
        json = json[int.parse(i)];
      } else if (i.contains('[')) {
        bool deepCheck = false;
        String deepKey = "";
        if (i.contains('=')) {
          String typeCheck = 'equals';
          const start = "[";
          const end = "]";
          final startIndex = i.indexOf(start);
          final endIndex = i.indexOf(end, startIndex + start.length);
          String tmp = i.substring(startIndex + start.length, endIndex);
          var split = tmp.split('=');
          var keySplit = split[0];
          dynamic valueSplit = split[1];
          if (keySplit.contains(">>")) {
            var deepSplit = keySplit.split(">>");
            deepKey = deepSplit[0];
            keySplit = deepSplit[1];
            deepCheck = true;
          }
          if (valueSplit.startsWith('~')) {
            typeCheck = 'contains';
            valueSplit = valueSplit.substring(1);
          }
          if (int.tryParse(valueSplit) != null) {
            valueSplit = int.parse(valueSplit);
          }
          if (typeCheck == 'equals') {
            if (deepCheck) {
              List deepTmp = json
                  .where((p) => p[deepKey][keySplit] == valueSplit)
                  .toList();
              if (deepTmp.isNotEmpty) {
                json = deepTmp[0];
              }
            } else {
              List tmpx = json.where((p) => p[keySplit] == valueSplit).toList();
              if (tmpx.isNotEmpty) {
                json = tmpx[0];
              }
            }
          } else if (typeCheck == 'contains') {
            List tmpx = json
                .where((p) => p[keySplit].toString().contains(valueSplit))
                .toList();
            if (tmpx.isNotEmpty) {
              json = tmpx[0];
            }
          }
        } else {
          var selectorAfter = listSelector.split('[]');
          if (selectorAfter[1] != "") {
            selectorAfter[1] = selectorAfter[1].toString().substring(1);
          }
          var data = pullFromList(parser, selectorAfter[1], json, listSelector);
          if (data != null) {
            json = data;
            break;
          } else {
            return null;
          }
        }
      } else {
        if (i.contains(':')) {
          var split = i.split(':');
          if (split[0] == 'String') {
            json = json[split[1].toString()];
          }
        } else {
          json = json[i];
        }
      }
    }
  } catch (_) {
    return null;
  }
  if (json != null || json != "") {
    if (json is List && parser.multiple == true) {
      return json.toList();
    }
    return json;
  } else {
    return null;
  }
}

dynamic pullFromList(parser, selector, json, listSelector) {
  List<String> path = selector.split(".");
  var results = [];
  if (json is List) {
    if (path[0] == "") {
      results.addAll(json);
    } else {
      for (final j in json) {
        var d = jsonHandler(parser, j, path, listSelector);
        if (d != null) {
          results.add(d);
        }
      }
    }
  } else if (json is Map) {
    if (path[0] == "") {
      json.forEach((key, j) {
        results.add(j);
      });
    } else {
      json.forEach((key, j) {
        var d = jsonHandler(parser, j, path, listSelector);
        if (d != null) {
          results.add(d);
        }
      });
    }
  } else {
    return null;
  }

  if (results.isNotEmpty) {
    return results;
  } else {
    return null;
  }
}
