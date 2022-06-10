import 'package:flutter_pokedex/app/services/api/index.dart';

class GetExecutionFailure extends BaseApiException {
  int? code;
  String? error;
  String? message = "API Get execution has failed due to an error.";
  String? type = "$GetExecutionFailure";
  StackTrace? stackTrace;

  GetExecutionFailure({this.error, this.stackTrace})
      : super(true, stackTrace: stackTrace);
}

class PostExecutionFailure extends BaseApiException {
  int? code;
  String? error;
  String? message = "API Post execution has failed due to an error.";
  String? type = "$PostExecutionFailure";
  StackTrace? stackTrace;

  PostExecutionFailure({this.error, this.stackTrace})
      : super(true, stackTrace: stackTrace);
}

class PutExecutionFailure extends BaseApiException {
  int? code;
  String? error;
  String? message = "API Put execution has failed due to an error.";
  String? type = "$PutExecutionFailure";
  StackTrace? stackTrace;

  PutExecutionFailure({this.error, this.stackTrace})
      : super(true, stackTrace: stackTrace);
}

class PatchExecutionFailure extends BaseApiException {
  int? code;
  String? error;
  String? message = "API Patch execution has failed due to an error.";
  String? type = "$PatchExecutionFailure";
  StackTrace? stackTrace;

  PatchExecutionFailure({this.error, this.stackTrace})
      : super(true, stackTrace: stackTrace);
}

class BodyWasNullException extends BaseApiException {
  int? code;
  String? error = "No body was provided.";
  String? message = "API Post requires a body object, but no one was provided.";
  String? type = "$BodyWasNullException";
  BaseApiExceptionDetail? detail;
  StackTrace? stackTrace;

  BodyWasNullException(this.stackTrace) : super(true, stackTrace: stackTrace);
}

class ResolveResponseError extends BaseApiException {
  int? code;
  String? error;
  String? message =
      "Some model parsing has failed while executing a resolve response " +
          "method. This is a huge critical error.";
  String? type = "$ResolveResponseError";
  StackTrace? stackTrace;

  ResolveResponseError({this.error, this.stackTrace})
      : super(true, error: error, stackTrace: stackTrace);
}
