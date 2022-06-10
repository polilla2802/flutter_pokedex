/// https://www.restapitutorial.com/httpstatuscodes.html
enum StatusCode {
  ok,
  created,
  accepted,
  noContent,
  partialContent,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  methodNotAllowed,
  notAcceptable,
  conflict,
  gone,
  internalServerError,
  notImplemented,
  badGateway,
  serviceUnavailable,

  /// Used for any status code unlisted in this enumerator.
  unhandled
}

StatusCode getStatusCode(int statusCode) {
  switch (statusCode) {
    case 200:
      return StatusCode.ok;
    case 201:
      return StatusCode.created;
    case 202:
      return StatusCode.accepted;
    case 204:
      return StatusCode.noContent;
    case 206:
      return StatusCode.partialContent;
    case 400:
      return StatusCode.badRequest;
    case 401:
      return StatusCode.unauthorized;
    case 403:
      return StatusCode.forbidden;
    case 404:
      return StatusCode.notFound;
    case 406:
      return StatusCode.notAcceptable;
    case 409:
      return StatusCode.conflict;
    case 410:
      return StatusCode.gone;
    case 500:
      return StatusCode.internalServerError;
    case 501:
      return StatusCode.notImplemented;
    case 502:
      return StatusCode.badGateway;
    case 503:
      return StatusCode.serviceUnavailable;
    default:
      return StatusCode.unhandled;
  }
}

int? getStatusCodeValue(StatusCode statusCode) {
  switch (statusCode) {
    case StatusCode.ok:
      return 200;
    case StatusCode.created:
      return 201;
    case StatusCode.accepted:
      return 202;
    case StatusCode.noContent:
      return 204;
    case StatusCode.partialContent:
      return 206;
    case StatusCode.badRequest:
      return 400;
    case StatusCode.unauthorized:
      return 401;
    case StatusCode.forbidden:
      return 403;
    case StatusCode.notFound:
      return 404;
    case StatusCode.notAcceptable:
      return 406;
    case StatusCode.conflict:
      return 409;
    case StatusCode.gone:
      return 410;
    case StatusCode.internalServerError:
      return 500;
    case StatusCode.notImplemented:
      return 501;
    case StatusCode.badGateway:
      return 502;
    case StatusCode.serviceUnavailable:
      return 503;
    default:
      return null;
  }
}
