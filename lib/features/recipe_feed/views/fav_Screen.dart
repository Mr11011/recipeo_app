import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/imageWidget.dart';
import '../controller/recipe_cubit.dart';
import '../controller/recipe_states.dart';
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown.withOpacity(0.8),
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text('No favorite recipes found.'))
          : ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
          return ListTile(
            leading: CircleAvatar(
             child: RecipeImageWidget( imagePath: recipe.image),
            ),
            title: Text(recipe.recipe_name),
          );
        },
      ),
    );
  }
}


//
// class RecipeGrid extends StatelessWidget {
//   final List<RecipeModel> recipes;
//
//   const RecipeGrid({required this.recipes, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 3 / 4,
//         ),
//         itemCount: recipes.length,
//         itemBuilder: (context, index) {
//           final recipe = recipes[index];
//           return GestureDetector(
//             onTap: () {
//               // Add navigation to a detailed screen if required.
//             },
//             child: _RecipeCard(recipe: recipe),
//           );
//         },
//       ),
//     );
//   }
// }
// class _RecipeCard extends StatelessWidget {
//   final RecipeModel recipe;
//
//   const _RecipeCard({required this.recipe});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       elevation: 8,
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: RecipeImageWidget(imagePath: recipe.image),
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.6),
//                     Colors.transparent,
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 25,
//             left: 10,
//             right: 10,
//             child: Text(
//               recipe.recipe_name,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'fredoka',
//                 fontSize: 18,
//                 shadows: [
//                   Shadow(
//                     blurRadius: 10,
//                     color: Colors.black,
//                     offset: Offset(1, 1),
//                   ),
//                 ],
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Positioned(
//             bottom: 5,
//             left: 10,
//             right: 10,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.access_time,
//                         size: 14, color: Colors.white),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${recipe.prepTimeMinutes} min',
//                       style: const TextStyle(fontSize: 12, color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(Icons.local_fire_department,
//                         size: 14, color: Colors.white),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${recipe.calories} kcal',
//                       style: const TextStyle(fontSize: 12, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



