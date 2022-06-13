import 'package:flutter_pokedex/app/models/core/base_exception.dart';
import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';
import 'package:flutter_pokedex/app/providers/pokedex_provider.dart';
import 'package:flutter_pokedex/app/services/api/index.dart';

class PokedexRepo {
  late PokedexProvider _pokedexProvider;

  PokedexRepo() {
    _pokedexProvider = PokedexProvider();
  }

  Future<Result<Pokemon>> getPokemonById(int pokemonId) async {
    try {
      final ApiResult apiResponse =
          await this._pokedexProvider.getPokemonById(pokemonId);

      if (apiResponse.hasData()) return Pokemon.fromJson(apiResponse.data);

      if (apiResponse.isException())
        return Result.apiFail(apiResponse.exception);

      return Result.fail(BaseException(true));
    } catch (e) {
      return Result.fail(BaseException(true, error: e.toString()));
    }
  }

  Future<Result<PokemonDetails>> getPokemonDetailsById(int pokemonId) async {
    try {
      final ApiResult apiResponse =
          await this._pokedexProvider.getPokemonSpecieById(pokemonId);

      if (apiResponse.hasData())
        return PokemonDetails.fromJson(apiResponse.data);

      if (apiResponse.isException())
        return Result.apiFail(apiResponse.exception);

      return Result.fail(BaseException(true));
    } catch (e) {
      return Result.fail(BaseException(true, error: e.toString()));
    }
  }

  Future<Result<PokemonMove>> getPokemonMoveById(int pokemonMoveId) async {
    try {
      final ApiResult apiResponse =
          await this._pokedexProvider.getPokemonMoveById(pokemonMoveId);

      if (apiResponse.hasData()) return PokemonMove.fromJson(apiResponse.data);

      if (apiResponse.isException())
        return Result.apiFail(apiResponse.exception);

      return Result.fail(BaseException(true));
    } catch (e) {
      return Result.fail(BaseException(true, error: e.toString()));
    }
  }

  Future<Result<PokemonChain>> getPokemonEvolutionById(int pokemonId) async {
    try {
      final ApiResult apiResponse =
          await this._pokedexProvider.getPokemonEvolutionById(pokemonId);

      if (apiResponse.hasData()) return PokemonChain.fromJson(apiResponse.data);

      if (apiResponse.isException())
        return Result.apiFail(apiResponse.exception);

      return Result.fail(BaseException(true));
    } catch (e) {
      return Result.fail(BaseException(true, error: e.toString()));
    }
  }
}
