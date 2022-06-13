import 'package:flutter_pokedex/app/services/api/index.dart';

class PokedexArgs {
  PokedexArgs();
}

class PokedexProvider {
  late API _api;

  PokedexProvider() {
    _api = API();
  }

  Future<ApiResult> getPokemonById(int pokemonId) async {
    return await _api.get(ApiRequest(ApiChannel.pokedex, "getPokemonById",
        "/pokemon/$pokemonId", AuthType.none));
  }

  Future<ApiResult> getPokemonSpecieById(int pokemonId) async {
    return await _api.get(ApiRequest(ApiChannel.pokedex, "getPokemonSpecieById",
        "/pokemon-species/$pokemonId", AuthType.none));
  }

  Future<ApiResult> getPokemonMoveById(int pokemonMoveId) async {
    return await _api.get(ApiRequest(ApiChannel.pokedex, "getPokemonSpecieById",
        "/move/$pokemonMoveId", AuthType.none));
  }
}
