import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:recipe_sharing/features/recipe_feed/model/recipe_model.dart';

import '../../../Core/imageWidget.dart';

class DetailsScreen extends StatelessWidget {
  final RecipeModel recipe;

  const DetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown.withOpacity(0.8),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          recipe.recipe_name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "fredoka",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10),
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(30)),
                child:RecipeImageWidget(imagePath: recipe.image),
              ),
            ),
            const SizedBox(height: 16),

            // Recipe Name & Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                color: Colors.deepPurple.withOpacity(0.5),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.recipe_name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'karla'),
                      ),
                      const SizedBox(height: 8),

                      // Rating and Reviews
                      Row(
                        children: [
                          PannableRatingBar(
                            rate: recipe.rating.toDouble(),
                            items: List.generate(
                                5,
                                    (index) => const RatingWidget(
                                  selectedColor: Colors.yellow,
                                  unSelectedColor: Colors.grey,
                                  child: Icon(
                                    Icons.star,
                                    size: 25,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${recipe.rating.toDouble()} ",
                            style: const TextStyle(
                                fontFamily: 'karla', fontSize: 16),
                          ),

                          const SizedBox(
                            width: 15,
                          ),
                          // Review Count
                          Text(
                            '(${recipe.reviewCount} reviews)',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'karla',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Additional Info (Calories, Prep Time, etc.)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calories: ${recipe.calories} kcal',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'karla'),
                          ),
                          Text(
                            'Prep Time: ${recipe.prepTimeMinutes} min',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'karla'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Chips for Difficulty and Cuisine
                      Row(
                        children: [
                          Chip(
                            label: Text(recipe.difficulity),
                            backgroundColor: Colors.teal[50],
                            labelStyle: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlaywriteDEGrund'),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(recipe.cuisine),
                            backgroundColor: Colors.orange[50],
                            labelStyle: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlaywriteDEGrund'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Ingredients Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                color: Colors.orangeAccent.withOpacity(0.5),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                            fontFamily: 'karla'),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.ingredients.map(
                            (ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.circle,
                                  size: 8, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(
                                      fontSize: 18, fontFamily: 'karla'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                color: Colors.amberAccent,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Instructions',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                            fontFamily: 'karla'),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.instructions.map(
                            (ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.circle,
                                  size: 8, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(
                                      fontSize: 18, fontFamily: 'karla'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Meal Type Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                color: Colors.greenAccent,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meal Type',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.mealType.map(
                            (type) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.fastfood,
                                  size: 20, color: Colors.brown),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  type,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'karla',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}