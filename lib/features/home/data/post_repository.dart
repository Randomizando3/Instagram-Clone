import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:instagramclone/core/models/comment.dart';
import 'package:instagramclone/core/models/post.dart';
import 'package:instagramclone/core/services/firestore_service.dart';


class PostRepository {
  final _fs = FirestoreService.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  // ===== Feed =====
  Stream<List<Post>> feedStream() => _fs.collectionStream<Post>(
    'posts',
    Post.fromDoc,
    queryBuilder: (q) =>
        q.orderBy('createdAt', descending: true).limit(50),
  );

  // ===== Likes =====
  Future<void> toggleLike(Post post, String uid) async {
    final ref = 'posts/${post.id}';
    final isLiked = post.likedBy.contains(uid);

    await _fs.updateDocument(ref, {
      'likes': FieldValue.increment(isLiked ? -1 : 1),
      'likedBy': isLiked
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid]),
    });
  }

  // ===== Comentários =====
  Stream<List<Comment>> commentsStream(String postId) =>
      _fs.collectionStream<Comment>(
        'posts/$postId/comments',
        Comment.fromDoc,
        queryBuilder: (q) => q.orderBy('createdAt', descending: true),
      );

  Future<void> addComment({
    required String postId,
    required String uid,
    required String text,
  }) async {
    final id = FirebaseFirestore.instance
        .collection('posts/$postId/comments')
        .doc()
        .id;

    await _fs.setDocument(
      'posts/$postId/comments/$id',
      Comment(
        id: id,
        postId: postId,
        authorId: uid,
        content: text,
      ).toJson(),
    );
  }

  // ===== Upload de imagem + criação do Post =====
  Future<String> _uploadImage(File file, String uid) async {
    final ext = file.path.split('.').last;
    final ref = _storage.ref().child('posts/$uid/${_uuid.v4()}.$ext');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<void> createPost({
    required String uid,
    required File image,
    required String description,
    double? price,
    bool? isRent,
    String? category,
  }) async {
    final url = await _uploadImage(image, uid);
    final doc = FirebaseFirestore.instance.collection('posts').doc();

    final post = Post(
      id: doc.id,
      authorId: uid,
      mediaUrl: url,
      description: description,
      price: price,
      isRent: isRent,
      category: category,
    );

    await _fs.setDocument('posts/${post.id}', post.toJson());
  }
}
