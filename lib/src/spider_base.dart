import 'package:dart_spider/src/models/config_model.dart';
import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/models/error_model.dart';
import 'package:dart_spider/src/models/target_model.dart';
import 'package:dart_spider/src/utils/http_functions.dart';
import 'package:dart_spider/src/utils/spider_functions.dart';
import 'dart:io';
import 'models/parser_model.dart';
import 'parsers/element_parser.dart';
import 'parsers/attribute_parser.dart';
import 'parsers/image_parser.dart';
import 'parsers/json_parser.dart';
import 'parsers/table_parser.dart';
import 'parsers/text_parser.dart';
import 'parsers/url_parser.dart';
import 'parsers/http_parser.dart';
import 'parsers/string_between_parser.dart';
import 'parsers/jsonld_parser.dart';
import 'parsers/sibling_parser.dart';
import 'parsers/url_parameter_parser.dart';
import 'parsers/json_table_parser.dart';
import 'parsers/none_parser.dart';
import 'parsers/staticvalue_parser.dart';

class Spider {
  //Main function entry point
  static Future scrapeFromUrl(
    Map<String, Config> masterConfig,
    String? url, {
    String? html,
    Extract extract = Extract.product,
    Map<String, Config> priceConfig = const {},
  }) async {
    if (url != null) {
      //Find configuration file for URL and Extraction type!
      Config? config = getConfig(
        masterConfig,
        url,
        extract,
        priceConfig: priceConfig,
      );
      if (config == null) {
        return SpiderError(
          500,
          'This URL is not supported, Please try again!',
        );
      }

      //Pass config, url and html (optional) to scraping handler
      return await scrapingHandler(url, config, html: html);
    } else {
      return SpiderError(
        500,
        'URL should not be empty, Please try again.',
      );
    }
  }

  static Future scrapingHandler(
    String url,
    Config config, {
    String? html,
  }) async {
    //Scraping headers
    Map<String, String> headers = {};
    headers.addAll({
      HttpHeaders.userAgentHeader: generateUserAgent(config.userAgent),
    });
    if (config.headers != null) {
      headers.addAll(config.headers!);
    }

    //Find if target is available for URL
    Target? target = fetchTarget(config.targets, url);
    if (target == null) {
      return SpiderError(
        500,
        "This URL is not supported, Please try another URL",
      );
    }
    String? proxy;
    if (config.proxy != null) {
      proxy = config.proxy!;
    }

    //Clean URL first
    url = runCleaner(url, target.cleaner);

    String dom;
    if (target.needsHtml) {
      //we need HTML
      if (config.forceFetch) {
        String? data = await getRequest(url, proxy, headers);
        if (data == null) {
          return SpiderError(500, 'Unable to find data from url.');
        } else {
          dom = data;
        }
      } else {
        if (html == null || html == '' || html.isEmpty) {
          String? data = await getRequest(url, proxy, headers);
          if (data == null) {
            return SpiderError(500, 'Unable to find data from url.');
          } else {
            dom = data;
          }
        } else {
          dom = html;
        }
      }
    } else {
      //When needsHtml is false, dom gets replaced with url
      dom = url;
    }

    //Only known parsers to us
    List<Parser> rootParsers = [];

    //Fetch all parsers and put them in allParsers variable as Parser model
    List<Parser> allParsers = [];
    for (final p in config.parsers[target.name]!) {
      allParsers.add(p);
    }

    //Fetch _root parsers
    rootParsers = childFinder('_root', allParsers);

    //Minify huge html page
    dom = htmlMinify(url, dom, target);

    //Start parsing
    Map<String, dynamic> f = await parsingHandler(allParsers, rootParsers, dom);
    if (f.containsKey('url')) {
      f.addAll({'target': target.name});
    } else {
      f.addAll({'url': url, 'target': target.name});
    }
    return f;
  }

