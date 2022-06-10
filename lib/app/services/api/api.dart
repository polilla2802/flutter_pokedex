import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/services/api/api_errors.dart';
import 'package:flutter_pokedex/app/services/api/api_exceptions.dart';
import 'package:flutter_pokedex/app/services/api/api_logger.dart';
import 'package:flutter_pokedex/app/services/api/api_result.dart';
import 'package:flutter_pokedex/app/services/api/request.dart';
import 'package:flutter_pokedex/app/services/api/status_codes.dart';

class ApiProvider {
  late String pokedexBaseAddress;
  late String secretKey;

  ApiProvider() {
    pokedexBaseAddress = environment!.apiBaseAddress!;
    secretKey = environment!.secretKey!;
  }

  @override
  String getToken() {
    return environment!.bearer!;
  }
}

class API {
  late ApiProvider _apiProvider;

  API() {
    _apiProvider = ApiProvider();
  }

  Future<ApiResult> get(ApiRequest request) async {
    try {
      final Uri uri = Uri.parse(
          _buildUri(request.api, request.uri, request.queryParameters));

      final String tokenResult = _getToken();

      final Map<String, String> headers =
          await _getHeaders(request.api, request.authType, tokenResult);

      ApiLogger.printUrl(uri.toString(), request.key);
      ApiLogger.printHeaders(headers, request.key);

      final http.Response response = await http.get(uri, headers: headers);

      final ApiResult result =
          _resolveResponse(request.key, response, request.api);
      ApiLogger.printResponse(result.toString(), request.key);

      return result;
    } catch (e, stackTrace) {
      print("response ${e.toString()}");

      return ApiResult.fail(
          GetExecutionFailure(error: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<ApiResult> post(ApiRequest request) async {
    try {
      if (request.body == null) {
        return ApiResult.fail(BodyWasNullException(StackTrace.current));
      }

      final Uri uri = Uri.parse(
          _buildUri(request.api, request.uri, request.queryParameters));

      print("[URI] POST ${uri.toString()}");

      final String tokenResult = _getToken();

      final Map<String, String> headers =
          await _getHeaders(request.api, request.authType, tokenResult);

      ApiLogger.printUrl(uri.toString(), request.key);
      ApiLogger.printHeaders(headers, request.key);

      final String body = convert.jsonEncode(request.body);
      ApiLogger.printBodyEncoded(body, request.key);

      final http.Response response =
          await http.post(uri, headers: headers, body: body);

      final ApiResult result =
          _resolveResponse(request.key, response, request.api);
      ApiLogger.printResponse(result.toString(), request.key);

      return result;
    } catch (e, stackTrace) {
      return ApiResult.fail(
          PostExecutionFailure(error: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<ApiResult> put(ApiRequest request) async {
    try {
      final Uri uri = Uri.parse(
          _buildUri(request.api, request.uri, request.queryParameters));

      print("[URI] PUT ${uri.toString()}");

      final String tokenResult = _getToken();

      final Map<String, String> headers =
          await _getHeaders(request.api, request.authType, tokenResult);

      ApiLogger.printUrl(uri.toString(), request.key);
      ApiLogger.printHeaders(headers, request.key);

      if (request.body != null) {
        final String body = convert.jsonEncode(request.body);
        ApiLogger.printBodyEncoded(body, request.key);
        final http.Response response =
            await http.put(uri, headers: headers, body: body);

        final ApiResult result =
            _resolveResponse(request.key, response, request.api);
        ApiLogger.printResponse(result.toString(), request.key);

        return result;
      } else {
        final http.Response response = await http.put(uri, headers: headers);

        final ApiResult result =
            _resolveResponse(request.key, response, request.api);
        ApiLogger.printResponse(result.toString(), request.key);

        return result;
      }
    } catch (e, stackTrace) {
      return ApiResult.fail(
          PutExecutionFailure(error: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<ApiResult> delete(ApiRequest request) async {
    try {
      final Uri uri = Uri.parse(
          _buildUri(request.api, request.uri, request.queryParameters));

      print("[URI] DELETE ${uri.toString()}");

      final String tokenResult = _getToken();

      final Map<String, String> headers =
          await _getHeaders(request.api, request.authType, tokenResult);

      ApiLogger.printUrl(uri.toString(), request.key);
      ApiLogger.printHeaders(headers, request.key);

      if (request.body != null) {
        final String body = convert.jsonEncode(request.body);
        ApiLogger.printBodyEncoded(body, request.key);
        final http.Response response =
            await http.delete(uri, headers: headers, body: body);

        final ApiResult result =
            _resolveResponse(request.key, response, request.api);
        ApiLogger.printResponse(result.toString(), request.key);

        return result;
      } else {
        final http.Response response = await http.delete(uri, headers: headers);

        final ApiResult result =
            _resolveResponse(request.key, response, request.api);
        ApiLogger.printResponse(result.toString(), request.key);

        return result;
      }
    } catch (e, stackTrace) {
      return ApiResult.fail(
          PutExecutionFailure(error: e.toString(), stackTrace: stackTrace));
    }
  }

  Future<ApiResult> patch(ApiRequest request) async {
    try {
      final Uri uri = Uri.parse(
          _buildUri(request.api, request.uri, request.queryParameters));

      print("[URI] PATCH ${uri.toString()}");

      final String tokenResult = _getToken();

      final Map<String, String> headers =
          await _getHeaders(request.api, request.authType, tokenResult);

      ApiLogger.printUrl(uri.toString(), request.key);
      ApiLogger.printHeaders(headers, request.key);

      final http.Response response = await http.patch(uri, headers: headers);

      final ApiResult result =
          _resolveResponse(request.key, response, request.api);
      ApiLogger.printResponse(result.toString(), request.key);

      return result;
    } catch (e, stackTrace) {
      return ApiResult.fail(
          PatchExecutionFailure(error: e.toString(), stackTrace: stackTrace));
    }
  }

  /// resolveResponse by ApiChannel yo determine how will resolve the error
  /// object response.
  ApiResult _resolveResponse(
      String key, http.Response response, ApiChannel api) {
    switch (api) {
      case ApiChannel.pokedex:
      default:
        return _resolveCommonApiResponse(response);
    }
  }

  /// This resolveResponse method don't capture the error message sended by the
  /// API. Just detect which status code was thrown and generate an internal
  /// Exception related to.
  ApiResult _resolveCommonApiResponse(http.Response response) {
    final StatusCode code = getStatusCode(response.statusCode);

    try {
      switch (code) {
        case StatusCode.ok:
          final dynamic data = convert.jsonDecode(response.body);
          return ApiResult.ok(data);
        case StatusCode.created:
          final dynamic data = convert.jsonDecode(response.body);
          return ApiResult.ok(data);
        case StatusCode.noContent:
          return ApiResult.fail(EmptyResultException(response.statusCode));
        case StatusCode.unauthorized:
          return ApiResult.fail(
              UnauthorizedResultException(response.statusCode));
        case StatusCode.badRequest:
          return ApiResult.fail(BadRequestException(response.statusCode));
        case StatusCode.internalServerError:
          return ApiResult.fail(ServerErrorException(response.statusCode));
        case StatusCode.serviceUnavailable:
          return ApiResult.fail(ServerDownException(response.statusCode));
        case StatusCode.forbidden:
        case StatusCode.notFound:
          return ApiResult.fail(NotFoundException(response.statusCode));
        case StatusCode.notAcceptable:
        case StatusCode.conflict:
        case StatusCode.gone:
        case StatusCode.notImplemented:
        case StatusCode.badGateway:
          return ApiResult.fail(GenericServerException(response.statusCode));
        default:
          return ApiResult.fail(
              UnhandledStatusCodeException(response.statusCode));
      }
    } catch (e, stackTrace) {
      return ApiResult.fail(
          ResolveResponseError(error: e.toString(), stackTrace: stackTrace));
    }
  }

  String _getToken() {
    return environment!.bearer!;
  }

  Future<Map<String, String>> _getHeaders(
      ApiChannel api, AuthType authType, String token) async {
    switch (api) {
      case ApiChannel.urlencoded:
        return {
          "content-type": "application/x-www-form-urlencoded",
          "authorization": _getAuthHeader(authType, token),
        };
      case ApiChannel.pokedex:
      default:
        return {
          "Content-Type": "application/json",
          "Authorization": _getAuthHeader(authType, token),
        };
    }
  }

  String _getAuthHeader(AuthType authType, String token) {
    switch (authType) {
      case AuthType.bearer:
        return "Bearer $token";
      case AuthType.soft:
        return environment!.secretKey!;
    }
  }

  String _buildUri(
      ApiChannel api, String baseUri, Map<String, dynamic>? queryParameters) {
    String authorityUri;
    String uri;

    switch (api) {
      case ApiChannel.pokedex:
      default:
        authorityUri = "${_apiProvider.pokedexBaseAddress}";
        uri = "$authorityUri/$baseUri";
        break;
    }

    if (queryParameters != null) {
      uri += "?";

      int count = 0;
      queryParameters.forEach((key, value) {
        if (count != 0) uri += "&";

        uri += "$key=$value";

        count++;
      });
    }

    return uri;
  }
}
