import 'package:educonnect/services/course_service.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/course_info.dart';
import '../widgets/rectangle_course.dart';

class CoursesScreen extends StatefulWidget {
  static const String id = "coursesScreen";
  final String? keyword;
  final String? levelOfEducation;
  final bool? getOnlyUserSavedCourses;

  const CoursesScreen(
      {Key? key,
      this.keyword,
      this.levelOfEducation,
      this.getOnlyUserSavedCourses})
      : super(key: key);

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

  void _showCourseInfo(BuildContext context, Course course) {
    showModalBottomSheet(
        context: context,
        builder: (context) => CourseInfoWidget(
              course: course,
            ));
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
            return const Center(child: Text('Нема курсеви за прикажување.'));
          }

          var courses = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (1 / 0.75),
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showCourseInfo(context, courses[index]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RectangleCourse(course: courses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
