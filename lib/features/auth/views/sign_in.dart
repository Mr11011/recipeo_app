import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipe_sharing/features/auth/controller/auth_cubit.dart';
import 'package:recipe_sharing/features/auth/controller/auth_states.dart';
import 'package:recipe_sharing/features/auth/views/sign_up.dart';
import 'package:recipe_sharing/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordHidden = true;
  final TapGestureRecognizer _signUpRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _signUpRecognizer.dispose(); // Dispose the recognizer
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => authCubit(),
      child: SafeArea(
        child: Scaffold(
          body: BlocListener<authCubit, authStates>(
            listener: (context, state) {
              if (state is authStatesSuccess) {
                Fluttertoast.showToast(
                  msg: "Login Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  backgroundColor: Colors.green,
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                      (Route<dynamic> route) => false,
              );
              } else if (state is authStatesError) {
                Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
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
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Logo Image
                              Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage("assets/smile.png"),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlaywriteDEGrund',
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),

                              // Email TextField
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                child: CustomTextFormField(
                                  focusedCustomColor: Colors.purple,
                                  controller: emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: "Please Enter Your Email",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
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
                                  labelText: "Email",
                                  hintText: "Enter Your Email Address",
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.attach_email_rounded,
                                ),
                              ),

                              // Password TextField
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                child: CustomTextFormField(
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Your Password';
                                    }
                                    return null;
                                  },
                                  labelText: "Password",
                                  obscureText: isPasswordHidden,
                                  focusedCustomColor: Colors.purple,
                                  suffixIcon: isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  onSuffixIconPressed: () {
                                    setState(() {
                                      isPasswordHidden = !isPasswordHidden;
                                    });
                                  },
                                  hintText: "Enter Your Password",
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.lock,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),

                              // Sign In Button
                              ConditionalBuilder(
                                builder: (context) => ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      saveProfileData();
                                      context.read<authCubit>().signInWithFirebase(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                condition: state is! authStatesLoading,
                                fallback: (context) =>
                                const CircularProgressIndicator(),
                              ),
                              SizedBox(height: screenHeight * 0.03),

                              // Sign Up Text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "Don't have an account?",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontFamily: 'PlaywriteDEGrund',
                                        fontSize: screenWidth * 0.04,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: " Sign up",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.04,
                                            fontFamily: 'PlaywriteDEGrund',
                                          ),
                                          recognizer: _signUpRecognizer
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const SignUpScreen(),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
    await pref.setString("email", emailController.text.trim());
    debugPrint("Email saved");
  }
}
