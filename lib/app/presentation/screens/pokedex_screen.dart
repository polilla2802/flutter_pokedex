import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_card.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_list_tile.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/screens/login_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/teams_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokedexScreen extends StatefulWidget {
  static const String pokedexScreenKey = "/pokedex_screen";
  final bool selectable;

  const PokedexScreen(this.selectable, {Key? key}) : super(key: key);

  @override
  State<PokedexScreen> createState() =>
      _PokedexScreenState(pokedexScreenKey, selectable);
}

class _PokedexScreenState extends State<PokedexScreen> {
  String? _key;
  late String _userName = "";
  late ScrollController _scrollController;
  late int _pokemonCount = 10;
  late bool _listView = false;
  late bool _selectable = false;
  late List<int> _selected = [];

  _PokedexScreenState(String pokedexScreenKey, bool selectable) {
    _key = pokedexScreenKey;
    _selectable = selectable;
    _listView = _selectable;
    _scrollController = ScrollController();
  }

  @override
  void initState() {
    super.initState();
    _scrollListener();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    await _getUser();
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString("UserName")!;
      _listView = prefs.getBool("ListView") ?? false;
      _selectable ? _listView = true : _listView = _listView;
      print("_userName $_userName");
    });
  }

  Future<void> _setListView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var done = await prefs.setBool("ListView", !_listView);

    if (done) print('[$_key] ListView saved to $_listView');
    setState(() {
      _listView = !_listView;
    });
  }

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool done = await prefs.remove("UserName");
    if (done) print("prefs cleared");

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: LoginScreen.loginScreenKey),
        builder: (context) => LoginScreen()));
  }

  Future<void> _toTeamsScreenReplacement() async {
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: TeamsScreen.teamsScreenKey),
        builder: (context) => TeamsScreen(team: _selected)));
  }

  Future<void> _toTeamsScreenPush() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeamsScreen()),
    );
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
        if (_pokemonCount == 150) {
          setState(() {
            _pokemonCount = _pokemonCount + 1;
          });
        }
      }
    });
  }

  void _addPokemon(int value) {
    setState(() {
      _selected.add(value);
    });
    if (_selected.length == 6) {
      _toTeamsScreenReplacement();
    }
  }

  void _resPokemon(int value) {
    setState(() {
      _selected.remove(value);
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
            appBar: _selectable
                ? AppBar(
                    backgroundColor: _selectable
                        ? ConstValues.primaryColor
                        : ConstValues.secondaryColor,
                    leading: Container(),
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
                      _selected.length == 6
                          ? GestureDetector(
                              onTap: () => _toTeamsScreenReplacement(),
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.check, color: Colors.white),
                              ))
                          : GestureDetector(
                              child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ))
                    ],
                  )
                : AppBar(
                    backgroundColor: _selectable
                        ? ConstValues.primaryColor
                        : ConstValues.secondaryColor,
                    leading: _listView
                        ? GestureDetector(
                            onTap: () => _setListView(),
                            child: Container(
                              child: Icon(
                                Icons.grid_view,
                                color: Colors.white,
                              ),
                            ))
                        : GestureDetector(
                            onTap: () => _setListView(),
                            child: Container(
                              child: Icon(
                                Icons.list,
                                color: Colors.white,
                              ),
                            )),
                    title: Container(
                      width: double.infinity,
                      child: Text(
                        _userName,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    actions: [
                      GestureDetector(
                          onTap: () => _logOut(),
                          child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.logout,
                                color: Colors.white,
                              )))
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
