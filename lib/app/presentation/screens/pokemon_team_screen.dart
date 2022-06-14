import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_list_tile.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/screens/teams_screen.dart';

class PokemonTeamScreen extends StatefulWidget {
  static const String pokemonTeamScreenKey = "/pokemon_team_screen";
  final TeamsScreenArgs team;

  const PokemonTeamScreen(this.team, {Key? key}) : super(key: key);

  @override
  State<PokemonTeamScreen> createState() =>
      _PokemonTeamScreenState(pokemonTeamScreenKey, team);
}

class _PokemonTeamScreenState extends State<PokemonTeamScreen> {
  String? _key;
  late TeamsScreenArgs _team;

  _PokemonTeamScreenState(String pokemonTeamScreenKey, TeamsScreenArgs team) {
    _key = pokemonTeamScreenKey;
    _team = team;
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ConstValues.secondaryColor,
          title: Container(
            width: double.infinity,
            child: Text(
              _team.teamName!,
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
        body: _buildBody());
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
      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        for (int i = 0; i < _team.team!.length; i++)
          _getPokemonListTile(_team.team![i])
      ])
    ]));
  }

  Widget _getPokemonListTile(int id) {
    return PokemonListTile(id, true, false, false);
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
