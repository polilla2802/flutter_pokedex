import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';

part '../state/pokedex_state.dart';

class PokedexCubit extends Cubit<PokedexState> {
  final PokedexRepo _pokedexRepo;

  PokedexCubit(this._pokedexRepo) : super(const PokedexInitial());

  Future<void> getPokedex(int pokemonCount, BuildContext context) async {
    try {
      emit(PokedexLoading());

      List<Result<Pokemon>> pokemons = [];

      for (var i = 1; i < pokemonCount; ++i) {
        Result<Pokemon> pokemon = await _pokedexRepo.getPokemonById(i);
        pokemons.add(pokemon);
      }

      emit(PokedexLoaded(pokemons));
    } catch (e) {
      emit(PokedexError("error"));
    }
  }

  Future<void> getPokemonById(int pokemonId, BuildContext context) async {
    try {
      emit(PokedexLoading());

      Result<Pokemon> pokemon = await _pokedexRepo.getPokemonById(pokemonId);

      print("pokemon ${pokemon.data}");
      emit(PokemonLoaded(pokemon.data!));
    } catch (e) {
      emit(PokedexError("error"));
    }
  }

  @override
  Future<void> close() {
    // dispose
    return super.close();
  }
}
