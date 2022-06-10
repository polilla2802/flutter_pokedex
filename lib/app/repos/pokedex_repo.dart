import 'package:flutter_pokedex/app/providers/pokedex_provider.dart';

class PokedexRepo {
  late PokedexProvider _pokedexProvider;

  PokedexRepo() {
    _pokedexProvider = PokedexProvider();
  }
}
