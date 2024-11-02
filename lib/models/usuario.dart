import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String firebaseUuid;
  final String nomeUsuario;
  final String email;
  final int pontosTotais;

  Usuario({
    required this.firebaseUuid,
    required this.nomeUsuario,
    required this.email,
    required this.pontosTotais,
  });

  Usuario.fromJson(Map<String, dynamic> json)
      : firebaseUuid = json['firebase_uuid'] as String,
        nomeUsuario = json['nome_usuario'] as String,
        email = json['email'] as String,
        pontosTotais = json['pontos_totais'] as int;

  Usuario copyWith({
    String? firebaseUuid,
    String? nomeUsuario,
    String? email,
    int? pontosTotais,
  }) {
    return Usuario(
      firebaseUuid: firebaseUuid ?? this.firebaseUuid,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      email: email ?? this.email,
      pontosTotais: pontosTotais ?? this.pontosTotais,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_usuario': nomeUsuario,
      'email': email,
      'pontos_totais': pontosTotais,
    };
  }
}
