import 'package:dart_spider/dart_spider.dart';
import 'dart:convert';

void main() async {
  //Map of Config for multiple domains!
  Map<String, Config> config = {
    "books.toscrape.com": Config(
      parsers: {
        "homepage": [
          Parser(
            id: "books",
            parent: ["_root"],
            type: ParserType.element,
            selector: "ol.row > li",
            isPrivate: true,
            multiple: true,
          ),
          Parser(
            id: "name",
            parent: ["books"],
            type: ParserType.attribute,
            selector: "h3 a::title",
          ),
          Parser(
            id: "link",
            parent: ["books"],
            type: ParserType.url,
            selector: "a",
            optional: Optional(
              prepend: "http://books.toscrape.com/",
            ),
          ),
          Parser(
            id: "image",
            parent: ["books"],
            type: ParserType.image,
            selector: "img",
            optional: Optional(
              prepend: "http://books.toscrape.com/",
            ),
          ),
          Parser(
            id: "price",
            parent: ["books"],
            type: ParserType.text,
            selector: "p.price_color",
            optional: Optional(
              regexReplace: r"[^\x00-\x7F]",
              regexReplaceWith: "",
            ),
          ),
          Parser(
            id: "in_stock",
            parent: ["books"],
            type: ParserType.text,
            selector: "p.availability",
            optional: Optional(
              match: ['In stock', 'In Stock'],
            ),
          ),
        ],
        "product_page": [
          Parser(
            id: "breadcrumb",
            parent: ["_root"],
            type: ParserType.text,
            selector: "ul.breadcrumb > li",
            multiple: true,
          ),
          Parser(
            id: "title",
            parent: ["_root"],
            type: ParserType.text,
            selector: "h1",
          ),
          Parser(
            id: "price",
            parent: ["_root"],
            type: ParserType.text,
            selector: "div.product_main > p.price_color",
            optional: Optional(
              regexReplace: r"[^\x00-\x7F]",
              regexReplaceWith: "",
            ),
          ),
          Parser(
            id: "image",
            parent: ["_root"],
            type: ParserType.image,
            selector: "div#product_gallery img",
            optional: Optional(
              replace: {
                "../../": "http://books.toscrape.com/",
              },
            ),
          ),
          Parser(
            id: "in_stock",
            parent: ["_root"],
            type: ParserType.text,
            selector: "div.product_main > p.availability",
            optional: Optional(
              match: ['In stock', 'In Stock'],
            ),
          ),
          Parser(
            id: "description_element",
            parent: ["_root"],
            type: ParserType.sibling,
            selector: "div#product_description",
            optional: SiblingOptional(
              direction: SiblingDirection.next,
            ),
            isPrivate: true,
          ),
          Parser(
            id: "description",
            parent: ["description_element"],
            type: ParserType.text,
            selector: "p",
          ),
          Parser(
            id: "product_information",
            parent: ["_root"],
            type: ParserType.table,
            selector: "table tr",
            optional: TableOptional(
              keys: "th",
              values: "td",
            ),
          ),
        ],
      },
      targets: [
        Target(
          name: "product_page",
          where: ["/catalogue"],
        ),
        //Target "homepage" is last because ["/"] means any given url.
        Target(
          name: "homepage",
          where: ["/"],
        ),
      ],
    ),
  };

  //URL to scrape

  // To Scrape all books:
  // String url = "http://books.toscrape.com/";

  // To Scrape specific book:
  String url =
      "http://books.toscrape.com/catalogue/a-light-in-the-attic_1000/index.html";

  //Scrape from URL
  var res = await Spider.scrapeFromUrl(config, url);

  //Check if it's successful
  if (res is SpiderError) {
    //Print out the error
    print(res.error);
  } else {
    //Success
    print(jsonEncode(res));
  }
}
