import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_sharing/Core/imageWidget.dart';
import 'package:recipe_sharing/features/recipe_feed/views/details_screen.dart';
import 'package:recipe_sharing/features/recipe_feed/controller/recipe_cubit.dart';
import 'package:recipe_sharing/features/recipe_feed/controller/recipe_states.dart';
import '../model/recipe_model.dart';
import '../recipe_data_service.dart';
import 'fav_Screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<RecipeModel> favoriteRecipes = []; // List to store favorite recipes

  void _toggleFavorite(RecipeModel recipe) {
    setState(() {
      recipe.isFavorite = !recipe.isFavorite;
      if (recipe.isFavorite) {
        favoriteRecipes.add(recipe);
      } else {
        favoriteRecipes.removeWhere((r) => r.recipe_name == recipe.recipe_name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(RecipeService())..fetchRecipes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Recipeo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: "fredoka",
            ),
          ),
          backgroundColor: Colors.brown.withOpacity(0.8),
          actions: [
            _TagDropdown(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FavoriteRecipesScreen(favoriteRecipes: favoriteRecipes),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        body: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else if (state is RecipeSuccess) {
              final recipes = state.recipes;
              debugPrint(
                  'Recipe count: ${recipes.length}'); // Monitor recipe count
              if (recipes.isEmpty) {
                return const Center(child: Text('No recipes found.'));
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(recipe: recipe),
                          ),
                        );
                      },
                      child: _RecipeCard(
                        recipe: recipe,
                        onFavoriteToggle: _toggleFavorite,
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _TagDropdown extends StatelessWidget {
  final List<String> _tags = [
    'All',
    'Pizza',
    'Beef',
    'Pasta',
    'Chicken',
    'Shrimp',
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = RecipeCubit.get(context);
    return DropdownButton<String>(
      value: null,
      hint: const Text(
        "Filter",
        style: TextStyle(color: Colors.white, fontFamily: 'fredoka'),
      ),
      dropdownColor: Colors.white.withOpacity(0.8),
      items: _tags.map((tag) {
        return DropdownMenuItem<String>(
          value: tag,
          child: Text(tag, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: (value) {
        if (value == 'All') {
          cubit.fetchRecipes();
        } else {
          cubit.fetchRecipeWithTags(value!);
        }
      },
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final Function(RecipeModel) onFavoriteToggle;

  const _RecipeCard({
    required this.recipe,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      child: Stack(
        children: [
          // Recipe Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: RecipeImageWidget(imagePath: recipe.image),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          // Recipe Name
          Positioned(
            bottom: 25,
            left: 10,
            right: 10,
            child: Text(
              recipe.recipe_name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'fredoka',
                fontSize: 18,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Prep Time and Calories
          Positioned(
            bottom: 5,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${recipe.prepTimeMinutes} min',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${recipe.calories} kcal',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Favorite Button
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade500.withOpacity(0.9),
              child: IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  onFavoriteToggle(recipe);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

