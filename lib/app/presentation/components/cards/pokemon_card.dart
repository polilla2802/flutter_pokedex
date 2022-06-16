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

class PokemonCard extends StatefulWidget {
  final int pokemonId;
  const PokemonCard(
    this.pokemonId, {
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonCard> createState() => _PokemonCardState(pokemonId);
}

class _PokemonCardState extends State<PokemonCard> {
  String _key = "pokemon_card";

  late bool _saved = false;
  late bool _ready = false;
  late int _dexNumber;
  late String _name = "";
  late String _imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/';
  late String _type1 = "";
  String? _type2;

  final EdgeInsetsGeometry buttonMargin =
      const EdgeInsets.only(top: 8, bottom: 8);

  late PokedexRepo _pokedexRepo;

  _PokemonCardState(int pokemonId) {
    _dexNumber = pokemonId;
    _pokedexRepo = PokedexRepo();
  }

  @override
  void initState() {
    super.initState();
    _checkLoaded();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    setState(() {
      _ready = true;
    });
  }

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

  Future<void> _getPokemonById(int pokemonCount, BuildContext context) async {
    final pokedexCubit = BlocProvider.of<PokedexCubit>(context);
    await pokedexCubit.getPokemonById(pokemonCount, context);
  }

  Future<void> _pokemonCardDetails(int pokemonId, String pokemonType) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonDetailsScreen(pokemonId, pokemonType),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      if (_saved) {
        return Container(
            child: GestureDetector(
          onTap: () async => await _pokemonCardDetails(_dexNumber, _type1),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color:
                  PokemonUtils.getColorByType(PokemonUtils.getTypeEnum(_type1)),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              PokemonUtils.toDexNumber(_dexNumber),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Text(
                              _name.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    PokemonUtils.getImageByType(
                                        PokemonUtils.getTypeEnum(_type1)),
                                    height: 20,
                                  ),
                                ),
                                _type2 != null
                                    ? Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset(
                                          PokemonUtils.getImageByType(
                                              PokemonUtils.getTypeEnum(
                                                  _type2!)),
                                          height: 20,
                                        ))
                                    : Container()
                              ]),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: Container(
                                width: 70,
                                height: 70,
                                child: _getPokemonImg(),
                                decoration: BoxDecoration(
                                  color: PokemonUtils.getLighterColorByType(
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
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ));
      } else {
        return Container(
            child: BlocProvider(
          create: (context) => PokedexCubit(_pokedexRepo),
          child: BlocConsumer<PokedexCubit, PokedexState>(
            listener: (context, state) async => await _pokedexListener(state),
            builder: (context, state) {
              if (state is PokemonInitial) {
                _getPokemonById(_dexNumber, context);
                return Container(
                    child: GestureDetector(
                  onTap: () {},
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.grey,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "#???",
                                      style: TextStyle(
                                          color: Colors.grey.shade100,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "???",
                                      style: TextStyle(
                                          color: Colors.grey.shade100,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: []),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2.0, sigmaY: 2.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        child: Image.asset(
                                            "assets/loaders/roll.gif"),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                            color: ConstValues.secondaryColor,
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ));
              } else if (state is PokemonLoading) {
                return Container(
                    child: GestureDetector(
                  onTap: () {},
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.grey,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "#???",
                                      style: TextStyle(
                                          color: Colors.grey.shade100,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "???",
                                      style: TextStyle(
                                          color: Colors.grey.shade100,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: []),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2.0, sigmaY: 2.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        child: Image.asset(
                                            "assets/loaders/roll.gif"),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                            color: ConstValues.secondaryColor,
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ));
              } else if (state is PokemonLoaded) {
                return Container(
                    child: GestureDetector(
                  onTap: () async => await _pokemonCardDetails(
                      state.pokemon.dexNumber, state.pokemon.type1),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: PokemonUtils.getColorByType(
                          PokemonUtils.getTypeEnum(state.pokemon.type1)),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      PokemonUtils.toDexNumber(
                                          state.pokemon.dexNumber),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      state.pokemon.name.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 4),
                                          alignment: Alignment.centerLeft,
                                          child: Image.asset(
                                            PokemonUtils.getImageByType(
                                                PokemonUtils.getTypeEnum(
                                                    state.pokemon.type1)),
                                            height: 20,
                                          ),
                                        ),
                                        state.pokemon.type2 != null
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4),
                                                alignment: Alignment.centerLeft,
                                                child: Image.asset(
                                                  PokemonUtils.getImageByType(
                                                      PokemonUtils.getTypeEnum(
                                                          state
                                                              .pokemon.type2!)),
                                                  height: 20,
                                                ))
                                            : Container()
                                      ]),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2.0, sigmaY: 2.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        child: _getPokemonImg(),
                                        decoration: BoxDecoration(
                                          color: PokemonUtils
                                              .getLighterColorByType(
                                                  PokemonUtils.getTypeEnum(
                                                      state.pokemon.type1)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                            color: PokemonUtils.getColorByType(
                                                PokemonUtils.getTypeEnum(
                                                    state.pokemon.type1)),
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ));
              } else {
                return Container(
                    child: GestureDetector(
                  onTap: () {},
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.grey,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "#???",
                                      style: TextStyle(
                                          color: Colors.grey.shade100,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Error",
                                      style: TextStyle(
                                          color: Colors.grey.shade100,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: []),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2.0, sigmaY: 2.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        child: Image.asset(
                                            "assets/loaders/roll.gif"),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                            color: ConstValues.secondaryColor,
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ));
              }
            },
          ),
        ));
      }
    } else {
      return Container(
          child: GestureDetector(
        onTap: () {},
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.grey,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "#???",
                            style: TextStyle(
                                color: Colors.grey.shade100,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "???",
                            style: TextStyle(
                                color: Colors.grey.shade100,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: []),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: Container(
                              width: 70,
                              height: 70,
                              child: Image.asset("assets/loaders/roll.gif"),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                                border: Border.all(
                                  color: ConstValues.secondaryColor,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
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
