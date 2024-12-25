import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_sharing/features/recipe_feed/recipe_data_service.dart';
import 'package:recipe_sharing/features/recipe_feed/controller/recipe_states.dart';

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
  Future<void> fetchRecipesFromAllSources() async {
  emit(RecipeLoading());
  try {
    final apiRecipes = await recipeService.fetchRecipes();
    final firestoreRecipes = await recipeService.fetchFirestoreRecipes();

    // Combine both sources
    final allRecipes = [...apiRecipes, ...firestoreRecipes];
    emit(RecipeSuccess(allRecipes));
  } catch (e) {
    emit(RecipeError("Failed to fetch recipes: ${e.toString()}"));
  }
}

}
