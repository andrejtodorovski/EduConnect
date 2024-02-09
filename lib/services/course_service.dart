import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/models/course.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Course>> getCoursesStream(
      String? keyword, String? levelOfEducation) {
    var query = _firestore.collection('courses').snapshots();

    if (keyword != null) {
      query = FirebaseFirestore.instance
          .collection('courses')
          .where('name', isGreaterThanOrEqualTo: keyword)
          .where('name', isLessThan: '${keyword}z')
          .snapshots();
    } else if (levelOfEducation != null) {
      query = FirebaseFirestore.instance
          .collection('courses')
          .where('educationLevel', isEqualTo: levelOfEducation)
          .snapshots();
    }

    return query.map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return Course.fromJson(doc.id, data);
      }).toList();
    });
  }

  Future<List<Course>> getUserCoursesStream(String userId) {
    return _firestore
        .collection('courses')
        .where('userId', isEqualTo: userId)
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map((doc) => Course.fromJson(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> createCourse(Course course) async {
    Map<String, dynamic> courseData = course.toJson();
    courseData.remove('id');
    await _firestore.collection('courses').add(courseData).then((docRef) {});
  }

  Stream<List<Course>> getTopRatedCoursesStream() {
    return _firestore
        .collection('courses')
        .orderBy('averageRating', descending: true)
        .limit(4)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Course.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}
