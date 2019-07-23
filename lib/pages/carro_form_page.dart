import 'dart:io';

import 'package:estudo/domain/carro.dart';
import 'package:estudo/domain/services/carro_service.dart';
import 'package:estudo/utils/alert.dart';
import 'package:estudo/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CarroFormPage extends StatefulWidget {

  final Carro carro;

  const CarroFormPage({this.carro});

  @override
  _CarroFormPageState createState() => _CarroFormPageState();
}

class _CarroFormPageState extends State<CarroFormPage> {

  final GlobalKey<FormState> globalKey = new GlobalKey();
  
  final tNome = TextEditingController();
  final tDesc = TextEditingController();
  final tTipo = TextEditingController();

  File fileCamera;

  get carro => widget.carro;

  int _radioIndex = 0;

  bool _showProgress = false;

   // Add validate email function.
  String _validateNome(String value) {
    if (value.isEmpty) {
      return 'Informe o nome do carro.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    if (carro != null) {
      tNome.text = carro.nome;
      tDesc.text = carro.desc;
      _radioIndex = getTipoInt(carro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          carro != null ? carro.nome : "Novo carro",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _form(),
              ),
            );
    }

  _form() {
    return Form(
      key: globalKey,
      child: ListView(
        children: <Widget>[
          _headerFoto(),
          Text(
            "Clique na imagem para tirar uma foto",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey,)
          ),
          Divider(),
          Text(
            "Tipo",
            style: TextStyle(color: Colors.blue, fontSize: 20),
          ),
          _radioTipo(),
          Divider(),
          TextFormField(
            controller: tNome,
            keyboardType: TextInputType.text,
            validator: _validateNome,
            style: TextStyle(color: Colors.blue, fontSize: 20),
            decoration: InputDecoration(
              hintText: '',
              labelText: 'Nome',
            ), 
          ),
          TextFormField(
            controller: tDesc,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.blue, fontSize: 20),
            decoration: InputDecoration(
              hintText: '',
              labelText: 'Descrição',
            ), 
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.blue,
              child: _showProgress 
                ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 22)
                ),
              onPressed: () {
                _onClickSalvar(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _headerFoto() {
    if (fileCamera != null) {
      return InkWell(
        child: Image.file(fileCamera, height: 150),
        onTap: _onClickFoto,
      );
    }

    return InkWell(
      child: carro != null && carro.urlFoto != null 
        ? Image.network(carro.urlFoto) 
        : Image.asset(
            "assets/images/camera.png",
            height: 150,
      ),
      onTap: _onClickFoto,
    );
  }

  _radioTipo() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 0,
            groupValue: _radioIndex,
            onChanged: _onClickTipo,
          ),
          Text(
            "Clássicos",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          Radio(
            value: 1,
            groupValue: _radioIndex,
            onChanged: _onClickTipo,
          ),
          Text(
            "Esportivos",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          Radio(
            value: 2,
            groupValue: _radioIndex,
            onChanged: _onClickTipo,
          ),
          Text(
            "Luxo",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
        ],
      ),
    );
  }

  _onClickSalvar(BuildContext context) async {
    if (!globalKey.currentState.validate()) {
      return;
    }

    // Cria o carro
    var c = carro ?? Carro();
    c.nome = tNome.text;
    c.desc = tDesc.text;
    c.tipo = _getTipo();

    setState(() {
      _showProgress = true;
    });

    //faz o post no websrvice
    final response = await CarroService.salvar(c, fileCamera);
    if (response.isOk()) {
      alert(context, "Carro salvo", response.msg, callback: () => pop(context));
    } else {
      alert(context, "Erro", response.msg);
    }

    setState(() {
      _showProgress = false;
    });
  }

  getTipoInt(Carro carro) {
    switch (carro.tipo) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  void _onClickTipo(int value) {
    setState(() {
      _radioIndex = value;
    });
  }

  _onClickFoto() async{
    fileCamera = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
    });
  }
}