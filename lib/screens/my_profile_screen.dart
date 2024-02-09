import 'package:flutter/material.dart';
import 'package:educonnect/models/course.dart'; // Ensure you have this model
import 'package:educonnect/services/auth_service.dart'; // Adjust based on your implementation

import '../services/course_service.dart';

class MyProfileScreen extends StatefulWidget {
  static const String id = "myProfileScreen";

  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      onPressed: () {

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                'default_user_picture_url'), // Add your default user picture URL
          ),
          const SizedBox(height: 10),
          const Text('User Name', style: TextStyle(fontSize: 20)),
          // Replace 'User Name' with the actual user name
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
                _buildBasicInfoTab(),
                _buildMyCoursesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return Center(
      child: ListView(
        children: const <Widget>[
          ListTile(
            title: Text('First Name'),
            subtitle: Text('UserFirstName'), // Replace with actual data
          ),
          ListTile(
            title: Text('Last Name'),
            subtitle: Text('UserLastName'), // Replace with actual data
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text('UserEmail'), // Replace with actual data
          ),
          ListTile(
            title: Text('Phone Number'),
            subtitle: Text('UserPhoneNumber'), // Replace with actual data
          ),
          // Add more fields as needed
        ],
      ),
    );
  }

  Widget _buildMyCoursesTab() {
    // Assuming you have a method in your CourseService to fetch user courses
    return FutureBuilder<List<Course>>(
      future: CourseService().getUserCoursesStream(AuthService().currentUser!.uid), // Adjust fetching logic as needed
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No courses found'));
        }
        List<Course> courses = snapshot.data!;
        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            Course course = courses[index];
            return ListTile(
              title: Text(course.name),
              subtitle: Text(course.schoolName),
              // Implement onTap or other actions as needed
            );
          },
        );
      },
    );
  }

}
