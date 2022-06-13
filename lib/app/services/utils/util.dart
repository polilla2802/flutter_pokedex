import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';

enum Type {
  normal,
  fighting,
  flying,
  poison,
  ground,
  rock,
  bug,
  ghost,
  steel,
  fire,
  water,
  grass,
  electric,
  psychic,
  ice,
  dragon,
  dark,
  fairy,
  unknown,
  shadow
}

extension PokemonUtils on Pokemon {
  static String toDexNumber(int dexNumber) {
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
  static String getImageByType(Type type) {
    switch (type) {
      case Type.normal:
        return "assets/types/normal.png";
      case Type.fighting:
        return "assets/types/fighting.png";
      case Type.flying:
        return "assets/types/flying.png";
      case Type.poison:
        return "assets/types/poison.png";
      case Type.ground:
        return "assets/types/ground.png";
      case Type.rock:
        return "assets/types/rock.png";
      case Type.bug:
        return "assets/types/bug.png";
      case Type.ghost:
        return "assets/types/ghost.png";
      case Type.steel:
        return "assets/types/steel.png";
      case Type.fire:
        return "assets/types/fire.png";
      case Type.water:
        return "assets/types/water.png";
      case Type.grass:
        return "assets/types/grass.png";
      case Type.electric:
        return "assets/types/electric.png";
      case Type.psychic:
        return "assets/types/psychic.png";
      case Type.ice:
        return "assets/types/ice.png";
      case Type.dragon:
        return "assets/types/dragon.png";
      case Type.dark:
        return "assets/types/dark.png";
      case Type.fairy:
        return "assets/types/fairy.png";
      case Type.unknown:
        return "assets/types/ghost.png";
      case Type.shadow:
        return "assets/types/ghost.png";
      default:
        return "assets/types/ghost.png";
    }
  }

  static String getMoveImageByType(Type type) {
    switch (type) {
      case Type.normal:
        return "assets/move_types/POKEMON_TYPE_NORMAL_BORDERED.png";
      case Type.fighting:
        return "assets/move_types/POKEMON_TYPE_FIGHTING_BORDERED.png";
      case Type.flying:
        return "assets/move_types/POKEMON_TYPE_FLYING_BORDERED.png";
      case Type.poison:
        return "assets/move_types/POKEMON_TYPE_POISON_BORDERED.png";
      case Type.ground:
        return "assets/move_types/POKEMON_TYPE_GROUND_BORDERED.png";
      case Type.rock:
        return "assets/move_types/POKEMON_TYPE_ROCK_BORDERED.png";
      case Type.bug:
        return "assets/move_types/POKEMON_TYPE_BUG_BORDERED.png";
      case Type.ghost:
        return "assets/move_types/POKEMON_TYPE_GHOST_BORDERED.png";
      case Type.steel:
        return "assets/move_types/POKEMON_TYPE_STEEL_BORDERED.png";
      case Type.fire:
        return "assets/move_types/POKEMON_TYPE_FIRE_BORDERED.png";
      case Type.water:
        return "assets/move_types/POKEMON_TYPE_WATER_BORDERED.png";
      case Type.grass:
        return "assets/move_types/POKEMON_TYPE_GRASS_BORDERED.png";
      case Type.electric:
        return "assets/move_types/POKEMON_TYPE_ELECTRIC_BORDERED.png";
      case Type.psychic:
        return "assets/move_types/POKEMON_TYPE_PSYCHIC_BORDERED.png";
      case Type.ice:
        return "assets/move_types/POKEMON_TYPE_ICE_BORDERED.png";
      case Type.dragon:
        return "assets/move_types/POKEMON_TYPE_DRAGON_BORDERED.png";
      case Type.dark:
        return "assets/move_types/POKEMON_TYPE_DARK_BORDERED.png";
      case Type.fairy:
        return "assets/move_types/POKEMON_TYPE_FAIRY_BORDERED.png";
      case Type.unknown:
        return "assets/move_types/POKEMON_TYPE_GHOST_BORDERED.png";
      case Type.shadow:
        return "assets/move_types/POKEMON_TYPE_GHOST_BORDERED.png";
      default:
        return "assets/move_types/POKEMON_TYPE_GHOST_BORDERED.png";
    }
  }

//The function gets the Color by Pokemon Type
  static Color getColorByType(Type type) {
    switch (type) {
      case Type.normal:
        return Colors.grey.shade400;
      case Type.fighting:
        return Colors.brown.shade600;
      case Type.flying:
        return Colors.lightBlue;
      case Type.poison:
        return Colors.purple.shade600;
      case Type.ground:
        return Colors.brown.shade400;
      case Type.rock:
        return Colors.lime.shade900;
      case Type.bug:
        return Colors.lightGreen.shade600;
      case Type.ghost:
        return Colors.deepPurple;
      case Type.steel:
        return Colors.blueGrey;
      case Type.fire:
        return Colors.orange.shade900;
      case Type.water:
        return Colors.blue;
      case Type.grass:
        return Colors.green;
      case Type.electric:
        return Colors.yellow.shade700;
      case Type.psychic:
        return Colors.pink.shade400;
      case Type.ice:
        return Colors.lightBlue.shade200;
      case Type.dragon:
        return Colors.deepPurple.shade500;
      case Type.dark:
        return Colors.brown.shade900;
      case Type.fairy:
        return Colors.pink.shade200;
      case Type.unknown:
        return Colors.black;
      case Type.shadow:
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  //The function gets the Color by Pokemon Type
  static Color getLighterColorByType(Type type) {
    switch (type) {
      case Type.normal:
        return Colors.grey.shade100;
      case Type.fighting:
        return Colors.brown.shade100;
      case Type.flying:
        return Colors.lightBlue.shade100;
      case Type.poison:
        return Colors.purple.shade100;
      case Type.ground:
        return Colors.brown.shade100;
      case Type.rock:
        return Colors.brown.shade100;
      case Type.bug:
        return Colors.green.shade100;
      case Type.ghost:
        return Colors.deepPurple.shade100;
      case Type.steel:
        return Colors.blueGrey.shade100;
      case Type.fire:
        return Colors.deepOrange.shade100;
      case Type.water:
        return Colors.blue.shade100;
      case Type.grass:
        return Colors.green.shade100;
      case Type.electric:
        return Colors.yellow.shade100;
      case Type.psychic:
        return Colors.pink.shade100;
      case Type.ice:
        return Colors.lightBlue.shade100;
      case Type.dragon:
        return Colors.deepPurple.shade100;
      case Type.dark:
        return Colors.white10;
      case Type.fairy:
        return Colors.pink.shade100;
      case Type.unknown:
        return Colors.white10;
      case Type.shadow:
        return Colors.white10;
      default:
        return Colors.white10;
    }
  }

  //The function gets the Color
  static Type getTypeEnum(String type) {
    switch (type) {
      case "normal":
        return Type.normal;
      case "fighting":
        return Type.fighting;
      case "flying":
        return Type.flying;
      case "poison":
        return Type.poison;
      case "ground":
        return Type.ground;
      case "rock":
        return Type.rock;
      case "bug":
        return Type.bug;
      case "ghost":
        return Type.ghost;
      case "steel":
        return Type.steel;
      case "fire":
        return Type.fire;
      case "water":
        return Type.water;
      case "grass":
        return Type.grass;
      case "electric":
        return Type.electric;
      case "psychic":
        return Type.psychic;
      case "ice":
        return Type.ice;
      case "dragon":
        return Type.dragon;
      case "dark":
        return Type.dark;
      case "fairy":
        return Type.fairy;
      case "unknown":
        return Type.unknown;
      case "shadow":
        return Type.shadow;

      default:
        return Type.unknown;
    }
  }
}
