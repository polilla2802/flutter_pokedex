part of '../cubit/pokedex_cubit.dart';

@immutable
abstract class PokedexState {
  const PokedexState();
}

class PokemonInitial extends PokedexState {
  const PokemonInitial();
}

class PokemonLoading extends PokedexState {
  const PokemonLoading();
}

class PokemonCount extends PokedexState {
  final int pokemonCount;
  const PokemonCount(this.pokemonCount);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PokemonCount && o.pokemonCount == pokemonCount;
  }

  @override
  int get hashCode => pokemonCount.hashCode;
}

class PokemonLoaded extends PokedexState {
  final Pokemon pokemon;
  final PokemonDetails? pokemonDetails;
  const PokemonLoaded(this.pokemon, {this.pokemonDetails});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PokemonLoaded && o.pokemon == pokemon;
  }

  @override
  int get hashCode => pokemon.hashCode;
}

class PokemonMoveLoaded extends PokedexState {
  final PokemonMove pokemonMove;
  const PokemonMoveLoaded(this.pokemonMove);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PokemonMoveLoaded && o.pokemonMove == pokemonMove;
  }

  @override
  int get hashCode => pokemonMove.hashCode;
}

class PokemonError extends PokedexState {
  final String? message;
  const PokemonError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PokemonError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
