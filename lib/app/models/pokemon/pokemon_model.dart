import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/models/exceptions/response.dart';

class Pokemon {
  int dexNumber;
  String name;
  String type1;
  String? type2;
  int height;
  int weight;
  List<Result<Ability>> abilities;
  List<Result<Stat>> stats;
  List<Result<MoveId>> moveIds;

  Pokemon(this.dexNumber, this.name, this.type1, this.height, this.weight,
      this.abilities, this.stats, this.moveIds,
      {this.type2});

  static Result<Pokemon> fromJson(Map<String, dynamic> json) {
    var stores = json["types"];
    int len = stores.length;

    try {
      final response = Pokemon(
          json["id"],
          json["name"],
          json["types"][0]["type"]["name"],
          json["height"],
          json["weight"],
          (json["abilities"] as List)
              .map((sp) => Ability.fromJson(sp))
              .toList(),
          (json["stats"] as List).map((sp) => Stat.fromJson(sp)).toList(),
          (json["moves"] as List).map((sp) => MoveId.fromJson(sp)).toList(),
          type2: len == 2 ? json["types"][1]["type"]["name"] : null);

      return Result.ok(response);
    } catch (e) {
      print("[Pokemon] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class PokemonDetails {
  List<Result<FlavorText>> flavorText;
  List<Result<Genera>> genre;
  int genderRate;
  int baseHappiness;
  int captureRate;
  String growthRate;
  String habitat;
  bool genderDifferences;
  int hatchCounter;
  bool isBaby;
  bool isLegendary;
  String shape;
  PokemonDetails(
      this.flavorText,
      this.genre,
      this.genderRate,
      this.baseHappiness,
      this.captureRate,
      this.growthRate,
      this.habitat,
      this.genderDifferences,
      this.hatchCounter,
      this.isBaby,
      this.isLegendary,
      this.shape);

  static Result<PokemonDetails> fromJson(Map<String, dynamic> json) {
    try {
      final response = PokemonDetails(
        (json["flavor_text_entries"] as List)
            .map((sp) => FlavorText.fromJson(sp))
            .toList(),
        (json["genera"] as List).map((sp) => Genera.fromJson(sp)).toList(),
        json["gender_rate"],
        json["base_happiness"],
        json["capture_rate"],
        json["growth_rate"]["name"],
        json["habitat"]["name"],
        json["has_gender_differences"],
        json["hatch_counter"],
        json["is_baby"],
        json["is_legendary"],
        json["shape"]["name"],
      );

      return Result.ok(response);
    } catch (e) {
      print("[PokemonDetails] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class PokemonMove {
  String name;
  String type;
  String damageClass;
  int? power;
  int? accuracy;
  int pp;

  PokemonMove(this.name, this.type, this.damageClass, this.power, this.accuracy,
      this.pp);

  static Result<PokemonMove> fromJson(Map<String, dynamic> json) {
    try {
      final response = PokemonMove(
        json["name"],
        json["type"]["name"],
        json["damage_class"]["name"],
        json["power"] != null ? json["power"] : 0,
        json["accuracy"] != null ? json["accuracy"] : 100,
        json["pp"],
      );

      return Result.ok(response);
    } catch (e) {
      print("[PokemonMove] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class MoveId {
  String moveId;
  MoveId(this.moveId);

  static Result<MoveId> fromJson(Map<String, dynamic> json) {
    try {
      final response = MoveId(json["move"]["url"]);

      return Result.ok(response);
    } catch (e) {
      print("[MoveId] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class Stat {
  int baseStat;
  String stat;
  Stat(this.baseStat, this.stat);

  static Result<Stat> fromJson(Map<String, dynamic> json) {
    try {
      final response = Stat(json["base_stat"], json["stat"]["name"]);

      return Result.ok(response);
    } catch (e) {
      print("[Stat] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class Ability {
  String abilityName;
  Ability(this.abilityName);

  static Result<Ability> fromJson(Map<String, dynamic> json) {
    try {
      final response = Ability(json["ability"]["name"]);

      return Result.ok(response);
    } catch (e) {
      print("[Ability] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class Genera {
  String genus;
  Result<Language> language;
  Genera(this.genus, this.language);

  static Result<Genera> fromJson(Map<String, dynamic> json) {
    try {
      final response =
          Genera(json["genus"], Language.fromJson(json["language"]));

      return Result.ok(response);
    } catch (e) {
      print("[Genera] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class FlavorText {
  String flavorText;
  Result<Language> language;
  FlavorText(this.flavorText, this.language);

  static Result<FlavorText> fromJson(Map<String, dynamic> json) {
    try {
      final response =
          FlavorText(json["flavor_text"], Language.fromJson(json["language"]));

      return Result.ok(response);
    } catch (e) {
      print("[FlavorText] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}

class Language {
  String name;
  Language(this.name);

  static Result<Language> fromJson(Map<String, dynamic> json) {
    try {
      final response = Language(json["name"]);

      return Result.ok(response);
    } catch (e) {
      print("[Language] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}