  static Future<Map<String, dynamic>> parsingHandler(
    List<Parser> allParsers,
    List<Parser> parsers,
    dynamic dom,
  ) async {
    //Data only used for operations
    List privateIds = [];
    //Data shown in output
    Map<String, dynamic> publicData = {};

    for (final parser in parsers) {
      String id = parser.id;

      //If parser is private then check if privateData has an object with same ID
      if (parser.isPrivate) {
        if (privateIds.contains(id)) {
          continue;
        }
        //If parser is public then check if publicData has an object with same ID
      } else {
        if (publicData[id] != null) {
          continue;
        }
      }
      var parsedData = await runParser(parser, dom);
      if (parsedData != null) {
        dynamic data = parsedData;
        if (parser.optional != null) {
          //Select nth result
          if (parser.optional!.nth != null && data is List) {
            if (data.length >= (parser.optional!.nth! + 1)) {
              data = data[parser.optional!.nth!];
            }
          }
          //Apply methods
          if (parser.optional!.apply != null) {
            switch (parser.optional!.apply) {
              case ApplyMethod.urldecode:
                data = Uri.decodeFull(data);
                break;
              case ApplyMethod.mapToList:
                if (data is Map) {
                  data = data.values.toList();
                }
                break;
              default:
            }
          }
          //Simple replace
          if (parser.optional!.replace != null) {
            if (data is List) {
              List tmpR = [];
              for (final r in data) {
                var tmpD = r;
                parser.optional!.replace!.forEach((key, value) {
                  tmpD = tmpD.toString().replaceFirst(key, value);
                });
                tmpR.add(tmpD);
              }
              data = tmpR;
            } else {
              parser.optional!.replace!.forEach((key, value) {
                data = data.toString().replaceFirst(key, value);
              });
            }
          }
          //Regex replace
          if (parser.optional!.regexReplace != null) {
            final re = RegExp(parser.optional!.regexReplace!);
            String replaceWith = "";
            if (parser.optional!.regexReplaceWith != null) {
              replaceWith = parser.optional!.regexReplaceWith!;
            }
            if (data is List) {
              List<String> cleanedData = [];
              for (final l in data) {
                String sanitized = l.toString().replaceAll(re, replaceWith);
                if (sanitized != "") {
                  cleanedData.add(sanitized.trim());
                }
              }
              if (cleanedData.isNotEmpty) {
                data = cleanedData;
              }
            } else {
              String? sanitized = data.replaceAll(re, replaceWith);
              if (sanitized != null && sanitized != "") {
                data = sanitized;
              }
            }
          }
          //Regex match
          if (parser.optional!.regex != null) {
            RegExp exp = RegExp(parser.optional!.regex!);
            RegExpMatch? regexed = exp.firstMatch(data);
            if (regexed != null) {
              data = regexed.group(parser.optional!.regexGroup ?? 0);
            }
          }
          //Crop String
          int? cropStart = parser.optional!.cropStart;
          int? cropEnd = parser.optional!.cropEnd;
          if (cropStart != null) {
            if (data is List) {
              if (data.length >= cropStart) {
                data.removeRange(0, cropStart);
              }
            } else if (data is String) {
              if (data.length >= cropStart && cropStart > 0) {
                data = data.substring(cropStart).trim();
              }
            }
          }
          if (cropEnd != null) {
            if (data is List) {
              if (cropEnd <= data.length) {
                data.removeRange(data.length - cropEnd, data.length);
              }
            } else if (data is String) {
              if (data.length >= cropEnd && cropEnd > 0) {
                data = data.substring(0, data.length - cropEnd).trim();
              }
            }
          }
          //Prepend
          if (parser.optional!.prepend != null) {
            if (data is List) {
              List tmpD = [];
              for (final d in data) {
                tmpD.add(parser.optional!.prepend! + d);
              }
              data = tmpD;
            } else {
              data = parser.optional!.prepend! + data;
            }
          }
          //Append
          if (parser.optional!.append != null) {
            data = data + parser.optional!.append!;
          }
          //Match with list
          if (parser.optional!.match != null) {
            for (final m in parser.optional!.match!) {
              if (data.toString().contains(m.toString())) {
                data = true;
                break;
              }
            }
            if (data != true) {
              data = false;
            }
          }
        }
        //Apply optional params end
        if (parser.isPrivate) {
          // privateData.addAll({id: data});
          privateIds.add(id);
        } else {
          publicData.addAll({id: data});
        }
        List<Parser> childParsers = childFinder(id, allParsers);
        if (childParsers.isNotEmpty) {
          if (data is List) {
            //Run child parsers for each data entry
            //Add parent id to public data as empty list
            publicData.addAll({id: []});
            for (final ddd in data) {
              var childrenResults =
                  await parsingHandler(allParsers, childParsers, ddd);
              if (childrenResults.isNotEmpty) {
                publicData[id].add(childrenResults);
              }
            }
          } else {
            //Run child parsers for data
            Map<String, dynamic> childResult =
                await parsingHandler(allParsers, childParsers, data);
            if (childResult.isNotEmpty) {
              publicData.addAll(childResult);
            }
          }
        }
      }
    }
    return publicData;
  }

  //Find all children of parser
  static List<Parser> childFinder(String parent, List<Parser> allParsers) {
    return allParsers.where((p) => p.parent.contains(parent)).toList();
  }

  //Parser matching
  static dynamic runParser(Parser parser, dynamic dom) async {
    switch (parser.type) {
      case ParserType.element:
        return elementParser(parser, dom);
      case ParserType.text:
        return textParser(parser, dom);
      case ParserType.image:
        return imageParser(parser, dom);
      case ParserType.attribute:
        return attributeParser(parser, dom);
      case ParserType.json:
        return jsonParser(parser, dom);
      case ParserType.url:
        return urlParser(parser, dom);
      case ParserType.http:
        return await httpParser(parser, dom);
      case ParserType.strBetween:
        return stringBetweenParser(parser, dom);
      case ParserType.jsonld:
        return jsonLdParser(parser, dom);
      case ParserType.table:
        return tableParser(parser, dom);
      case ParserType.sibling:
        return siblingParser(parser, dom);
      case ParserType.urlParam:
        return urlParamParser(parser, dom);
      case ParserType.jsonTable:
        return jsonTableParser(parser, dom);
      case ParserType.none:
        return noneParser(parser, dom);
      case ParserType.staticVal:
        return staticValueParser(parser, dom);
      default:
        return null;
    }
  }
}
