# Dart Spider
##### Simple way to scrape and extract data from websites
---
Dart Spider is a simple package to scrape HTML from URL and parse it using built-in parsers.
- Pre-clean URLs ✅
- Scrape Data ✅
- Parse Data ✅
- Clean Data ✅

## Features
- Scrape HTML page or load JSON data from API with custom payload or headers
- 13 parser types
- Nested parsers for improved performance on huge HTML pages
- Apply methods on extracted results
- Proxy support (URL Based)

## Parsers
- **Element Parser** - Extract reusable elements from HTML
- **Text Parser** - Extract text or list of text from HTML
- **Image Parser** - Extract image or multiple images from HTML
- **Attribute Parser** - Extract any attribute of HTML element
- **JSON Parser** - Extract data from JSON object
- **URL Parser** - Extract URLs fron HTML
- **HTTP Parser** - Fetches data from dynamic URLs
- **String Between Parser** - Extract data between two strings
- **JSON-LD Parser** - Extracts data from JSON-LD elements
- **Table Parser** - Extracts data as key-val format
- **Sibling Parser** - Finds next sibling of selected element
- **Url Params Parser** - Extract data from URL parameters
- **JSON Table Parser** - Extracts data as key-val format from JSON
- **None Parser** - Does nothing for extraction but you can apply methods
- **Static Value Parser** - Provide pre-defined data from your config

## Installation
Add `dart_spider` to your pubspec.yaml file:
```yaml
dependencies:
    dart_spider: ^0.0.3
```
And import using:
```dart
import 'package:dart_spider/dart_spider.dart';
```

## How to use?
Entrypoint of spider is: `Spider.scrapeFromUrl` which requires `Map<String, Config> config` and `String url`
`config` is a map of base `domain` and `Config` for that domain.
You can define configs for multiple domains like:
```dart
Map<String, Config> config = {
    "example.com": Config(),
    "domain2.com": Config(),
};
```

Each `Config` should have `parsers` and `targets`.
- Define URL rules in `Target`, when match is found, target is selected.
- Using selected target name, scraper will find `parsers` belonging to that target.

Example:
```dart
Config(
    targets: <Target>[
        Target(
            name: "homepage",
            where: ["/"], //Any URL will match
        ),
        Target(
            name: "search_page",
            where: ["/search", "?q="], //Only URLs with /search or ?q= will match
        ),
    ],
    parsers: {
        "homepage": <Parser>[
            Parser(
                id: "title", //This id will be used for output
                parent: ["_root"], //List of parent ids, _root is the starting point
                type: ParserType.text, //Select what type of parser you want
                selector: "h1", //CSS Selector
            ),
        ],
        "search_page": <Parser>[],
    },
)
```
Please refer to `example/example.dart` for full example.

This package was built to scrape e-commerce websites, You might find things related to products. 😛