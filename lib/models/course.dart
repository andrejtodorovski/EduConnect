import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String userId;
  final String name;
  final String educationLevel;
  final String schoolName;
  final int yearOfStudy;
  final String methodOfTeaching; // online ili vo zivo
  final GeoPoint location;
  final double price;
  final int length; // vo minuti
  final double averageRating;

  Course({
    required this.id,
    required this.userId,
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

  static Course fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      educationLevel: json['educationLevel'],
      schoolName: json['schoolName'],
      yearOfStudy: json['yearOfStudy'],
      methodOfTeaching: json['methodOfTeaching'],
      location:
          GeoPoint(json['location']['latitude'], json['location']['longitude']),
      price: json['price'],
      length: json['length'],
      averageRating: json['averageRating'],
    );
  }
}
