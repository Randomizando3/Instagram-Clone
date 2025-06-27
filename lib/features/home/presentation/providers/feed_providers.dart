import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/post_repository.dart';
import '../../../../core/models/comment.dart';
import '../../../../core/models/post.dart';

/// UID fixo para testes; depois troque por FirebaseAuth.instance.currentUser!.uid
const demoUid = 'demoUser';

/// PostRepository compartilhado entre todos os módulos
final postRepoProvider = Provider<PostRepository>((_) => PostRepository());

/// ----------- FEED -------------------------------------------------------
final feedProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  final repo = ref.watch(postRepoProvider);
  return repo.feedStream();
});

/// ----------- COMENTÁRIOS -----------------------------------------------
final commentsProvider =
StreamProvider.family.autoDispose<List<Comment>, String>((ref, postId) {
  final repo = ref.watch(postRepoProvider);
  return repo.commentsStream(postId);
});

/// ----------- AÇÃO DE LIKE ----------------------------------------------
final likeActionProvider =
Provider.family<void Function(), Post>((ref, post) {
  final repo = ref.watch(postRepoProvider);
  return () => repo.toggleLike(post, demoUid);
});

/// ----------- ADICIONAR COMENTÁRIO --------------------------------------
final addCommentProvider =
Provider.family<Future<void> Function(String), String>((ref, postId) {
  final repo = ref.watch(postRepoProvider);
  return (text) =>
      repo.addComment(postId: postId, uid: demoUid, text: text);
});
