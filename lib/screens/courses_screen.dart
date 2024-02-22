import 'package:educonnect/services/course_service.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/user.dart';
import '../widgets/course_card.dart';

class CoursesScreen extends StatefulWidget {
  static const String id = "coursesScreen";
  final String? keyword;
  final String? levelOfEducation;

  const CoursesScreen({Key? key, this.keyword, this.levelOfEducation}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Stream<List<Course>> coursesStream;
  late List<MyUser> allTutors;
  @override
  void initState() {
    super.initState();
    coursesStream = CourseService().getCoursesStream(widget.keyword, widget.levelOfEducation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсеви'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Course>>(
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
      ),
    );
  }
}
