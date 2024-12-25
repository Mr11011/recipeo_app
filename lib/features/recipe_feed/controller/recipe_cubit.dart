import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_sharing/features/recipe_feed/recipe_data_service.dart';
import 'package:recipe_sharing/features/recipe_feed/controller/recipe_states.dart';

import '../model/recipe_model.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeService recipeService;

  RecipeCubit(this.recipeService) : super(RecipeInitial());

  static RecipeCubit get(context) => BlocProvider.of(context);

  Future<void> fetchRecipes() async {
    emit(RecipeLoading());
    try {
      // final recipes = await recipeService.fetchRecipes();
      final recipes = await recipeService.fetchRecipesFromAllSources();
      emit(RecipeSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> fetchRecipeWithTags(String tag) async {
    emit(RecipeLoading());
    try {
      final recipesWithTags = await recipeService.fetchRecipeWithTags(tag);
      emit(RecipeSuccess(recipesWithTags));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<List<RecipeModel>> fetchRecipesFromAllSources() async {
    emit(RecipeLoading());
    try {
      final apiRecipes = await recipeService.fetchRecipes();
      final firestoreRecipes = await recipeService.fetchFirestoreRecipes();
      // Combine both sources, ensuring no unexpected duplicates
      final allRecipes = [...apiRecipes, ...firestoreRecipes];
      emit(RecipeSuccess(allRecipes));
      return allRecipes;
    } catch (e) {
      emit(RecipeError("Failed to fetch recipes: ${e.toString()}"));
      return [];
    }
  }
}
