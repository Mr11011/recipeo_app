import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_sharing/features/recipe_feed/model/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String baseURL = 'https://dummyjson.com/recipes?limit=8';

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

  Future<List<RecipeModel>> fetchFirestoreRecipes() async {
    final querySnapshot = await firestore.collection('recipes').get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("No recipes found in Firestore");
    }

    // Ensure handling multiple documents properly
    return querySnapshot.docs.map((doc) {
      return RecipeModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<RecipeModel>> fetchRecipesFromAllSources() async {
    final apiRecipes = await fetchRecipes();
    final firestoreRecipes = await fetchFirestoreRecipes();

    // Combine both sources
    final allRecipes = [...apiRecipes, ...firestoreRecipes];
    return allRecipes;
  }
}
