import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/services/course_service.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';

Widget rectangleCourse(
    Course course, bool showFavoritesButton, bool isUserFavoriteCourse) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: 250,
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
              const SizedBox(height: 8),
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
          FavoriteCourseIconButton(
            courseId: course.id,
            initialState: isUserFavoriteCourse,
          ),
        ],
      ],
    ),
  );
}

class FavoriteCourseIconButton extends StatefulWidget {
  final String courseId;
  final bool initialState;

  const FavoriteCourseIconButton(
      {Key? key, required this.courseId, required this.initialState})
      : super(key: key);

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
    // The icon changes based on the isFavorite flag
    IconData iconData = isFavorite ? Icons.bookmark : Icons.bookmark_border;

    return IconButton(
      icon: Icon(iconData),
      onPressed: () async {
        // Ideally, handle potential errors and ensure createUserFavoriteCourse
        // can indicate success/failure or use a state management solution
        await CourseService().createUserFavoriteCourse(
            widget.courseId, AuthService().currentUser!.uid);

        // Toggle the favorite state
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
