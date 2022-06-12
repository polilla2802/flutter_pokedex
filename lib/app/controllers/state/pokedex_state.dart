part of '../cubit/pokedex_cubit.dart';

@immutable
abstract class PokedexState {
  const PokedexState();
}

class PokedexInitial extends PokedexState {
  const PokedexInitial();
}

class PokedexLoading extends PokedexState {
  const PokedexLoading();
}

class PokedexLoaded extends PokedexState {
  final List<Result<Pokemon>> pokedex;
  const PokedexLoaded(this.pokedex);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PokedexLoaded && o.pokedex == pokedex;
  }

  @override
  int get hashCode => pokedex.hashCode;
}

class PokemonLoaded extends PokedexState {
  final Pokemon pokemon;
  const PokemonLoaded(this.pokemon);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PokemonLoaded && o.pokemon == pokemon;
  }

  @override
  int get hashCode => pokemon.hashCode;
}

class PokedexError extends PokedexState {
  final String? message;
  const PokedexError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PokedexError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
