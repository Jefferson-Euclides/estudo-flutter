import 'package:estudo/domain/carro.dart';
import 'package:flutter/material.dart';

listTile(Carro carro) {
  return ListTile(
    leading: Image.network(carro.urlFoto),
    title: Text(
      "Carro ${carro.nome}",
      style: TextStyle(fontSize: 25, color: Colors.blue),
    ),
    subtitle: Text("Descrição"),
  );
}
