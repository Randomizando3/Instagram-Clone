import 'package:cloud_firestore/cloud_firestore.dart';

/// Função que converte um documento em um modelo
typedef FromDoc<T> = T Function(DocumentSnapshot<Map<String, dynamic>> doc);

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ------- CRUD básico --------------------------------------------------

  Future<void> setDocument(String path, Map<String, dynamic> data) =>
      _db.doc(path).set(data);

  Future<void> updateDocument(String path, Map<String, dynamic> data) =>
      _db.doc(path).update(data);

  Future<void> deleteDocument(String path) => _db.doc(path).delete();

  // ------- Leituras -----------------------------------------------------

  Future<T?> getDocument<T>(String path, FromDoc<T> builder) async {
    final doc = await _db.doc(path).get();
    return doc.exists ? builder(doc) : null;
  }

  Stream<T?> documentStream<T>(String path, FromDoc<T> builder) =>
      _db.doc(path).snapshots().map(
            (doc) => doc.exists ? builder(doc) : null,
      );

  /// Stream em tempo real de uma coleção
  Stream<List<T>> collectionStream<T>(
      String path,
      FromDoc<T> builder, {
        Query<Map<String, dynamic>> Function(
            Query<Map<String, dynamic>> q)?
        queryBuilder,
        int limit = 100,
      }) {
    Query<Map<String, dynamic>> query =
    _db.collection(path).limit(limit);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map(
          (snap) =>
          snap.docs.map((doc) => builder(doc)).toList(growable: false),
    );
  }
}
