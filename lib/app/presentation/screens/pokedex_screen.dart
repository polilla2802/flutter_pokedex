import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_card.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/screens/login_screen.dart';
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

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString("UserName")!;
      print("_userName $_userName");
    });
  }

  Future<void> _afterBuild() async {
    await _getUser();
  }

  Future<void> _pokemonCardDetails() async {
    //TODO: implement pokemon details screen

    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => PokemonDetailsScreen(
    //             userName: token,
    //           )),
    // );
  }

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool done = await prefs.remove("UserName");
    if (done) print("prefs cleared");

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: LoginScreen.loginScreenKey),
        builder: (context) => LoginScreen()));
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        //the bottom of the scrollbar is reached
        //adding more pokemon
        print("reached bottom");

        if (_pokemonCount < 150) {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: Container(),
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
        padding: const EdgeInsets.all(16),
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Wrap(children: [_buildPokedex(_pokemonCount)])),
        ));
  }

  Widget _buildPokedex(int pokemonCount) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [for (int i = 1; i < pokemonCount; i++) _getPokemonCard(i)]);
  }

  Widget _getPokemonCard(int id) {
    return PokemonCard(id);
  }

  Widget _floatingButton() {
    return GestureDetector(
      onTap: () => {
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 1500), curve: Curves.decelerate)
      },
      child: Container(
        child: Chip(
          label: Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
          ),
          backgroundColor: ConstValues.primaryColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    _scrollController.dispose();
    super.dispose();
  }
}
