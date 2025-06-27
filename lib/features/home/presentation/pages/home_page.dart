import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_providers.dart';
import '../widgets/post_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: feedAsync.when(
        data: (posts) => RefreshIndicator(
          onRefresh: () async => ref.refresh(feedProvider),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: posts.length,
            itemBuilder: (_, i) => PostCard(post: posts[i]),
          ),
        ),
        loading: () =>
        const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(
          child: Text('Erro ao carregar feed\n$e'),
        ),
      ),
    );
  }
}
