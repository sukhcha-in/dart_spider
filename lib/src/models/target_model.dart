import 'package:dart_spider/src/models/cleaner_model.dart';

class Target {
  String name;
  List<String> where;
  bool needsHtml;
  Cleaner? cleaner;
  bool minifyHtmlHead;
  bool minifyHtmlScripts;
  bool minifyHtmlStyles;
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
