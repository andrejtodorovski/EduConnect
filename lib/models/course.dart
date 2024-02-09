import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String userId;
  final String tutorName;
  final String name;
  final String educationLevel;
  final String schoolName;
  final int yearOfStudy;
  final String methodOfTeaching; // online ili vo zivo
  final GeoPoint location;
  final int price;
  final int length; // vo minuti
  final double averageRating;

  Course({
    required this.id,
    required this.userId,
    required this.tutorName,
    required this.name,
    required this.educationLevel,
    required this.schoolName,
    required this.yearOfStudy,
    required this.methodOfTeaching,
    required this.location,
    required this.price,
    required this.length,
    required this.averageRating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tutorName': tutorName,
      'name': name,
      'educationLevel': educationLevel,
      'schoolName': schoolName,
      'yearOfStudy': yearOfStudy,
      'methodOfTeaching': methodOfTeaching,
      'location': location,
      'price': price,
      'length': length,
      'averageRating': averageRating,
    };
  }

  static Course fromJson(String _id, Map<String, dynamic> json) {
    return Course(
      id: _id,
      userId: json['userId'],
      tutorName: json['tutorName'],
      name: json['name'],
      educationLevel: json['educationLevel'],
      schoolName: json['schoolName'],
      yearOfStudy: json['yearOfStudy'],
      methodOfTeaching: json['methodOfTeaching'],
      location: json['location'] as GeoPoint,
      price: json['price'],
      length: json['length'],
      averageRating: json['averageRating'] as double
    );
  }
}
