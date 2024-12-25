import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../on_boarding.dart';
import '../controller/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username') ?? 'Username not set';
      email = pref.getString('email') ?? 'Email not set';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.8),
          title: const Text(
            "User Profile",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'fredoka',color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                HexColor("#1434A4").withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    child: Image.asset(
                      "assets/user.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileCard(
                      title: username ?? 'Loading...', icon: Icons.person),
                  const SizedBox(height: 20),
                  _buildProfileCard(
                      title: email ?? 'Loading...', icon: Icons.email),
                  const SizedBox(height: 20),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        authCubit.get(context).signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OnBoarding()));
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.yellow,
                      ),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.lightGreen.withOpacity(0.4),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A reusable widget for the profile fields
  Widget _buildProfileCard({required String title, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Karla',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
