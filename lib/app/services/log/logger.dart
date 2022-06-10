import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/services/api/api_result.dart';

class Logger {
  final String _classKey;

  Logger(this._classKey);

  log(String processKey, String log) {
    print("LOG: [$_classKey][$processKey] $log");
  }

  error(String processKey,
      {catchError: dynamic,
      result: Result,
      apiResult: ApiResult,
      stackTrace: StackTrace}) async {
    dynamic ex;

    if (catchError != null) {
      print("ERROR: [$_classKey][$processKey] ${catchError.toString()}");
      ex = catchError;
    }

    if (result != null) {
      print("ERROR: [$_classKey][$processKey] ${result.toString()}");
      ex = result;
    }

    if (apiResult != null) {
      print("ERROR: [$_classKey][$processKey] ${apiResult.toString()}");
      ex = apiResult;
    }
  }
}
