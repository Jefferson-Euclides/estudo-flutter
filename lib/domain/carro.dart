class TipoCarro {
  static const String classicos = "classicos";
  static const String esportivos = "esportivos";
  static const String luxo = "luxo";
}

class Carro {
  final int id;
  String tipo;
  String nome;
  String desc;
  String urlFoto;
  String urlVideo;
  String latitude;
  String longitude;

  Carro(
      {this.id,
        this.nome,
        this.tipo,
        this.desc,
        this.urlFoto,
        this.urlVideo,
        this.latitude,
        this.longitude});

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      id: json['id'] as int,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      desc: json['desc'] as String,
      urlFoto: json['urlFoto'] as String,
      urlVideo: json['urlVideo'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  @override
  String toString() {
    return "Carro[$id]: $nome";
  }

  Map toMap() {
    Map<String,dynamic> map = {
      "nome": nome,
      "tipo": tipo,
      "desc": desc,
      "urlFoto": urlFoto,
    };
    if(id != null) {
      map["id"] = id;
    }
    return map;
  }

}