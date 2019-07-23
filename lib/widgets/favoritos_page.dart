import 'package:estudo/domain/carro.dart';
import 'package:estudo/domain/db/CarroDB.dart';
import 'package:estudo/domain/services/carro_service.dart';
import 'package:estudo/pages/carro_page.dart';
import 'package:flutter/material.dart';

import 'carros_listView.dart';

/**
 * Widget que busca no WEBSERVICE uma lista de carros de um tipo pré estabelecido
 */
class FavoritosPage extends StatefulWidget {

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    //BUSCA NO WEBSERVICE
    Future future = CarroDB.getInstance().getCarros();

    return Container(
      padding: EdgeInsets.all(12),
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Carro> carros = snapshot.data;

            return CarrosListView(carros);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Sem dados",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 26,
                    fontStyle: FontStyle.italic),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
