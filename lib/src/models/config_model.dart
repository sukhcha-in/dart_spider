import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/models/parser_model.dart';
import 'package:dart_spider/src/models/target_model.dart';

class Config {
  bool forceFetch;
  UserAgentDevice userAgent;
  Map<String, List<Parser>> parsers;
  List<Target> targets;
  Map<String, String>? headers;
  String? proxy;

  Config({
    this.forceFetch = false,
    this.userAgent = UserAgentDevice.mobile,
    required this.parsers,
    required this.targets,
    this.headers,
    this.proxy,
  });
}
