import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/models/course.dart';
import 'package:educonnect/models/user_favorite_courses.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Course>> getUsersFavoriteCourses(String userId) {
    final coursesCollection = FirebaseFirestore.instance.collection('courses');
    final userFavoritesCollection =
        FirebaseFirestore.instance.collection('user_favorite_courses');

    Stream<List<String>> favoriteCourseIdsStream = userFavoritesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['courseId'] as String).toList());

    return favoriteCourseIdsStream.asyncMap((courseIds) async {
      List<Course> courses = [];
      for (String courseId in courseIds) {
        var courseDocument = await coursesCollection.doc(courseId).get();
        var courseData = courseDocument.data();
        if (courseData != null) {
          Course course = Course.fromJson(courseDocument.id, courseData);
          courses.add(course);
        }
      }
      return courses;
    });
  }

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

  Stream<Course> getCourseStream(String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((snapshot) {
      return Course.fromJson(snapshot.id, snapshot.data()!);
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

  Stream<List<String>> getFavoriteCoursesStream(String userId) {
    return _firestore
        .collection('user_favorite_courses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['courseId'].toString()).toList();
    });
  }

  Future<void> createUserFavoriteCourse(String courseId, String userId) async {
    final List<UserFavoriteCourses> currentUserFavoriteCourses =
        await _firestore
            .collection('user_favorite_courses')
            .where('courseId', isEqualTo: courseId)
            .where('userId', isEqualTo: userId)
            .get()
            .then((snapshot) {
      return snapshot.docs
          .map((doc) => UserFavoriteCourses.fromJson(doc.id, doc.data()))
          .toList();
    });
    if (currentUserFavoriteCourses.isEmpty) {
      final UserFavoriteCourses userFavoriteCourses = UserFavoriteCourses(
        id: '',
        courseId: courseId,
        userId: userId,
      );
      Map<String, dynamic> userFavoriteCoursesData =
          userFavoriteCourses.toJson();
      userFavoriteCoursesData.remove('id');
      await _firestore
          .collection('user_favorite_courses')
          .add(userFavoriteCoursesData)
          .then((docRef) {});
    } else {
      await _firestore
          .collection('user_favorite_courses')
          .doc(currentUserFavoriteCourses[0].id)
          .delete();
    }
  }
}
