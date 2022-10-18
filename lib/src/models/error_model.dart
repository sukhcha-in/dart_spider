class SpiderError {
  int? code;
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
