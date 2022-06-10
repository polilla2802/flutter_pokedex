import 'dart:convert' as convert;

import 'package:flutter_pokedex/app/services/api/base_api_exception.dart';

class BaseException implements Exception {
  int? code;
  String? error;
  String? message;
  String? type;
  bool internalError;
  String? detail;

  BaseException(this.internalError,
      {this.code, this.detail, this.error, this.message, this.type})
      : super();

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "detail": detail,
      "error": error,
      "internalError": internalError,
      "message": message,
      "type": type
    };
  }

  @override
  String toString() {
    return convert.jsonEncode(toJson()).toString();
  }

  static fromApiException(BaseApiException ex) {
    return BaseException(false,
        code: ex.code,
        detail: ex.detail.toString(),
        error: ex.error,
        message: ex.message,
        type: ex.type);
  }
}
