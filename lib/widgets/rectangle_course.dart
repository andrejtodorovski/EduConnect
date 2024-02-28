import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/services/course_service.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';

class RectangleCourse extends StatefulWidget {
  final Course course;

  const RectangleCourse({Key? key, required this.course}) : super(key: key);

  @override
  State<RectangleCourse> createState() => _RectangleCourseState();
}

class _RectangleCourseState extends State<RectangleCourse> {
  late bool showFavoritesButton;

  @override
  void initState() {
    super.initState();
    showFavoritesButton = false;

    var currentUser = AuthService().currentUser;
    if (currentUser != null) {
      showFavoritesButton = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return rectangleCourse(widget.course, showFavoritesButton);
  }
}

Widget rectangleCourse(Course course, bool showFavoritesButton) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: 200,
    decoration: BoxDecoration(
      color: grey,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    course.averageRating.toString(),
                    style: const TextStyle(
                      color: green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                course.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                course.tutorName,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (showFavoritesButton) ...[
          StreamBuilder<List<String>>(
              stream: CourseService()
                  .getFavoriteCoursesStream(AuthService().currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Icon(Icons.error);
                }
                if (snapshot.hasData) {
                  bool isUserFavoriteCourse =
                      snapshot.data!.any((fav) => fav == course.id);
                  return FavoriteCourseIconButton(
                    courseId: course.id,
                    initialState: isUserFavoriteCourse,
                  );
                } else {
                  return const SizedBox();
                }
              })
        ],
      ],
    ),
  );
}

class FavoriteCourseIconButton extends StatefulWidget {
  final String courseId;
  final bool initialState;

  const FavoriteCourseIconButton({
    Key? key,
    required this.courseId,
    required this.initialState,
  }) : super(key: key);

  @override
  State<FavoriteCourseIconButton> createState() =>
      _FavoriteCourseIconButtonState();
}

class _FavoriteCourseIconButtonState extends State<FavoriteCourseIconButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData = isFavorite ? Icons.bookmark : Icons.bookmark_border;

    return IconButton(
      icon: Icon(iconData),
      onPressed: () async {
        await CourseService().createUserFavoriteCourse(
            widget.courseId, AuthService().currentUser!.uid);

        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
