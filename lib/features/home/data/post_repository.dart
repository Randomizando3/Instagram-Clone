import 'package:instagramclone/core/models/comment.dart';
import 'package:instagramclone/core/models/post.dart';
import 'package:instagramclone/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final _fs = FirestoreService.instance;

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
      'likedBy':
      isLiked ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid]),
    });
  }

  // ===== Comentários =====
  Stream<List<Comment>> commentsStream(String postId) =>
      _fs.collectionStream<Comment>(
        'posts/$postId/comments',
        Comment.fromDoc,
        queryBuilder: (q) => q.orderBy('createdAt', descending: true),
      );

  Future<void> addComment(
      {required String postId,
        required String uid,
        required String text}) async {
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
}
