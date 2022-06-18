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

  const PokedexScreen({Key? key}) : super(key: key);

  @override
  State<PokedexScreen> createState() => _PokedexScreenState(pokedexScreenKey);
}

class _PokedexScreenState extends State<PokedexScreen> {
  String? _key;
  late String _userName = "";
  late ScrollController _scrollController;
  late int _pokemonCount = 10;
  late bool _listView = false;

  _PokedexScreenState(String pokedexScreenKey) {
    _key = pokedexScreenKey;
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
      print("_userName $_userName");
    });
  }

  Future<void> _setListView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var done = await prefs.setBool("ListView", !_listView);

    if (done) print('[$_key] ListView saved to $_listView');
    setState(() {
      _pokemonCount = 10;
      _listView = !_listView;
    });
  }

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool doneUserName = await prefs.remove("UserName");
    if (doneUserName) print("UserName prefs cleared");

    bool doneTeams = await prefs.remove("Teams");
    if (doneTeams) print("Teams prefs cleared");

    bool doneTeamNames = await prefs.remove("TeamNames");
    if (doneTeamNames) print("TeamNames prefs cleared");

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: LoginScreen.loginScreenKey),
        builder: (context) => LoginScreen()));
  }

  Future<void> _toTeamsScreenPush() async {
    await Navigator.of(context).pushNamed(TeamsScreen.teamsScreenKey);
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
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ConstValues.secondaryColor,
              leading: _listView
                  ? GestureDetector(
                      onTap: () async => await _setListView(),
                      child: Container(
                        width: 100,
                        child: Icon(
                          Icons.grid_view,
                          color: Colors.white,
                        ),
                      ))
                  : GestureDetector(
                      onTap: () async => await _setListView(),
                      child: Container(
                        width: 100,
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
                    onTap: () async => await _logOut(),
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        )))
              ],
            ),
            body: _buildBody(),
            floatingActionButton: _floatingButton()));
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
    return PokemonListTile(
      id,
      true,
      false,
      false,
    );
  }

  Widget _getPokemonCard(int id) {
    return PokemonCard(id);
  }

  Widget _floatingButton() {
    return FloatingActionButton(
      onPressed: () async => await _toTeamsScreenPush(),
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
