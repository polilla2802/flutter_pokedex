import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/controllers/cubit/pokedex_cubit.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_list_tile.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_move.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';
import 'package:flutter_pokedex/app/services/utils/util.dart';

class PokemonDetailsScreen extends StatefulWidget {
  static const String pokemonDetailsScreenKey = "/pokemon_details_screen";
  final int pokemonId;

  const PokemonDetailsScreen(this.pokemonId, {Key? key}) : super(key: key);

  @override
  State<PokemonDetailsScreen> createState() =>
      _PokemonDetailsScreenState(pokemonDetailsScreenKey, pokemonId);
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen>
    with SingleTickerProviderStateMixin {
  String? _key;
  late int _pokemonId;
  late PokedexRepo _pokedexRepo;
  late String _imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/';

  TextStyle _titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: ConstValues.secondaryColor);
  TextStyle _subStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: ConstValues.secondaryColor);
  TextStyle _textStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: ConstValues.secondaryColor);

  int _selectedIndex = 0;
  List<int> ids = [];

  _PokemonDetailsScreenState(String pokemonDetailsScreenKey, int pokemonId) {
    _key = pokemonDetailsScreenKey;
    _pokemonId = pokemonId;
    _pokedexRepo = PokedexRepo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _getPokemonDetails(BuildContext context) async {
    final pokedexCubit = BlocProvider.of<PokedexCubit>(context);
    await pokedexCubit.getPokemonDetailsById(_pokemonId, context);
  }

  Future<void> _pokedexListener(PokedexState state) async {
    if (state is PokemonError) {
      print("error");
      print("${state.message}");
    }

    if (state is PokemonLoaded) {}
  }

  void _getPokemonMoveIds(String moveId) {
    ids.add(int.parse(moveId
        .replaceAll('https://pokeapi.co/api/v2/move/', '')
        .replaceAll('/', '')));
  }

  int _getTotal(PokemonLoaded state) {
    int total = 0;
    for (var i in state.pokemon.stats) total += i.data!.baseStat;
    return total;
  }

  String _getDexEntry(PokemonLoaded state) {
    String _dexEntry = "";
    for (var i in state.pokemonDetails!.flavorText) {
      if (i.data!.language.data!.name == "en") {
        _dexEntry = i.data!.flavorText;
        return _dexEntry.replaceAll('\n', ' ').replaceAll('\f', ' ');
      }
    }
    return _dexEntry.replaceAll('\n', ' ').replaceAll('\f', ' ');
  }

  String _getGenreType(PokemonLoaded state) {
    String _genreType = "";
    for (var i in state.pokemonDetails!.genre) {
      if (i.data!.language.data!.name == "en") {
        _genreType = i.data!.genus;
        return _genreType;
      }
    }
    return _genreType;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PokedexCubit(_pokedexRepo),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )),
            title: Container(
                width: double.infinity,
                child: Text(
                  PokemonUtils.toDexNumber(_pokemonId),
                  textAlign: TextAlign.right,
                )),
          ),
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Center(
          child: BlocConsumer<PokedexCubit, PokedexState>(
        listener: (context, state) => _pokedexListener(state),
        builder: (context, state) {
          if (state is PokemonInitial) {
            _getPokemonDetails(context);
            return Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/backgrounds/grey.png")),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(500.0)),
                    ),
                    child: Image.asset("assets/loaders/roll.gif")),
              ],
            );
          } else if (state is PokemonLoading) {
            return Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/backgrounds/grey.png")),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(500.0)),
                    ),
                    child: Image.asset("assets/loaders/roll.gif")),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(
                        color: ConstValues.secondaryColor,
                        width: 5.0,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Image.asset("assets/loaders/roll.gif")],
                    ),
                  ),
                )
              ],
            );
          } else if (state is PokemonLoaded) {
            return Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/backgrounds/grey.png")),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(500.0)),
                    ),
                    child: _getPokemonImg()),
                _getPokemonListTile(_pokemonId),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: PokemonUtils.getLighterColorByType(
                            PokemonUtils.getTypeEnum(state.pokemon.type1)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                          color: PokemonUtils.getColorByType(
                              PokemonUtils.getTypeEnum(state.pokemon.type1)),
                          width: 5.0,
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                  child: Wrap(children: [_getContent(state)])),
                            ),
                          ),
                          BottomNavigationBar(
                              elevation: 0.0,
                              type: BottomNavigationBarType.shifting,
                              currentIndex: _selectedIndex, //New
                              onTap: _onItemTapped,
                              selectedItemColor: PokemonUtils.getColorByType(
                                  PokemonUtils.getTypeEnum(
                                      state.pokemon.type1)),
                              items: [
                                BottomNavigationBarItem(
                                  label: "About",
                                  activeIcon: Icon(Icons.account_circle,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  icon: Icon(Icons.account_circle,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  backgroundColor: Colors.transparent,
                                ),
                                BottomNavigationBarItem(
                                  label: "Stats",
                                  icon: Icon(Icons.stacked_bar_chart_sharp,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  activeIcon: Icon(
                                      Icons.stacked_bar_chart_sharp,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  backgroundColor: Colors.transparent,
                                ),
                                BottomNavigationBarItem(
                                  label: "Evolution",
                                  icon: Icon(Icons.group_work,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  activeIcon: Icon(Icons.group_work,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  backgroundColor: Colors.transparent,
                                ),
                                BottomNavigationBarItem(
                                  label: "Moves",
                                  activeIcon: Icon(Icons.move_down_sharp,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  icon: Icon(Icons.move_down_sharp,
                                      color: PokemonUtils.getColorByType(
                                          PokemonUtils.getTypeEnum(
                                              state.pokemon.type1))),
                                  backgroundColor: Colors.transparent,
                                )
                              ]),
                        ],
                      )),
                )
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/backgrounds/grey.png")),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(500.0)),
                    ),
                    child: _getPokemonImg()),
                _getPokemonListTile(_pokemonId),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(
                        color: ConstValues.secondaryColor,
                        width: 5.0,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                  ),
                )
              ],
            );
          }
        },
      )),
    );
  }

  List<Widget> _getAbilities(PokemonLoaded state, TextStyle textStyle) {
    List<Widget> abilities = [];
    for (var i in state.pokemon.abilities) {
      abilities.add(
        Container(
          padding: EdgeInsets.only(bottom: 8, right: 8),
          child: Text("${i.data!.abilityName}", style: textStyle),
        ),
      );
    }

    return abilities;
  }

  Widget _getPokemonImg() {
    return CachedNetworkImage(
        imageUrl: _imageUrl + "$_pokemonId.png",
        fadeInDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => Image.asset("assets/loaders/roll.gif"));
  }

  Widget _getPokemonListTile(int id) {
    return PokemonListTile(id, false, false, false);
  }

  Widget _getAboutContent(PokemonLoaded state) {
    String weight = state.pokemon.weight.toString();
    String gr = weight.substring(weight.length - 1, weight.length);

    String kg = weight.substring(0, weight.length - 1);
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dex Entry:", style: _titleStyle),
                  if (state.pokemonDetails != null)
                    Flexible(
                      child: Text(_getGenreType(state), style: _subStyle),
                    ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.pokemonDetails != null)
                    Flexible(
                      child: Text(_getDexEntry(state), style: _textStyle),
                    ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Height:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Flexible(
                      child:
                          Text("${state.pokemon.height}''", style: _subStyle),
                    ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Weight:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Flexible(
                      child: Text("$kg.$gr", style: _subStyle),
                    ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Text("Abilities", style: _titleStyle),
            ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [..._getAbilities(state, _textStyle)]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Text("Relationship", style: _titleStyle),
            ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Growth Rate:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.growthRate}",
                        style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Base Happiness:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.baseHappiness}",
                        style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hatch Counter:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.hatchCounter}",
                        style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Text("Habitat", style: _titleStyle),
            ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Lives in:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.habitat}", style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Capture Rate:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.captureRate}",
                        style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Text("Gender", style: _titleStyle),
            ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gender Differences:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.genderDifferences}",
                        style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gender Rate:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text(
                      "${state.pokemonDetails!.genderRate}",
                      style: _subStyle,
                    ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Text("Characteristics", style: _titleStyle),
            ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Baby:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.isBaby}", style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Legendary:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.isLegendary}",
                        style: _subStyle)
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Shape:", style: _textStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemonDetails!.shape}", style: _subStyle)
                ]),
          ),
        ]);
  }

  Widget _getStatsContent(PokemonLoaded state) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${state.pokemon.stats[0].data!.stat.toUpperCase()}",
                      style: _subStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemon.stats[0].data!.baseStat}",
                        style: _subStyle),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${state.pokemon.stats[1].data!.stat.toUpperCase()}",
                      style: _subStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemon.stats[1].data!.baseStat}",
                        style: _subStyle),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${state.pokemon.stats[2].data!.stat.toUpperCase()}",
                      style: _subStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemon.stats[2].data!.baseStat}",
                        style: _subStyle),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${state.pokemon.stats[3].data!.stat.toUpperCase()}",
                      style: _subStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemon.stats[3].data!.baseStat}",
                        style: _subStyle),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${state.pokemon.stats[4].data!.stat.toUpperCase()}",
                      style: _subStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemon.stats[4].data!.baseStat}",
                        style: _subStyle),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${state.pokemon.stats[5].data!.stat.toUpperCase()}",
                      style: _subStyle),
                  if (state.pokemonDetails != null)
                    Text("${state.pokemon.stats[5].data!.baseStat}",
                        style: _subStyle),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("TOTAL", style: _subStyle),
                  if (state.pokemonDetails != null)
                    Text("${_getTotal(state)}", style: _subStyle),
                ]),
          ),
        ]);
  }

  Widget _getEvolutionContent(PokemonLoaded state) {
    int stateParse = int.parse(state
        .pokemonChain!.evolutionChain.data!.pokemonSpecie.data!.id
        .replaceAll('https://pokeapi.co/api/v2/pokemon-species/', '')
        .replaceAll('/', ''));
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (stateParse <= environment!.totalPokemon!)
            Container(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: state.pokemon.dexNumber == stateParse
                        ? null
                        : () async => {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PokemonDetailsScreen(stateParse)),
                              )
                            },
                    child: Container(
                      child: Image.network(
                        "$_imageUrl$stateParse.png",
                        width: 80,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ..._getChain(state),
          for (var i in state.pokemonChain!.evolutionChain.data!.pokemonLink)
            for (var j in i.data!.pokemonLink)
              if (int.parse(j.data!.pokemonSpecie.data!.id
                      .replaceAll(
                          'https://pokeapi.co/api/v2/pokemon-species/', '')
                      .replaceAll('/', '')) <=
                  environment!.totalPokemon!)
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: state.pokemon.dexNumber ==
                                int.parse(j.data!.pokemonSpecie.data!.id
                                    .replaceAll(
                                        'https://pokeapi.co/api/v2/pokemon-species/',
                                        '')
                                    .replaceAll('/', ''))
                            ? null
                            : () async => {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PokemonDetailsScreen(int.parse(j
                                                .data!.pokemonSpecie.data!.id
                                                .replaceAll(
                                                    'https://pokeapi.co/api/v2/pokemon-species/',
                                                    '')
                                                .replaceAll('/', '')))),
                                  )
                                },
                        child: Container(
                          child: Image.network(
                            "$_imageUrl${int.parse(j.data!.pokemonSpecie.data!.id.replaceAll('https://pokeapi.co/api/v2/pokemon-species/', '').replaceAll('/', ''))}.png",
                            width: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  List<Widget> _getChain(PokemonLoaded state) {
    return [
      for (var i in state.pokemonChain!.evolutionChain.data!.pokemonLink)
        if (int.parse(i.data!.pokemonSpecie.data!.id
                .replaceAll('https://pokeapi.co/api/v2/pokemon-species/', '')
                .replaceAll('/', '')) <=
            environment!.totalPokemon!)
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: state.pokemon.dexNumber ==
                          int.parse(i.data!.pokemonSpecie.data!.id
                              .replaceAll(
                                  'https://pokeapi.co/api/v2/pokemon-species/',
                                  '')
                              .replaceAll('/', ''))
                      ? null
                      : () async => {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PokemonDetailsScreen(
                                      int.parse(i.data!.pokemonSpecie.data!.id
                                          .replaceAll(
                                              'https://pokeapi.co/api/v2/pokemon-species/',
                                              '')
                                          .replaceAll('/', '')))),
                            )
                          },
                  child: Container(
                    child: Image.network(
                      "$_imageUrl${int.parse(i.data!.pokemonSpecie.data!.id.replaceAll('https://pokeapi.co/api/v2/pokemon-species/', '').replaceAll('/', ''))}.png",
                      width: 80,
                    ),
                  ),
                ),
              ],
            ),
          )
    ];
  }

  Widget _getMovesContent(PokemonLoaded state) {
    ids.clear();
    for (var i in state.pokemon.moveIds) _getPokemonMoveIds(i.data!.moveId);
    print(ids);
    List<int> finalIds = ids.toSet().toList();
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [for (var i in finalIds) _getPokemonMoveCard(i)]);
  }

  Widget _getPokemonMoveCard(int moveId) {
    return PokemonMoveCard(moveId);
  }

  Widget _getContent(PokemonLoaded state) {
    switch (_selectedIndex) {
      case 0:
        return _getAboutContent(state);
      case 1:
        return _getStatsContent(state);
      case 2:
        return _getEvolutionContent(state);
      case 3:
        return _getMovesContent(state);
      default:
        return _getAboutContent(state);
    }
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
