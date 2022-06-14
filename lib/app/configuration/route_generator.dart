import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokedex_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/pokedex_select_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/splash_screen.dart';
import 'package:flutter_pokedex/app/presentation/screens/teams_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case SplashScreen.splashScreenKey:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case TeamsScreen.teamsScreenKey:
        if (args is TeamsScreenArgs) {
          return MaterialPageRoute(
              settings: const RouteSettings(name: TeamsScreen.teamsScreenKey),
              builder: (_) => TeamsScreen(
                    teamName: args.teamName,
                    team: args.team,
                  ));
        }
        return MaterialPageRoute(
            settings: const RouteSettings(name: TeamsScreen.teamsScreenKey),
            builder: (_) => TeamsScreen());
      case PokedexScreen.pokedexScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(name: PokedexScreen.pokedexScreenKey),
            builder: (_) => PokedexScreen());
      case PokedexSelectScreen.pokedexSelectScreenKey:
        return MaterialPageRoute(
            settings: const RouteSettings(
                name: PokedexSelectScreen.pokedexSelectScreenKey),
            builder: (_) => PokedexSelectScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
