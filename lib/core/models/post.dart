import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String authorId;
  final String mediaUrl;             // URL da imagem / vídeo
  final String description;
  final double? price;               // valor do imóvel (opcional)
  final bool? isRent;                // true = locação, false = venda
  final String? category;            // “Apartamento”, “Casa”, etc.
  final DateTime createdAt;

  // Likes
  final int likes;
  final List<String> likedBy;        // uids que curtiram

  Post({
    required this.id,
    required this.authorId,
    required this.mediaUrl,
    required this.description,
    this.price,
    this.isRent,
    this.category,
    this.likes = 0,
    List<String>? likedBy,
    DateTime? createdAt,
  })  : likedBy = likedBy ?? const [],
        createdAt = createdAt ?? DateTime.now();

  // ---------- Firestore helpers ----------

  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Post(
      id: doc.id,
      authorId: d['authorId'],
      mediaUrl: d['mediaUrl'],
      description: d['description'] ?? '',
      price: (d['price'] as num?)?.toDouble(),
      isRent: d['isRent'],
      category: d['category'],
      likes: d['likes'] ?? 0,
      likedBy: List<String>.from(d['likedBy'] ?? []),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'authorId': authorId,
    'mediaUrl': mediaUrl,
    'description': description,
    'price': price,
    'isRent': isRent,
    'category': category,
    'likes': likes,
    'likedBy': likedBy,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
