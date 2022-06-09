import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';
import 'package:flutter_pokedex/app/presentation/login_screen.dart';

void main() {
  const key = "main prod";
  print("[$key] invoked");

  BuildEnvironment.init(
      apiBaseAddress: "https://pokeapi.co/api/v2",
      env: Environment.production,
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
        backgroundColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}
