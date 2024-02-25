import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/helpers/firebase_options.dart';
import 'package:educonnect/screens/add_course.dart';
import 'package:educonnect/screens/courses_screen.dart';
import 'package:educonnect/screens/home_screen.dart';
import 'package:educonnect/screens/login_screen.dart';
import 'package:educonnect/screens/messages_screen.dart';
import 'package:educonnect/screens/my_profile_screen.dart';
import 'package:educonnect/screens/register_screen.dart';
import 'package:educonnect/screens/splash_screen.dart';
import 'package:educonnect/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EduConnect',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: green),
          useMaterial3: true,
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          AddCourseScreen.id: (context) => const AddCourseScreen(),
          CoursesScreen.id: (context) => const CoursesScreen(),
          MessagesScreen.id: (context) => const MessagesScreen(),
          MyProfileScreen.id: (context) => const MyProfileScreen(),
        });
  }
}
