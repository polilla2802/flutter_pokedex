import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokemon_team_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/teams_screen.dart';

class PokemonTeamCard extends StatefulWidget {
  final String teamName;
  final String team;
  const PokemonTeamCard(
    this.teamName,
    this.team, {
    Key? key,
  }) : super(key: key);

  @override
  State<PokemonTeamCard> createState() => _PokemonTeamCardState(teamName, team);
}

class _PokemonTeamCardState extends State<PokemonTeamCard> {
  String _key = "pokemon_team_card";

  late String _teamName;
  late String _team;
  late List<int> _teamList = [];
  late String _imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/';

  final EdgeInsetsGeometry buttonMargin =
      const EdgeInsets.only(top: 8, bottom: 8);

  _PokemonTeamCardState(String teamName, String team) {
    _teamName = teamName;
    _team = team;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    setState(() {
      _teamList = _team.split(',').map(int.parse).toList();
    });
  }

  Future<void> _toPokemonTeam() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PokemonTeamScreen(TeamsScreenArgs(_teamList, _teamName))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: buttonMargin,
        child: GestureDetector(
          onTap: () async => await _toPokemonTeam(),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
              decoration: BoxDecoration(
                  color: ConstValues.secondaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _teamName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 3, bottom: 3, right: 3, left: 3),
              decoration: BoxDecoration(
                  color: ConstValues.secondaryColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Card(
                margin: const EdgeInsets.all(0),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListTile(
                            dense: false,
                            minVerticalPadding: 0,
                            minLeadingWidth: 0,
                            horizontalTitleGap: 16,
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (var i in _teamList)
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 3),
                                        width: 40,
                                        height: 40,
                                        child: _getPokemonImg(i),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100.0)),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _getPokemonImg(int pokemonId) {
    return CachedNetworkImage(
        imageUrl: _imageUrl + "$pokemonId.gif",
        fadeInDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => Image.asset("assets/loaders/roll.gif"));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
