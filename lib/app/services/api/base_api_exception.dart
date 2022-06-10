import 'dart:convert' as convert;

import 'package:flutter_pokedex/app/services/api/index.dart';

class BaseApiException {
  int? code;
  String? error;
  String? message;
  String? type;
  bool internalError;
  BaseApiExceptionDetail? detail;
  StackTrace? stackTrace;

  BaseApiException(this.internalError,
      {this.code,
      this.error,
      this.message,
      this.type,
      this.detail,
      this.stackTrace})
      : super() {
    if (stackTrace == null) {
      stackTrace = StackTrace.current;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "internalError": internalError,
      "code": code,
      "error": error,
      "message": message,
      "type": type,
      "detail": detail,
      "stackTrace": stackTrace.toString()
    };
  }

  @override
  String toString() {
    return convert.jsonEncode(toJson()).toString();
  }
}

class BaseApiExceptionDetail {
  ApiChannel api;

  BaseApiExceptionDetail(this.api);

  Map<String, dynamic> toJson() {
    final apiKey = getApiChannelKey(api);

    return {
      "api": apiKey,
    };
  }

  @override
  String toString() {
    return convert.jsonEncode(toJson()).toString();
  }
}
