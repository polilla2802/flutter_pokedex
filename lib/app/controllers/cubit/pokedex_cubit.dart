import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';

part '../state/pokedex_state.dart';

class PokedexCubit extends Cubit<PokedexState> {
  final PokedexRepo _pokedexRepo;

  PokedexCubit(this._pokedexRepo) : super(const PokedexInitial());
}
