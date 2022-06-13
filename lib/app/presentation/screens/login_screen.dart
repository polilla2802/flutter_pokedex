import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/controllers/cubit/pokedex_cubit.dart';
import 'package:flutter_pokedex/app/presentation/components/cards/pokemon_list_tile.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/components/form/input.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokedex_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokemon_details_screen.dart';
import 'package:flutter_pokedex/app/repos/pokedex_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String loginScreenKey = "/login_screen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState(loginScreenKey);
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String? _key;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _loginController;
  late FocusNode? _myFocus;
  late int _randomNumber;
  late String _userName = "";
  late bool isPlaying = false;
  late AnimationController _animationController;
  late PokedexRepo _pokedexRepo;

  _LoginScreenState(String loginScreenKey) {
    _key = loginScreenKey;
    _myFocus = FocusNode();
    _loginController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _pokedexRepo = PokedexRepo();
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    _initializeAnimationController();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _getPokemonCount(BuildContext context) async {
    final pokedexCubit = BlocProvider.of<PokedexCubit>(context);
    await pokedexCubit.getPokemonCount(_randomNumber, context);
  }

  Future<void> _setUser(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var done = await prefs.setString("UserName", _userName);

    if (done) print('[$_key] UserName saved to $_userName');
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _setUser(_userName);

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PokedexScreen()),
      );
    }
  }

  Future<void> _pokeballTap(BuildContext context) async {
    setState(() {
      _getRandNumber();
    });
    await _getPokemonCount(context);
  }

  Future<void> _pokedexListener(PokedexState state) async {
    if (state is PokemonError) {
      print("error");
      print("${state.message}");
    }
  }

  void _initializeAnimationController() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
  }

  void _getRandNumber() {
    var rng = Random();
    _randomNumber = rng.nextInt(environment!.totalPokemon!);
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
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: Container(),
                title: Container(
                    width: double.infinity,
                    child: const Text(
                      "Pokedex",
                      textAlign: TextAlign.right,
                    )),
              ),
              body: _buildBody(context),
            )));
  }

  Widget _getPokemonCard(int id) {
    return PokemonListTile(id, true);
  }

  Widget _getPokemonError() {
    return Container(child: Text("Error Loading"));
  }

  Widget _buildBody(BuildContext context) {
    return Center(
        child: BlocConsumer<PokedexCubit, PokedexState>(
      listener: (context, state) => _pokedexListener(state),
      builder: (context, state) {
        if (state is PokemonInitial) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async => await _pokeballTap(context),
                child: Container(
                  color: ConstValues.myRedColor,
                  child: Image.asset("assets/loaders/pokeball.gif"),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0),
                width: double.infinity,
                color: ConstValues.secondaryColor,
                child: FadeTransition(
                    opacity: _animationController,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Press the pokeball",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )),
              )
            ],
          );
        } else if (state is PokemonLoading) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async => await _pokeballTap(context),
                child: Container(
                  color: ConstValues.myRedColor,
                  child: Image.asset("assets/loaders/pokeball.gif"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                          child: Form(
                        key: _formKey,
                        child: Input(
                          backgroundColor: ConstValues.secondaryColor,
                          color: ConstValues.primaryColor,
                          controller: _loginController,
                          labelText: "Enter your username",
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSave: (String? value) {
                            return _userName = value!.trim();
                          },
                          focusNode: _myFocus,
                        ),
                      )),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Container()],
                            )),
                            ElevatedButton(
                              onPressed: () async => await _login(context),
                              child: const Text(
                                'LOGIN',
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: ConstValues.primaryColor),
                            )
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is PokemonCount) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async => await _pokeballTap(context),
                child: Container(
                  color: ConstValues.myRedColor,
                  child: Image.asset("assets/loaders/pokeball.gif"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                          child: Form(
                        key: _formKey,
                        child: Input(
                          backgroundColor: ConstValues.secondaryColor,
                          color: ConstValues.primaryColor,
                          controller: _loginController,
                          labelText: "Enter your username",
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSave: (String? value) {
                            return _userName = value!.trim();
                          },
                          focusNode: _myFocus,
                        ),
                      )),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child:
                                          _getPokemonCard(state.pokemonCount)),
                                ],
                              ),
                            )),
                            ElevatedButton(
                              onPressed: () async => await _login(context),
                              child: const Text(
                                'LOGIN',
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: ConstValues.primaryColor),
                            )
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              GestureDetector(
                onTap: () async => await _pokeballTap(context),
                child: Container(
                  color: ConstValues.myRedColor,
                  child: Image.asset("assets/loaders/pokeball.gif"),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                          child: Form(
                        key: _formKey,
                        child: Input(
                          backgroundColor: ConstValues.secondaryColor,
                          color: ConstValues.primaryColor,
                          controller: _loginController,
                          labelText: "Enter your username",
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSave: (String? value) {
                            return _userName = value!.trim();
                          },
                          focusNode: _myFocus,
                        ),
                      )),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height:
                                        MediaQuery.of(context).size.height * .2,
                                    child: _getPokemonError()),
                              ],
                            )),
                            ElevatedButton(
                              onPressed: () async => await _login(context),
                              child: const Text(
                                'LOGIN',
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: ConstValues.primaryColor),
                            )
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    ));
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    _animationController.dispose();
    _loginController.dispose();
    if (_myFocus != null) {
      _myFocus!.dispose();
    }
    super.dispose();
  }
}
