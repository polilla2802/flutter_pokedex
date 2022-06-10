import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/screens/login_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokedex_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String splashScreenKey = "/splash_screen";

  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState(splashScreenKey);
}

class _SplashScreenState extends State<SplashScreen> {
  String _key = "";
  String _userName = "";

  _SplashScreenState(String splashScreenKey) {
    _key = splashScreenKey;
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await _buildMethod();
    });
  }

  Future<String> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("UserName") ?? "";
    print("_userName $_userName");
    return _userName;
  }

  Future<void> _buildMethod() async {
    String user = await _getUser();

    if (user.isEmpty) {
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.loginScreenKey),
          builder: (context) => LoginScreen()));
    } else {
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
          settings: const RouteSettings(name: PokedexScreen.pokedexScreenKey),
          builder: (context) => PokedexScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset("assets/loader/poke.gif")],
      ),
    );
  }

  @override
  void dispose() {
    print('$_key Dispose invoked');
    super.dispose();
  }
}
