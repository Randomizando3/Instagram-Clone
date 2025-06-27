import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/post_repository.dart';
import '../../../../core/models/comment.dart';
import '../../../../core/models/post.dart';

const demoUid = 'demoUser'; // ← substitua depois pelo FirebaseAuth.instance.currentUser!.uid

final _postRepoProvider = Provider<PostRepository>((_) => PostRepository());

final feedProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  final repo = ref.watch(_postRepoProvider);
  return repo.feedStream();
});

final commentsProvider =
StreamProvider.family.autoDispose<List<Comment>, String>((ref, postId) {
  final repo = ref.watch(_postRepoProvider);
  return repo.commentsStream(postId);
});

final likeActionProvider =
Provider.family<void Function(), Post>((ref, post) {
  final repo = ref.watch(_postRepoProvider);
  return () => repo.toggleLike(post, demoUid);
});

final addCommentProvider =
Provider.family<Future<void> Function(String), String>((ref, postId) {
  final repo = ref.watch(_postRepoProvider);
  return (text) => repo.addComment(postId: postId, uid: demoUid, text: text);
});