import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/post.dart';
import '../providers/feed_providers.dart';
import '../pages/comments_page.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = post.likedBy.contains(demoUid);
    final like = ref.watch(likeActionProvider(post));

    final priceText = post.price != null
        ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(post.price)
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: post.mediaUrl,
            placeholder: (_, __) => const AspectRatio(
                aspectRatio: 1, child: Center(child: CircularProgressIndicator())),
            errorWidget: (_, __, ___) => const AspectRatio(
                aspectRatio: 1, child: Icon(Icons.broken_image)),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Like + comment
                Row(
                  children: [
                    IconButton(
                      isSelected: isLiked,
                      selectedIcon: const Icon(Icons.favorite),
                      icon: const Icon(Icons.favorite_border),
                      onPressed: like,
                    ),
                    Text('${post.likes}'),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CommentsPage(post: post),
                        ),
                      ),
                    ),
                  ],
                ),
                if (post.description.isNotEmpty)
                  Text(post.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                if (priceText != null) ...[
                  const SizedBox(height: 6),
                  Text(priceText,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
                const SizedBox(height: 6),
                Text(
                  DateFormat.yMMMd('pt_BR').add_Hm().format(post.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
