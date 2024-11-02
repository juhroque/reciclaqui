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
}
