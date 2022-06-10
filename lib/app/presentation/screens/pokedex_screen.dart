import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/app/controllers/cubit/pokedex_cubit.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_card.dart';
import 'package:flutter_pokedex/app/presentation/components/snackbar/custom_snackbar.dart';
import 'package:flutter_pokedex/app/presentation/screens/login_screen.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokedexScreen extends StatefulWidget {
  static const String pokedexScreenKey = "/pokedex_screen";

  const PokedexScreen({Key? key}) : super(key: key);

  @override
  State<PokedexScreen> createState() => _PokedexScreenState(pokedexScreenKey);
}

class _PokedexScreenState extends State<PokedexScreen> {
  String? _key;
  late PokedexRepo _pokedexRepo;
  late String _userName = "";
  late CustomSnackbar _customSnackBar;
  final List<Pokemon> _pokemons = [
    Pokemon(
        "Bulbasaur",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif",
        "green",
        1,
        "grass",
        type2: "poison"),
    Pokemon(
        "Ivysaur",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/2.gif",
        "green",
        2,
        "grass",
        type2: "poison"),
    Pokemon(
        "Venasaur",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/3.gif",
        "green",
        3,
        "grass",
        type2: "poison"),
    Pokemon(
        "Charmander",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif",
        "red",
        4,
        "fire"),
    Pokemon(
        "Charmeleon",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/5.gif",
        "red",
        5,
        "fire"),
    Pokemon(
        "Charizard",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif",
        "red",
        6,
        "fire")
  ];
  _PokedexScreenState(String pokedexScreenKey) {
    _key = pokedexScreenKey;
    _pokedexRepo = PokedexRepo();
    _customSnackBar = CustomSnackbar();
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("UserName")!;
    print("_userName $_userName");
    setState(() {});
  }

  Future<void> _afterBuild() async {
    _getUser();
  }

  Future<void> _postTask() async {
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
    bool done = await prefs.clear();
    if (done) print("prefs cleared");

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: LoginScreen.loginScreenKey),
        builder: (context) => LoginScreen()));
  }

  Future<void> _getPokemonById({int? pokemonId}) async {
    //TODO: implement _getPokemonById
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: BlocProvider(
            create: (context) => PokedexCubit(_pokedexRepo),
            child: Scaffold(
                appBar: AppBar(
                  leading: Container(),
                  title: Text(
                    _userName,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    GestureDetector(
                        onTap: () => _logOut(),
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(right: 16),
                            child: const Text("Logout")))
                  ],
                ),
                body: _buildBody(),
                floatingActionButton: _floatingButton())));
  }

  void _pokedexListener(PokedexState state) {
    if (state is PokedexError) {
      _customSnackBar.show(context, state.message as String);
    }
  }

  Widget _buildBody() {
    return Container(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<PokedexCubit, PokedexState>(
          listener: (context, state) => _pokedexListener(state),
          builder: (context, state) {
            if (state is PokedexInitial) {
              return Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    child: Wrap(children: [_buildPokedex()])),
              );
            } else if (state is PokedexLoading) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              );
            } else if (state is PokedexLoaded) {
              return Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    child: Wrap(children: [_buildPokedex()])),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("No tienes ninguna tarea aún")],
                ),
              );
            }
          },
        ));
  }

  Widget _buildPokedex() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _pokemons
          .asMap()
          .map((i, item) => MapEntry(
                i,
                _getPokemon(i, item),
              ))
          .values
          .toList(),
    );
  }

  Widget _getPokemon(int id, Pokemon pokemon) {
    return PokemonCard(pokemon);
  }

  Widget _floatingButton() {
    return BlocConsumer<PokedexCubit, PokedexState>(
      listener: (context, state) => _pokedexListener(state),
      builder: (context, state) {
        if (state is PokedexInitial) {
          return Container();
        } else if (state is PokedexLoading) {
          return Container();
        } else if (state is PokedexLoaded) {
          return Container(
            alignment: Alignment.topCenter,
            child:
                SingleChildScrollView(child: Wrap(children: [_buildPokedex()])),
          );
        } else {
          return FloatingActionButton(
            onPressed: () => _postTask(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
