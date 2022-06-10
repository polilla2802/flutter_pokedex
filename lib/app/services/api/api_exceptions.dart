import 'package:flutter_pokedex/app/services/api/index.dart';

class UnhandledStatusCodeException extends BaseApiException {
  int? code;
  String? error = "Unhandled switch case of response status code.";
  String? message = "response resolver had an unhandled response status " +
      "code. This shouldn't happen, and could be fixed.";
  String? type = "$UnhandledStatusCodeException";
  BaseApiExceptionDetail? detail;

  UnhandledStatusCodeException(this.code, {this.detail})
      : super(false, detail: detail);
}

class EmptyResultException extends BaseApiException {
  int? code;
  String? error;
  String? message = "The server returned a status code with no response.";
  String? type = "$EmptyResultException";
  BaseApiExceptionDetail? detail;

  EmptyResultException(this.code, {this.detail}) : super(true, detail: detail);
}

class UnauthorizedResultException extends BaseApiException {
  int? code;
  String? error;
  String? message = "User has no permission to access our servers.";
  String? type = "$UnauthorizedResultException";
  BaseApiExceptionDetail? detail;

  UnauthorizedResultException(this.code, {this.detail})
      : super(true, detail: detail);
}

class BadRequestException extends BaseApiException {
  int? code;
  String? error;
  String? message = "The server has returned a bad code due to bad request. " +
      "this could be an error on the request data.";
  String? type = "$BadRequestException";
  BaseApiExceptionDetail? detail;

  BadRequestException(this.code, {this.detail}) : super(true, detail: detail);
}

class ServerErrorException extends BaseApiException {
  int? code;
  String? error;
  String? message = "The server has failed. Contact with support.";
  String? type = "$ServerErrorException";
  BaseApiExceptionDetail? detail;

  ServerErrorException(this.code, {this.detail}) : super(true, detail: detail);
}

class ServerDownException extends BaseApiException {
  int? code;
  String? error;
  String? message =
      "The server responded with an 503 status code. Server was down! " +
          "ask for help inmediately.";
  String? type = "$ServerDownException";
  BaseApiExceptionDetail? detail;

  ServerDownException(this.code, {this.detail}) : super(true, detail: detail);
}

class GenericServerException extends BaseApiException {
  int? code;
  String? error;
  String? message = "Server returned a 4xx or 5xx error unhandled.";
  String? type = "$GenericServerException";
  BaseApiExceptionDetail? detail;

  GenericServerException(this.code, {this.detail})
      : super(true, detail: detail);
}

class AuthenticationException extends BaseApiException {
  int? code;
  String? error;
  String? message = "Server returned a 4xx or 5xx error unhandled.";
  String? type = "$AuthenticationException";
  BaseApiExceptionDetail? detail;

  AuthenticationException({this.detail}) : super(true, detail: detail);
}

class NotFoundException extends BaseApiException {
  int? code;
  String? error;
  String? message = "Resource was not found";
  String? type = "$NotFoundException";
  BaseApiExceptionDetail? detail;

  NotFoundException(this.code, {this.detail}) : super(true, detail: detail);
}
