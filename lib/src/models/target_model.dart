import 'package:dart_spider/src/models/cleaner_model.dart';

/// Target to target specific type of URL.
class Target {
  /// Name of our target, [parsers] in [Config] should contain this value.
  String name;

  /// List of parts of URL to target.
  List<String> where;

  /// If we need to scrape HTML or just start scraper based on URL.
  bool needsHtml;

  /// Pre-clean the url before starting the scraper.
  Cleaner? cleaner;

  /// Removes <head> tag from HTML.
  bool minifyHtmlHead;

  /// Removes <script> tags from HTML.
  bool minifyHtmlScripts;

  /// Removes <style> tags from HTML.
  bool minifyHtmlStyles;

  /// Removes <form> elements from HTML.
  bool minifyHtmlForms;

  Target({
    required this.name,
    required this.where,
    this.needsHtml = true,
    this.cleaner,
    this.minifyHtmlHead = false,
    this.minifyHtmlScripts = false,
    this.minifyHtmlStyles = false,
    this.minifyHtmlForms = false,
  });
}
