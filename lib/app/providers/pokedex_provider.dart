import 'package:flutter_pokedex/app/services/api/index.dart';

class PokedexArgs {
  PokedexArgs();
}

class PokedexProvider {
  late API _api;

  PokedexProvider() {
    _api = API();
  }
}
