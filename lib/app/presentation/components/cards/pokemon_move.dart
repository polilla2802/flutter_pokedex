import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/app/controllers/cubit/pokedex_cubit.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';
import 'package:flutter_pokedex/app/services/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonMoveCard extends StatefulWidget {
  final int moveId;
  const PokemonMoveCard(
    this.moveId, {
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonMoveCard> createState() => _PokemonMoveCardState(moveId);
}

class _PokemonMoveCardState extends State<PokemonMoveCard> {
  String _key = "pokemon_move_card";

  late int _moveId;
  late bool _saved = false;
  late bool _ready = false;
  late String _name = "";
  late String _type = "";
  late String _damageClass = "";
  late int _power = 0;
  late int _accuracy = 0;
  late int _pp = 0;

  final EdgeInsetsGeometry buttonMargin =
      const EdgeInsets.only(top: 8, bottom: 8);

  late PokedexRepo _pokedexRepo;

  _PokemonMoveCardState(int moveId) {
    _moveId = moveId;
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

    String moveNumber = prefs.getString("Move${_moveId.toString()}") ?? "";

    if (moveNumber != "") {
      _saved = true;
      _name = prefs.getString("${_moveId.toString()}MoveName") ?? "";
      _type = prefs.getString("${_moveId.toString()}MoveType") ?? "";
      _damageClass =
          prefs.getString("${_moveId.toString()}MoveDamageClass") ?? "";
      _power = prefs.getInt("${_moveId.toString()}MovePower")!;
      _accuracy = prefs.getInt("${_moveId.toString()}MoveAccuracy")!;
      _pp = prefs.getInt("${_moveId.toString()}MovePP")!;
    }
  }

  Future<void> _pokedexListener(PokedexState state) async {
    if (state is PokemonError) {
      print("error");
      print("${state.message}");
    }

    if (state is PokemonMoveLoaded) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var move = await prefs.setString(
          "Move${_moveId.toString()}", _moveId.toString());

      if (move) print('#${_moveId.toString()} saved to MoveId');

      var name = await prefs.setString(
          "${_moveId.toString()}MoveName", state.pokemonMove.name);

      if (name)
        print(
            '${state.pokemonMove.name} saved to "${_moveId.toString()}MoveName"');

      var type = await prefs.setString(
          "${_moveId.toString()}MoveType", state.pokemonMove.type);

      if (type)
        print(
            '${state.pokemonMove.type} saved to "${_moveId.toString()}MoveType"');

      var damage = await prefs.setString("${_moveId.toString()}MoveDamageClass",
          state.pokemonMove.damageClass);

      if (damage)
        print(
            '${state.pokemonMove.damageClass} saved to "${_moveId.toString()}MoveDamageClass"');

      var power = await prefs.setInt(
          "${_moveId.toString()}MovePower", state.pokemonMove.power!);

      if (power)
        print(
            '${state.pokemonMove.power} saved to "${_moveId.toString()}MovePower"');

      var accuracy = await prefs.setInt(
          "${_moveId.toString()}MoveAccuracy", state.pokemonMove.accuracy!);

      if (accuracy)
        print(
            '${state.pokemonMove.accuracy} saved to "${_moveId.toString()}MoveAccuracy"');

      var pp = await prefs.setInt(
          "${_moveId.toString()}MovePP", state.pokemonMove.pp);

      if (pp)
        print('${state.pokemonMove.pp} saved to "${_moveId.toString()}MovePP"');
    }
  }

  Future<void> _getPokemonMoveById(int moveId, BuildContext context) async {
    final pokedexCubit = BlocProvider.of<PokedexCubit>(context);
    await pokedexCubit.getPokemonMoveById(moveId, context);
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      if (_saved) {
        return Container(
            margin: buttonMargin,
            child: GestureDetector(
              onTap: () => {},
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                  decoration: BoxDecoration(
                      color: PokemonUtils.getColorByType(
                          PokemonUtils.getTypeEnum(_type)),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _name.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _damageClass,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
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
                          PokemonUtils.getTypeEnum(_type)),
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
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                          color: PokemonUtils.getLighterColorByType(
                              PokemonUtils.getTypeEnum(_type)),
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
                                      child: Image.asset(
                                        PokemonUtils.getMoveImageByType(
                                            PokemonUtils.getTypeEnum(_type)),
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                dense: false,
                                minVerticalPadding: 0,
                                minLeadingWidth: 0,
                                horizontalTitleGap: 16,
                                title: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          child: Text(
                                        "Power",
                                        textAlign: TextAlign.center,
                                      )),
                                      Container(
                                          child: Text(
                                        "Acc",
                                        textAlign: TextAlign.center,
                                      )),
                                      Container(
                                          child: Text(
                                        "PP",
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: Text(
                                                _power == 0 ? "-" : "$_power")),
                                        Container(child: Text("   $_accuracy")),
                                        Container(child: Text("$_pp")),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                listener: (context, state) async =>
                    await _pokedexListener(state),
                builder: (context, state) {
                  if (state is PokemonInitial) {
                    _getPokemonMoveById(_moveId, context);
                    return GestureDetector(
                      onTap: () {},
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 8, right: 16, left: 16),
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
                                                          Radius.circular(
                                                              50.0)),
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
                          padding: const EdgeInsets.only(
                              top: 8, right: 16, left: 16),
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
                                                          Radius.circular(
                                                              50.0)),
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
                  } else if (state is PokemonMoveLoaded) {
                    return GestureDetector(
                      onTap: () => {},
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 8, right: 16, left: 16),
                          decoration: BoxDecoration(
                              color: PokemonUtils.getColorByType(
                                  PokemonUtils.getTypeEnum(
                                      state.pokemonMove.type)),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.pokemonMove.name.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                state.pokemonMove.damageClass,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
                                  PokemonUtils.getTypeEnum(
                                      state.pokemonMove.type)),
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
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              decoration: BoxDecoration(
                                  color: PokemonUtils.getLighterColorByType(
                                      PokemonUtils.getTypeEnum(
                                          state.pokemonMove.type)),
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
                                              child: Image.asset(
                                                PokemonUtils.getMoveImageByType(
                                                    PokemonUtils.getTypeEnum(
                                                        state
                                                            .pokemonMove.type)),
                                                height: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                        dense: false,
                                        minVerticalPadding: 0,
                                        minLeadingWidth: 0,
                                        horizontalTitleGap: 16,
                                        title: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  child: Text(
                                                "Power",
                                                textAlign: TextAlign.center,
                                              )),
                                              Container(
                                                  child: Text(
                                                "Acc",
                                                textAlign: TextAlign.center,
                                              )),
                                              Container(
                                                  child: Text(
                                                "PP",
                                                textAlign: TextAlign.center,
                                              )),
                                            ],
                                          ),
                                        ),
                                        subtitle: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text(state
                                                                .pokemonMove
                                                                .power ==
                                                            0
                                                        ? "-"
                                                        : "${state.pokemonMove.power}")),
                                                Container(
                                                    child: Text(
                                                        "   ${state.pokemonMove.accuracy}")),
                                                Container(
                                                    child: Text(
                                                        "${state.pokemonMove.pp}")),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
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
                          padding: const EdgeInsets.only(
                              top: 8, right: 16, left: 16),
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
                                                          Radius.circular(
                                                              50.0)),
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
    } else {
      return Container(
          margin: buttonMargin,
          child: GestureDetector(
            onTap: () {},
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
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
                padding:
                    const EdgeInsets.only(top: 3, bottom: 3, right: 3, left: 3),
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
                                  borderRadius: BorderRadius.circular(50),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 2.0, sigmaY: 2.0),
                                    child: Container(
                                      width: 50,
                                      child: Image.asset(
                                          "assets/loaders/roll.gif"),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
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
                                dense: true,
                                minVerticalPadding: 8,
                                minLeadingWidth: 10,
                                horizontalTitleGap: 8,
                                title: Container(
                                  padding: EdgeInsets.only(top: 16),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
          ));
    }
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
