import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/data/post_repository.dart';
import '../../home/presentation/providers/feed_providers.dart';

// ------------ Estado do arquivo escolhido -------------------------------
final imageFileProvider = StateProvider<File?>((_) => null);

// ------------ Função para criar post ------------------------------------
final createPostProvider = Provider<
    Future<void> Function({
    required String description,
    double? price,
    bool? isRent,
    String? category,
    })>((ref) {
  final repo = ref.watch(postRepoProvider);

  return ({
    required String description,
    double? price,
    bool? isRent,
    String? category,
  }) async {
    final file = ref.read(imageFileProvider);
    if (file == null) throw 'Selecione uma imagem';

    await repo.createPost(
      uid: demoUid,
      image: file,
      description: description,
      price: price,
      isRent: isRent,
      category: category,
    );

    // limpa após o upload
    ref.read(imageFileProvider.notifier).state = null;
  };
});
