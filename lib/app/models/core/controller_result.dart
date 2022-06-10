import 'package:flutter_pokedex/app/models/core/base_exception.dart';

class ControllerResult<E> {
  E? exception;
  BaseException? error;
  String _key;

  ControllerResult(this._key, {this.exception, this.error});

  bool hasFail() {
    return exception != null || error != null ? true : false;
  }

  void log() {
    print("[$_key] exception: $exception, error: ${error.toString()}");
  }
}
