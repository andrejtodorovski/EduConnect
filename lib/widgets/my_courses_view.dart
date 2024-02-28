import 'package:flutter/material.dart';

import '../models/course.dart';

Widget myCoursesView(Course course) {
  return Card(
    margin: const EdgeInsets.all(8.0),
    child: ListTile(
      leading: Container(
        width: 50.0,
        color: Colors.grey[300],
      ),
      title: Text(
        course.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${course.schoolName}, ${course.yearOfStudy.toString()}'),
          Text(course.methodOfTeaching),
          Text(
              'Локација: ${course.location.latitude}, ${course.location.longitude}'),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${course.length} мин.'),
          Text('${course.price} мкд/час'),
        ],
      ),
      isThreeLine: true,
    ),
  );
}
