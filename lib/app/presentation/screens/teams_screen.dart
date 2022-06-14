import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_team.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokedex_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokedex_select_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamsScreenArgs {
  final List<int>? team;
  final String? teamName;

  TeamsScreenArgs(this.team, this.teamName);
}

class TeamsScreen extends StatefulWidget {
  static const String teamsScreenKey = "/teams_screen";
  final List<int>? team;
  final String? teamName;
  const TeamsScreen({Key? key, this.team, this.teamName}) : super(key: key);

  @override
  State<TeamsScreen> createState() =>
      _TeamsScreenState(teamsScreenKey, team, teamName);
}

class _TeamsScreenState extends State<TeamsScreen> {
  String? _key;
  late List<String>? _teamNames = [];
  late List<String>? _teams = [];
  late List<int>? _team;
  late String? _teamName;

  _TeamsScreenState(String teamsScreenKey, List<int>? team, String? teamName) {
    _key = teamsScreenKey;
    _team = team;
    _teamName = teamName;
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    await _getTeams();
    await _getTeamsNames();
    if (_teamName != null) await _setTeamName();
    if (_team != null) await _setTeam();
    setState(() {});
  }

  Future<void> _getTeams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _teams = prefs.getStringList("Teams") ?? [];
    print(_teams);
  }

  Future<void> _getTeamsNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _teamNames = prefs.getStringList("TeamNames") ?? [];
    print(_teamNames);
  }

  Future<void> _setTeamName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _teamNames!.add(_teamName!);
    var done = await prefs.setStringList("TeamNames", _teamNames!);

    if (done) print('[$_key] TeamNames saved to $_teamNames');
  }

  Future<void> _setTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _teams!.add(_team!.join(","));
    var done = await prefs.setStringList("Teams", _teams!);

    if (done) print('[$_key] Teams saved to $_teams');
  }

  Future<void> _toPokedexScreen() async {
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: PokedexScreen.pokedexScreenKey),
        builder: (context) => PokedexScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (true) {
            await _toPokedexScreen();
          }
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () async => await _toPokedexScreen(),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: Container(
                width: double.infinity,
                child: Text(
                  "Teams",
                  textAlign: TextAlign.center,
                ),
              ),
              actions: [
                GestureDetector(
                    child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ))
              ],
            ),
            body: _buildBody(),
            floatingActionButton: _floatingButton()));
  }

  Widget _buildBody() {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Container(
            alignment: Alignment.topCenter, child: _buildPokedexList()));
  }

  Widget _buildPokedexList() {
    return SingleChildScrollView(
        child: Wrap(children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        for (int i = 0; i < _teamNames!.length; i++)
          PokemonTeamCard(_teamNames![i], _teams![i])
      ])
    ]));
  }

  Widget _floatingButton() {
    return FloatingActionButton(
      onPressed: () async => await Navigator.of(context)
          .pushNamed(PokedexSelectScreen.pokedexSelectScreenKey),
      backgroundColor: ConstValues.primaryColor,
      child: const Icon(Icons.add),
    );
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
