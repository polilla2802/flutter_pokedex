enum Environment { production, development }

//enum to get the app Environment value
String getEnvironmentValue(Environment? environment) {
  switch (environment) {
    case Environment.development:
      return "development";
    case Environment.production:
      return "production";
    default:
      return "undefined";
  }
}

BuildEnvironment? get environment => _environment;
BuildEnvironment? _environment;

class BuildEnvironment {
  final Environment? env;

  final String? apiBaseAddress;
  final int? totalPokemon;
  final String? bearer;
  final String? secretKey;

  BuildEnvironment._init(
      {this.env,
      this.apiBaseAddress,
      this.totalPokemon,
      this.secretKey,
      this.bearer});

  static void init(
          {required env,
          required apiBaseAddress,
          required totalPokemon,
          required secretKey,
          required bearer}) =>
      _environment ??= BuildEnvironment._init(
          env: env,
          apiBaseAddress: apiBaseAddress,
          totalPokemon: totalPokemon,
          secretKey: secretKey,
          bearer: bearer);

  @override
  String toString() {
    return _toJson().toString();
  }

  Map<String, dynamic> _toJson() => {
        "env": env,
        "apiBaseAddress": apiBaseAddress,
        "totalPokemon": totalPokemon,
        "secretKey": secretKey,
        "bearer": bearer
      };
}
