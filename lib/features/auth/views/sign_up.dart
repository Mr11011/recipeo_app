import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe_sharing/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/textfield.dart';
import '../controller/auth_cubit.dart';
import '../controller/auth_states.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var emailController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordHidden = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => authCubit(),
          child: BlocListener<authCubit, authStates>(
            listener: (context, state) {
              if (state is signUpStatesSuccess) {
                Fluttertoast.showToast(
                  msg: "Sign Up Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.green,
                );

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                      (Route<dynamic> route) => false,
                );
              } else if (state is signUpStatesError) {
                Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            child: BlocBuilder<authCubit, authStates>(
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Image Container
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/OB.png"),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08, // 8% of screen width
                            vertical: screenHeight * 0.02, // 2% of screen height
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Background Image Container
                              Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.2, // 20% of screen height
                                  width: screenWidth * 0.5, // 50% of screen width
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: const DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage("assets/char3.png"),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'PlaywriteDEGrund',
                                ),
                              ),

                              // Username TextField
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.01,
                                  top: screenHeight * 0.04,
                                ),
                                child: CustomTextFormField(
                                  controller: userNameController,
                                  labelText: "Username",
                                  focusedCustomColor: Colors.purple,
                                  keyboardType: TextInputType.name,
                                  hintText: "Enter your preferred username",
                                  prefixIcon: Icons.account_circle,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Username should not be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              // Email TextField
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                child: CustomTextFormField(
                                  controller: emailController,
                                  labelText: "Email",
                                  keyboardType: TextInputType.emailAddress,
                                  focusedCustomColor: Colors.purple,
                                  hintText: "Enter your email here",
                                  prefixIcon: Icons.attach_email_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Your Email';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      Fluttertoast.showToast(
                                        msg: 'Enter a valid email',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              // Password
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.03,
                                ),
                                child: CustomTextFormField(
                                  controller: passwordController,
                                  labelText: "Password",
                                  obscureText: isPasswordHidden,
                                  focusedCustomColor: Colors.purple,
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: "Enter your strong password",
                                  prefixIcon: Icons.lock,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password Cannot Be Empty';
                                    }
                                    return null;
                                  },
                                  suffixIcon: isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  onSuffixIconPressed: () {
                                    setState(() {
                                      isPasswordHidden = !isPasswordHidden;
                                    });
                                  },
                                ),
                              ),

                              ConditionalBuilder(
                                builder: (context) => Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        saveProfileData();
                                        authCubit.get(context).signUpWithFirebase(
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      minimumSize: Size(
                                        screenWidth * 0.4, // 40% of screen width
                                        screenHeight * 0.06, // 6% of screen height
                                      ),
                                    ),
                                    child: const Text(
                                      "Let's Go",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                fallback: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                condition: state is! authStatesLoading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future saveProfileData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("username", userNameController.text.trim());
    await pref.setString("email", emailController.text.trim());
    debugPrint("email Saved");
  }
}
