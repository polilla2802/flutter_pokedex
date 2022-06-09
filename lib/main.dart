import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/configuration/environment.dart';

void main() {
  const key = "main prod";
  print("[$key] invoked");

  BuildEnvironment.init(
      apiBaseAddress: "https://ecsdevapi.nextline.mx",
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
        primarySwatch: Colors.blue,
      ),
      // Implement LoginScreen here
      // home: LoginScreen(),
    );
  }
}
