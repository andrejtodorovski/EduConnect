import 'package:educonnect/models/course.dart'; // Ensure you have this model
import 'package:educonnect/services/auth_service.dart'; // Adjust based on your implementation
import 'package:flutter/material.dart';

import '../helpers/colors.dart';
import '../models/user.dart';
import '../services/course_service.dart';
import '../widgets/my_courses_view.dart';
import 'add_course.dart';

class MyProfileScreen extends StatefulWidget {
  static const String id = "myProfileScreen";

  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Future<MyUser> getUserData() async {
    return await AuthService().getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _socialMediaButton(IconData icon) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мој профил'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<MyUser>(
          future: getUserData(), // the Future function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Data is loaded, access it using snapshot.data
              MyUser currentUser = snapshot.data!;
              return Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  const CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: green,
                        size: 90.0,
                      )),
                  const SizedBox(height: 10),
                  Text(currentUser.username,
                      style: const TextStyle(fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialMediaButton(Icons.facebook),
                      _socialMediaButton(Icons.email),
                    ],
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Basic Info'),
                      Tab(text: "My Courses"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildBasicInfoTab(currentUser),
                        _buildMyCoursesTab(currentUser),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab(MyUser currentUser) {
    return Center(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('First Name'),
            subtitle: Text(currentUser.firstName), // Replace with actual data
          ),
          ListTile(
            title: const Text('Last Name'),
            subtitle: Text(currentUser.lastName), // Replace with actual data
          ),
          ListTile(
            title: const Text('Email'),
            subtitle: Text(currentUser.username), // Replace with actual data
          ),
          ListTile(
            title: const Text('Phone Number'),
            subtitle: Text(currentUser.phoneNumber), // Replace with actual data
          ),
          // Add more fields as needed
        ],
      ),
    );
  }

  Widget _buildMyCoursesTab(MyUser currentUser) {
    // Assuming you have a method in your CourseService to fetch user courses
    return FutureBuilder<List<Course>>(
      future: CourseService().getUserCoursesStream(
          AuthService().currentUser!.uid), // Adjust fetching logic as needed
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No courses found'));
        }
        List<Course> courses = snapshot.data!;
        return Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCourseScreen()),
                  );
                },
                child: const Text('Add Course')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  Course course = courses[index];
                  return myCoursesView(course);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
