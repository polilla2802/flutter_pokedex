import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';

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
  late String _name;
  late String _imageUrl;
  late String _colorString;
  late int _dexNumber;
  late String _type1;
  late String? _type2;

  final EdgeInsetsGeometry buttonMargin =
      const EdgeInsets.only(top: 8, bottom: 8);

  _PokemonCardState(
    Pokemon pokemon,
  ) {
    _name = pokemon.name;
    _imageUrl = pokemon.imageUrl;
    _dexNumber = pokemon.dexNumber;
    _colorString = pokemon.color;
    _type1 = pokemon.type1;
    _type2 = pokemon.type2;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  String _toDexNumber(int dexNumber) {
    String dexString = dexNumber.toString();
    if (dexString.length >= 3) {
      return "#$dexNumber";
    }
    if (dexString.length == 2) {
      return "#0$dexNumber";
    }
    return "#00$dexNumber";
  }

//The function gets the Color
  Color getColor(String color) {
    switch (color) {
      case "black":
        return Colors.black;
      case "blue":
        return Colors.blue;
      case "brown":
        return Colors.brown;
      case "gray":
        return Colors.grey;
      case "green":
        return Colors.green;
      case "pink":
        return Colors.pink;
      case "purple":
        return Colors.purple;
      case "red":
        return Colors.red;
      case "white":
        return Colors.white;
      case "yellow":
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: buttonMargin,
      child: GestureDetector(
        onTap: () {},
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
                color: getColor(_colorString),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _name,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 3, bottom: 3, right: 3, left: 3),
            decoration: BoxDecoration(
                color: getColor(_colorString),
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
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                child: Container(
                                  width: 50,
                                  child: Image.network(
                                    _imageUrl,
                                    scale: .01,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0)),
                                    border: Border.all(
                                      color: getColor(_colorString),
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            dense: true,
                            minVerticalPadding: 5,
                            minLeadingWidth: 10,
                            horizontalTitleGap: 8,
                            title: Container(
                                child: Text(
                              _toDexNumber(_dexNumber),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: getColor(_colorString)),
                            )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _name,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: getColor(_colorString)),
                                ),
                                Container(height: 10),
                                Text(
                                  _type1,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: getColor(_colorString)),
                                ),
                                _type2 != null
                                    ? Text(
                                        _type2!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: getColor(_colorString)),
                                      )
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
    );
  }
}
