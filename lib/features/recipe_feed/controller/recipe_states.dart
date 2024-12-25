import 'package:recipe_sharing/features/recipe_feed/model/recipe_model.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeSuccess extends RecipeState {
  final List<RecipeModel> recipes;
  RecipeSuccess(this.recipes);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}
