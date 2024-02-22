import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/helpers/images.dart';
import 'package:educonnect/models/course.dart';
import 'package:educonnect/screens/add_course.dart';
import 'package:educonnect/screens/courses_screen.dart';
import 'package:educonnect/screens/login_screen.dart';
import 'package:educonnect/screens/messages_screen.dart';
import 'package:educonnect/screens/my_profile_screen.dart';
import 'package:educonnect/screens/saved_courses_screen.dart';
import 'package:educonnect/services/course_service.dart';
import 'package:educonnect/services/tutors_service.dart';
import 'package:educonnect/widgets/circle_with_text_below.dart';
import 'package:educonnect/widgets/rectangle_course.dart';
import 'package:educonnect/widgets/text_entry_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/course_info.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "homePage";
  final Stream<List<String>>? favoriteCourses;

  const HomeScreen({this.favoriteCourses, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// TODO() - check favorites everywhere and reviews everywhere

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _keywordController = TextEditingController();
  final TutorsService _tutorsService = TutorsService();
  final CourseService _courseService = CourseService();
  final AuthService _authService = AuthService();
  final favoriteCoursesIds = <String>[];

  @override
  void initState() {
    super.initState();
    widget.favoriteCourses?.listen((event) {
      favoriteCoursesIds.clear();
      favoriteCoursesIds.addAll(event);
    });
  }

  void searchCourses() async {
    if (_keywordController.text.isEmpty) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CoursesScreen(
                  keyword: _keywordController.text,
                )));
  }

  void _showCourseInfo(BuildContext context, Course course) {
    showModalBottomSheet(
        context: context,
        builder: (context) => CourseInfoWidget(
              course: course,
            ));
  }

  Widget _searchIcon() {
    return IconButton(
        onPressed: searchCourses,
        icon: const Icon(Icons.search, color: Colors.white));
  }

  // TODO() - use SingleChildScrollView
  @override
  Widget build(BuildContext context) {
    var isSignedIn = FirebaseAuth.instance.currentUser != null;
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                color: green,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  logo,
                  entryFieldWidget(
                    'Пребарувај...',
                    _keywordController,
                  ),
                  _searchIcon()
                ],
              )),
          const SizedBox(height: 20),
          const Text("Образование",
              style: TextStyle(fontSize: 20, color: green)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoursesScreen(
                                levelOfEducation: "Основно",
                              )));
                },
                child: circleWithTextBelowWidget("Основно", showPersonIcon: false),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoursesScreen(
                                levelOfEducation: "Средно",
                              )));
                },
                child: circleWithTextBelowWidget("Средно", showPersonIcon: false),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoursesScreen(
                                levelOfEducation: "Високо",
                              )));
                },
                child: circleWithTextBelowWidget("Високо", showPersonIcon: false),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CoursesScreen(
                                levelOfEducation: "Друго",
                              )));
                },
                child: circleWithTextBelowWidget("Друго", showPersonIcon: false),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text("Популарни часови",
              style: TextStyle(fontSize: 20, color: green)),
          const SizedBox(height: 20),
          StreamBuilder<List<Course>>(
            stream: _courseService.getTopRatedCoursesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final courses = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GestureDetector(
                            onTap: () =>
                                _showCourseInfo(context, courses[index]),
                            child: rectangleCourse(courses[index], true,
                                favoriteCoursesIds.contains(courses[index].id)),
                          ),
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(height: 30),
          const Text("Најдобри тутори",
              style: TextStyle(fontSize: 20, color: green)),
          const SizedBox(height: 20),
          FutureBuilder(
              future: _tutorsService.getTopRatedUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: users
                        .map((user) => GestureDetector(
                              onTap: () {},
                              child: circleWithTextBelowWidget(user.firstName,
                                  showPersonIcon: true),
                            ))
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          const SizedBox(height: 60)
        ],
      )),
      bottomNavigationBar: BottomAppBar(
          color: Colors.grey.shade200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (isSignedIn) ...[
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CoursesScreen()));
                    },
                    icon: const Icon(Icons.book)),
                if(isSignedIn) ...[
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SavedCoursesScreen()));
                    },
                    icon: const Icon(Icons.favorite))],
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MessagesScreen()));
                    },
                    icon: const Icon(Icons.message)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyProfileScreen()));
                    },
                    icon: const Icon(Icons.person)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddCourseScreen()));
                    },
                    child: const Text("Add")),
                ElevatedButton(
                    onPressed: () {
                      _authService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text("Logout"))
              ] else ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Најави се",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ]
            ],
          )),
    );
  }
}
