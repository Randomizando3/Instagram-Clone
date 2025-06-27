import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
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
          // imagem / vídeo (simplificado p/ foto)
          CachedNetworkImage(
            imageUrl: post.mediaUrl,
            placeholder: (_, __) =>
            const AspectRatio(aspectRatio: 1, child: Center(child: CircularProgressIndicator())),
            errorWidget: (_, __, ___) =>
            const AspectRatio(aspectRatio: 1, child: Icon(Icons.broken_image)),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
