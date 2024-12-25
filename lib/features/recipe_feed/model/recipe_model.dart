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
    final List<String> instructions;
    final List<String> mealType;
    final List<String> tags;
    bool isFavorite;

    RecipeModel({
      required this.recipe_name,
      required this.difficulity,
      required this.image,
      required this.cuisine,
      this.calories = 0,
      this.prepTimeMinutes = 0,
      this.reviewCount = 0,
      this.rating = 0.0,
      this.ingredients = const [],
      this.instructions = const [],
      this.mealType = const [],
      this.tags = const [],
      this.isFavorite = false,
    });

    factory RecipeModel.fromJson(Map<String, dynamic> json) {
      return RecipeModel(
        recipe_name: json["name"] ?? "",
        difficulity: json["difficulty"] ?? "Unknown",
        image: json["image"] ?? "Not available",
        cuisine: json["cuisine"] ?? "Unknown",
        calories: json["caloriesPerServing"] ?? 0,
        prepTimeMinutes: json["prepTimeMinutes"] ?? 0,
        reviewCount: json["reviewCount"] ?? 0,
        rating: json["rating"] ?? 0.0,
        ingredients: List<String>.from(json["ingredients"] ?? ['Not available']),
        instructions: List<String>.from(json["instructions"] ?? ['Not available']),
        mealType: List<String>.from(json["mealType"] ?? ['Not available']),
        tags: List<String>.from(json["tags"] ?? ['Not available']),
        isFavorite: json["isFavorite"] ?? false,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        "name": recipe_name,
        "difficulty": difficulity,
        "image": image,
        "cuisine": cuisine,
        "caloriesPerServing": calories,
        "prepTimeMinutes": prepTimeMinutes,
        "reviewCount": reviewCount,
        "rating": rating,
        "ingredients": ingredients,
        "instructions": instructions,
        "mealType": mealType,
        "tags": tags,
        "isFavorite": isFavorite,
      };
    }
  }
