import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';

part '../state/pokedex_state.dart';

class PokedexCubit extends Cubit<PokedexState> {
  final PokedexRepo _pokedexRepo;

  PokedexCubit(this._pokedexRepo) : super(const PokemonInitial());

  Future<void> getPokemonCount(int pokemonCount, BuildContext context) async {
    try {
      emit(PokemonLoading());

      Future.delayed(const Duration(milliseconds: 100), () {
        emit(PokemonCount(pokemonCount));
      });
    } catch (e) {
      emit(PokemonError("error"));
    }
  }

  Future<void> getPokemonById(int pokemonId, BuildContext context) async {
    try {
      emit(PokemonLoading());

      Result<Pokemon> pokemon = await _pokedexRepo.getPokemonById(pokemonId);

      print("pokemon ${pokemon.data}");
      emit(PokemonLoaded(pokemon.data!));
    } catch (e) {
      if (isClosed) return null;
      emit(PokemonError("error"));
    }
  }

  Future<void> getPokemonMoveById(
      int pokemonMoveId, BuildContext context) async {
    try {
      emit(PokemonLoading());

      Result<PokemonMove> pokemonMove =
          await _pokedexRepo.getPokemonMoveById(pokemonMoveId);

      print("pokemon ${pokemonMove.data}");
      emit(PokemonMoveLoaded(pokemonMove.data!));
    } catch (e) {
      if (isClosed) return null;
      emit(PokemonError("error"));
    }
  }

  Future<void> getPokemonDetailsById(
      int pokemonId, BuildContext context) async {
    try {
      emit(PokemonLoading());

      Result<Pokemon> pokemon = await _pokedexRepo.getPokemonById(pokemonId);

      Result<PokemonDetails> pokemonDetails =
          await _pokedexRepo.getPokemonDetailsById(pokemonId);

      int evolutionId = int.parse(pokemonDetails.data!.evolutionChain
          .replaceAll('https://pokeapi.co/api/v2/evolution-chain/', '')
          .replaceAll('/', ''));

      Result<PokemonChain> pokemonChain =
          await _pokedexRepo.getPokemonEvolutionById(evolutionId);

      print("pokemon ${pokemon.data}");
      emit(PokemonLoaded(pokemon.data!,
          pokemonDetails: pokemonDetails.data,
          pokemonChain: pokemonChain.data));
    } catch (e) {
      if (isClosed) return null;
      emit(PokemonError("error"));
    }
  }

  @override
  Future<void> close() {
    // dispose
    return super.close();
  }
}
