/// Cleaner cleans URLs based on configuration in Target.
class Cleaner {
  /// List of parameters to keep them in cleaned URL.
  List<String>? whitelistParams;

  /// List of parameters to remove them from cleaned URL.
  List<String>? blacklistParams;

  /// Extra parameters to append to cleaned URL.
  Map<String, String>? appendParams;

  Cleaner({
    this.whitelistParams,
    this.blacklistParams,
    this.appendParams,
  });
}
