import 'dart:convert';
import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/models/exceptions/response.dart';

class Pokemon {
  int dexNumber;
  String name;
  String type1;
  String? type2;

  Pokemon(this.dexNumber, this.name, this.type1, {this.type2});

  static Result<Pokemon> fromJson(Map<String, dynamic> json) {
    var stores = json["types"];
    int len = stores.length;

    try {
      final response = Pokemon(
          json["id"], json["name"], json["types"][0]["type"]["name"],
          type2: len == 2 ? json["types"][1]["type"]["name"] : null);

      return Result.ok(response);
    } catch (e) {
      print("[Pokemon] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }
}
