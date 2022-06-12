import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';

part '../state/pokedex_state.dart';

class PokedexCubit extends Cubit<PokedexState> {
  final PokedexRepo _pokedexRepo;

  PokedexCubit(this._pokedexRepo) : super(const PokedexInitial());

  Future<void> getPokemonCount(int pokemonCount, BuildContext context) async {
    try {
      emit(PokedexLoading());

      Future.delayed(const Duration(milliseconds: 100), () {
        emit(PokedexLoaded(pokemonCount));
      });
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
      if (isClosed) return null;
      emit(PokedexError("error"));
    }
  }

  @override
  Future<void> close() {
    // dispose
    return super.close();
  }
}
