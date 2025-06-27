import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/post_repository.dart';

final _postRepoProvider = Provider<PostRepository>((_) => PostRepository());

/// Stream<List<Post>>
final feedProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(_postRepoProvider);
  return repo.feedStream();
});
