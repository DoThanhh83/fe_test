class APIResult {
  dynamic code;
  dynamic message;
  dynamic data;

  APIResult({
    this.code,
    this.message,
    this.data,
  });

  factory APIResult.fromJson(Map<String, dynamic> parsedJson) {
    return APIResult(
      code: parsedJson['code'],
      message: parsedJson['message'],
      data: parsedJson['data'],
    );
  }
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'code': code,
        'message': message,
        'data': data,
      };
}
