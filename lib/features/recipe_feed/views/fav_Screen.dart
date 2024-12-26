import 'package:flutter/material.dart';
import '../../../Core/imageWidget.dart';
import '../model/recipe_model.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  final List<RecipeModel> favoriteRecipes;

  const FavoriteRecipesScreen({required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Recipes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Fredoka',
          ),
        ),
        backgroundColor: Colors.brown.withOpacity(0.9),
        elevation: 5,
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(
        child: Text(
          'No favorite recipes found.',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Fredoka', // Applied Fredoka font
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              leading: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: RecipeImageWidget(
                    imagePath: recipe.image,
                  ),
                ),
              ),
              title: Text(
                recipe.recipe_name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka', // Applied Fredoka font
                  color: Colors.black87,
                ),
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.prepTimeMinutes} min',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Fredoka', // Applied Fredoka font
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.local_fire_department, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.calories} kcal',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Fredoka', // Applied Fredoka font
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  // Handle favorite toggle
                },
              ),
              onTap: () {
                // Handle recipe tap
              },
            ),
          );
        },
      ),
    );
  }
}
