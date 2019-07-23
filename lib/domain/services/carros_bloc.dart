import 'dart:async';

import 'carro_service.dart';

class CarroBloc {
  final _controller = StreamController();

  get stream => _controller.stream;

  fetch(String tipo) {
    Future future = CarroService.getCarros(tipo);
    future.then((carros){
      _controller.sink.add(carros);
    });
  }

  void close() {
    _controller.close();
  }
}