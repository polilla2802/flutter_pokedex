import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/components/form/input.dart';

class LoginScreen extends StatefulWidget {
  static const String loginScreenKey = "/login_screen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState(loginScreenKey);
}

class _LoginScreenState extends State<LoginScreen> {
  String? _key;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _loginController;
  FocusNode? _myFocus;
  String _userName = "";

  _LoginScreenState(String loginScreenKey) {
    _key = loginScreenKey;
    _myFocus = FocusNode();
    _loginController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void initState() {
    super.initState();
    print("$_key invoked");
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {}

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //TODO: implement PokedexScreen here

      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => PokedexScreen(
      //             userName: _userName,
      //           )),
      // );
    }
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
              title: const Text("Login"),
            ),
            body: _buildBody()));
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Input(
                  controller: _loginController,
                  labelText: "Enter your username",
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSave: (String? value) {
                    _userName = value!.trim();
                  },
                  focusNode: _myFocus,
                ),
              )),
          ElevatedButton(
            onPressed: () => _login(context),
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
