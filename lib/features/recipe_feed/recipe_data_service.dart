import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_sharing/features/recipe_feed/model/recipe_model.dart';

class RecipeService {
  final String baseURL = 'https://dummyjson.com/recipes';

  Future<List<RecipeModel>> fetchRecipes() async {
    final response = await http.get(Uri.parse(baseURL));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<RecipeModel> recipes = (jsonData['recipes'] as List)
          .map((recipe) => RecipeModel.fromJson(recipe))
          .toList();

      return recipes;
    } else {
      throw Exception("Unable to Fetch data from API");
    }
  }

  Future<List<RecipeModel>> fetchRecipeWithTags(String tag) async {
    final tagsResponse =
        await http.get(Uri.parse('https://dummyjson.com/recipes/tag/$tag'));

    if (tagsResponse.statusCode == 200) {
      final data = jsonDecode(tagsResponse.body);
      List<RecipeModel> recipesWithTags = (data['recipes'] as List)
          .map((recipe) => RecipeModel.fromJson(recipe))
          .toList();

      return recipesWithTags;
    } else {
      throw Exception("Unable to fetch needed tag");
    }
  }
}
