import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_sharing/features/auth/views/profile.dart';
import 'package:recipe_sharing/features/recipe_feed/views/add_recipe_screen.dart';
import 'package:recipe_sharing/features/recipe_feed/views/fav_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Core/blocObserver.dart';
import 'features/auth/controller/auth_cubit.dart';
import 'features/recipe_feed/views/recipe_screen.dart';
import 'firebase_options.dart';
import 'on_boarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => authCubit(),
        ),
      ],
      child: DevicePreview(
        builder: (context) => MyApp(isLoggedIn: isLoggedIn),
        enabled: kDebugMode,
      )));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      home: isLoggedIn ? const MyHomePage() : const OnBoarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    const RecipeScreen(),
    const AddRecipeScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: "Profile")
            ]));
  }
}
