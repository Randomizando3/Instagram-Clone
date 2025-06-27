import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String authorId;
  final String mediaUrl;
  final String description;
  final double? price;
  final bool? isRent;
  final String? category;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.authorId,
    required this.mediaUrl,
    required this.description,
    this.price,
    this.isRent,
    this.category,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

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
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
