import 'dart:convert';
import 'dart:io';
import 'package:dart_spider/spider.dart';
import 'package:dart_spider/src/models/config_model.dart';
import 'package:dart_spider/src/models/optional_model.dart';
import 'package:dart_spider/src/models/parser_model.dart';
import 'package:dart_spider/src/models/target_model.dart';

void main() async {
  //Config
  Map<String, Config> masterConfig = {
    "example.com": Config(
      parsers: {
        "homepage": [
          Parser(
            id: "title",
            parent: ["_root"],
            type: ParserType.text,
            selector: "h1",
          ),
          Parser(
            id: "description",
            parent: ["_root"],
            type: ParserType.text,
            selector: "p",
            optional: Optional(
              nth: 1,
            ),
          ),
          Parser(
            id: "link",
            parent: ["_root"],
            type: ParserType.url,
            selector: "a",
          ),
        ],
      },
      targets: [
        Target(name: "homepage", where: ["/"]),
      ],
    ),
  };

  //URL input from console
  stdout.write('URL: ');
  String? url = stdin.readLineSync();

  //Scrape from URL
  var res = await Spider.scrapeFromUrl(
    masterConfig,
    url,
    extract: Extract.product,
  );
  //Check if it's successful
  if (res is SpiderError) {
    print(res.error);
  } else {
    //Success
    print(jsonEncode(res));
  }
}
