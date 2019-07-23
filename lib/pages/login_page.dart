import 'package:estudo/domain/services/login_service.dart';
import 'package:estudo/utils/alert.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estudo"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _loginController,
            keyboardType: TextInputType.text,
            validator: _validateLogin,
            decoration: InputDecoration(
              labelText: "Login",
              labelStyle: TextStyle(fontSize: 25, color: Colors.black),
              hintText: "Digite o login",
              hintStyle: TextStyle(fontSize: 15, color: Colors.blue),
            ),
          ),
          TextFormField(
            controller: _senhaController,
            keyboardType: TextInputType.text,
            obscureText: true,
            validator: _validateSenha,
            decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: TextStyle(fontSize: 25, color: Colors.black),
              hintText: "Digite o login",
              hintStyle: TextStyle(fontSize: 15, color: Colors.blue),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 50,
            child: RaisedButton(
                child: _progress
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                color: Colors.blue,
                onPressed: () {
                  _onPressedButton(context);
                }),
          ),
        ],
      ),
    );
  }

  _onPressedButton(BuildContext context) async {
    print("Clicou no botão");

    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final response =
        await LoginService.login(_loginController.text, _senhaController.text);

    if (response.isOk()) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } else {
      alert(context, "Erro", response.msg);
    }

    setState(() {
      _progress = false;
    });
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Infome a senha";
    }

    return null;
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Informe o login";
    }

    return null;
  }
}
