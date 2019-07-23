import 'package:estudo/domain/carro.dart';
import 'package:estudo/domain/services/carro_service.dart';
import 'package:estudo/pages/carro_page.dart';
import 'package:flutter/material.dart';

import 'carros_listView.dart';

/**
 * Widget que busca no WEBSERVICE uma lista de carros de um tipo pré estabelecido
 */
class CarrosPage extends StatefulWidget {
  final String tipoCarro;

  const CarrosPage(this.tipoCarro);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    //BUSCA NO WEBSERVICE
    Future future = CarroService.getCarros(widget.tipoCarro);

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
