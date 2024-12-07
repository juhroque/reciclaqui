import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reciclaqui/models/Usuario.dart';

const String REF_USUARIOS = 'usuarios';

class DatabaseServiceUsers {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usuariosCollection;

  DatabaseServiceUsers() {
    _usuariosCollection = _firestore
        .collection(REF_USUARIOS)
        .withConverter<Usuario>(
            fromFirestore: (snapshots, _) =>
                Usuario.fromJson(snapshots.data()!),
            toFirestore: (usuario, _) => usuario.toJson());
  }

  Stream<QuerySnapshot> getUsuarios() {
    return _usuariosCollection.snapshots();
  }

  void addUsuario(Usuario usuario) async {
    _usuariosCollection.add(usuario);
  }

  // Get by email
  Future<Usuario?> getByEmail(String email) async {
    final snapshot = await _firestore
        .collection(REF_USUARIOS)
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Usuario.fromJson(snapshot.docs.first.data());
    }

    return null;
  }

  //atualizar pontos do usuário
  void updatePontos(String uuid, int pontos) async {
    final snapshot = await _firestore
        .collection(REF_USUARIOS)
        .where('firebase_uuid', isEqualTo: uuid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      Usuario usuario = Usuario.fromJson(snapshot.docs.first.data());
      usuario = usuario.copyWith(pontosTotais: pontos);
      _usuariosCollection.doc(docId).set(usuario);
    }
  }

  //atualizar nome
  void updateNome(String uuid, String nome) async {
    final snapshot = await _firestore
        .collection(REF_USUARIOS)
        .where('firebase_uuid', isEqualTo: uuid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      Usuario usuario = Usuario.fromJson(snapshot.docs.first.data());
      usuario = usuario.copyWith(nomeUsuario: nome);
      _usuariosCollection.doc(docId).set(usuario);
    }
  }
}
