class RecipeModel {
  final String recipe_name;
  final String difficulity;
  final String image;
  final String cuisine;
  final int calories;
  final int prepTimeMinutes;
  final int reviewCount;
  final dynamic rating;
  final List<String> ingredients;
  final List<String> mealType;
  final List<String> tags;

  const RecipeModel({
    required this.recipe_name,
    required this.difficulity,
    required this.image,
    required this.calories,
    required this.prepTimeMinutes,
    required this.cuisine,
    required this.reviewCount,
    required this.rating,
    required this.ingredients,
    required this.mealType,
    required this.tags,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      recipe_name: json["name"] as String,
      difficulity: json["difficulty"] as String,
      image: json["image"] as String,
      cuisine: json["cuisine"] as String,
      calories: json["caloriesPerServing"] as int,
      prepTimeMinutes: json["prepTimeMinutes"] as int,
      reviewCount: json["reviewCount"] as int,
      rating: json["rating"] as dynamic,
      ingredients: List<String>.from(json["ingredients"]),
      mealType: List<String>.from(json["mealType"]),
      tags: List<String>.from(json["tags"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': recipe_name,
      'difficulty': difficulity,
      'image': image,
      'cuisine': cuisine,
      'caloriesPerServing': calories,
      'prepTimeMinutes': prepTimeMinutes,
      "reviewCount": reviewCount,
      "rating": rating,
      "ingredients": ingredients,
      "mealType": mealType,
      "tags": tags,
    };
  }
}
