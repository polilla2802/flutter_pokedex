import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/app/controllers/cubit/pokedex_cubit.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokemon_details_screen.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';
import 'package:flutter_pokedex/app/services/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonListTile extends StatefulWidget {
  final int pokemonId;
  final bool interactive;
  final bool selectable;
  final bool selected;
  final Function(int val)? addPokemon;
  final Function(int val)? resPokemon;
  const PokemonListTile(
    this.pokemonId,
    this.interactive,
    this.selectable,
    this.selected, {
    this.addPokemon,
    this.resPokemon,
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonListTile> createState() =>
      _PokemonListTileState(pokemonId, interactive, selectable, selected,
          addPokemon: addPokemon, resPokemon: resPokemon);
}

class _PokemonListTileState extends State<PokemonListTile> {
  String _key = "pokemon_list_tile";

  late bool _saved = false;
  late int _dexNumber;
  late String _name = "";
  late String _imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/';
  late String _type1 = "";
  String? _type2;
  late bool _interactive;
  final EdgeInsetsGeometry buttonMargin =
      const EdgeInsets.only(top: 8, bottom: 8);
  bool _selectable = false;
  bool _selected = false;
  late Function(int val)? _addPokemon;
  late Function(int val)? _resPokemon;

  late PokedexRepo _pokedexRepo;

  _PokemonListTileState(
      int pokemonId, bool interactive, bool selectable, bool selected,
      {Function(int val)? addPokemon, Function(int val)? resPokemon}) {
    _dexNumber = pokemonId;
    _interactive = interactive;
    _selectable = selectable;
    _selected = selected;
    _addPokemon = addPokemon;
    _resPokemon = resPokemon;
    _pokedexRepo = PokedexRepo();
  }

  @override
  void initState() {
    super.initState();
    _checkLoaded();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _checkLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String dexNumber = prefs.getString("#${_dexNumber.toString()}") ?? "";

    if (dexNumber != "") {
      _saved = true;
      _name = prefs.getString("${_dexNumber.toString()}Name") ?? "";
      _type1 = prefs.getString("${_dexNumber.toString()}Type1") ?? "";
      String type2 = prefs.getString("${_dexNumber.toString()}Type2") ?? "";
      if (type2 == "") return null;
      _type2 = type2;
    }
  }

  Future<void> _pokedexListener(PokedexState state) async {
    if (state is PokemonError) {
      print("error");
      print("${state.message}");
    }

    if (state is PokemonLoaded) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var dex = await prefs.setString(
          "#${_dexNumber.toString()}", _dexNumber.toString());

      if (dex) print('#${_dexNumber.toString()} saved to #');

      var name = await prefs.setString(
          "${_dexNumber.toString()}Name", state.pokemon.name);

      if (name)
        print('${state.pokemon.name} saved to "${_dexNumber.toString()}Name"');

      var type1 = await prefs.setString(
          "${_dexNumber.toString()}Type1", state.pokemon.type1);

      if (type1)
        print(
            '${state.pokemon.type1} saved to "${_dexNumber.toString()}Type1"');

      if (state.pokemon.type2 != null) {
        var type2 = await prefs.setString(
            "${_dexNumber.toString()}Type2", state.pokemon.type2!);

        if (type2)
          print(
              '${state.pokemon.type2} saved to "${_dexNumber.toString()}Type2"');
      }
    }
  }

  Future<void> _getPokemonById(int pokemonId, BuildContext context) async {
    final pokedexCubit = BlocProvider.of<PokedexCubit>(context);
    await pokedexCubit.getPokemonById(pokemonId, context);
  }

  Future<void> _pokemonCardDetails(int pokemonId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailsScreen(pokemonId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_saved) {
      return Container(
          margin: buttonMargin,
          child: GestureDetector(
            onTap: _interactive
                ? _selectable
                    ? () async => setState(() {
                          _selected = !_selected;
                          if (_selected) {
                            _addPokemon!(_dexNumber);
                          } else {
                            _resPokemon!(_dexNumber);
                          }
                        })
                    : () async => await _pokemonCardDetails(_dexNumber)
                : null,
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
                        color: _selected
                            ? ConstValues.secondaryColor
                            : PokemonUtils.getLighterColorByType(
                                PokemonUtils.getTypeEnum(_type1)),
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
                                        color: PokemonUtils.getColorByType(
                                            PokemonUtils.getTypeEnum(_type1)),
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
          ));
    } else {
      return Container(
          margin: buttonMargin,
          child: BlocProvider(
            create: (context) => PokedexCubit(_pokedexRepo),
            child: BlocConsumer<PokedexCubit, PokedexState>(
              listener: (context, state) async => await _pokedexListener(state),
              builder: (context, state) {
                if (state is PokemonInitial) {
                  _getPokemonById(_dexNumber, context);
                  return GestureDetector(
                    onTap: () {},
                    child: Column(children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 8, right: 16, left: 16),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#???",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "???",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 3, bottom: 3, right: 3, left: 3),
                        decoration: BoxDecoration(
                            color: Colors.grey,
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
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2.0, sigmaY: 2.0),
                                            child: Container(
                                              width: 50,
                                              child: Image.asset(
                                                  "assets/loaders/roll.gif"),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50.0)),
                                                border: Border.all(
                                                  color: ConstValues
                                                      .secondaryColor,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                } else if (state is PokemonLoading) {
                  return GestureDetector(
                    onTap: () {},
                    child: Column(children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 8, right: 16, left: 16),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#???",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "???",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 3, bottom: 3, right: 3, left: 3),
                        decoration: BoxDecoration(
                            color: Colors.grey,
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
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2.0, sigmaY: 2.0),
                                            child: Container(
                                              width: 50,
                                              child: Image.asset(
                                                  "assets/loaders/roll.gif"),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50.0)),
                                                border: Border.all(
                                                  color: ConstValues
                                                      .secondaryColor,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                } else if (state is PokemonLoaded) {
                  return GestureDetector(
                    onTap: _interactive
                        ? _selectable
                            ? () async => setState(() {
                                  _selected = !_selected;
                                  if (_selected) {
                                    _addPokemon!(state.pokemon.dexNumber);
                                  } else {
                                    _resPokemon!(state.pokemon.dexNumber);
                                  }
                                })
                            : () async => await _pokemonCardDetails(_dexNumber)
                        : null,
                    child: Column(children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 8, right: 16, left: 16),
                        decoration: BoxDecoration(
                            color: _selected
                                ? ConstValues.secondaryColor
                                : PokemonUtils.getColorByType(
                                    PokemonUtils.getTypeEnum(
                                        state.pokemon.type1)),
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
                              state.pokemon.name.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 3, bottom: 3, right: 3, left: 3),
                        decoration: BoxDecoration(
                            color: PokemonUtils.getColorByType(
                                PokemonUtils.getTypeEnum(state.pokemon.type1)),
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
                                color: _selected
                                    ? ConstValues.secondaryColor
                                    : PokemonUtils.getLighterColorByType(
                                        PokemonUtils.getTypeEnum(
                                            state.pokemon.type1)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2.0, sigmaY: 2.0),
                                            child: Container(
                                              width: 50,
                                              child: _getPokemonImg(),
                                              decoration: BoxDecoration(
                                                color:
                                                    PokemonUtils.getColorByType(
                                                        PokemonUtils
                                                            .getTypeEnum(state
                                                                .pokemon
                                                                .type1)),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50.0)),
                                                border: Border.all(
                                                  color: PokemonUtils
                                                      .getColorByType(
                                                          PokemonUtils
                                                              .getTypeEnum(state
                                                                  .pokemon
                                                                  .type1)),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(top: 8),
                                              alignment: Alignment.centerRight,
                                              child: Image.asset(
                                                PokemonUtils.getImageByType(
                                                    PokemonUtils.getTypeEnum(
                                                        state.pokemon.type1)),
                                                height: 25,
                                              ),
                                            ),
                                            Container(
                                              width: 8,
                                            ),
                                            _type2 != null
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.only(top: 8),
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Image.asset(
                                                      PokemonUtils.getImageByType(
                                                          PokemonUtils
                                                              .getTypeEnum(state
                                                                  .pokemon
                                                                  .type2!)),
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
                  );
                } else {
                  return GestureDetector(
                    onTap: () {},
                    child: Column(children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 8, right: 16, left: 16),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#???",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Error",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 3, bottom: 3, right: 3, left: 3),
                        decoration: BoxDecoration(
                            color: Colors.grey,
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
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2.0, sigmaY: 2.0),
                                            child: Container(
                                              width: 50,
                                              child: Image.asset(
                                                  "assets/loaders/roll.gif"),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50.0)),
                                                border: Border.all(
                                                  color: ConstValues
                                                      .secondaryColor,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                }
              },
            ),
          ));
    }
  }

  Widget _getPokemonImg() {
    return CachedNetworkImage(
        imageUrl: _imageUrl + "$_dexNumber.gif",
        fadeInDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => Image.asset("assets/loaders/roll.gif"));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
