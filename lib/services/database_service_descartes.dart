import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/descarte.dart';

const String REF_DESCARTES = 'descartes';

class DatabaseServiceDescartes {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _descartesCollection;

  DatabaseServiceDescartes() {
    _descartesCollection = _firestore
        .collection(REF_DESCARTES)
        .withConverter<Descarte>(
            fromFirestore: (snapshots, _) =>
                Descarte.fromJson(snapshots.data()!),
            toFirestore: (descarte, _) => descarte.toJson());
  }

  Stream<QuerySnapshot> getDescartes() {
    return _descartesCollection.snapshots();
  }

  void addDescarte(Descarte descarte) async {
    _descartesCollection.add(descarte);
  }

  // get by user id
  Future<List<Descarte>> getByIdUsuario(String idUsuario) async {
    final snapshot = await _firestore
        .collection(REF_DESCARTES)
        .where('idUsuario', isEqualTo: idUsuario)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => Descarte.fromJson(doc.data())).toList();
    }

    return [];
  }

  // Get by useremail

  Future<List<Descarte>> getByUserEmail(String email) async {
    final snapshot = await _firestore
        .collection(REF_DESCARTES)
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => Descarte.fromJson(doc.data())).toList();
    }

    return [];
  }
}
