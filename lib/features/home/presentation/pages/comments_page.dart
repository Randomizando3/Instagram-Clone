import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/post.dart';
import '../providers/feed_providers.dart';

class CommentsPage extends ConsumerWidget {
  const CommentsPage({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(commentsProvider(post.id));
    final addComment = ref.watch(addCommentProvider(post.id));
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Comentários')),
      body: Column(
        children: [
          Expanded(
            child: comments.when(
              data: (list) => ListView.builder(
                reverse: true,
                itemCount: list.length,
                itemBuilder: (_, i) => ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(list[i].content),
                  subtitle: Text(list[i].authorId),
                ),
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator.adaptive()),
              error: (e, _) => Center(child: Text('Erro: $e')),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Escreva um comentário…'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isNotEmpty) {
                        addComment(text);
                        controller.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
