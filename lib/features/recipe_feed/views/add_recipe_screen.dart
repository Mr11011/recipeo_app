import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_sharing/Core/textfield.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController cuisineNameController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController difficulityController = TextEditingController();
  final TextEditingController prepTimeController = TextEditingController();
  final TextEditingController mealtypeController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  bool isLoading = false;

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
      Fluttertoast.showToast(msg: "Image Selected");
    } else {
      Fluttertoast.showToast(msg: "No Image Selected");
    }
  }

  void _clearFields() {
    recipeNameController.clear();
    caloriesController.clear();
    difficulityController.clear();
    tagsController.clear();
    ingredientsController.clear();
    instructionsController.clear();
    cuisineNameController.clear();
    prepTimeController.clear();
    mealtypeController.clear();
    ratingController.clear();
    setState(() {
      _selectedImage = null;
    });
    Fluttertoast.showToast(msg: "Fields cleared!");
  }

  Future<void> _submitRecipe() async {
    if (recipeNameController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        difficulityController.text.isEmpty ||
        prepTimeController.text.isEmpty ||
        mealtypeController.text.isEmpty ||
        ratingController.text.isEmpty ||
        cuisineNameController.text.isEmpty ||
        instructionsController.text.isEmpty ||
        ingredientsController.text.isEmpty||  _selectedImage == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and select an image");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('recipes').add({
        'name': recipeNameController.text,
        'caloriesPerServing': int.parse(caloriesController.text),
        'difficulty': difficulityController.text,
        'prepTimeMinutes': int.parse(prepTimeController.text),
        'mealType': mealtypeController.text.split(','),
        // Split by commas
        'rating': double.parse(ratingController.text),
        'cuisine': cuisineNameController.text,
        'tags': tagsController.text.split(','),
        // Split by commas
        'instructions': instructionsController.text.split(','),
        // Split by commas
        'ingredients': ingredientsController.text.split(','),
        // Split by commas
        'image': _selectedImage!.path,
        'reviewCount': 1,
        // Use the local image path for now
      });

      Fluttertoast.showToast(msg: "Recipe added successfully!");
      _clearFields();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Add Recipe",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'fredoka',
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.brown.withOpacity(0.8),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Selection Section
              Center(
                child: GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 60,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input Fields
              CustomTextFormField(
                labelText: "Recipe name",
                hintText: "Enter your recipe name",
                controller: recipeNameController,
                prefixIcon: Icons.dining_rounded,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "Calories",
                hintText: "Enter the calories",
                keyboardType: TextInputType.number,
                controller: caloriesController,
                prefixIcon: Icons.local_fire_department,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "Difficulty",
                hintText: "Enter difficulty level",
                controller: difficulityController,
                prefixIcon: Icons.analytics_rounded,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "Prep Time",
                hintText: "Enter preparation time (in minutes)",
                keyboardType: TextInputType.number,
                controller: prepTimeController,
                prefixIcon: Icons.timer,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "Meal Type",
                hintText: "Enter meal type (e.g., Breakfast, Lunch)",
                controller: mealtypeController,
                prefixIcon: Icons.food_bank_rounded,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "Rating",
                hintText: "Enter rating (1-5)",
                keyboardType: TextInputType.number,
                controller: ratingController,
                prefixIcon: Icons.star,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "Cuisine",
                hintText: "Enter cuisine name (e.g., Italian)",
                controller: cuisineNameController,
                prefixIcon: Icons.dinner_dining,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "Tags",
                hintText: "Enter tags separated by commas",
                controller: tagsController,
                prefixIcon: Icons.tag,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: "ingredients",
                hintText: "Enter recipe ingredients",
                controller: ingredientsController,
                prefixIcon: Icons.soup_kitchen,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                labelText: "instructions",
                hintText: "Enter recipe instructions",
                controller: instructionsController,
                prefixIcon: Icons.rule,
              ),
              // Submit Button
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            iconColor: Colors.brown,
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 12),
                          ),
                          onPressed: _submitRecipe,
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
