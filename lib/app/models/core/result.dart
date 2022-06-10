import 'dart:convert' as convert;

import 'package:flutter_pokedex/app/models/core/base_exception.dart';
import 'package:flutter_pokedex/app/services/api/base_api_exception.dart';

class Result<T> {
  T? data;
  BaseException? exception;
  final bool _wasSuccessful;

  Result(this._wasSuccessful, {this.data, this.exception});

  bool isException() {
    return this._wasSuccessful ? false : true;
  }

  bool hasData() {
    return this._wasSuccessful ? true : false;
  }

  static Result<T> ok<T>(T data) {
    return Result<T>(true, data: data, exception: null);
  }

  /// use this when something fails on the implementation (internal error).
  static Result<T> fail<T>(BaseException exception) {
    return Result<T>(false, data: null, exception: exception);
  }

  /// use this when api returns an exception and should be throw.
  static Result<T> apiFail<T>(BaseApiException? exception) {
    return Result<T>(false,
        data: null,
        exception:
            BaseException.fromApiException(exception as BaseApiException));
  }

  Map<String, dynamic> toJson() {
    return {
      "data": convert.jsonEncode(data),
      "exception": exception.toString(),
      "wasSuccessful": _wasSuccessful.toString()
    };
  }

  @override
  String toString() {
    return convert.jsonEncode(this.toJson()).toString();
  }
}
