import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_card.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_list_tile.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/components/dialogs/team_name_dialog.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokedex_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/teams_screen.dart';

class PokedexSelectScreen extends StatefulWidget {
  static const String pokedexSelectScreenKey = "/pokedex_select_screen";

  const PokedexSelectScreen({Key? key}) : super(key: key);

  @override
  State<PokedexSelectScreen> createState() =>
      _PokedexSelectScreenState(pokedexSelectScreenKey);
}

class _PokedexSelectScreenState extends State<PokedexSelectScreen> {
  String? _key;
  late ScrollController _scrollController;
  late String _teamName = "";
  late int _pokemonCount = 10;
  late bool _listView = true;
  late bool _selectable = true;
  late List<int> _selected = [];
  late GlobalKey<FormState> _formKey;
  late FocusNode _myFocus;

  _PokedexSelectScreenState(String pokedexSelectScreenKey) {
    _key = pokedexSelectScreenKey;
    _scrollController = ScrollController();
    _formKey = GlobalKey<FormState>();
    _myFocus = FocusNode();
  }

  @override
  void initState() {
    super.initState();
    _scrollListener();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _toTeamsScreenReplacement() async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
        TeamsScreen.teamsScreenKey,
        ModalRoute.withName(PokedexScreen.pokedexScreenKey),
        arguments: TeamsScreenArgs(_selected, _teamName));
  }

  Future<void> _toTeamsScreenPush() async {
    await Navigator.of(context).pushNamed(TeamsScreen.teamsScreenKey);
  }

  Future<void> _chooseName(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Form(
              key: _formKey,
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(16),
                child: Container(
                    child: TeamNameDialog(
                        focusNode: _myFocus,
                        onClosed: () {
                          Navigator.of(context).pop();
                          _selected.removeLast();
                          setState(() {});
                        },
                        onPressed: () async {
                          await _validateName();
                        },
                        onSaved: (value) => _saveName(value))),
              ),
            ));
      },
    );
  }

  Future<void> _validateName() async {
    print("[_validateName] invoked");

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    print("_teamName $_teamName");

    await _toTeamsScreenReplacement();
  }

  void _saveName(String value) {
    print("[_saveName] invoked");

    _teamName = value;
  }

  void _addPokemon(int value) {
    setState(() {
      _selected.add(value);
    });
    if (_selected.length == 6) {
      _chooseName(context);
    }
  }

  void _resPokemon(int value) {
    setState(() {
      _selected.remove(value);
    });
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        //the bottom of the scrollbar is reached
        //adding more pokemon
        print("reached bottom");

        if (_pokemonCount < environment!.totalPokemon!) {
          setState(() {
            _pokemonCount = _pokemonCount + 10;
          });
        }
        if (_pokemonCount == 370) {
          setState(() {
            _pokemonCount = _pokemonCount + 7;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_selectable) {
            return true;
          }
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: _selectable
                  ? ConstValues.primaryColor
                  : ConstValues.secondaryColor,
              title: Container(
                width: double.infinity,
                child: Text(
                  _selected.length == 0
                      ? "Select Team"
                      : _selected.length.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              actions: [
                _selected.length > 0
                    ? GestureDetector(
                        onTap: () async => await _chooseName(context),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.check, color: Colors.white),
                        ))
                    : GestureDetector(
                        child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ))
              ],
            ),
            body: _buildBody(),
            floatingActionButton: _selectable ? null : _floatingButton()));
  }

  Widget _buildBody() {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Container(
            alignment: Alignment.topCenter,
            child: _listView
                ? _buildPokedexList(_pokemonCount)
                : _buildPokedexGrid(_pokemonCount)));
  }

  Widget _buildPokedexList(int pokemonCount) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: Wrap(children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            for (int i = 1; i < pokemonCount; i++) _getPokemonListTile(i)
          ])
        ]));
  }

  Widget _buildPokedexGrid(int pokemonCount) {
    return Center(
        child: GridView.extent(
      controller: _scrollController,
      primary: false,
      padding: const EdgeInsets.all(0),
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      maxCrossAxisExtent: 200.0,
      children: [for (int i = 1; i < pokemonCount; i++) _getPokemonCard(i)],
    ));
  }

  Widget _getPokemonListTile(int id) {
    return PokemonListTile(id, true, _selectable, false,
        addPokemon: (int val) => _addPokemon(val),
        resPokemon: (int val) => _resPokemon(val));
  }

  Widget _getPokemonCard(int id) {
    return PokemonCard(id);
  }

  Widget _floatingButton() {
    return FloatingActionButton(
      onPressed: () async => {_toTeamsScreenPush()},
      backgroundColor: ConstValues.primaryColor,
      child: const Icon(Icons.menu),
    );
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    _scrollController.dispose();
    super.dispose();
  }
}
