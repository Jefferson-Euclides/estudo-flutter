import 'package:estudo/domain/carro.dart';
import 'package:estudo/domain/db/CarroDB.dart';
import 'package:estudo/domain/services/carro_service.dart';
import 'package:estudo/pages/carro_form_page.dart';
import 'package:estudo/utils/alert.dart';
import 'package:estudo/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class CarroPage extends StatefulWidget {
  final Carro carro;

  const CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  get carro => widget.carro;
  bool _isFavorito = false;

  @override
  void initState() {
    super.initState();

    CarroDB.getInstance().exists(carro).then((b) {
      setState(() {
        _isFavorito = b;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: (){},
          ),
          PopupMenuButton(
            onSelected: (value) {
              _onClickPopUpMenu(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Editar"),
                  value: "Editar",
                ),
                PopupMenuItem(
                  child: Text("Deletar"),
                  value: "Deletar",
                ),
                PopupMenuItem(
                  child: Text("Share"),
                  value: "Share",
                ),
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Image.network(carro.urlFoto ?? "https://library.kissclipart.com/20180902/lyq/kissclipart-red-ferrari-png-clipart-ferrari-s-p-a-laferrari-d6f5cfd9040504d2.jpg"),
        _primeiroBloco(),
        _segundoBloco(),
      ],
    );
  }

  Row _primeiroBloco() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                carro.nome,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                carro.tipo,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            _onClickFavoritar(context, carro);
          },
          child: Icon(
            Icons.favorite,
            color: _isFavorito ? Colors.red : Colors.grey,
            size: 36,
          ),
        ),
        InkWell(
            onTap: () {
              Share.share(carro.urlFoto);
            },
            child: Icon(
              Icons.share,
              size: 36,
            )),
      ],
    );
  }

  Widget _segundoBloco() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            carro.desc,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<String>(
            future: CarroService.getLoremIpsum(),
            builder: (context, snapshot) {
              return Center(
                child: snapshot.hasData
                    ? Text(snapshot.data)
                    : CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future _onClickFavoritar(BuildContext context, carro) async {
    final db = CarroDB.getInstance();

    final exists = await db.exists(carro);

    if (exists) {
      db.deleteCarro(carro.id);
    } else {
      int id = await db.saveCarro(carro);
    }

    setState(() {
      _isFavorito = !exists;
    });
  }

  void _onClickPopUpMenu(value) {
    if (value == "Editar") {
      push(context, CarroFormPage(carro: carro));
    } else if (value == "Deletar") {
      deletar();
    } else {
      Share.share(carro.urlFoto);
    }
  }

  void deletar() async{
    final response = await CarroService.deletar(carro.id);
    if (response.isOk()) {
      pop(context);
    } else {
      alert(context, "Erro", response.msg);
    }
  }
}
