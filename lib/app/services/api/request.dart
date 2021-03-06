enum ApiChannel { pokedex, undefined }

String getApiChannelKey(ApiChannel api) {
  switch (api) {
    case ApiChannel.pokedex:
      return "pokedex";
    case ApiChannel.undefined:
    default:
      return "undefined";
  }
}

enum AuthType { bearer, soft, none }

class ApiRequest {
  ApiChannel api;
  String key;
  String uri;
  Map<String, dynamic>? body;
  Map<String, dynamic>? queryParameters;
  AuthType authType;

  ApiRequest(this.api, this.key, this.uri, this.authType,
      {this.body, this.queryParameters});
}
