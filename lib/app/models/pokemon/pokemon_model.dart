class Pokemon {
  String name;
  String imageUrl;
  String color;
  int dexNumber;
  String type1;
  String? type2;

  Pokemon(
    this.name,
    this.imageUrl,
    this.color,
    this.dexNumber,
    this.type1, {
    this.type2,
  });
}
