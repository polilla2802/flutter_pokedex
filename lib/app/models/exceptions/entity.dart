import 'package:flutter_pokedex/app/models/core/base_exception.dart';

class FailToParseEntityError extends BaseException {
  int? code;
  String? error;
  String? message = "Response model has failed while doing parsing execution.";
  String? type = "$FailToParseEntityError";

  FailToParseEntityError({this.error}) : super(true);
}
