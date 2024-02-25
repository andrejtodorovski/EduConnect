import 'package:educonnect/services/course_service.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/course_card.dart';

class CoursesScreen extends StatefulWidget {
  static const String id = "coursesScreen";
  final String? keyword;
  final String? levelOfEducation;
  final bool? getOnlyUserSavedCourses;

  const CoursesScreen({Key? key, this.keyword, this.levelOfEducation, this.getOnlyUserSavedCourses}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Stream<List<Course>> coursesStream;
  late List<MyUser> allTutors;
  @override
  void initState() {
    super.initState();
    if (widget.getOnlyUserSavedCourses != null &&
        widget.getOnlyUserSavedCourses == true) {
      coursesStream = CourseService()
          .getUsersFavoriteCourses(AuthService().currentUser!.uid);
    } else {
      coursesStream = CourseService()
          .getCoursesStream(widget.keyword, widget.levelOfEducation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсеви'),
      ),
      body: StreamBuilder<List<Course>>(
          stream: coursesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No courses found'));
            }
        
            var courses = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (1 / 0.75),
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseCard(
                  name: courses[index].name,
                  schoolName: courses[index].schoolName,
                  tutorName: courses[index].tutorName,
                  averageRating: courses[index].averageRating,
                );
              },
            );
          },
        ),
    );
  }
}
