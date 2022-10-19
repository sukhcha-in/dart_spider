/// Spider Error Model.
class SpiderError {
  /// Error Code.
  int? code;

  /// Error Message.
  String? error;

  SpiderError(
    this.code,
    this.error,
  );

  int? get getCode {
    return code;
  }

  String? get getError {
    return error;
  }
}
