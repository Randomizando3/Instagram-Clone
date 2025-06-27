import 'package:instagramclone/core/models/post.dart';
import 'package:instagramclone/core/services/firestore_service.dart';

class PostRepository {
  final _fs = FirestoreService.instance;

  Stream<List<Post>> feedStream() => _fs.collectionStream<Post>(
    'posts',
    Post.fromDoc,
    queryBuilder: (q) =>
        q.orderBy('createdAt', descending: true).limit(50),
  );
}
