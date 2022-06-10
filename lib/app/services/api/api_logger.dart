class ApiLogger {
  static printBodyEncoded(String json, String key) {
    print("[API][REQUEST] $key: $json");
  }

  static printHeaders(Map<String, String> headers, String key) {
    print("[API][HEADERS] $key: $headers");
  }

  static printResponse(String res, String key) {
    print("[API][RESPONSE] $key: $res");
  }

  static printUrl(String url, String key) {
    print("[API][URL] $key: $url");
  }
}
