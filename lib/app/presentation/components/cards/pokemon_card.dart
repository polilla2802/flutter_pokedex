import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/app/controllers/cubit/pokedex_cubit.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';
import 'package:flutter_pokedex/app/services/utils/util.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCard(
    this.pokemon, {
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState(pokemon);
}

class _PokemonCardState extends State<PokemonCard> {
  late int _dexNumber;
  late String _name = "";
  late String _imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/';
  late String _type1 = "";
  String? _type2;
  late PokedexRepo _pokedexRepo;

  final EdgeInsetsGeometry buttonMargin =
      const EdgeInsets.only(top: 8, bottom: 8);
  _PokemonCardState(
    Pokemon pokemon,
  ) {
    _dexNumber = pokemon.dexNumber;
    _name = pokemon.name;
    _type1 = pokemon.type1;
    if (pokemon.type2 != null) _type2 = pokemon.type2;
    _pokedexRepo = PokedexRepo();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Widget _getPokemonImg() {
    return CachedNetworkImage(
        imageUrl: _imageUrl + "$_dexNumber.gif",
        fadeInDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => Image.asset("assets/loader/roll.gif"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: buttonMargin,
        child: BlocProvider(
          create: (context) => PokedexCubit(_pokedexRepo),
          child: GestureDetector(
            onTap: () {},
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                decoration: BoxDecoration(
                    color: PokemonUtils.getColorByType(
                        PokemonUtils.getTypeEnum(_type1)),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      PokemonUtils.toDexNumber(_dexNumber),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _name.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(top: 3, bottom: 3, right: 3, left: 3),
                decoration: BoxDecoration(
                    color: PokemonUtils.getColorByType(
                        PokemonUtils.getTypeEnum(_type1)),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Card(
                  margin: const EdgeInsets.all(0),
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: ConstValues.secondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 2.0, sigmaY: 2.0),
                                    child: Container(
                                      width: 50,
                                      child: _getPokemonImg(),
                                      decoration: BoxDecoration(
                                        color:
                                            PokemonUtils.getLighterColorByType(
                                                PokemonUtils.getTypeEnum(
                                                    _type1)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0)),
                                        border: Border.all(
                                          color: PokemonUtils.getColorByType(
                                              PokemonUtils.getTypeEnum(_type1)),
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                dense: true,
                                minVerticalPadding: 8,
                                minLeadingWidth: 10,
                                horizontalTitleGap: 8,
                                title: Container(
                                  padding: EdgeInsets.only(top: 16),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 8),
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                        PokemonUtils.getImageByType(
                                            PokemonUtils.getTypeEnum(_type1)),
                                        height: 25,
                                      ),
                                    ),
                                    Container(
                                      width: 8,
                                    ),
                                    _type2 != null
                                        ? Container(
                                            padding: EdgeInsets.only(top: 8),
                                            alignment: Alignment.centerRight,
                                            child: Image.asset(
                                              PokemonUtils.getImageByType(
                                                  PokemonUtils.getTypeEnum(
                                                      _type2!)),
                                              height: 25,
                                            ))
                                        : Container()
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
