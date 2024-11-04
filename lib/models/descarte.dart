class Descarte {
  String objeto;
  String categoria;
  int quantidade;
  String localDeDescarte;
  String idUsuario; //vai ser o uuid do usuário no firebase

  Descarte({
    required this.objeto,
    required this.categoria,
    required this.quantidade,
    required this.localDeDescarte,
    required this.idUsuario,
  });

  Map<String, dynamic> toJson() {
    return {
      'objeto': objeto,
      'categoria': categoria,
      'quantidade': quantidade,
      'localDeDescarte': localDeDescarte,
      'idUsuario': idUsuario,
    };
  }

  Descarte.fromJson(Map<String, dynamic> json)
      : objeto = json['objeto'] as String,
        categoria = json['categoria'] as String,
        quantidade = json['quantidade'] as int,
        localDeDescarte = json['localDeDescarte'] as String,
        idUsuario = json['idUsuario'] as String;
}
