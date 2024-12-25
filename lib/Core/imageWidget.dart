import 'dart:io';
import 'package:flutter/material.dart';

class RecipeImageWidget extends StatelessWidget {
  final String imagePath;

  const RecipeImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    bool isLocal = !imagePath.startsWith('http://') && !imagePath.startsWith('https://');
    bool fileExists = isLocal && File(imagePath).existsSync();

    return isLocal
        ? fileExists
        ? Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      height: 250,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(
          Icons.broken_image,
          size: 150,
          color: Colors.grey,
        ),
      ),
    )
        : const Center(
      child: Icon(
        Icons.broken_image,
        size: 150,
        color: Colors.grey,
      ),
    )
        : Image.network(
      imagePath,
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(
          Icons.broken_image,
          size: 150,
          color: Colors.grey,
        ),
      ),
    );
  }
}
