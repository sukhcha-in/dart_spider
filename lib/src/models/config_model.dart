import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/models/parser_model.dart';
import 'package:dart_spider/src/models/target_model.dart';

/// Top-Level Config object.
class Config {
  /// If [true] scraper will fetch data from URL.
  /// Defaults to [false].
  bool forceFetch;

  /// User Agent selections: [UserAgentDevice.desktop] or [UserAgentDevice.mobile]
  /// Defaults to [UserAgentDevice.mobile]
  UserAgentDevice userAgent;

  /// Map of parsers based on [Target] name.
  /// Set Target name as key and List of Parser as value.
  Map<String, List<Parser>> parsers;

  /// Targets are set based on page types of target website.
  List<Target> targets;

  /// Extra headers to pass for HTTP requests.
  Map<String, String>? headers;

  /// Proxy URL, when set original URL is appended as urlencoded format to Proxy URL.
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
