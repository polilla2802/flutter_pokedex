import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/app/controllers/cubit/pokedex_cubit.dart';
import 'package:flutter_pokedex/app/models/core/result.dart';
import 'package:flutter_pokedex/app/models/pokemon/pokemon_model.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_card.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
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
  late ScrollController _scrollController;
  int _pokemonCount = 10;

  _PokedexScreenState(String pokedexScreenKey) {
    _key = pokedexScreenKey;
    _pokedexRepo = PokedexRepo();
    _customSnackBar = CustomSnackbar();
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

  void _scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        //the bottom of the scrollbar is reached
        //adding more widgets
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

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("UserName")!;
    print("_userName $_userName");
    setState(() {});
  }

  Future<void> _afterBuild() async {
    _getUser();
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
    bool done = await prefs.clear();
    if (done) print("prefs cleared");

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        settings: const RouteSettings(name: LoginScreen.loginScreenKey),
        builder: (context) => LoginScreen()));
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
              _getPokedex(_pokemonCount, context);
              return Container(
                alignment: Alignment.center,
                child: Image.asset("assets/loader/roll.gif"),
              );
            } else if (state is PokedexLoading) {
              return Container(
                alignment: Alignment.center,
                child: Image.asset("assets/loader/roll.gif"),
              );
            } else if (state is PokedexLoaded) {
              return Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Wrap(children: [_buildPokedex(state.pokedex)])),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("Error")],
                ),
              );
            }
          },
        ));
  }

  Widget _buildPokedex(List<Result<Pokemon>> pokedex) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      ...pokedex
          .asMap()
          .map((i, item) => MapEntry(
                i,
                _getPokemonCard(i, item),
              ))
          .values
          .toList()
    ]);
  }

  Future<void> _getPokedex(int pokemonCount, BuildContext context) async {
    final pokedexCubit = BlocProvider.of<PokedexCubit>(context);
    await pokedexCubit.getPokedex(pokemonCount, context);
  }

  Widget _getPokemonCard(int id, Result<Pokemon> pokemon) {
    if (pokemon.hasData()) {
      return PokemonCard(pokemon.data!);
    } else {
      return Container(
        child: Text("error"),
      );
    }
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
    super.dispose();
  }
}
