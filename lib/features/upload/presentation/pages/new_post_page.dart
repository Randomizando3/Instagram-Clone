import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../home/presentation/providers/feed_providers.dart';
import '../../providers/upload_providers.dart';

class NewPostPage extends ConsumerStatefulWidget {
  const NewPostPage({super.key});

  @override
  ConsumerState<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool? _isRent;
  String? _category;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85);

    if (xFile != null) {
      ref.read(imageFileProvider.notifier).state = File(xFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = ref.watch(imageFileProvider);
    final createPost = ref.watch(createPostProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Novo anúncio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: file == null
                    ? const Icon(Icons.add_a_photo,
                    size: 64, color: Colors.grey)
                    : Image.file(file, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            TextField(
              controller: _priceCtrl,
              decoration: const InputDecoration(
                  labelText: 'Preço (opcional)', prefixText: 'R\$ '),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<bool>(
              value: _isRent,
              items: const [
                DropdownMenuItem(
                    value: null,
                    child: Text('Venda ou locação? (opcional)')),
                DropdownMenuItem(value: false, child: Text('Venda')),
                DropdownMenuItem(value: true, child: Text('Locação')),
              ],
              onChanged: (v) => setState(() => _isRent = v),
            ),
            TextField(
              decoration:
              const InputDecoration(labelText: 'Categoria (opcional)'),
              onChanged: (v) => _category = v,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Publicar'),
              onPressed: () async {
                try {
                  await createPost(
                    description: _descCtrl.text.trim(),
                    price: double.tryParse(
                        _priceCtrl.text.replaceAll(',', '.')),
                    isRent: _isRent,
                    category: _category?.trim().isEmpty ?? true
                        ? null
                        : _category,
                  );
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
