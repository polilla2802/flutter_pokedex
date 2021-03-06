import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/configuration/route_generator.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/screens/splash_screen.dart';

void main() {
  const key = "main prod";
  print("[$key] invoked");

  BuildEnvironment.init(
      apiBaseAddress: "https://pokeapi.co/api/v2",
      env: Environment.production,
      totalPokemon: 386,
      secretKey: "",
      bearer: "");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      title: 'Pokedex',
      theme: ThemeData(
        fontFamily: "Aldrich",
        primaryColor: ConstValues.primaryColor,
        primarySwatch: ConstValues.myBlackColor,
        backgroundColor: ConstValues.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: SplashScreen.splashScreenKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
